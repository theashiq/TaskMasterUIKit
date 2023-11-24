//
//  TaskItemTableViewController.swift
//  TaskMasterUIKit
//
//  Created by mac 2019 on 11/22/23.
//

import UIKit

class TaskItemTableViewController: UITableViewController {
    
    enum DisplayMode: Equatable { case create; case viewOrEdit(Bool) }
    
    //MARK: - IBOutlets
    @IBOutlet weak var textTitle: UITextField!
    @IBOutlet weak var textNotes: UITextView!
    @IBOutlet weak var datePickerRemindTime: UIDatePicker!
    @IBOutlet weak var switchMarkComplete: UISwitch!
    @IBOutlet weak var switchRemind: UISwitch!
    @IBOutlet weak var barButtonCancel: UIBarButtonItem!
    @IBOutlet weak var barButtonSubmit: UIBarButtonItem!
    
    //MARK: - Properties
    
    var taskItem: TaskItem!
    var onTaskItemChanged: ((TaskItem)->Void)?
    var indexPathForDatePicker: IndexPath = IndexPath(row: 1, section: 1)
    
    private var inputsValid: Bool{
        textTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 1
    }
    
    private var displayMode: DisplayMode = .create{
        didSet{
            var enableInputs = true
            switch displayMode {
            case .create:
                enableInputs = true
                barButtonCancel.title = "Cancel"
                barButtonSubmit.title = "Save"
                
            case .viewOrEdit(let editing):
                enableInputs = editing
                barButtonCancel.title = editing ? "Cancel" : "Back"
                barButtonSubmit.title = editing ? "Done" : "Edit"
            }
            
            textTitle.isEnabled = enableInputs
            textNotes.isEditable = enableInputs
            switchRemind.isEnabled = enableInputs
            datePickerRemindTime.isEnabled = enableInputs && switchRemind.isOn
            
            barButtonSubmit.isEnabled = inputsValid
        }
    }
    
    //MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateUI()
        displayMode = taskItem == nil ? .create : .viewOrEdit(false)
    }
    
    @IBAction func onBarButtonCancelPressed(_ sender: UIBarButtonItem) {
        
        switch displayMode {
        case .create:
            goBack()
            
        case .viewOrEdit(let editing):
            
            if editing {
                populateUI()
                barButtonSubmit.isEnabled = true // set as edit button
            }
            else{
                goBack()
            }
            
            displayMode = .viewOrEdit(!editing)
        }
    }
    @IBAction func onBarButtonSubmitPressed(_ sender: UIBarButtonItem) {
        switch displayMode {
        case .create:
            saveAndGoBack()
            
        case .viewOrEdit(let editing):
            
            if editing {
                _ = save()
            }
            
            displayMode = .viewOrEdit(!editing)
        }
    }
    
    @IBAction func onTitleEditingEnded(_ sender: UITextField) {
        barButtonSubmit.isEnabled = inputsValid
    }
    
    @IBAction func onSwitchMarkCompleteChanged(_ sender: UISwitch) {
        if taskItem != nil{
            taskItem.completed = switchMarkComplete.isOn
            onTaskItemChanged?(taskItem)
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    @IBAction func onSwitchRemindChanged(_ sender: UISwitch) {
        datePickerRemindTime.isEnabled = switchRemind.isOn
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    private func goBack() {
        if presentingViewController is UINavigationController{
            dismiss(animated: true)
        }
        else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func saveAndGoBack() {
        guard save() else { return }
        goBack()
    }
    
    private func save() -> Bool {
        guard inputsValid else { return false}
                
        if let existingID = taskItem?.id {
            taskItem = TaskItem(
                id:             existingID,
                title:          textTitle.text!,
                notes:          textNotes.text!,
                completed:      switchMarkComplete.isOn,
                remindTime:     !switchMarkComplete.isOn && switchRemind.isOn ? datePickerRemindTime.date : nil
            )
        }
        else{
            taskItem = TaskItem(
                title:          textTitle.text!,
                notes:          textNotes.text!,
                remindTime:     switchRemind.isOn ? datePickerRemindTime.date : nil
            )
        }
        onTaskItemChanged?(taskItem)
        
        return true
    }
    
    private func populateUI(){
        textTitle.text = taskItem?.title
        textNotes.text = taskItem?.notes
        switchMarkComplete.isOn = taskItem?.completed ?? false
        switchRemind.isOn = taskItem?.remind ?? true
        datePickerRemindTime.date = taskItem?.remindTime ?? .now + 60
        datePickerRemindTime.isEnabled = switchRemind.isOn
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return taskItem == nil ? 0 : 60
        }
        else if indexPath.section == 2{
            if indexPath.row == 0 {
                return switchMarkComplete.isOn ? 0 : 60
            }
            else if indexPath.row == 1{
                return switchRemind.isOn && !switchMarkComplete.isOn ? 60 : 0
            }
        }
        else if indexPath.section == 3{
            return 120
        }
        
        return 60
    }
}


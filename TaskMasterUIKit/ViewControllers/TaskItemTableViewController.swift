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
    @IBOutlet weak var switchRemind: UISwitch!
    @IBOutlet weak var barButtonCancel: UIBarButtonItem!
    @IBOutlet weak var barButtonSubmit: UIBarButtonItem!
    
    //MARK: - Properties
    
    var taskItem: TaskItem!
    var onTaskItemChanged: ((TaskItem)->Void)?
    
    private var inputsValid: Bool{
        textTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 0
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
            datePickerRemindTime.isEnabled = enableInputs
        }
    }
    
    //MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayMode = taskItem == nil ? .create : .viewOrEdit(false)
        populateUI()
    }
    
    @IBAction func onBarButtonCancelPressed(_ sender: UIBarButtonItem) {
        
        switch displayMode {
        case .create:
            goBack()
            
        case .viewOrEdit(let editing):
            
            if editing {
                populateUI()
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
    }
    
    @IBAction func onSwitchRemindChanged(_ sender: UISwitch) {
        datePickerRemindTime.isEnabled = switchRemind.isOn
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
                creationTime:   taskItem.creationTime,
                remindTime:     switchRemind.isOn ? datePickerRemindTime.date : nil
            )
        }
        else{
            taskItem = TaskItem(
                title:          textTitle.text!,
                notes:          textNotes.text!,
                creationTime:   .now,
                remindTime:     switchRemind.isOn ? datePickerRemindTime.date : nil
            )
        }
        onTaskItemChanged?(taskItem)
        
        return true
    }
    
    private func populateUI(){
        textTitle.text = taskItem?.title
        textNotes.text = taskItem?.notes
        switchRemind.isOn = taskItem?.remind ?? true
        datePickerRemindTime.date = taskItem?.remindTime ?? .now + 60
        datePickerRemindTime.isEnabled = switchRemind.isOn
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 2 ? 120 : 60
    }
}


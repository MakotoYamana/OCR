//
//  ResultViewController.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/04.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, UITextFieldDelegate {
    
    private let resultViewControllerPresenter = ResultViewControllerPresenter()
    
    var resultText = ""
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var detailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultViewControllerPresenter.delegate = self
        titleTextField.delegate = self
        self.detailTextView.text = self.resultText
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        resultViewControllerPresenter.tapSaveButton(titleText: titleTextField.text, resultText: resultText)
    }
    
    @IBAction func tapCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension ResultViewController: ResultViewControllerDelegate {
    
    func closeResultView() {
        if let navigationController = self.presentingViewController as? UINavigationController {
            navigationController.popViewController(animated: true)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "タイトルを入力してください", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

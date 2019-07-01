//
//  RecognitionDetailView.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/06.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import UIKit

class RecognitionDetailView: UIViewController, UITextFieldDelegate {
    
    private var recognitionDetailViewPresenter: RecognitionDetailViewPresenter?
    var info: RecognitionInfo?
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var detailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recognitionDetailViewPresenter = RecognitionDetailViewPresenter()
        recognitionDetailViewPresenter?.delegate = self
        recognitionDetailViewPresenter?.viewDidLoad()
        titleTextField.delegate = self
        titleTextField.text = info?.title
        detailTextView.text = info?.detail
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        recognitionDetailViewPresenter?.viewDidDisappear()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        guard let info = info else { return }
        recognitionDetailViewPresenter?.tapSaveButton(titleText: titleTextField.text, detailText: detailTextView.text, info: info)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension RecognitionDetailView: RecognitionDetailViewPresenterDelegate {
    
    func closeDetailView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

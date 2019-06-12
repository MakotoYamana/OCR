//
//  DetailViewController.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/06.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    let detailViewControllerPresenter = DetailViewControllerPresenter()
    
    var info: RecognitionInfo?
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var detailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailViewControllerPresenter.delegate = self
        detailViewControllerPresenter.viewDidLoad()
        titleTextField.delegate = self
        titleTextField.text = info?.title
        detailTextView.text = info?.detail
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        detailViewControllerPresenter.viewDidDisappear()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        guard let info = info else { return }
        detailViewControllerPresenter.tapSaveButton(titleText: titleTextField.text, detailText: detailTextView.text, info: info)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension DetailViewController: DetailViewPresenterDelegate {
    
    func closeDetailView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "タイトルを入力してください", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

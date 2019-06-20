//
//  OCRListView.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/03.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import UIKit

class OCRListView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var ocrListViewPresenter: OCRListViewPresenter?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ocrListViewPresenter = OCRListViewPresenter(model: OCRModel.shared)
        ocrListViewPresenter?.delegate = self
        ocrListViewPresenter?.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "OCRListTableViewCell", bundle: nil), forCellReuseIdentifier: "OCRListTableViewCell")
        tableView.tableFooterView = UIView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecognitionDetailView" {
            guard let recognitionDetailView = segue.destination as? RecognitionDetailView,
                let info = sender as? RecognitionInfo else {
                    print("画面遷移またはデータ取得に失敗")
                    return
            }
            ocrListViewPresenter?.prepareFor(recognitionDetailView: recognitionDetailView, info :info)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ocrListViewPresenter = ocrListViewPresenter else { return 0 }
        return ocrListViewPresenter.viewInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OCRListTableViewCell", for: indexPath) as! OCRListTableViewCell
        if let ocrListViewPresenter = ocrListViewPresenter,
            ocrListViewPresenter.viewInfo.indices.contains(indexPath.row) {
            cell.setItem(ocrListViewPresenter.viewInfo[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let ocrListViewPresenter = ocrListViewPresenter else { return }
        let selectedItem = ocrListViewPresenter.viewInfo[indexPath.row]
        performSegue(withIdentifier: "toRecognitionDetailView", sender: selectedItem)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let ocrListViewPresenter = ocrListViewPresenter else { return }
            let deleteItem = ocrListViewPresenter.viewInfo[indexPath.row]
            ocrListViewPresenter.swipeDelete(info: deleteItem)
        }
    }
    
}

extension OCRListView: OCRListViewPresenterDelegate {
    
    func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

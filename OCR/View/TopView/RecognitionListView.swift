//
//  RecognitionListView.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/03.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import UIKit

class RecognitionListView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var recognitionListViewPresenter: RecognitionListViewPresenter?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recognitionListViewPresenter = RecognitionListViewPresenter()
        recognitionListViewPresenter?.delegate = self
        recognitionListViewPresenter?.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RecognitionListTableViewCell", bundle: nil), forCellReuseIdentifier: "RecognitionListTableViewCell")
        tableView.tableFooterView = UIView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecognitionDetailView" {
            guard let recognitionDetailView = segue.destination as? RecognitionDetailView,
                let info = sender as? RecognitionInfo else {
                    print("画面遷移またはデータ取得に失敗")
                    return
            }
            recognitionListViewPresenter?.prepareFor(recognitionDetailView: recognitionDetailView, info :info)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recognitionListViewPresenter = recognitionListViewPresenter else { return 0 }
        return recognitionListViewPresenter.viewInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecognitionListTableViewCell", for: indexPath) as! RecognitionListTableViewCell
        if let recognitionListViewPresenter = recognitionListViewPresenter,
            recognitionListViewPresenter.viewInfo.indices.contains(indexPath.row) {
            cell.setItem(recognitionListViewPresenter.viewInfo[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let recognitionListViewPresenter = recognitionListViewPresenter else { return }
        let selectedItem = recognitionListViewPresenter.viewInfo[indexPath.row]
        performSegue(withIdentifier: "toRecognitionDetailView", sender: selectedItem)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let recognitionListViewPresenter = recognitionListViewPresenter else { return }
            let deleteItem = recognitionListViewPresenter.viewInfo[indexPath.row]
            recognitionListViewPresenter.swipeDelete(info: deleteItem)
        }
    }
    
}

extension RecognitionListView: RecognitionListViewPresenterDelegate {
    
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

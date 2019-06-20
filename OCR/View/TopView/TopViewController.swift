//
//  TopViewController.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/03.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import UIKit

class TopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let topViewControllerPresenter = TopViewControllerPresenter()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topViewControllerPresenter.delegate = self
        topViewControllerPresenter.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TopTableViewCell", bundle: nil), forCellReuseIdentifier: "TopTableViewCell")
        tableView.tableFooterView = UIView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailViewController" {
            guard let detailViewController = segue.destination as? DetailViewController,
                let info = sender as? RecognitionInfo else {
                    print("画面遷移またはデータ取得に失敗")
                    return
            }
            topViewControllerPresenter.prepareFor(detailViewController: detailViewController, info :info)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topViewControllerPresenter.viewInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopTableViewCell", for: indexPath) as! TopTableViewCell
        cell.setItem(topViewControllerPresenter.viewInfo[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = topViewControllerPresenter.viewInfo[indexPath.row]
        performSegue(withIdentifier: "toDetailViewController", sender: selectedItem)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteItem = topViewControllerPresenter.viewInfo[indexPath.row]
            topViewControllerPresenter.swipeDelete(info: deleteItem)
        }
    }
    
}

extension TopViewController: TopViewPresenterDelegate {
    
    func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

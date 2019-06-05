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
        topViewControllerPresenter.viewDidLoad(delegate: self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TopTableViewCell", bundle: nil), forCellReuseIdentifier: "TopTableViewCell")
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        topViewControllerPresenter.viewWillAppear()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailViewController" {
            guard let detailViewController = segue.destination as? DetailViewController,
                let item = sender as? Item else {
                    print("画面遷移またはデータ取得に失敗")
                    return
            }
            topViewControllerPresenter.prepareFor(detailViewController: detailViewController, item :item)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topViewControllerPresenter.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopTableViewCell", for: indexPath) as! TopTableViewCell
        cell.setItem(topViewControllerPresenter.items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = topViewControllerPresenter.items[indexPath.row]
        performSegue(withIdentifier: "toDetailViewController", sender: selectedItem)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteItem = topViewControllerPresenter.items[indexPath.row]
            topViewControllerPresenter.swipeDelete(item: deleteItem)
        }
    }
    
}

extension TopViewController: TopViewControllerDelegate {
    
    func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

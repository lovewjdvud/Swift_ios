//
//  WorldViewController.swift
//  Schrodinger
//
//  Created by ido on 2021/07/30.
//

import UIKit

class WorldViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var cosmeticsButton: UIButton!
    @IBOutlet weak var medicineButton: UIButton!
    @IBOutlet weak var totalOfWorldThrowOut: UILabel!
    
    var items = [ThrowOutItem]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        allButton.isSelected = true
        updateButtonUI(allButton)
        allButton.addTarget(self, action: #selector(showList(_:)), for: .touchUpInside)
        foodButton.addTarget(self, action: #selector(showList(_:)), for: .touchUpInside)
        cosmeticsButton.addTarget(self, action: #selector(showList(_:)), for: .touchUpInside)
        medicineButton.addTarget(self, action: #selector(showList(_:)), for: .touchUpInside)
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadAll()
        APIService().performAllItemRequest { items in
            DispatchQueue.main.async {
                self.totalOfWorldThrowOut.text = " \(items.map{ Int($0.totalOfThrowOut)! }.reduce(0){ $0 + $1 })"
            }
        }
    }
    
    func updateButtonUI(_ button: UIButton) {
        if button.isSelected {
            button.backgroundColor = .systemGreen
            button.setTitleColor(.systemBackground, for: .selected)
        } else {
            button.backgroundColor = .clear
            button.setTitleColor(.systemGreen, for: .normal)
        }
    }
    
    @objc func showList(_ button: UIButton) {
        
        switch button {
        case allButton:
            foodButton.isSelected = false
            cosmeticsButton.isSelected = false
            medicineButton.isSelected = false
            button.isSelected = true
            loadAll()
        case foodButton:
            allButton.isSelected = false
            cosmeticsButton.isSelected = false
            medicineButton.isSelected = false
            button.isSelected = true
            loadFoodAndBeverage()
        case cosmeticsButton:
            allButton.isSelected = false
            foodButton.isSelected = false
            medicineButton.isSelected = false
            button.isSelected = true
            loadCosmetics()
        case medicineButton:
            allButton.isSelected = false
            foodButton.isSelected = false
            cosmeticsButton.isSelected = false
            button.isSelected = true
            loadMedicine()
            
        default:
            return
        }
        updateButtonUI(allButton)
        updateButtonUI(foodButton)
        updateButtonUI(cosmeticsButton)
        updateButtonUI(medicineButton)
    }
    
    //MARK: API Service
    func loadAll() {
        APIService().performAllItemRequest { items in
            DispatchQueue.main.async {
                self.items = items
                self.tableView.reloadData()
            }
        }
    }
    
    func loadFoodAndBeverage() {
        APIService().performAllItemRequest { items in
            DispatchQueue.main.async {
                self.items = items.filter{ $0.category == "0"}
                self.tableView.reloadData()
            }
        }
    }

    func loadCosmetics() {
        APIService().performAllItemRequest { items in
            DispatchQueue.main.async {
                self.items = items.filter{ $0.category == "1"}
                self.tableView.reloadData()
            }
        }
    }

    func loadMedicine() {
        APIService().performAllItemRequest { items in
            DispatchQueue.main.async {
                self.items = items.filter{ $0.category == "2"}
                self.tableView.reloadData()
            }
        }
    }

}

extension WorldViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellOfWorld") as? CellOfWorldRanking else {
            return UITableViewCell()
        }
        cell.itemName.text = items[indexPath.row].name
        cell.totalOfThrowOut.text = items[indexPath.row].totalOfThrowOut
        return cell
    }
    
}

class CellOfWorldRanking: UITableViewCell {
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var totalOfThrowOut: UILabel!
}

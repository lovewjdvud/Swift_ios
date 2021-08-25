//
//  CheckTodayViewController.swift
//  Schrodinger
//
//  Created by Doyoung on 2021/08/08.
//

import UIKit

class CheckTodayViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var expiredItem = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
}

//MARK: Table View Extension
extension CheckTodayViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expiredItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellOfCheckToday") as? CellOfCheckToday else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = expiredItem[indexPath.item].name
        //DispatchQueue.global().async {
            guard let url = URL(string: "\(APIService().imageURL)\(self.expiredItem[indexPath.row].image!)") else { return cell}
            guard let data = try? Data(contentsOf: url) else { return cell}
            
            let image = UIImage(data: data)
            //DispatchQueue.main.async {
                cell.imageView?.image = image
            //}
        //}
        
        return cell
    }
}

extension CheckTodayViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "JpSong", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "DetailItemViewController") as! DetailItemViewController
        receivepno = Int(self.expiredItem[indexPath.row].id)!
        let destinationNAC = UINavigationController(rootViewController: destinationVC)
        present(destinationNAC, animated: true, completion: nil)
    }
    
}


//MARK: Table View Cell
class CellOfCheckToday: UITableViewCell {
    
}

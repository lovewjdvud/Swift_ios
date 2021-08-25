//
//  HomeViewController.swift
//  Schrodinger
//
//  Created by ido on 2021/07/29.
//

import UIKit
import Firebase
import GoogleSignIn
import KakaoSDKUser

class HomeViewController: UIViewController {
// Check
//MARK: View
    @IBOutlet weak var firstSectionTitle: UILabel!
    @IBOutlet weak var todayExpiredItem: UILabel!
    @IBOutlet weak var secondSectionTitle: UILabel!
    @IBOutlet weak var thirdSectionTitle: UILabel!
    @IBOutlet weak var fourthSectionTitle: UILabel!
    @IBOutlet weak var checkTodayButton: UIButton!
    @IBOutlet weak var expiredItemCollectionView: UICollectionView!
    @IBOutlet weak var upcomingExpireCollectionView: UICollectionView!
    @IBOutlet weak var chartView: UIView!
    
    func applyLabel() {
        firstSectionTitle.text = "Today expired item..".localized
        secondSectionTitle.text = "Expired item".localized
        thirdSectionTitle.text = "Upcoming expire".localized
        fourthSectionTitle.text = "My History".localized
    }
    
    func applyButton() {
        checkTodayButton.setTitle("Check".localized, for: .normal)
        checkTodayButton.layer.cornerRadius = 10
        checkTodayButton.addTarget(self, action: #selector(showTodayExpiredList), for: .touchUpInside)
    }
    
    func applyRightNaviagationItem() {
        let profileSetButton = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(profileActionSheet))
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addItem))
        navigationItem.rightBarButtonItem = plusButton
        navigationItem.leftBarButtonItem = profileSetButton
    }
    
    var todayExpired = [Item]()
    var expiredItem = [Item]()
    var upcomingExpire = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Success view did Load")
        applyLabel()
        applyButton()
        applyRightNaviagationItem()
        expiredItemCollectionView.delegate = self
        expiredItemCollectionView.dataSource = self
        upcomingExpireCollectionView.delegate = self
        upcomingExpireCollectionView.dataSource = self
        
        chartView.backgroundColor = .secondarySystemBackground
        let pieView = PieChart(frame: CGRect(
                                x: self.chartView.bounds.minX,
                                y: self.chartView.bounds.minY,
                                width: self.view.frame.width - 40,
                                height: self.view.frame.width - 40))
        pieView.backgroundColor = .systemBackground
        chartView.addSubview(pieView)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        APIService().performUserItemRequest { items in
            //DispatchQueue.global().async {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
            self.todayExpired = items.filter{ $0.date == formatter.string(from: Date()) }
                let todayExpiredNames = self.todayExpired.map { $0.name }
                self.upcomingExpire = items.filter{ Date() >= $0.date.toDate().beforeOneWeek() && $0.date.toDate() > Date()}
                self.expiredItem = items.filter{ $0.date.toDate() <= Date() }
                DispatchQueue.main.sync {
                    self.expiredItemCollectionView.reloadData()
                    self.upcomingExpireCollectionView.reloadData()
                    self.todayExpiredItem.text = todayExpiredNames.joined(separator: " ")
                }
            //}
        }
        
    //MARK: Todo redraw pie chart
    }
    @objc func showTodayExpiredList() {
        let storyboard = UIStoryboard(name: "DyLee", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "CheckTodayViewController") as! CheckTodayViewController
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        APIService().performUserItemRequest { items in
            destinationVC.expiredItem = items.filter{ $0.date == formatter.string(from: Date()) }
        }
        present(destinationVC, animated: true, completion: nil)
    }
   
    @objc func profileActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Preferences", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let signOut = UIAlertAction(title: "Sign Out", style: .default) { _ in
            //MARK: TODO SET DELETE ACCOUNT
            UserApi.shared.unlink {(error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("unlink() success.")
                    self.dismiss(animated: true)
    //                Share.userID = "방문자"

                }
            }
            myUserDefaults.set("방문자", forKey: "userEmail")
            
            // MARK: Google Login - LogOut
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.dismiss(animated: true)
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
            
        }
        let deleteMyAccout = UIAlertAction(title: "Delete my account", style: .destructive) { _ in
            
        }
        actionSheet.addAction(cancel)
        actionSheet.addAction(signOut)
        actionSheet.addAction(deleteMyAccout)
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func addItem() {
        let storyboard = UIStoryboard(name: "HjYang", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "AddItemViewController") as! AddItemViewController
        let destinationNAV = UINavigationController(rootViewController: destinationVC)
        destinationNAV.modalPresentationStyle = .fullScreen
        present(destinationNAV, animated: true, completion: nil)
    }
}

//MARK: Extension CollectionView

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "JpSong", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "DetailItemViewController") as! DetailItemViewController
        
        if collectionView == expiredItemCollectionView {
    
            receivepno = Int(self.expiredItem[indexPath.item].id)!
        } else {
            receivepno = Int(self.upcomingExpire[indexPath.item].id)!
        }
        let destinationNAC = UINavigationController(rootViewController: destinationVC)
        destinationNAC.modalPresentationStyle = .fullScreen
        present(destinationNAC, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case expiredItemCollectionView:
            print("Expired Item : \(expiredItem.count)")
            return expiredItem.count
        case upcomingExpireCollectionView:
            print("Upcoming Item : \(upcomingExpire.count)")
            return upcomingExpire.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellOfHomeView", for: indexPath) as? CellOfHomeView else {
            return UICollectionViewCell()
        }
        switch collectionView {
        case expiredItemCollectionView:
            DispatchQueue.global().async {
                guard let url = URL(string: "\(APIService().imageURL)\(self.expiredItem[indexPath.item].image!)") else { return }
                guard let data = try? Data(contentsOf: url) else { return }
                
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    cell.cellImageView.image = image
                }
            }
        case upcomingExpireCollectionView:
            DispatchQueue.global().async {
                guard let url: URL = URL(string: "\(APIService().imageURL)\(self.upcomingExpire[indexPath.item].image!)") else { return }
                guard let data = try? Data(contentsOf: url) else { return }
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    cell.cellImageView.image = image
                }
            }
        default:
            print("empty")
        }
        return cell
    }
    
}

//MARK: Collection View Cell
class CellOfHomeView: UICollectionViewCell {
    
    
    @IBOutlet weak var cellImageView: UIImageView!
    
}

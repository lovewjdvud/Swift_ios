//
//  ViewController.swift
//  Schrodinger
//
//  Created by ido on 2021/07/29.
//

import UIKit

//MARK: 이 뷰 컨트롤러는 바로 자기 파트로 움직이기 위해서 만들어논 컨트롤러입니다.
class ViewController: UIViewController {

    @IBOutlet weak var kjyButton: UIButton!
    
    @IBOutlet weak var sjpButton: UIButton!
    
    @IBOutlet weak var yhjButton: UIButton!
    
    @IBOutlet weak var ldyButton: UIButton!
    
    @IBOutlet weak var lhjButton: UIButton!
    
    @IBOutlet weak var cjyButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kjyButton.addTarget(self, action: #selector(goKjy), for: .touchUpInside)
        kjyButton.setTitle("JY KIM".localized, for: .normal)
        
        sjpButton.addTarget(self, action: #selector(goSjp), for: .touchUpInside)
        sjpButton.setTitle("JP SONG".localized, for: .normal)
        
        yhjButton.addTarget(self, action: #selector(goYhj), for: .touchUpInside)
        yhjButton.setTitle("HJ YANG".localized, for: .normal)
        
        ldyButton.addTarget(self, action: #selector(goLdy), for: .touchUpInside)
        ldyButton.setTitle("DY LEE".localized, for: .normal)
        
        lhjButton.addTarget(self, action: #selector(goLhj), for: .touchUpInside)
        lhjButton.setTitle("HJ LIM".localized, for: .normal)
        
        cjyButton.addTarget(self, action: #selector(goCjy), for: .touchUpInside)
        cjyButton.setTitle("JY CHOI".localized, for: .normal)
        
        // Do any additional setup after loading the view.
    }

    
    @objc func goKjy() {
        let storyboard = UIStoryboard(name: "JyKim", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true, completion: nil)
    }

    @objc func goSjp() {
        let storyboard = UIStoryboard(name: "JpSong", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "TestViewController") as! TestViewController
        let destinationNAC = UINavigationController(rootViewController: destinationVC)
        destinationNAC.modalPresentationStyle = .fullScreen
        present(destinationNAC, animated: true, completion: nil)
    }
    
    @objc func goYhj() {
        let storyboard = UIStoryboard(name: "HjYang", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "AddItemViewController") as! AddItemViewController
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true, completion: nil)
    }
    
    @objc func goLdy() {
        let storyboard = UIStoryboard(name: "DyLee", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true, completion: nil)
    }
    
    @objc func goLhj() {
        let storyboard = UIStoryboard(name: "HjLim", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true, completion: nil)
    }
    
    @objc func goCjy() {
        let storyboard = UIStoryboard(name: "JyChoi", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "ListMainViewController") as! ListMainViewController
        let destinationNAV = UINavigationController(rootViewController: destinationVC)
        destinationNAV.modalPresentationStyle = .fullScreen
        present(destinationNAV, animated: true, completion: nil)
    }
}


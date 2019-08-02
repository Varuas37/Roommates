//
//  FinanceViewController.swift
//  Roommates
//
//  Created by Saurav Panthee on 8/1/19.
//  Copyright © 2019 Saurav Panthee. All rights reserved.
//

import UIKit

class FinanceViewController: UIViewController {
    @IBOutlet weak var BottomView: UIView!
    @IBOutlet weak var TopView: UIView!
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize.height = 950
        view.backgroundColor = UIColor(red: 16.0/255.0, green: 195.0/255.0, blue: 130.0/255.0, alpha: 1)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        BottomView.roundCornersWithLayerMask(cornerRadii: 21, corners: [.topLeft,.topRight])

       view.addSubview(scrollView)
        scrollView.addSubview(BottomView)
        scrollView.addSubview(TopView)
        setupScrollView()
    }
    
    func setupScrollView(){
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }



}

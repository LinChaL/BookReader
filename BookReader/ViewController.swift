//
//  ViewController.swift
//  BookReader
//
//  Created by linchl on 2018/6/20.
//  Copyright © 2018年 linchl. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.activityIndicatorViewStyle = .white
        return loadingView
    }()
    
    private lazy var txtButton: UIButton = {
        let txtButton = UIButton(type: .custom)
        txtButton.setTitle("Begin To Read", for: UIControlState())
        txtButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        txtButton.backgroundColor = .yellow
        txtButton.setTitleColor(.black, for: UIControlState())
        txtButton.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        return txtButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        view.addSubview(txtButton)
        txtButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(50)
        }
        
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

    @objc private func onClick() {
        loadingView.startAnimating()
        let pageView = RDPageViewController()
        let url = Bundle.main.url(forResource: "执宰大明", withExtension: "txt") as URL?
        pageView.resourceURL = url
        DispatchQueue.global().async {
            guard let url = url else {
                DispatchQueue.main.async(execute: {
                    self.loadingView.stopAnimating()
                })
                return
            }
            let readModel = RDReadModel(resource: url)
            pageView.readModel = readModel
            DispatchQueue.main.async(execute: {
                self.loadingView.stopAnimating()
                self.present(pageView, animated: true, completion: nil)
            })
        }
    }


}


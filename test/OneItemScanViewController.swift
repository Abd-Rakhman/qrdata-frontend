//
//  OneItemScanViewController.swift
//  test
//
//  Created by Rakhman on 20.05.2022.
//

import UIKit

class OneItemScanViewController: UIViewController {
    
    let searchField: UITextField = {
        let text = UITextField()
        text.layer.borderWidth = 1
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let scanButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .green
        button.setTitle("SCAN IT!", for: .normal)
        button.titleLabel?.textColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(presentShowDataViewController), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
    }
    
    @objc private func presentShowDataViewController() {
        let vc = ViewController()
        vc.searchString = searchField.text
        showDetailViewController(vc, sender: self)
    }
    
    private func setupViews() {
        view.addSubview(searchField)
        view.addSubview(scanButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        searchField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        searchField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 11/12).isActive = true
        searchField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        scanButton.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 6).isActive = true
        scanButton.widthAnchor.constraint(equalTo: searchField.widthAnchor).isActive = true
        scanButton.heightAnchor.constraint(equalTo: searchField.heightAnchor).isActive = true
        scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
}

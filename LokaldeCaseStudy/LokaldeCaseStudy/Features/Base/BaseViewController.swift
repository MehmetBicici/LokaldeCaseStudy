//
//  BaseViewController.swift
//  LokaldeCaseStudy
//
//  Created by Mehmet Biçici on 1.06.2026.
//

import UIKit

private enum Constants {
    static let indicatorColor: UIColor = .gray
}

class BaseViewController: UIViewController {
    
    private var spinner: UIActivityIndicatorView?
    
    deinit {
        debugPrint("🗑 DEINIT DETECTED: \(String(describing: type(of: self))) removed from the memory.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardDismissal()
    }

    private func setupKeyboardDismissal() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showLoading() {
        guard spinner == nil else { return }
        
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = Constants.indicatorColor
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        
        view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        indicator.startAnimating()
        self.spinner = indicator
    }
    
    func hideLoading() {
        spinner?.stopAnimating()
        spinner?.removeFromSuperview()
        spinner = nil
    }
}

//
//  DetailViewController.swift
//  Project7
//
//  Created by Juan Felipe Zorrilla Ocampo on 9/10/21.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(openCredits))
        
        guard let detailItem = detailItem else { return }

        let html = """
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <style>
                body {
                    background-color: #f8f9fd;
                    font-size: 120%;
                    font-family: "Roboto", sans-serif;
                    display: flex;
                    justify-content: center;
                    margin: 25px;
                }
            </style>
        </head>
        <body>
            \(detailItem.body)
        </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: nil)
        
    }
    
    @objc func openCredits() {
        let ac = UIAlertController(title: "We The People API by White House", message: "The data you're seeing comes from 'We the people' petitions from USA White House", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

}

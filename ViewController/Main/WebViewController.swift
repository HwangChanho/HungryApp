//
//  WebViewController.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/27.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    static let identifier = "WebViewController"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var presentWebView: WKWebView!
    
    var url: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        loadVideoData(url: url!)
    }
    
    @objc func closeButtonClicked(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func xButtonPressed(_ sender: UIBarButtonItem) {
        presentWebView.stopLoading()
    }

    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        if presentWebView.canGoBack {
            presentWebView.goBack()
        } else {
            print("Back Error")
        }
    }
    
    @IBAction func reloadButtonPressed(_ sender: UIBarButtonItem) {
        presentWebView.reload()
    }
    
    @IBAction func forwardButtonPressed(_ sender: UIBarButtonItem) {
        if presentWebView.canGoForward {
            presentWebView.goForward()
        } else {
            print("Forward Error")
        }
    }
    
    func loadVideoData(url : String) {
        print(url)
        
        guard let formattedUrl = URL(string: url) else {
            print("ERROR")
            return
        }
        
        let request = URLRequest(url: formattedUrl)
        presentWebView.load(request)
    }
}

extension WebViewController: UISearchBarDelegate {
    // 검색 리턴키 클릭
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let url = URL(string: searchBar.text ?? "") else {
            print("ERROR")
            return
        }
        
        let request = URLRequest(url: url)
        presentWebView.load(request)
    }
}

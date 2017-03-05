//
//  ViewController.swift
//  Project 4
//
//  Created by Adrian McDaniel on 2/8/17.
//  Copyright © 2017 Adrian McDaniel. All rights reserved.
//

import WebKit
import UIKit

class ViewController: UIViewController, WKNavigationDelegate {
    //all view controllers automatically come with a toolbarItems array that automatically gets read in when the view controller is active inside a UINavigationController.
    
    //We need ot store WKWebView and UIProgressView as properties to reference later
    var webView: WKWebView!
    
    var progressView: UIProgressView!
    
    var websites = ["apple.com", "hackingwithswift.com"]

    
    override func loadView() {
        //created an instance of Apple's WKWebView web browser component and assign it t the webView property
        webView = WKWebView()
        
        //In our code, we're setting the web view's navigationDelegate property to self, which means "when any web page navigation happens, please tell me."
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title:
            "Open", style: .plain, target: self, action:
            #selector(openTapped))
        
        //creates a UIProgressView instance with the style being default  There is another style called bar you can try
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        
        //wrapped the UIProgressView in a new UIBarButtonItem using the customView parameter so that the progressView can go on the toolbar
        let progressButton = UIBarButtonItem(customView: progressView)
        
        
        //We're creating a new bar button item using the special system item type .flexibleSpace, which creates a flexible space. It doesn't need a target or action because it can't be tapped
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        //reload method for refreshing the webView
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        //puts an array containing the, pregressButton, flexible spacer, and the refresh button, then sets it to be our view controller's toolbarItems array
        toolbarItems = [progressButton, spacer, refresh]
        
        //sets the navigation controller's isToolbarHidden property to be false, so the toolbar will be shown – and its items will be loaded from our current view.
        navigationController?.isToolbarHidden = false
        
        
        //created URL and stored to a property
        //MUST USE https:// FOR ALL SITES!!!!!!
        //URL must be complete and valid for process to work
        let url = URL(string: "https://" + websites[0])!
        
        //Then we load the web and request the URL
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        //The addObserver() method takes four parameters: who the observer is (we're the observer so we use self), what property we want to observe (we want the estimatedProgress property of WKWebView), which value we want (we want the value that was just set, so we want the new one), and a context value.
        webView.addObserver(self, forKeyPath:
            #keyPath(WKWebView.estimatedProgress), options: .new, context:
            nil)
        //WARNING: in more complex applications, all calls to addObserver() should be matched with a call to removeObserver() when you're finished observing – for example, when you're done with the view controller.
    }
    
    func openTapped() {
        //using nil for message because this time we don't need one
        //preferredStyle of .actionSheet because we're prompting the user for more information.
        let ac = UIAlertController(title: "Open page...", message:
            nil, preferredStyle: .actionSheet)
        //ac.addAction(UIAlertAction(title: "apple.com",style: .default, handler: openPage))
        //ac.addAction(UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openPage))
        
        //replaces the two seperate addActions from above
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default,
                                       handler: openPage))
        }
        
        //adding a cancel button of style .cancel which hides the alert
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    //Once you have registered as an observer using KVO, you must implement a method called observeValue(). This tells you when an observed value has changed
    override func observeValue(forKeyPath keyPath: String?, of
        object: Any?, change: [NSKeyValueChangeKey : Any]?, context:
        UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        } }

    func openPage(action: UIAlertAction) {
        
        //combines the "https://" with the title of the addAction button to create the URL.
        let url = URL(string: "https://" + action.title!)!
        //loads web with URL request
        webView.load(URLRequest(url: url))
    }
    //updates the ViewControllers title to the webView title
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url
        if let host = url!.host {
            for website in websites {
                if host.range(of: website) != nil {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
    }
/*There are some easy bits, but they are outweighed by the hard bits so let's go through every line in detail to make sure:
 1. First, we set the constant url to be equal to the URL of the navigation. This is just to make the code clearer.
 2. Second, we use if let syntax to unwrap the value of the optional url.host. Remember I said that URL does a lot of work for you in parsing URLs properly? Well, here's a good example: this line says, "if there is a host for this URL, pull it out" – and by "host" it means "website domain" like apple.com. NB: we need to unwrap this carefully because not all URLs have hosts.
 3. Third, we loop through all sites in our safe list, placing the name of the site in the website variable.
 4. Fourth, we use the range(of:) String method to see whether each safe website exists somewhere in the host name.
 5. Fifth, if the website was found (if range(of:) is not nil) then we call the decision handler with a positive response: allow loading.
 6. Sixth, if the website was found, after calling the decisionHandler we use the return statement. This means "exit the method now."
 7. Last, if there is no host set, or if we've gone through all the loop and found nothing, we call the decision handler with a negative response: cancel loading.
 The range(of:) method can take quite a few parameters, however all but the first are optional so the above usage is fine. To use it, call range(of:) on one string, giving it another string as a parameter, and it will tell you where it was found, or nil if it wasn't found at all.
 You've already met the hasPrefix() method in project 1, but hasPrefix() isn't suitable here because our safe site name could appear anywhere in the URL. For example, slashdot.org redirects to m.slashdot.org for mobile devices, and hasPrefix() would fail that test.
 www.hackingwithswift.com 199
 redirects to m.slashdot.org for mobile devices, and hasPrefix() would fail that test.
 The return statement is new, but it's one you'll be using a lot from now on. It exits the method immediately, executing no further code. If you said your method returns a value, you'll use the return statement to return that value.*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


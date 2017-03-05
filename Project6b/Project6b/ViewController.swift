//
//  ViewController.swift
//  Project6b
//
//  Created by Adrian McDaniel on 2/27/17.
//  Copyright © 2017 Adrian McDaniel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Using VFL  or "Visual Format Language" ******************************************
        
        
        //manually creating 5 label objects with unique text and color
        //then we turn off auto layout on each object so that we can set them by hand
        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = UIColor.red
        label1.text = "THESE"
        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = UIColor.cyan
        label2.text = "ARE"
        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = UIColor.yellow
        label3.text = "SOME"
        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = UIColor.green
        label4.text = "AWESOME"
        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = UIColor.orange
        label5.text = "LABELS"
        
        //adding all 5 labels to the view
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        
        /*let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]
        
        // adds array of contraints to the view
        //The "H" means that we are defining a horizontal layout. The pipe symbol, |, means "the edge of the view." We're adding these constraints to the main view inside our view controller, so this effectively means "the edge of the view controller." Finally, we have [label1], which is a visual way of saying "put label1 here". Imagine the brackets, [ and ], are the edges of the view.
        for label in viewsDictionary.keys {
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
        }
        
        //setting an amount for the label height so that you don't have to adjust each number for each label when you make changes
        let metrics = ["labelHeight": 88]
        
        //Setting the vertical contraints.
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]->=10-|", options: [], metrics: metrics, views: viewsDictionary))*/
       
        //Using "Anchors", we loop over each label setting the to the same width as our main view and a height of exactly 88 points
        var previous: UILabel!
        for label in [label1, label2, label3, label4, label5] {
            label.widthAnchor.constraint(equalTo:
                view.widthAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: 88).isActive
                = true
            if previous != nil {
                // we have a previous label – create a height constraint
                label.topAnchor.constraint(equalTo:
                    previous.bottomAnchor).isActive = true
            }
            // set the previous label to be the current one, for the next loop iteration
            previous = label
        }
        
    

    }
    
    //obviously tells iOS that we don't want to show the status bar up top
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


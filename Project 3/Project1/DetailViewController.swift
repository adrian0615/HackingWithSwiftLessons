//
//  DetailViewController.swift
//  Project1
//
//  Created by Adrian McDaniel on 1/20/17.
//  Copyright © 2017 dssafsfsd. All rights reserved.
//
import Social
import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var ImageView: UIImageView!
    
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedImage
        
        //Assigning a right bar button to the nav bar and telling it what method to run when tapped
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        if let imageToLoad = selectedImage {
            ImageView.image  = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    //method that allows you to share image 
    //When on iPad the activity view controller will pop up over the right bar button
    //On iPhone it will take up the whole screen
    //activity items are the list of items you want to share
    //application activities are the list of services you want your app to share
    func shareTapped() {
        let vc = UIActivityViewController(activityItems:
            [ImageView.image!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem =
            navigationItem.rightBarButtonItem
        present(vc, animated: true)
        
        
        //Allows you to share directly to Facebook
        //Also has a twitter option
        //Allows you to set the text inside that will go with the post
        
        /*if let vc = SLComposeViewController(forServiceType:
            SLServiceTypeFacebook) {
            vc.setInitialText("Look at this great picture!")
            vc.add(ImageView.image!)
            vc.add(URL(string: "http://www.photolib.noaa.gov/nssl"))
            present(vc, animated: true)
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

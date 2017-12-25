//
//  FirstViewController.swift
//  NasaSpaceApps
//
//  Created by Vansh Badkul on 09/04/17.
//  Copyright © 2017 Apple. All rights reserved.
//


import UIKit
import Alamofire
import ImageSlideshow
import Firebase
import FirebaseDatabase

struct postStruct{
    let title : String!
    let message : String!
}

class FirstViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    var posts=[postStruct]()
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var Register: UIButton!
    @IBOutlet weak var slideshow: ImageSlideshow!

    let localSource = [ImageSource(imageString: "slide1")!, ImageSource(imageString: "s2")!]

    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "TermsAccepted") {
            // Terms have been accepted, proceed as normal
        } else {
            self.performSegue (withIdentifier: "testy", sender: self)
        }
        
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Posts").queryOrderedByKey().observe(.value, with: {snap in
            self.posts.removeAll()
                    databaseRef.child("Posts").queryOrderedByKey().observe(.childAdded, with: {
                        snapshot in
                        let snapshotValue = snapshot.value as? NSDictionary
                        let title = snapshotValue?["title"] as! String
                        let message = snapshotValue?["message"] as! String
                        self.posts.insert(postStruct(title:title,message:message), at: 0)
                        self.tableview.reloadData()
                        
                    })
            self.tableview.reloadData()
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //for assigning value of token for last session
        Register.isEnabled = false
        let defaults = UserDefaults.standard
        token = defaults.string(forKey: "MyKey")!
        if(token != "")
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Start")
            self.present(vc!, animated: true, completion: nil)
        }
//        token = UserDefaults.standard.value(forKey: "TokenValue") as! String
//        if UserDefaults.standard.bool(forKey: "Token") {
//            // Terms have been accepted, proceed as normal
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Start")
//            self.present(vc!, animated: true, completion: nil)
//        } else {
//            
//        }
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        let connectedRef = FIRDatabase.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                print("Connected")
            } else {
                print("Not connected")
            }
        })
        // Do any additional setup after loading the view, typically from a nib.

       //post()
        slideshow.backgroundColor = UIColor.clear
        slideshow.slideshowInterval = 5.0
        slideshow.pageControlPosition = PageControlPosition.underScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideshow.pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        slideshow.currentPageChanged = { page in
            print("current page:", page)
    
        }
        
        
        slideshow.setImageInputs(localSource)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(FirstViewController.didTap))
        slideshow.addGestureRecognizer(recognizer)
    }

    func didTap() {
        slideshow.presentFullScreenController(from: self)
    }
    
    func post(){
        let title = "Title"
        let message = "message"
        let post:[String:AnyObject]=["title": title as AnyObject,"message": message as AnyObject]
        let databaseRef=FIRDatabase.database().reference()
        databaseRef.child("Posts").childByAutoId().setValue(post)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let label1 = cell.viewWithTag(1)as! UILabel
        label1.text = posts[indexPath.row].title
        print(label1)
        let label2 = cell.viewWithTag(2)as! UILabel
        label2.text = posts[indexPath.row].message
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }

}

//
//  MentorViewController.swift
//  NasaSpaceApps
//
//  Created by Vansh Badkul on 26/04/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import FirebaseDatabase
import AlamofireImage


struct mentStruct{
    let name : String!
    let designation : String!
    let skill : String!
    let image: String!

}
var imageOne = [UIImage]()
class MentorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    var mentors=[mentStruct]()
    @IBOutlet weak var tableview: UITableView!
   
    
    override func viewDidAppear(_ animated: Bool) {
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Mentors").queryOrderedByKey().observe(.value, with: {snap in
            self.mentors.removeAll()
            databaseRef.child("Mentors").queryOrderedByKey().observe(.childAdded, with: {
                snapshot in
                let snapshotValue = snapshot.value as? NSDictionary
                let name = snapshotValue?["name"] as! String
                let designation = snapshotValue?["designation"] as! String
                let skill = snapshotValue?["skill"] as! String
                let image = snapshotValue?["image"] as! String
                self.mentors.insert(mentStruct(name:name,designation:designation,skill:skill,image:image), at: 0)
                self.tableview.reloadData()
                
            })
            self.tableview.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
//        if mentors.count != 0{
//            for i in 0...mentors.count{
//                let urlImage:String=mentors[i].image
//                Alamofire.request(String(urlImage)!,method:.get).responseImage { img in
//                    imageOne.append(img.result.value!)
//                }
//            }
//            
//        }
        
       // post()
     //   print(imageOne)

        
    }
    func post(){
        let name = "Vansh"
        let designation = "Student"
        let skill = "Management"
        let image="M"

        let post:[String:AnyObject]=["name": name as AnyObject,"designation": designation as AnyObject, "skill": skill as AnyObject,"image": image as AnyObject]
        let databaseRef=FIRDatabase.database().reference()
        databaseRef.child("Mentors").childByAutoId().setValue(post)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ImageTableViewCell
        cell.name.text = String(mentors[indexPath.row].name)
        cell.designation.text = mentors[indexPath.row].designation
        cell.skill.text = mentors[indexPath.row].skill
        cell.view.layer.cornerRadius = 20
        cell.mentorImage.roundCorners(corners: [.topLeft, .bottomLeft], radius: 20)
        let urlImage:String = mentors[indexPath.row].image
            Alamofire.request(String(urlImage),method:.get).responseImage { img in
                cell.mentorImage.image = img.result.value
//                cell.setNeedsLayout() //invalidate current layout
//                cell.layoutIfNeeded()
        }

    
       // cell.profile.layer.cornerRadius=20.0
        //cell.profile.clipsToBounds=true
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
}
extension UIView
{
    func roundCorners(corners:UIRectCorner, radius: CGFloat)
    {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

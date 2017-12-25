//
//  TimelineTableViewController.swift
//  TimelineTableViewCell
//
//  Created by Zheng-Xiang Ke on 2016/10/20.
//  Copyright © 2016年 Zheng-Xiang Ke. All rights reserved.
//

import UIKit
import TimelineTableViewCell

class TimelineTableViewController: UITableViewController {
    
    // TimelinePoint, Timeline back color, title, description, lineInfo, thumbnail
    let data:[Int: [(TimelinePoint, UIColor, String, String, String?, String?)]] = [0:[
        (TimelinePoint(), UIColor.black, "8:00 am", "Registration Check \nAll the Registered Participants acknowledge there presence followed by simultaneous Ice-Breaking Sessions.", nil, "ins"),
        (TimelinePoint(), UIColor.black, "10:00 am", "HACK101 \nNASA SpaceApps 2017 would be explained and problem statements would be discussed. All the participants would be introduced to NASA Open Data and the judging criteria.", nil, nil),
        (TimelinePoint(color: UIColor.black, filled: false), UIColor.red, "11:00 am", "Hacking Begins\nParticipants are expected to get a sense of problem statements by now. Hack Begins. Participants would be given HackerSpace, some plug points and a good WiFi Connection.", "", "ready"),
        (TimelinePoint(), UIColor.black, "01:00 pm", "Lunch\nTake a break, Relax!", nil, nil),
        (TimelinePoint(), UIColor.black, "02:00 pm", "HackShop Opens\nHardware components will be given to the Teams, if required, on a First-Come-First-Serve basis.", "", nil),
        (TimelinePoint(), UIColor.black, "04:00 pm", "Open Mentor Hours\nMentors from diverse backgrounds would be accessible to all the participants.", "", nil),
        (TimelinePoint(), UIColor.clear, "08:00 pm", "Dinner\nFuel Up!", "", "Apple")
        ], 1:[
            (TimelinePoint(), UIColor.black, "01:00 am", "Midnight Munchies\nSnacks and Caffeine will be provided to the hackers to keep up with the energy!", "", nil),
            (TimelinePoint(), UIColor.black, "06:00 am", "Team Acknowledgement\nFinal Team List would be prepared for scheduling the presentations.", "", "Apple"),
            (TimelinePoint(), UIColor.black, "09:00 am", "Breakfast\nRelax For a While!", "", "Apple"),
            (TimelinePoint(), UIColor.black, "11:00 am", "Practice Presentations\nTime will be given to better help the hackers with their own mock presentation.", "", "Apple"),
            (TimelinePoint(), UIColor.black, "02:00 pm", "Final Presentations\nThe time for the participants to Show Off their hard work done during the SpaceAppsChallenge!", "", nil),
            (TimelinePoint(), UIColor.black, "05:00 pm", "Judges Deliberation and Feedback Session\nParticipants will be reminded to focus on giving kind, specific and helpful feedback.", "", "Apple"),
            (TimelinePoint(), backColor: UIColor.clear, "06:00 pm", "Closing Ceremony and Results\nThe most awaited moment!", "", "Apple")
        ]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let bundle = Bundle(for: TimelineTableViewCell.self)
        let nibUrl = bundle.url(forResource: "TimelineTableViewCell", withExtension: "bundle")
        let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell",
                                             bundle: Bundle(url: nibUrl!)!)
        tableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "TimelineTableViewCell")
        self.tableView.estimatedRowHeight = 300
        self.tableView.rowHeight = UITableViewAutomaticDimension
       
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let sectionData = data[section] else {
            return 0
        }
        return sectionData.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Day " + String(describing: section + 1)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as! TimelineTableViewCell
        
        // Configure the cell...
        guard let sectionData = data[indexPath.section] else {
            return cell
        }
        
        let (timelinePoint, timelineBackColor, title, description, lineInfo, thumbnail) = sectionData[indexPath.row]
        var timelineFrontColor = UIColor.clear
        if (indexPath.row > 0) {
            timelineFrontColor = sectionData[indexPath.row - 1].1
        }
        
        cell.backgroundColor=UIColor.clear
        cell.timelinePoint = timelinePoint
        cell.timeline.frontColor = timelineFrontColor
        cell.timeline.backColor = timelineBackColor
        cell.titleLabel.text = title
        cell.descriptionLabel.text = description
        cell.descriptionLabel.textColor=UIColor.black
        cell.lineInfoLabel.text = lineInfo
        if let thumbnail = thumbnail {
            cell.thumbnailImageView.image = UIImage(named: thumbnail)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        guard let sectionData = data[indexPath.section] else {
            return
        }
        
        print(sectionData[indexPath.row])
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

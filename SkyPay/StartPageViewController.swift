//
//  StartPageViewController.swift
//  SkyPay
//
//  Created by Saransh Mittal on 17/06/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Alamofire

class TipInCellAnimator {
    // placeholder for things to come -- only fades in for now
    class func animate(cell:UITableViewCell) {
        let view = cell.contentView
        view.layer.opacity = 0.1
        UIView.animate(withDuration: 1.0, animations: {
            view.layer.opacity = 1
        })
    }
}

class StartPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var createTransactionButton: UIButton!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var tranparentLayerOfCard: UIView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var totalBitcoinsReceivedLabel: UILabel!
    @IBOutlet weak var totalBitcoinsSentLabel: UILabel!
    @IBOutlet weak var cardholderNameLabel: UILabel!
    @IBOutlet weak var transactionHistoryTableView: UITableView!
    @IBOutlet weak var qrCode: UIImageView!
    
    @IBAction func createTransaction(_ sender: Any) {
    }
    var code = "mvVsU2vhw9HNzpCCCV6ojhpU7CFFc1277z"
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    var flag = 1
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionHistoryTableView.dequeueReusableCell(withIdentifier: "transactionHistoryTableView", for: indexPath as IndexPath) as! TransactionHistoryTableViewCell
        if flag % 2 == 0{
            cell.imageView?.image = UIImage.init(named: "Collapse Arrow-50")
        }
        else{
            cell.imageView?.image = UIImage.init(named: "Expand Arrow-50")
        }
        flag += 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        transactionHistoryTableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.2, animations: {
            self.card.alpha = 1.0
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        card.alpha = 0.0
        var navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        createTransactionButton.layer.cornerRadius = createTransactionButton.frame.height / 2
        transactionHistoryTableView.delegate = self
        transactionHistoryTableView.dataSource = self
        // Do any additional setup after loading the view.
        card.layer.cornerRadius = 10.0
        tranparentLayerOfCard.layer.cornerRadius = 10.0
        Alamofire.request(url + "addrs/" + String(describing: address["address"]!) + "/full").responseJSON{
            response in print(response.result.value!)
        }
        // For generating qr code
        if self.qrcodeImage == nil {
            if code == "" {
                print("no qr code available")
                return
            }
            let data = code.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            filter?.setValue("Q", forKey: "inputCorrectionLevel")
            self.qrcodeImage = filter?.outputImage
            self.displayQRCodeImage()
        }
        self.qrCode.alpha = 0.7
        
    }
    var qrcodeImage: CIImage!
    // function to clear out the blur QR code
    func displayQRCodeImage() {
        let scaleX = qrCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = qrCode.frame.size.height / qrcodeImage.extent.size.height
        let transformedImage = qrcodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        qrCode.image = UIImage(ciImage: transformedImage)
        qrCode.contentMode = .scaleAspectFit
        
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

//
//  FoodTableController.swift
//  First App
//
//  Created by Theodore Ando on 12/7/16.
//  Copyright © 2016 Theodore Ando. All rights reserved.
//

import UIKit
import MapKit

class FoodTableController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet @IBInspectable weak var tableHeader: UIView!
    var freeFoodResults = [FoodResult]()
    var locationManager = CLLocationManager()
    var refreshController = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
    
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // Set up pull to refresh
        self.refreshController.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshController.addTarget(self, action: #selector(FoodTableController.refresh), for: UIControlEvents.valueChanged)
        self.tableView?.addSubview(refreshController)
        
        // Download data and update table
        print("Loading json data...")
        downloadData()
        
        

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return freeFoodResults.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeFoodCell", for: indexPath) as! FreeFoodTableViewCell
        
        let result = freeFoodResults[indexPath.row]
        
        cell.locationLabel?.text = result.locationName
        cell.emailLabel?.text = result.emailText
        
        let distanceFormatter = MKDistanceFormatter()
        distanceFormatter.unitStyle = MKDistanceFormatterUnitStyle.abbreviated
        let prettyDistance = distanceFormatter.string(fromDistance: result.dist(manager: self.locationManager))
        cell.distanceLabel.text = prettyDistance
        print(prettyDistance)

        return cell
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
    // Override to support conditional rearranging of the view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    let foodSegueIdentifier = "ShowFoodSegue"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == foodSegueIdentifier, let destination = segue.destination as? FoodViewController, let foodIndex = tableView.indexPathForSelectedRow?.row {
            destination.foodResult = freeFoodResults[foodIndex]
        }
    }
    
    
    func refresh(sender: AnyObject) {
        self.downloadData()
    }
    
    
    func downloadData() {
        let requestURL: NSURL = NSURL(string: "http://frooder.herokuapp.com")!
        let urlRequest: URLRequest = URLRequest(url: requestURL as URL)
        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    for foodResult in (json as? [AnyObject])! {
                        do {
                            let f = try FoodResult(data: foodResult as! NSDictionary)
                            self.freeFoodResults.append(f)
                            print(f.locationName, f.latitude, f.longitude)
                        } catch {
                            continue
                        }
                        
                    }
                    print("Sorting JSON data by distance...")
                    self.freeFoodResults.sort(by: { $0.dist(manager: self.locationManager) < $1.dist(manager: self.locationManager) })
                    print("Sorted JSON data, reloading table view...")
                    DispatchQueue.main.async{
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error loading JSON: \(error)")
                }
            }
            if self.refreshController.isRefreshing
            {
                self.refreshController.endRefreshing()
            }
        }
        
        task.resume()
    }
    
}

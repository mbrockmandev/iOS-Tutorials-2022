  //
  //  MainTVC.swift
  //  ChartGenerator
  //
  //  Created by Michael Brockman on 10/24/22.
  //

import UIKit

class MainTVC: UITableViewController {
  var chart = Chart()
  let tableViewCells = ["CC", "HPI", "ROS", "MSE"]
  
  @IBOutlet weak var chiefComplaint: UILabel!
  
  @IBAction func resetButtonPushed(_ sender: UIButton) {
    chart.reset()
    tableView.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    chart.load()
    
//    print(">>> CC: \(chart.chiefComplaint)")
  }
  
  override func viewWillAppear(_ animated: Bool) {
//    chart.load()
    print(">>> CC: \(chart.chiefComplaint)")
  }
  
    // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
      // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
    return tableViewCells.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCells[indexPath.row], for: indexPath)
    
    
    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowCC" {
      let destVC = segue.destination as! ChiefComplaintVC
      destVC.chart = chart
    }
  }
  
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if segue.identifier == "ShowChiefComplaint" {
//      let destVC = segue.destination as! ChiefComplaintVC
//
//    }
//  }
  
}

  //
  //  MainTVC.swift
  //  Day59
  //
  //  Created by Michael Brockman on 10/23/22.
  //

import UIKit

class MainTVC: UITableViewController {
  var countryList = [Country]()
//  var countryList = Countries.offlineList
//  var baseURL = "https://restcountries.com/v3.1/name/"
  var baseURL = "https://restcountries.com/v3.1/lang/eng"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getCountries()
  }
  //TODO: fix networking code -- API call is bad and not matching
  //I either have to flatten the received data and filter down to name and brief description, or model data structures after the remote data
  //unfortunately I think the former is better
    //MARK: - Networking Code
  func getCountries() {
    for i in 0...countryList.count {
      print(countryList)
      let remoteURL = baseURL
      if let url = URL(string: remoteURL) {
        
          if let data = try? Data(contentsOf: url) {
            self.parse(json: data)
            return
          }
        
      }
    }
  }
  
  func parse(json: Data) {
    let decoder = JSONDecoder()
    
    if let jsonCountries = try? decoder.decode(Countries.self, from: json) {
      countryList = jsonCountries.results
      tableView.reloadData()
    }
  }
  
    // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
      // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if countryList.isEmpty {
      return 1
    }
    return countryList.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
    let country = countryList[indexPath.row]
    cell.textLabel?.text = country.name
      //    cell.detailTextLabel?.text = country.description
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = DetailVC()
    vc.detailItem = countryList[indexPath.row]
    navigationController?.pushViewController(vc, animated: true)
  }
  
  
}

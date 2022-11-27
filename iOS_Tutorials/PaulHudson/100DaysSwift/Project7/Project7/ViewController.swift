//
//  ViewController.swift
//  Project7
//
//  Created by Michael Brockman on 9/8/22.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var urlString: String = ""
    var filter: String?
    
    @IBOutlet weak var creditsBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        getPetitions()
    }
    

    func getPetitions() {
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        showError()
    }
    
    func filterPetitions(by userFilter: String?) {
        if userFilter == nil {
            filteredPetitions = petitions
        } else {
            filteredPetitions = petitions.filter
            { $0.title.lowercased().contains(userFilter?.lowercased() ?? "") }
            if filteredPetitions.isEmpty {
                let ac = UIAlertController(title: "No results found", message: "People must not care", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            } else {
                petitions.removeAll(keepingCapacity: true)
                petitions += filteredPetitions
                tableView.reloadData()
            }
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading Error!", message: "Whoops something is wrong", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func resetFilter() {
        filter = nil
    }
    
    //challenge 1 -- could extract the stringly typed stuff into enum or constants?
    @IBAction func creditsTouched(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Credits", message: "Data presented here comes from the We The People API hosted through Whitehouse.gov", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    //challenge 2
    @IBAction func filterTouched(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Filter by…", message: "nil", preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Filter", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.filterPetitions(by: answer)
        }
        
        ac.addAction(submitAction)
        
        if filter != nil {
            ac.addAction(UIAlertAction(title: "Reset Filter", style: .destructive))
            resetFilter()
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}


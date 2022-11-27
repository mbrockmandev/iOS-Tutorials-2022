  //
  //  StoryPrompTVC.swift
  //  StoryPrompt
  //
  //  Created by Michael Brockman on 9/5/22.
  //

import UIKit

class StoryPromptTVC: UITableViewController {
  
  var storyPrompts = [StoryPromptEntry]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    storyPrompts.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "StoryPromptCell", for: indexPath)
    cell.textLabel?.text = "Prompt \(indexPath.row + 1)"
    cell.imageView?.image = storyPrompts[indexPath.row].image
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let storyPrompt = storyPrompts[indexPath.row]
    performSegue(withIdentifier: "ShowStoryPrompt", sender: storyPrompt)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowStoryPrompt" {
      guard let storyPromptVC = segue.destination as? StoryPromptVC,
              let storyPrompt = sender as? StoryPromptEntry else {
        return
      }
      storyPromptVC.storyPrompt = storyPrompt
    }
  }
  
  @IBAction func saveStoryPrompt(unwindSegue: UIStoryboardSegue) {
    guard let storyPromptVC = unwindSegue.source as? StoryPromptVC,
          let storyPrompt = storyPromptVC.storyPrompt else {
      return
    }
    storyPrompts.append(storyPrompt)
    tableView.reloadData()
  }
  
  @IBAction func cancelStoryPrompt(unwindSegue: UIStoryboardSegue) {
    //dont need to do anything since we are canceling and not saving
  }
  
}

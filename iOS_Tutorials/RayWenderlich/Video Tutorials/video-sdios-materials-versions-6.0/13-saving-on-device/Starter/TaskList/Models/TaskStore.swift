/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Combine
import Foundation

class TaskStore: ObservableObject {    
  @Published var prioritizedTasks: [PrioritizedTasks] = [] {
    didSet {
      saveJSONPrioritizedTask()
    }
  }
  
  init() {
    loadJSONPrioritizedTasks()
  }
  
  func getIndex(for priority: Task.Priority) -> Int {
    prioritizedTasks.firstIndex { $0.priority == priority }!
  }
  
  private func loadJSONPrioritizedTasks() {
//    print(Bundle.main.bundleURL)
//    print(FileManager.documentsDirectoryURL)
//    print(FileManager.default.temporaryDirectory)
    
    let tasksJSONURL: URL
    if #available(iOS 16.0, *) {
      tasksJSONURL = URL(filePath: "PrioritizedTasks",
                             relativeTo: FileManager.documentsDirectoryURL).appendingPathExtension("json")
    } else {
      tasksJSONURL = URL(fileURLWithPath: "PrioritizedTasks",
                             relativeTo: FileManager.documentsDirectoryURL).appendingPathExtension("json")
    }
    
    print((try? FileManager.default.contentsOfDirectory(atPath: FileManager.documentsDirectoryURL.path)) ?? [])
    
    let decoder = JSONDecoder()
    
    do {
      let tasksData = try Data(contentsOf: tasksJSONURL)
      
      prioritizedTasks = try decoder.decode([PrioritizedTasks].self, from: tasksData)
    } catch let error {
      print(error)
    }
  }
  
  private func saveJSONPrioritizedTask() {
    let encoder = JSONEncoder()
    
    do {
      let taskData = try encoder.encode(prioritizedTasks.first?.tasks.last)
      
      let taskJSONURL = URL(fileURLWithPath: "Task", relativeTo: FileManager.documentsDirectoryURL).appendingPathExtension("json")
      print(taskJSONURL)
      try taskData.write(to: taskJSONURL, options: .atomicWrite)
      
    } catch let error {
      print(error.localizedDescription)
    }
    
  }
}

private extension TaskStore.PrioritizedTasks {
  init(priority: Task.Priority, names: [String]) {
    self.init(
      priority: priority,
      tasks: names.map { Task(name: $0) }
    )
  }
}

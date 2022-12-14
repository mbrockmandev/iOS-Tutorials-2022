  //
  //  ProspectsView.swift
  //  HotProspects
  //
  //  Created by Michael Brockman on 11/7/22.
  //

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
  @EnvironmentObject var prospects: Prospects
  @State private var isShowingScanner = false
  @State private var showSortingOptions = false
  
  let testData = "Paul Hudson\npaul@hackingwithswift.com"
  
  let filter: FilterType
  
  enum FilterType {
    case none, contacted, uncontacted
  }
  
  var title: String {
    switch filter {
    case .none:
      return "Everyone"
    case .contacted:
      return "Contacted people"
    case .uncontacted:
      return "Uncontacted people"
    }
  }
  
  var filteredProspects: [Prospect] {
    switch filter {
    case .none:
      return prospects.people
    case .contacted:
      return prospects.people.filter { $0.isContacted }
    case .uncontacted:
      return prospects.people.filter { !$0.isContacted }
    }
  }
  
  var body: some View {
    NavigationView {
      List {
        ForEach(filteredProspects) { prospect in
          HStack {
            if filter == .none {
              Image(systemName: prospect.isContacted ? "bell" : "bell.fill")
            }
            VStack(alignment: .leading) {
              Text(prospect.name)
                .font(.headline)
              Text(prospect.emailAddress)
                .foregroundColor(.secondary)
            }
            .swipeActions {
              if prospect.isContacted {
                Button {
                  prospects.toggle(prospect)
                } label: {
                  Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                }
                .tint(.blue)
              } else {
                Button {
                  prospects.toggle(prospect)
                } label: {
                  Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                }
                .tint(.green)
                Button {
                  addNotification(for: prospect)
                } label: {
                  Label("Remind Me", systemImage: "bell")
                }
                .tint(.orange)
              }
          }
          }
        }
      }
      
      .navigationTitle(title)
      .toolbar {
        Button {
          showSortingOptions = true
        } label: {
          Label("Sort", systemImage: "arrow.up.and.down.text.horizontal")
        }
        
        Button {
          isShowingScanner = true
        } label: {
          Label("Scan", systemImage: "qrcode.viewfinder")
        }
      }
      .confirmationDialog("Sort Items:", isPresented: $showSortingOptions) {
        Button("Sort by Name") {
          prospects.sort(by: .name)
        }
        Button("Sort by most Recent") {
          prospects.sort(by: .mostRecent)
        }
      }
      .sheet(isPresented: $isShowingScanner) {
        CodeScannerView(codeTypes: [.qr], simulatedData: testData, completion: handleScan)
      }
    }
  }
  
  func handleScan(result: Result<ScanResult, ScanError>) {
    isShowingScanner = false
    switch result {
    case .success(let success):
      let details = success.string.components(separatedBy: "\n")
      guard details.count == 2 else { return }
      
      let person = Prospect()
      person.name = details[0]
      person.emailAddress = details[1]
      
      prospects.add(person)
    case .failure(let error):
      print("Scanned failed: \(error.localizedDescription)")
    }
  }
  
  func addNotification(for prospect: Prospect) {
    let center = UNUserNotificationCenter.current()
    
    let addRequest = {
      let content = UNMutableNotificationContent()
      content.title = "Contact \(prospect.name)"
      content.subtitle = prospect.emailAddress
      content.sound = UNNotificationSound.default
      
      var dateComponents = DateComponents()
      dateComponents.hour = 9
//      let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) //test ONLY
      
      let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
      center.add(request)
    }
      
    center.getNotificationSettings { settings in
      if settings.authorizationStatus == .authorized {
        addRequest()
      } else {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
          if success {
            addRequest()
          } else {
            print("DOH")
          }
        }
      }
    }
  }

  
}

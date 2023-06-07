//
//  TableViewController.swift
//  EventsAppUIKit
//
//  Created by Виталий on 07.06.2023.
//

import UIKit
import Foundation
import WebKit

class TableViewController: UIViewController, WKNavigationDelegate {
    
    var posts = [EventItem]()
    let cellReuseIdentifier = "event"
    var name = ""
    var webView: WKWebView!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func sayHello(_ sender: UIButton) {
        let alert = UIAlertController(title: "Hello \(name)", message: "So glad to see you :)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "You too!", style: UIAlertAction.Style.default) {
            UIAlertAction in
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: EXTENSIONS

// UrlSession
extension TableViewController {
    
    private func fetchData() {
        if let url = URL(string: "https://kontests.net/api/v1/all") {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error == nil {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    if let safeData = data {
                        do {
                            let results: [EventItem] = try decoder.decode([EventItem].self, from: safeData)
                            DispatchQueue.main.async { [self] in
                                for i in 0...results.count - 1 {
                                    posts.append(results[i])
                                    posts[i].id = UUID().uuidString
                                    posts[i].start_time = formattedDate(date: results[i].start_time)
                                    posts[i].end_time = formattedDate(date: results[i].end_time)
                                }
                                self.tableView.reloadData()
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}

// tableView

extension TableViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CustomViewCell
        cell.nameLabel.text = posts[indexPath.row].name
        cell.startTime.text = "Start: \(posts[indexPath.row].start_time)"
        cell.endTime.text = "End: \(posts[indexPath.row].end_time)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        let url = URL(string: posts[indexPath.row].url)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}

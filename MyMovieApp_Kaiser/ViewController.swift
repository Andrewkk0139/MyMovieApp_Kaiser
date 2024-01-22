//
//  ViewController.swift
//  MyMovieApp_Kaiser
//
//  Created by ANDREW KAISER on 1/22/24.
//

import UIKit

struct SearchResult: Codable {
    var Search: [movieTitle]
}
struct movieTitle: Codable {
    var Title: String
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var titleFieldOutlet: UITextField!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableViewOutlet.dataSource = self
        tableViewOutlet.delegate = self
    }
    
    @IBAction func lookupAction(_ sender: Any) {
        let title = titleFieldOutlet.text
        movieLook(title!)
    }
    
    
    func movieLook(_ title: String) {
        print("Func running")
        // creating object of URLSession class to make api call
        let session = URLSession.shared

                //creating URL for api call (you need your apikey)
                let weatherURL = URL(string: "http://www.omdbapi.com/?apikey=f61dccf3&s=\(title)")!

                // Making an api call and creating data in the completion handler
                let dataTask = session.dataTask(with: weatherURL) {
                    // completion handler: happens on a different thread, could take time to get data
                    (data: Data?, response: URLResponse?, error: Error?) in

                    if let error = error {
                        print("Error:\n\(error)")
                    } else {
                        if let data = data {
                            if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                                print(jsonObj)
                                if let movieObj = try? JSONDecoder().decode(SearchResult.self, from: data){
                                    for t in movieObj.Search{
                                        print(t.Title)
                                        // num of rows
                                        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                                            return movieObj.Search.count
                                        }
                                        // pops each cell
                                        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                                            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")
                                            cell?.textLabel?.text = "\(t.Title)"
                                        }

                                    }
                                }
                            }
                            else {
                                print("Error: Can't convert data to json object")
                            }
                        }else {
                            print("Error: did not receive data")
                        }
                    }
                }

                dataTask.resume()
    }


}


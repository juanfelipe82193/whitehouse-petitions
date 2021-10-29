//
//  ViewController.swift
//  Project7
//
//  Created by Juan Felipe Zorrilla Ocampo on 9/10/21.
//

import UIKit

class ViewController: UITableViewController {
    
    var allPetitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = (UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterItems)))
        
        navigationItem.rightBarButtonItem = (UIBarButtonItem(title: "Clear Filter", style: .plain, target: self, action: #selector(clearFilter)))
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
        
    }
    
    @objc func fetchJSON() {
        
        let urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
            
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check yout connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            allPetitions = jsonPetitions.results
            filteredPetitions = allPetitions
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func filterItems() {
        let ac = UIAlertController(title: "Search...", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitSearch = UIAlertAction(title: "GO", style: .default) { [weak self, weak ac] action in
            guard let searchKey = ac?.textFields?[0].text else { return }
            self?.filter(searchKey)
        }
        ac.addAction(submitSearch)
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(ac, animated: true)
    }
    
    @objc func clearFilter() {
        filteredPetitions = allPetitions
        tableView.reloadData()
    }
    
    func filter(_ searchKey: String) {
        print(searchKey)
        if searchKey.count > 0 {
            filteredPetitions = allPetitions.filter {
                $0.title.contains(searchKey)
            }
            print(filteredPetitions)
        } else {
            filteredPetitions = allPetitions
        }
        tableView.reloadData()
    }
    
    @objc func openCredits() {
        let ac = UIAlertController(title: "We The People API by White House", message: "The data you're seeing comes from 'We the people' petitions from USA White House", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


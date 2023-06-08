//
//  JokeViewController.swift
//  IOS_Test
//
//  Created by Prasoon Tiwari on 06/06/23.
//

import UIKit


class JokeViewController: UIViewController {
    
    private let tableView = UITableView()
    private let customNavigationBar = UILabel()
    private var viewModel:JokeViewModel?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let httpUtility = HttpUtility()
        viewModel = JokeViewModel(httpUtility: httpUtility)
        setupUI()
        getAllJoks()
    }
    
    //Creating Header and TableView programmatically using autolayout(without xib and storyboard)
    private func setupUI() {
        // Create and setup custom navigation bar
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customNavigationBar)
        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor ,constant:0.0),
            customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: 100.0)
        ])
        customNavigationBar.text = "Top Ten Jokes"
        customNavigationBar.backgroundColor = .systemGreen
        customNavigationBar.textColor = .systemYellow
        customNavigationBar.textAlignment = .center
        customNavigationBar.font = .boldSystemFont(ofSize: 20.0)
        
        //Create and setup tableview
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor,constant:10.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Joke_Cell")
        tableView.dataSource = self
    }
    
    private func getAllJoks()
    {
        //get saved jokes from userdefault to diplay otherwise get from api
        viewModel?.getSavedJokes { jokes in
            if let jokes = jokes
            {
                print(jokes)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            //get jokes from api
            fetchJokes()
        }
    }
    
    private func fetchJokes() {
        viewModel?.fetchJoke { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching jokes: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    showAlert(title: Constants.ErrorAlertTitle, message: Constants.ErrorAlertMessage)
                }
                
                return
            }
            // Fetch new jokes after a delay of 60 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Constants.Joke_ApiCall_Interval)) { [weak self] in
                self?.fetchJokes()
            }
        }
    }
}

extension JokeViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getJokes().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Joke_Cell", for: indexPath)
        cell.contentView.backgroundColor = .white
        let joke = viewModel?.getJokes()[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = .darkGray
        cell.textLabel?.backgroundColor = .white
        cell.textLabel?.text = joke?.joke
        return cell
    }
}


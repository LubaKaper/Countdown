//
//  ViewController.swift
//  Countdown
//
//  Created by Liubov Kaper  on 7/13/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //2
    enum Section {
        case main // could have more sections
    }
    
    private var tableView: UITableView!
    //1
    // define datasource instance
    
    private var dataSource: UITableViewDiffableDataSource<Section, Int>!

    private var timer: Timer!
    
    private var startInterval = 10 // seconds
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureNavBar()
        
        configureTableView()
        
        configureDataSource()
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    // restart countdown 
    private func configureNavBar() {
        navigationItem.title = "Countdown with diffable data source"
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startCountdown))
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Int>(tableView: tableView, cellProvider: { (tableView, indexPath, value) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            if value == -1 {
                cell.textLabel?.text = "App lounched 🚀. All looks good so far with Crashlytics"
                cell.textLabel?.numberOfLines = 0
            } else {
                cell.textLabel?.text = "\(value)"
            }
            
            
            return cell
        })
        // setup animation
        dataSource.defaultRowAnimation = .fade
        
        // setuo snapShot
//        var snapshot = NSDiffableDataSourceSnapshot<ViewController.Section, Int>()
//        // add sections
//        snapshot.appendSections([.main])
//        snapshot.appendItems([1,2,3,4,5,6,7,8,9,10])
   //     dataSource.apply(snapshot, animatingDifferences: true)
        startCountdown()
    }
    
   @objc private func startCountdown() {
        if timer != nil {
            timer.invalidate()
        }
        // configure timer
        // set intewrval for countdown
        // assign method that gets called every second
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(decremetCounter), userInfo: nil, repeats: true)
        // reset our startingInterval
        startInterval = 10 // seconds
        
        // setup snapshot
        var snapshop = NSDiffableDataSourceSnapshot<ViewController.Section, Int>()
        snapshop.appendSections([.main])
        snapshop.appendItems([startInterval])
        dataSource.apply(snapshop, animatingDifferences: false)
        
        
    }
    
    @objc private func decremetCounter() {
        
        // get access to shnapshot to manipulate data
        
        var snapshot = dataSource.snapshot()
        guard startInterval > 0 else {
            timer.invalidate()
            ship()
            return
        }
        startInterval -= 1 // 10, 9, 8...0
        snapshot.appendItems([startInterval]) // 9 is inserted in tableview
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }
    // function to add extra raw
    private func ship() {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([-1])
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}


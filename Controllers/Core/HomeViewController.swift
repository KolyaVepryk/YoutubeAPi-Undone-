//
//  HomeViewController.swift
//  YoutubeAPI
//
//  Created by FREESKIER on 11.10.2022.
//

import UIKit

enum Sections: Int {
    case PlaylistAuthor = 0
    case PlaylistName = 1
}

class HomeViewController: UIViewController  {
    
    private var randomTrendingMovie: Title?
    
    var thePageVC: MainVideoPageViewController!
    
    let sectionTitles: [String] = ["Playlist Name", "Playlist Name"]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.alwaysBounceVertical = false
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    let myContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        self.homeFeedTable.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.15, alpha: 1.00)
        view.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.15, alpha: 1.00)
        view.addSubview(homeFeedTable)
        view.addSubview(myContainerView)
        createPageViewController()
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
    }
    
    private func setupNavBar() {
        self.navigationItem.title = "YouTube API"
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.15, alpha: 1.00)
        navigationItem.standardAppearance = appearance
    }
    
    func createPageViewController() {
        NSLayoutConstraint.activate([
            myContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0),
            myContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 21.0),
            myContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -21.0),
            myContainerView.heightAnchor.constraint(equalToConstant: 200.0)
        ])
        
        thePageVC = MainVideoPageViewController()
        addChild(thePageVC)
        thePageVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        myContainerView.addSubview(thePageVC.view)
        
        NSLayoutConstraint.activate([
            thePageVC.view.topAnchor.constraint(equalTo: myContainerView.topAnchor, constant: 0.0),
            thePageVC.view.bottomAnchor.constraint(equalTo: myContainerView.bottomAnchor, constant: 0.0),
            thePageVC.view.leadingAnchor.constraint(equalTo: myContainerView.leadingAnchor, constant: 0.0),
            thePageVC.view.trailingAnchor.constraint(equalTo: myContainerView.trailingAnchor, constant: 0.0)
        ])
        
        thePageVC.didMove(toParent: self)
    }
    
    private func configureHeroHeaderView() {
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {

            case .success(let titles):
                let selectedTitle = titles.randomElement()
                self?.randomTrendingMovie = selectedTitle
                
            case .failure(let erorr):
                print(erorr.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = CGRect(x: 0.0, y: 300.0, width: 415.0, height: 550.0)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case Sections.PlaylistAuthor.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                    
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.PlaylistName.rawValue:
            APICaller.shared.getTopRated { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
    
    private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 25, weight: .heavy)
        header.textLabel?.text = header.textLabel!.text!.capitalized
        header.textLabel?.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
}


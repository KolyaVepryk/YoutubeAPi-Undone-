//
//  PageViewController.swift
//  YoutubeAPI
//
//  Created by FREESKIER on 12.10.2022.
//

import UIKit
import SDWebImage

class BasePageViewController: UIViewController {
    
    let theLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textAlignment = .left
        return v
    }()
    
    var theView: UIView = {
        let viewPage = UIView()
        viewPage.translatesAutoresizingMaskIntoConstraints = false
        viewPage.layer.cornerRadius = 5
        viewPage.layer.masksToBounds = true
        
        return viewPage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.addSubview(theLabel)
        NSLayoutConstraint.activate([
            theLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            theLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            theLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
        ])
    }
}

// example Page View Controller
class MainVideoPageViewController: UIPageViewController {
    
    let imgStr = ["/apzIqZIQLc8fNx5nbbcSSfPFtax.jpg",
                  "/3uDwqxbr0j34rJVJMOW6o8Upw5W.jpg",
                  "/t6P9l6tcVnWLS1ADUAfkUCGQhm0.jpg",
                  "/jQHrbzVy6ptopxqUohV6PcmmVcY.jpg"
    ]
    var images: [UIImageView] = []
    
    func setupImages() {
        for str in imgStr {
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(str)") else {
                return
            }
            
            let image = UIImageView()
            image.sd_setImage(with: url , completed: nil)
            images.append(image)
        }
    }
    
    var pages: [UIViewController] = [UIViewController]()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImages()
        dataSource = self
        delegate = nil
        
        // instantiate "pages"
        for i in 0..<images.count {
            let vc = BasePageViewController()
            images[i].frame = vc.view.bounds
            vc.view.addSubview(images[i])
            pages.append(vc)
        }
        
        setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
    }
}

// typical Page View Controller Data Source
extension MainVideoPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return pages.last }
        guard pages.count > previousIndex else { return nil }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return pages.first }
        guard pages.count > nextIndex else { return nil }
        return pages[nextIndex]
    }
}

// typical Page View Controller Delegate
extension MainVideoPageViewController: UIPageViewControllerDelegate {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstVC = pageViewController.viewControllers?.first else {
            return 0
        }
        
        guard let firstVCIndex = pages.firstIndex(of: firstVC) else {
            return 0
        }
        return firstVCIndex
    }
}


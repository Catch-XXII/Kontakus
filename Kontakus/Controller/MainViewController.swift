//
//  ViewController.swift
//  Kontakus
//
//  Created by Cüneyd on 24.08.2019.
//  Copyright © 2019 com.kontakus.www. All rights reserved.
//

import UIKit
import CoreData
import DropDown
import GoogleMobileAds

class MainViewController: UIViewController {
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var bannerViewGAD: GADBannerView!
    var cellArray: [CustomCell] = []
    var personArray: [PersonEntity] = []
    var nameArray : [String] = []
    var isTimmerOn: Bool = false
    var dropButton = DropDown()
    var index: Int = 0
    var currentTimer: Timer?
    var countDown: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarSetup()
        fetchContacts()
        dropDown()
    }
    
    //MARK:- viewWillAppear Section
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DropDown.startListeningToKeyboard()
        DropDown.appearance().selectedTextColor = .white
        DropDown.appearance().selectionBackgroundColor = .kontakBlue
        DropDown.appearance().textColor = .kontakBlue
        DropDown.appearance().setupCornerRadius(10)
    }
    //MARK:- Google Ad service settings
    func googleAdSetup() {
        let adSize = GADAdSizeFromCGSize(CGSize(width: self.view.frame.width, height: 50))
        bannerViewGAD = GADBannerView(adSize: adSize)
        bannerViewGAD.adUnitID = "ca-app-pub-6436920500856865/2978735566"
        bannerViewGAD.rootViewController = self
        bannerViewGAD.load(GADRequest())
        addBannerToView(bannerViewGAD)
    }
    //MARK:- Google AdBanner
    func addBannerToView(_ bannerView: GADBannerView) {
        bannerViewGAD.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerViewGAD)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerViewGAD!,
                                attribute: .top,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerViewGAD!,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)])
    }
    //MARK:- Share my app button
    @IBAction func shareApp(_ sender: Any) {
        let shareText = "Look what i have just found on AppStore tap on the link to download this cool App!\n"
        let appURL = "https://apps.apple.com/us/app/id1499356819"
        let activityVC = UIActivityViewController(activityItems: [shareText + appURL], applicationActivities: [])
        present(activityVC, animated: true)
    }
    //MARK:- Reset all positions of UIViews
    @IBAction func resetButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "launchedBefore")
        positionCalculator(count: personArray.count)
        for i in 0..<cellArray.count {
            let size = CGSize(width: 120, height: 120)
            let origin = CGPoint(x: CGFloat(personArray[i].centerX), y: CGFloat(personArray[i].centerY))
            cellArray[i].frame = CGRect(origin: origin, size: size)
        }
        DatabaseOperations.shared().saveContext()
    }
}

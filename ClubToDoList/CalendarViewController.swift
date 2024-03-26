//
//  CalendarViewController.swift
//  ClubToDoList
//
//  Created by 밀가루 on 3/22/24.
//

//import UIKit
//
//class CalendarViewController: ViewController {
//    lazy var dateView: UICalendarView = {
//        var view = UICalendarView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.wantsDateDecorations = true
//        return view
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        
//        applyConstraints()
//    }
//
//    fileprivate func applyConstraints() {
//        view.addSubview(dateView)
//        
//        let dateViewConstraints = [
//            dateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            dateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            dateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//        ]
//        
//        NSLayoutConstraint.activate(dateViewConstraints)
//    }
//}

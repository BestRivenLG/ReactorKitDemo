//
//  ViewController.swift
//  ReactorKitDemo
//
//  Created by Cb on 2024/5/11.
//

import UIKit

enum DataSourceType: String, CaseIterable {
    case reactor
    case feedback
    case feedbackReques
    case todo
    
    var title: String {
        rawValue
    }
}

class ViewController: BasicViewController {
        
    var dataSource: [DataSourceType] = DataSourceType.allCases

    var didSelectSubject = PublishSubject<DataSourceType>()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.reloadData()
    }
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.dataSource = self
        $0.delegate = self
        $0.register(cellWithClass: UITableViewCell.self)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = (dataSource[indexPath.row])
        if type == .reactor {
            navigationController?.pushViewController(ReactorViewController())
        } else if type == .feedback {
            navigationController?.pushViewController(FeedbackViewController())
        } else if type == .feedbackReques {
            navigationController?.pushViewController(FeedbackRequestViewController())
        }
    }
}

//
//  ReactorViewController.swift
//  ReactorKitDemo
//
//  Created by liangang zhan on 2024/5/12.
//

import UIKit

class ReactorViewController: BasicViewController {
    
    var dataSource: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = homeReactor

        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: refreshBtn)
        
        tableView.reloadData()
        
    }
    
    lazy var homeReactor = HomeReactor()
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.dataSource = self
        $0.delegate = self
        $0.register(cellWithClass: UITableViewCell.self)
    }
    
    private lazy var refreshBtn = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("刷新", for: .normal)
    }
    
}

extension ReactorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
}

extension ReactorViewController: View {

    func bind(reactor: HomeReactor) {
        reactor.state.map({ $0.list }).subscribe(onNext: { [weak self] list in
            self?.dataSource += list
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        let loadSubject = PublishSubject<Void>()

        loadSubject.asObservable().map({ HomeReactor.Action.loadData }).bind(to: reactor.action).disposed(by: disposeBag)
        
        refreshBtn.rx.tap.map({ HomeReactor.Action.loadMore }).bind(to: reactor.action).disposed(by: disposeBag)
        
        loadSubject.onNext(())
    }
    
}


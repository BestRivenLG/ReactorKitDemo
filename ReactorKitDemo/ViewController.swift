//
//  ViewController.swift
//  ReactorKitDemo
//
//  Created by Cb on 2024/5/11.
//

import UIKit

class ViewController: BasicViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = homeReactor

        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(refreshBtn)
        refreshBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-15)
            make.top.equalTo(44)
            make.height.equalTo(44)
        }
        
        tableView.reloadData()
        
        reactor?.loadSubject.onNext(())
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        homeReactor.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = homeReactor.dataSource[indexPath.row]
        return cell
    }
}

extension ViewController: View {

    func bind(reactor: HomeReactor) {
        reactor.state.map({ $0.list }).subscribe(onNext: { [weak self] list in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        reactor.loadSubject.asObservable().map({ HomeReactor.Action.loadData }).bind(to: reactor.action).disposed(by: disposeBag)
        
        refreshBtn.rx.tap.map({ HomeReactor.Action.loadMore }).bind(to: reactor.action).disposed(by: disposeBag)
    }
    
}

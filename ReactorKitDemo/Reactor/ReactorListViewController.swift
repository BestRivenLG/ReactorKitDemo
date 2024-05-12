//
//  ReactorListViewController.swift
//  ReactorKitDemo
//
//  Created by liangang zhan on 2024/5/13.
//

import UIKit

class ReactorListViewController: BasicViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = homeReactor

        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: refreshBtn)]
    }
    
    lazy var homeReactor = ListReactor()
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(cellWithClass: UITableViewCell.self)
        $0.delegate = self
    }
    
    private lazy var refreshBtn = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("刷新", for: .normal)
    }
    
    private lazy var titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 44)).then {
        $0.textColor = .black
        
    }
    
}

extension ReactorListViewController: View {

    func bind(reactor: ListReactor) {
        
        let loadSubject = PublishSubject<Void>()

        loadSubject.asObservable().map({ ListReactor.Action.loadData }).bind(to: reactor.action).disposed(by: disposeBag)
        
        reactor.state.map { $0.list }.asDriver(onErrorJustReturn: []).drive(tableView.rx.items)(configureCell).disposed(by: disposeBag)
        
        // 回调方法封装
        tableView.rx.itemSelected.asObservable().withLatestFrom(reactor.state.map { $0.list }, resultSelector: itemForIndexPath)
        .bind(to: rx.title).disposed(by: disposeBag)

        tableView.rx.itemSelected.asObservable().withLatestFrom(reactor.state.map { $0.list }) { indexPath, list -> String in
            list[indexPath.row]
        }.bind(to: rx.title).disposed(by: disposeBag)
        
        refreshBtn.rx.tap.map({ ListReactor.Action.loadMoreData }).bind(to: reactor.action).disposed(by: disposeBag)
        
        loadSubject.onNext(())
    }
    
    private func configureCell(tableView: UITableView, row: Int, string: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = string
        return cell
    }
    
    private func itemForIndexPath(indexPath: IndexPath, list: [String]) -> String {
        list[indexPath.row]
    }
}

extension ReactorListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let list = homeReactor.currentState.list
        print("list  = \(list)")
        return 100
    }
}


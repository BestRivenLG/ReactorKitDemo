//
//  FeedbackListViewController.swift
//  ReactorKitDemo
//
//  Created by liangang zhan on 2024/5/12.
//

import UIKit

fileprivate struct State {
    var lists: [String]
    
    static func reduce(state: State, event: Event) -> State {
        var state = state
        switch event {
        case .loadNewData:
            state.lists = ["fasdf", "asdfas", "asdfas", "asdfas"]
        }
        return state
    }
    
    static func configureCell(tableView: UITableView, row: Int, string: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = string
        return cell
    }
}

fileprivate enum Event {
    case loadNewData
}

class FeedbackListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
//        let configCell = { (tableView: UITableView, row: Int, string: String) -> UITableViewCell in
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
//            cell.textLabel?.text = string
//            return cell
//        }
        
//        let handler: (State, Event) -> State = State.reduce
        
        let triggerLoadData: (Driver<State>) -> Signal<Event> = { state in
            Signal.just(Event.loadNewData)
        }
        
        let bindUI: (Driver<State>) -> Signal<Event> = bind(self) { me, state in
            let subscriptions: [Disposable] = [
                state.map { $0.lists }.drive(me.tableView.rx.items)(State.configureCell)
            ]
            let events: [Signal<Event>] = [
                triggerLoadData(state)
            ]
            return Bindings(subscriptions: subscriptions, events: events)
        }
        
        Driver.system(initialState: State(lists: []), reduce: State.reduce, feedback: bindUI).drive().disposed(by: rx.disposeBag)
        
    }
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(cellWithClass: UITableViewCell.self)
    }
}

//
//  FeedbackRequestViewController.swift
//  ReactorKitDemo
//
//  Created by liangang zhan on 2024/5/12.
//

import UIKit

enum State {
    case humanHasIt(Int)
    case machineHasIt(Int)
    
    var value: Int {
        switch self {
        case .humanHasIt(let int):
            return int
        case .machineHasIt(let int):
            return int
        }
    }
    
    var humanValue: Int? {
        if case let State.humanHasIt(int) = self {
            return int
        }
        return nil
    }
    
    var machineValue: Int? {
        if case let State.machineHasIt(int) = self {
            return int
        }
        return nil
    }
    
    
    var isHuman: Bool {
        self == .humanHasIt(0)
    }
    
    var isMachine: Bool {
        self == .machineHasIt(0)
    }
    
    var isMachineRequest: RequestEqual? {
        isMachine ? RequestEqual(value: value) : nil
    }
}

extension State: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.humanHasIt, .humanHasIt):
            return true
        case (.machineHasIt, .machineHasIt):
            return true
        default:
            return false
        }
    }
}

enum Event {
    case minus
    case add
    case result
}

struct RequestEqual: Equatable {
    
    var value = 0
    
}


class FeedbackRequestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(100)
        }
        
        stackView.addArrangedSubviews([minusBtn, contentLabel, addBtn])
        contentLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        
        view.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.top.equalTo(contentLabel.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
        }

        Observable.system(initialState: State.humanHasIt(0), reduce: { state, event -> State in
            var state = state
            switch event {
            case .add:
                state = State.machineHasIt(state.value + 1)
            case .minus:
                state = State.machineHasIt(state.value - 1)
            case .result:
                state = State.humanHasIt(state.value)
            }
            return state
        }, scheduler: MainScheduler.instance, feedback: bind(self) { me, state -> Bindings<Event> in
            let subscriptions = [
                state.map({ $0.humanValue == nil ? "" : "\($0.humanValue!)" }).bind(to: me.contentLabel.rx.text),
                state.map({ $0.machineValue == nil ? "" : "\($0.machineValue!)" }).bind(to: me.detailLabel.rx.text)
            ]
            let evetnts = [
                me.minusBtn.rx.tap.map({ Event.minus }),
                me.addBtn.rx.tap.map({ Event.add }),
            ]
            return Bindings(subscriptions: subscriptions, events: evetnts)
        }, react(request: { $0.isMachineRequest }, effects: { _ -> Observable<Event> in
            Observable<Int>.timer(.seconds(3), scheduler: MainScheduler.instance).map({ _ in Event.result })
        })).subscribe().disposed(by: rx.disposeBag)
        
    }

    let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 5.0
    }
    
    let minusBtn = UIButton().then {
        $0.setTitle("-", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    let contentLabel = UILabel().then {
        $0.textColor = .black
        $0.text = "0"
        $0.textAlignment = .center
    }
    
    let detailLabel = UILabel().then {
        $0.textColor = .black
        $0.text = "0"
        $0.textAlignment = .center
    }
    
    let addBtn = UIButton().then {
        $0.setTitle("+", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
}

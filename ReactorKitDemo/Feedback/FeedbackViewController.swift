//
//  FeedbackViewController.swift
//  ReactorKitDemo
//
//  Created by liangang zhan on 2024/5/12.
//

import UIKit

class FeedbackViewController: UIViewController {

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
        
        typealias State = Int
        
        enum Event {
            case minus
            case add
        }
        
        Observable.system(initialState: 0, reduce: { state, event -> State in
            var state = state
            switch event {
            case .add:
                state += 1
            case .minus:
                state -= 1
            }
            return state
        }, scheduler: MainScheduler.instance, feedback: bind(self) { me, state -> Bindings<Event> in
            let subscriptions = [
                state.map({ "\($0)" }).bind(to: me.contentLabel.rx.text)
            ]
            let evetnts = [
                me.minusBtn.rx.tap.map({ Event.minus }),
                me.addBtn.rx.tap.map({ Event.add }),
            ]
            return Bindings(subscriptions: subscriptions, events: evetnts)
        }).subscribe().disposed(by: rx.disposeBag)
        
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
    
    let addBtn = UIButton().then {
        $0.setTitle("+", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
}

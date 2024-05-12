//
//  ListReactor.swift
//  ReactorKitDemo
//
//  Created by liangang zhan on 2024/5/13.
//

import Foundation

class ListReactor: Reactor {
    
    let initialState = State(list: [], noMore: false)
    
    enum Action {
        case loadData
        case loadMoreData
    }
    
    enum Mutation {
        case loadDataResult(_ list: [String], noMore: Bool)
        case loadMoreDataResult(_ list: [String], noMore: Bool)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadData:
            return Observable<Int>.timer(.seconds(3), scheduler: MainScheduler.instance).map { _ in Mutation.loadDataResult(["dafadsf", "sadfasdf", "sadfasdf"], noMore: false)}
        case .loadMoreData:
            return Observable<Int>.timer(.seconds(3), scheduler: MainScheduler.instance).map { _ in Mutation.loadDataResult(["dafadsffasdf", "sadfasdf", "sadfasdf", "dafadsffasdf", "sadfasdf", "sadfasdf", "dafadsffasdf", "sadfasdf", "sadfasdf"], noMore: false) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .loadDataResult(let list, let noMore):
            state.list = list
            state.noMore = noMore
        case .loadMoreDataResult(let list, let noMore):
            state.list += list
            state.noMore = noMore
        }
        return state
    }
    
    struct State {
        var list: [String]
        var noMore: Bool
    }
}

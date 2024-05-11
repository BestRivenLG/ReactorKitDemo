//
//  HomeReactor.swift
//  ReactorKitDemo
//
//  Created by Cb on 2024/5/11.
//

import Foundation

class HomeReactor: Reactor {
    let initialState: State
    
    init() {
        self.initialState = State()
    }
        
    enum Action {
        case loadData
        case loadMore
    }
    
    enum Mutation {
        case loadDataResult(_ list: [String], noMore: Bool)
        case loadMoreResult(_ list: [String], noMore: Bool)
    }
    
    struct State {
        var list: [String] = []
        var page: Int = 0
        var noMore: Bool = false
    }
    
    //
    var dataSource: [String] = []
    
    var loadSubject = PublishSubject<Void>()

}


// MAKR: - Mutation
extension HomeReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadData:
            return Observable.just(.loadDataResult(["asfadsf", "dsfasdfasdf", "asdfasdf", "asdfasdf"], noMore: false))
        case .loadMore:
            return Observable.just(.loadMoreResult(["asfdsfadsf", "dsfasdfasdf", "asdfasdf", "asfdsfadsf", "dsfasdfasdf", "asdfasdf", "asdfasdf"], noMore: true))
        }
    }
    
}

// MARK: - Reducer
extension HomeReactor {

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .loadDataResult(let list, let noMore):
            state.list = list
//            dataSource = list
            state.noMore = noMore
        case .loadMoreResult(let list, let noMore):
            state.list += list
//            dataSource += list
            state.noMore = noMore
        }
        return state
    }
    
}

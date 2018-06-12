//
//  RegisterViewModel.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/10.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import RxCocoa
import LeanCloud

final class RegisterViewModel {
    
    struct Input {
        let username: Observable<String>
        let password: Observable<String>
        let registerTap: ControlEvent<Void>
    }
    
    struct Output {
        let isEnabled: Driver<Bool>
        let register: Driver<Bool>
        let state: Driver<UIState>
    }
}

extension RegisterViewModel: ViewModelType {
    
    func transform(_ input: RegisterViewModel.Input) -> RegisterViewModel.Output {
        let isEnabled = Observable.combineLatest(input.username.isEmpty, input.password.isEmpty) { !$0 && !$1 }.asDriver(onErrorJustReturn: false)
        
        let state = PublishRelay<UIState>()
        let usernameAndPassword = Observable.combineLatest(input.username, input.password) { (username: $0, password: $1) }
        let register = input.registerTap.withLatestFrom(usernameAndPassword).flatMapLatest({
            LCUser.rx.register(username: $0.username, password: $0.password)
                .trackState(state, success: "注册成功").catchErrorJustComplete()
        }).asDriver(onErrorJustReturn: false)
        
        return Output(isEnabled: isEnabled, register: register, state: state.asDriver(onErrorJustReturn: .idle))
    }
}

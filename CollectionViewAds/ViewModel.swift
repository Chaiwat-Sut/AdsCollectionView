//
//  ViewModel.swift
//  
//
//  Created by A667459 A667459 on 6/2/2567 BE.
//
import UIKit
import RxSwift

class ViewModel {
    
    var output: Output
    var allSubject = PublishSubject<(Bool,Bool,Bool,Bool)>()
    
    var hamburger = false
    var frenchFries = false
    var iceCream = false
    
    init(){
        self.output = Output(displaySwitch: allSubject.asObserver())
    }
    
    func setSwitches() {
        let allSwitchIsOn = hamburger && frenchFries && iceCream
        allSubject.onNext(
            (allSwitchIsOn,
             hamburger,
             frenchFries,
             iceCream)
        )
    }
    
    func validateSwitches() -> SwitchState {
        if hamburger && frenchFries && iceCream {
            return .allOn
        }
        else if hamburger || frenchFries || iceCream {
            return .someOn
        }
        else {
            return .allOff
        }
    }
    
    func setLabel() -> String {
        var text = ""
        if hamburger {
            text += "hamburger, "
        }
        if frenchFries {
            text += "french fries, "
        }
        if iceCream {
            text += "ice cream, "
        }
        return text
    }

    
}

struct Output {
    var displaySwitch: Observable<(Bool,Bool,Bool,Bool)>
}

enum SwitchState {
    case allOn
    case someOn
    case allOff
}

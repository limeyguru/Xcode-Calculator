//
//  ViewController.swift
//  Calculator
//
//  Created by Ken Booth on 6/18/22.
//

import UIKit

let decimal = 10
let clear = 11
let plus_minus = 12
let percent = 13
let divide = 14
let multiply = 15
let minus = 16
let plus = 17
let equals = 18
let back = 19
let none = -1

let ops : [Int: String] = [
    divide: "/",
    multiply: "X",
    minus: "-",
    plus: "+"]

let validOperators : [Int] = [divide, multiply, minus, plus]

class ViewController: UIViewController {
    
    var accumulator1: String = "0"
    var accumulator2: String = ""
    var oper = none
    var value1 : Double = 0
    var value2 : Double = 0
    var result : Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var accumLabel1: UILabel!
    @IBOutlet var accumLabel2: UILabel!
    
    @IBAction func buttonPress(_ sender: UIButton) {
        //print("Button number \(sender.tag) pressed")
        switch(sender.tag) {
        case 0:
            if (accumulator1.isEmpty || accumulator1 != "0"){
                accumulator1 += "0"
            }
            break
        case 1...9:
            accumulator1 += "\(sender.tag)"
            break
        case decimal :
            if (!accumulator1.contains(".")){
                accumulator1 += "."
            }
            break
        case clear :
            reset()
            break
        case plus_minus :
            if (!accumulator1.isEmpty && accumulator1.starts(with: "-")) {
                accumulator1.removeFirst()
            }
            else {
                accumulator1.insert("-", at: accumulator1.startIndex)
            }
            break
        case minus :
            if (accumulator1.isEmpty || (accumulator1 == "0")){
                accumulator1 = "-0"
                break
            }
            fallthrough
        case divide, multiply, plus :
            processOperatorKey(_op: sender.tag)
            break
        case percent :
            value1 /= 100
            accumulator1 = "\(value1)"
            if (oper == none) {
                break
            }
            if (oper == plus || oper == minus) {
                value1 *= value2
            }
            fallthrough
        case equals :
            switch (oper) {
            case plus:
                result = value2 + value1
                break
            case minus:
                result = value2 - value1
                break
            case multiply:
                result = value2 * value1
                break
            case divide:
                result = value2 / value1
                break
            default:
                break
            }
            //print("result calculates as \(result)")
            reset()
            value1 = result
            accumulator1 = "\(value1)"
            update()
            break
        case back :
            if (!accumulator1.isEmpty){
                accumulator1.removeLast()
            }
            break
        default:
            return
        }
        evaluate()
        update()
    }
    
    func reset() {
        accumulator1 = "0"
        accumulator2  = ""
        oper = none
        value1  = 0
        value2  = 0
        evaluate()
        update()
    }
    func evaluate() {
        value1 = Double(accumulator1) ?? 0
        value2 = Double(accumulator2) ?? 0
        //print("value1 calculates as \(value1), value2 calculates as \(value2)")
    }
    func processOperatorKey(_op : Int) {
        if (validOperator(_oper: _op)) {
            oper = _op
            accumulator2 = accumulator1
            value2 = value1
            accumulator1 = "0"
            value1 = 0
        }
    }
    func validOperator(_oper : Int) -> Bool {
        return validOperators.contains(_oper)
    }
    
    func update(){
        accumLabel1.text = accumulator1
        if (validOperator(_oper: oper)) {
            let op : String = ops[oper] ?? ""
            accumLabel2.text = accumulator2 + " \(op)"
        }
        else {
            accumLabel2.text = ""
        }
    }
    
}


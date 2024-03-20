//
//  AddViewController.swift
//  ClubToDoList
//
//  Created by 밀가루 on 3/20/24.
//

import UIKit

protocol AddViewControllerDelegate: AnyObject {
    func didSaveTodoItem(_ todoItem: TodoItem)
}

class AddViewController: UIViewController, UITextFieldDelegate {
    weak var delegate: AddViewControllerDelegate?
    var todos: [TodoItem] = [] // 변경된 부분: 옵셔널이 아닌 일반 배열로 변경

    @IBOutlet weak var textfield: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textfield.attributedPlaceholder = NSAttributedString(string: "오늘의 ToDo를 입력해 주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        
        // 텍스트 필드의 delegate 설정
        textfield.delegate = self
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        // Save 버튼을 눌렀을 때 실행되는 액션 메서드
        guard let text = textfield.text, !text.isEmpty else {
            return
        }
        
        // 새로운 TodoItem 객체 생성
        let todoItem = TodoItem(title: text)
        
        // todos 배열에 추가
        todos.append(todoItem)
        
        // delegate를 통해 ViewController에 todoItem 전달
        delegate?.didSaveTodoItem(todoItem)
        print("todoItem \(todoItem)")
        
        // 이전 화면으로 돌아감
        navigationController?.popViewController(animated: true)
    }
}


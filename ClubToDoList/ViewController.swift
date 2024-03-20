//
//  ViewController.swift
//  ClubToDoList
//
//  Created by 밀가루 on 3/20/24.
//

import UIKit

struct TodoItem {
    static var nextId = 1 // 다음에 추가될 아이템의 아이디
    var id: Int
    var title: String
    var isCompleted: Bool

    init(title: String, isCompleted: Bool = false) {
        self.id = TodoItem.nextId
        self.title = title
        self.isCompleted = isCompleted
        TodoItem.nextId += 1 // 아이디 증가
    }
}


class ViewController: UIViewController, AddViewControllerDelegate {
    // To-Do 데이터 배열
    var todos: [TodoItem] = [] // 변경된 부분: 옵셔널이 아닌 일반 배열로 변경

    override func viewDidLoad() {
        super.viewDidLoad()
                
        // To-Do 배열이 비어 있는지 여부 확인
        if todos.isEmpty {
            print("투두 리스트는 비어 있습니다.")
        } else {
            print("투두 리스트 목록 \(todos)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 화면이 표시될 때마다 todos 배열을 출력하여 확인
        print("현재 투두 리스트: \(todos)")
    }
 

    // AddViewControllerDelegate 프로토콜 메서드 구현
    func didSaveTodoItem(_ todoItem: TodoItem) {
        // To-Do 배열에 추가
        todos.append(todoItem)
    }

    // AddViewController를 호출하는 메서드
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addVC = segue.destination as? AddViewController {
            addVC.delegate = self
        }
    }
    
}

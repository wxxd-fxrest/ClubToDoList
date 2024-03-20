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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddViewControllerDelegate {
    
    @IBOutlet var table: UITableView!

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
        
        // 테이블 뷰의 delegate와 dataSource 설정
        table.delegate = self  // 이 라인에서 nil이 아닌지 확인
        table.dataSource = self  // 이 라인에서 nil이 아닌지 확인
        
        // 셀 등록
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // 테이블 뷰의 상호 작용 활성화
        table.allowsSelection = true
        table.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 화면이 표시될 때마다 todos 배열을 출력하여 확인
        print("현재 투두 리스트: \(todos)")
    }
    
    // 섹션 수 반환
    func numberOfSections(in tableView: UITableView) -> Int {
        return todos.count
    }
    
    // 각 섹션별로 행의 개수 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let todoItem = todos[indexPath.section] // 섹션에 해당하는 todoItem 가져오기
        cell.textLabel?.text = todoItem.title
        cell.textLabel?.textColor = todoItem.isCompleted ? .gray : .black

        // 체크박스 이미지뷰 생성
        let checkboxImageView = UIImageView()
        checkboxImageView.contentMode = .scaleAspectFit // 이미지가 비율을 유지하면서 이미지뷰에 맞추도록 설정
        
        if todoItem.isCompleted {
            checkboxImageView.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            checkboxImageView.image = UIImage(systemName: "checkmark.circle")
        }
        
        // 체크박스 이미지뷰 크기 설정
        let checkboxSize: CGFloat = 24 // 원하는 크기로 조절 가능
        checkboxImageView.frame = CGRect(x: 0, y: 0, width: checkboxSize, height: checkboxSize)
        
        // 셀의 액세서리뷰로 설정
        cell.accessoryView = checkboxImageView
        
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 해당 셀의 TodoItem 가져오기
        var todoItem = todos[indexPath.section]
        
        // isCompleted 값 변경
        todoItem.isCompleted = !todoItem.isCompleted
        
        // 변경된 TodoItem을 배열에 다시 할당
        todos[indexPath.section] = todoItem
        
        // 테이블 뷰 리로드
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 해당 indexPath에 해당하는 TodoItem을 배열에서 제거
            todos.remove(at: indexPath.section)
            
            // 테이블 뷰에서 해당 행을 삭제
            tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        }
    }

    // AddViewControllerDelegate 프로토콜 메서드 구현
    func didSaveTodoItem(_ todoItem: TodoItem) {
        // To-Do 배열에 추가
        todos.append(todoItem)
        // 테이블 뷰 리로드
        table.reloadData()
    }

    // AddViewController를 호출하는 메서드
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addVC = segue.destination as? AddViewController {
            addVC.delegate = self
        }
    }
    
}

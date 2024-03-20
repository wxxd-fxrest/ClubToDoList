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
    var saveDate: String // 날짜를 저장할 문자열 형식 추가

    init(title: String, isCompleted: Bool = false, date: Date = Date()) {
        self.id = TodoItem.nextId
        self.title = title
        self.isCompleted = isCompleted
        
        // 날짜를 "yyyy년 MM월 dd일" 형식으로 포맷팅하여 문자열로 저장
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        self.saveDate = dateFormatter.string(from: date)
        
        TodoItem.nextId += 1 // 아이디 증가
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var table: UITableView!

    // MARK: - Properties
    
    // To-Do 데이터 배열
    var todos: [TodoItem] = [] // 변경된 부분: 옵셔널이 아닌 일반 배열로 변경
    var expandedSections = Set<Int>() // 펼쳐진 섹션을 추적하는 세트

    // MARK: - View Life Cycle

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

    // MARK: - UITableViewDataSource

    // 섹션 수 반환
    func numberOfSections(in tableView: UITableView) -> Int {
        // todos 배열에서 고유한 날짜 수만큼 섹션을 반환하여 날짜별로 데이터를 묶어 표시
        return Set(todos.map { $0.saveDate }).count
    }
    
    // 각 섹션별로 행의 개수 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 섹션이 펼쳐져 있는지 여부에 따라 다른 행의 개수를 반환
        if expandedSections.contains(section) {
            let date = Set(todos.map { $0.saveDate }).sorted()[section]
            return todos.filter { $0.saveDate == date }.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // 섹션 제목으로 해당 섹션의 날짜를 반환하여 날짜별로 데이터를 구분하여 표시
        let date = Set(todos.map { $0.saveDate }).sorted()[section] // 고유한 날짜 중 정렬된 순서의 날짜 가져오기
        return date
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let date = Set(todos.map { $0.saveDate }).sorted()[indexPath.section] // 고유한 날짜 중 정렬된 순서의 날짜 가져오기
        let todosOnDate = todos.filter { $0.saveDate == date } // 해당 날짜의 TodoItem들
        
        if expandedSections.contains(indexPath.section) {
            let todoItem = todosOnDate[indexPath.row]
            cell.textLabel?.text = todoItem.title
            cell.textLabel?.textColor = todoItem.isCompleted ? .gray : .black
            cell.selectionStyle = .none

            // 셀의 accessoryView로 UISwitch 설정
            var mySwitch: UISwitch
            if let accessory = cell.accessoryView as? UISwitch {
                mySwitch = accessory
            } else {
                mySwitch = UISwitch()
                mySwitch.addTarget(self, action: #selector(didChangeSwitch(_:)), for: .valueChanged)
                cell.accessoryView = mySwitch
            }
            
            // 스위치의 tag 속성에 셀의 인덱스를 설정하여 매핑
            mySwitch.tag = indexPath.row
            // UISwitch의 상태 설정
            mySwitch.isOn = todoItem.isCompleted
        } else {
            cell.textLabel?.text = ""
            cell.accessoryView = nil // 셀이 토글되지 않은 경우 아무 내용도 표시하지 않음
        }
        
        return cell
    }

    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let section = indexPath.section
            
            // 해당 섹션의 모든 아이템 가져오기
            let date = Set(todos.map { $0.saveDate }).sorted()[section]
            let todosInSection = todos.filter { $0.saveDate == date }
            
            // 해당 아이템 삭제
            todos.remove(at: indexPath.row)
            
            // 해당 섹션의 아이템 개수 확인
            let itemCountInSection = todosInSection.count
            
            if itemCountInSection == 1 {
                // 해당 섹션의 아이템이 한 개인 경우 섹션 삭제
                todos.removeAll { $0.saveDate == date }
                tableView.deleteSections(IndexSet(integer: section), with: .automatic)
            } else {
                // 해당 섹션의 아이템이 여러 개인 경우 행만 삭제
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    

    // MARK: - Action
    
    @IBAction func iconButtonTapped(_ sender: UIButton) {
        // 아이콘 버튼을 누를 때 실행되는 메서드
        // UIAlertController 생성
        let alertController = UIAlertController(title: nil, message: "새로운 ToDo 추가", preferredStyle: .alert)
        
        // 텍스트 필드 추가
        alertController.addTextField { textField in
            textField.placeholder = "오늘의 ToDo를 입력해 주세요."
        }
        
        // 액션 추가 - 추가
        let addAction = UIAlertAction(title: "추가", style: .default) { _ in
            // 텍스트 필드에서 입력한 값 가져오기
            if let textField = alertController.textFields?.first, let text = textField.text, !text.isEmpty {
                // 입력한 값으로 TodoItem 생성
                let todoItem = TodoItem(title: text)
                
                // 생성한 TodoItem을 배열에 추가
                self.todos.append(todoItem)
                
                // 테이블 뷰 리로드
                self.table.reloadData()
            } else {
                print("텍스트가 입력되지 않았습니다.")
            }
        }
        alertController.addAction(addAction)
        
        // 액션 추가 - 취소
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // UIAlertController 표시
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 52))
        
        // Arrow 아이콘 추가
        let arrowImageView = UIImageView()
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.image = expandedSections.contains(section) ? UIImage(systemName: "arrowtriangle.down.circle") : UIImage(systemName: "arrowtriangle.right.circle")
        arrowImageView.tintColor = expandedSections.contains(section) ? UIColor(named: "TrueColor") : UIColor(named: "FalseColor")
        arrowImageView.frame = CGRect(x: tableView.frame.width - 44, y: 0, width: 24, height: 24)
        arrowImageView.tag = section // 섹션을 구별하기 위해 태그 설정
        headerView.addSubview(arrowImageView)
        
        // Tap Gesture Recognizer 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sectionHeaderTapped(_:)))
        headerView.addGestureRecognizer(tapGesture)
        headerView.tag = section
        
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: tableView.frame.width - 80, height: 26))
        label.text = todos[section].saveDate
        label.font = UIFont.boldSystemFont(ofSize: 18) // 볼드체 폰트 설정
        label.textColor = .gray // 회색 텍스트 색상 설정
        headerView.addSubview(label)
        
        return headerView
    }

    @objc func sectionHeaderTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let section = gestureRecognizer.view?.tag else { return }
        if expandedSections.contains(section) {
            expandedSections.remove(section)
        } else {
            expandedSections.insert(section)
        }
        table.reloadSections(IndexSet(integer: section), with: .automatic)
    }

    // MARK: - Action
    
    @objc func didChangeSwitch(_ sender: UISwitch) {
        print("현재 투두 리스트: \(todos)")
        // 스위치를 소유한 셀의 인덱스를 얻어옴
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        // 해당 indexPath의 todoItem 가져오기
        let date = Set(todos.map { $0.saveDate }).sorted()[indexPath.section]
        let todosOnDate = todos.filter { $0.saveDate == date }
        var todoItem = todosOnDate[indexPath.row]
        
        // isCompleted 값을 토글
        todoItem.isCompleted = sender.isOn
        
        // 변경된 todoItem을 배열에 다시 할당
        if let index = todos.firstIndex(where: { $0.id == todoItem.id }) {
            todos[index] = todoItem
        }
        
        // 해당 셀을 다시 로드하여 변경 사항을 반영
        table.reloadRows(at: [indexPath], with: .automatic)
    }
}

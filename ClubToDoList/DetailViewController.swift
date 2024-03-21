//
//  DetailViewController.swift
//  ClubToDoList
//
//  Created by 밀가루 on 3/20/24.
//

import UIKit

// DetailViewControllerDelegate 프로토콜 정의
protocol DetailViewControllerDelegate: AnyObject {
    // 저장 버튼이 눌렸을 때 호출되는 메서드
    func detailViewControllerDidSave(todoItem: TodoItem)
}

// 세부 정보 편집을 위한 뷰 컨트롤러
class DetailViewController: UIViewController, UITextViewDelegate {
    
    // 델리게이트 속성 선언
    var delegate: DetailViewControllerDelegate?

    // MARK: - Properties
    
    var todoItem: TodoItem? // 전달된 TodoItem을 저장할 변수
    var saveDate: String? // 전달된 날짜를 저장할 변수
    var textViewEdited = false // TextView가 수정되었는지 여부를 나타내는 변수
    var memoViewEdited = false // MemoView가 입력되었는지 여부를 나타내는 변수

    // MARK: - Outlets
    
    @IBOutlet weak var textView: UITextView! // 제목을 입력받는 TextView
    @IBOutlet weak var completionStatusLabel: UILabel! // 완료 상태를 나타내는 레이블
    @IBOutlet weak var memoView: UITextView! // 메모를 입력받는 TextView

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TodoItem이 존재하는지 확인하고 화면 설정
        if let todoItem = todoItem {
            // TodoItem이 전달되었을 때
            title = "Todo 상세 정보"
            textView.text = todoItem.title
            memoView.text = todoItem.memo
            completionStatusLabel.text = todoItem.isCompleted ? "완료됨" : "미완료"
        } else {
            // TodoItem이 전달되지 않았을 때
            title = "새로운 Todo 추가"
            completionStatusLabel.text = "미완료"
        }
        
        // TextView 및 MemoView delegate 설정
        textView.delegate = self
        memoView.delegate = self
        
        // TextView 포커스 설정
        textView.becomeFirstResponder()
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        // TextView의 내용이 변경되었을 때 호출되는 메서드
        textViewEdited = true
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        // Save 버튼을 눌렀을 때 호출되는 메서드
        guard let title = textView.text, !title.isEmpty else {
            // 제목이 비어있을 경우 경고 표시
            showAlert(message: "제목을 입력해주세요.")
            return
        }
        
        // TodoItem 생성
        let todoItem = TodoItem(title: title, isCompleted: false, memo: memoView.text)
        
        // 델리게이트에게 TodoItem 전달
        delegate?.detailViewControllerDidSave(todoItem: todoItem)
        
        // 이전 화면으로 이동
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper Methods
    
    func showAlert(message: String) {
        // 경고창 표시 메서드
        let alertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}



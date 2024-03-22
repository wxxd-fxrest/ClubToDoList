//
//  DetailViewController.swift
//  ClubToDoList
//
//  Created by 밀가루 on 3/20/24.
//

import UIKit

// DetailViewControllerDelegate 프로토콜 정의
protocol DetailViewControllerDelegate: AnyObject {
    // 저장 버튼 클릭 시 호출되는 메서드
    func detailViewControllerDidSave(todoItem: TodoItem)
}

class DetailViewController: UIViewController, UITextViewDelegate {
    
    // delegate 속성 선언
    weak var delegate: DetailViewControllerDelegate?

    // MARK: - Properties
    
    var todoItem: TodoItem? // 전달된 TodoItem을 저장할 변수
    var saveDate: String? // 전달된 날짜를 저장할 변수
    var textViewEdited = false
    var memoViewEdited = false

    // MARK: - Outlets
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var completionStatusLabel: UILabel!
    @IBOutlet weak var memoView: UITextView!

    
    let placeholderText = "메모를 입력하세요..." // 플레이스홀더 텍스트

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TodoItem 존재 여부 확인 및 화면 설정
        if let todoItem = todoItem {
            // TodoItem이 전달O
            title = "Todo 상세 정보"
            textView.text = todoItem.title
            memoView.text = todoItem.memo
            completionStatusLabel.text = todoItem.isCompleted ? "완료됨" : "미완료"
            completionStatusLabel.backgroundColor = todoItem.isCompleted ? UIColor(named: "TrueColor") : UIColor(named: "FalseColor")
            completionStatusLabel.textColor = todoItem.isCompleted ? .white : .black
            
        } else {
            // TodoItem이 전달X
            title = "새로운 Todo 추가"
            completionStatusLabel.text = "미완료"
        }
        
        // TextView 및 MemoView delegate 설정
        textView.delegate = self
        memoView.delegate = self
        
        // 플레이스홀더 설정
        memoView.text = placeholderText
        memoView.textColor = UIColor.lightGray
        
        // TextView 포커스 설정
        // textView.becomeFirstResponder()
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // 텍스트뷰가 편집되기 시작할 때 플레이스홀더를 숨깁니다.
        if memoView.text == placeholderText {
            memoView.text = ""
            memoView.textColor = UIColor.black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // 플레이스홀더를 표시 또는 숨깁니다.
        if memoView.text.isEmpty {
            memoView.text = placeholderText
            memoView.textColor = UIColor.lightGray
        }
    }
    
    // MARK: - Save Button Action / ToDo 수정 및 메모 저장 동작

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        // 텍스트뷰가 비어 있는지 확인
        guard let text = textView.text, !text.isEmpty else {
            // 텍스트뷰가 비어 있으면 알림 표시
            let alertController = UIAlertController(title: "알림", message: "ToDo를 입력해 주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        // 수정된 TodoItem 생성
        var updatedTodoItem = todoItem ?? TodoItem(title: "") // 기존 TodoItem이 없으면 빈 TodoItem 생성
        
        // 수정된 값을 TodoItem의 title에 저장
        updatedTodoItem.title = text
        
        // 입력된 값을 TodoItem의 memo에 저장
        updatedTodoItem.memo = memoView.text
        
        // delegate를 통해 수정된 TodoItem을 ViewController로 전달
        delegate?.detailViewControllerDidSave(todoItem: updatedTodoItem)
        
        // 수정된 데이터 출력
        print("수정된 TodoItem:")
        print("Title: \(updatedTodoItem.title)")
        print("Memo: \(updatedTodoItem.memo ?? "")")
        
        // 이전 화면으로 이동
        navigationController?.popViewController(animated: true)
    }


}



//
//  ChatView.swift
//  ChatApp
//
//  Created by user on 2023/12/07.
//
import Foundation
import UIKit

class ChatView: UIViewController,UITableViewDelegate,UITableViewDataSource,InputViewDelegate {

    @IBOutlet weak var tableView: UITableView!
        
    let database = DatabaseHelper()
    var roomData:ChatRoom!
    var chatDate:[ChatText] = []
    
    private lazy var buttomInputView:InputView = {
        let view = InputView()
        view.frame = .init(x:0,y:0,width:view.frame.width,height: 100)
//        view.frame = .init(x:0,y:0,width:200,height: 100)
        view.delegate = self
        return view
    }()
    
    func sendTapped(text: String) {
        database.sendChatMessage(roomID: roomData.roomID, text: text)
    }
    
    override var inputAccessoryView: UIView?{
        return buttomInputView
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database.getUserName(userID: roomData.userID, result: {
            name in
            self.navigationItem.title = name
        })
        database.chatDataListener(roomID: roomData.roomID, result: {
            result in
            self.chatDate = result
            self.messageUpdated()
        })
        tableView.keyboardDismissMode = .interactive
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60.0, right: 0)
    }
    
    @objc func keyboardWillShow(_ notification:Notification){
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            scrollToBottom()
        }
    }
    
    func scrollToBottom(){
        let rowNum = tableView.numberOfRows(inSection: 0)
        if rowNum != 0 {
            tableView.scrollToRow(at: IndexPath(row: rowNum-1, section: 0), at: .bottom, animated: true)
        }
    }
    
    @objc func keyboardWillHide(){
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60.0, right: 0)
    }
    
    func messageUpdated(){
        tableView.reloadData()
        scrollToBottom()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell: UITableViewCell
            let data = chatDate[indexPath.row]
            if data.userID == AuthHelper().uid(){
                //自分のテキストを表示
                cell = tableView.dequeueReusableCell(withIdentifier: "cell2")!
        
                
            }else{
                //相手のテキストを表示
                cell = tableView.dequeueReusableCell(withIdentifier: "cell1")!
       
            }
            let imageView = cell.viewWithTag(2) as! UIImageView
            imageView.layer.cornerRadius = imageView.frame.height * 0.5
            imageView.clipsToBounds = true
            database.getImage(userID: data.userID, imageView: imageView)
            let label = cell.viewWithTag(1) as! UILabel
            label.text = data.text
            label.layer.cornerRadius = label.frame.size.height * 0.5
            label.clipsToBounds = true
            return cell
   
        }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}



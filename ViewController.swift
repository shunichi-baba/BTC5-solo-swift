//
//  ViewController.swift
//  ChatApp
//
//  Created by user on 2023/12/06.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
     
    @IBOutlet weak var tableView: UITableView!
    var dataHelper = DatabaseHelper()
    var roomList:[ChatRoom] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let uid = AuthHelper().uid()
        if uid == ""{
            performSegue(withIdentifier: "login", sender: nil)
        }else{
            print(uid)
            //チャットリストを表示する処理
            dataHelper.getMyRoomList(result: {
                result in
                self.roomList = result
                self.tableView.reloadData()
            })
        }
    }
    @IBAction func onLogOut(_ sender: Any) {
        print("ログアウト成功")
        AuthHelper().signOut()
        performSegue(withIdentifier: "login", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> 
    UITableViewCell {
        let cellData = roomList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let imageView = cell?.viewWithTag(1) as! UIImageView
        imageView.layer.cornerRadius = imageView.frame.width * 0.5
        imageView.clipsToBounds = true
        dataHelper.getImage(userID: cellData.userID, imageView: imageView)
        let nameLabel = cell?.viewWithTag(2) as! UILabel
        dataHelper.getUserName(userID: cellData.userID, result: {
            name in
            nameLabel.text = name
        })
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "chat", sender: roomList[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chat"{
            let VC = segue.destination as! ChatView
            let data = sender as! ChatRoom
            VC.roomData = data
        }
    }

}


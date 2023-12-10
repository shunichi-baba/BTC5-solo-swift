//
//  AuthHelper.swift
//  ChatApp
//
//  Created by user on 2023/12/06.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class AuthHelper{
    
    func createAccount(email:String,password:String,result:@escaping(Bool) -> Void){
        Auth.auth().createUser(withEmail: email, password: password, completion:{
            authResult,error in
            if error == nil {
                result(true)
            }else{
                print("Error:\(error!)")
                result(false)
            }
        })
    }
    
    func login(email:String,password:String,result:@escaping(Bool) -> Void){
        Auth.auth().signIn(withEmail: email, password: password, completion:{
            authResult,error in
            if error == nil {
                result(true)
            }else{
                print("Error:\(error!)")
                result(false)
            }
        })
    }
    
    func uid() -> String {
        guard let user = Auth.auth().currentUser else { return ""}
        return user.uid
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()
        }catch{
            print("Error signing out")
        }
    }
    
}

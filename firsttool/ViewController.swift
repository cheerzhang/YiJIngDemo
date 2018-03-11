//
//  ViewController.swift
//  firsttool
//
//  Created by 张乐 on 10/3/18.
//  Copyright © 2018 张乐. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {
    
    
    @IBOutlet weak var tableview: UITableView!
    var ref: DatabaseReference? = nil
    
    var handle: AuthStateDidChangeListenerHandle?

    @IBOutlet weak var nametx: UILabel!
    @IBOutlet weak var bgimg: UIImageView!
    
    @IBOutlet weak var fstbtn: UIButton!
    @IBOutlet weak var loginbtnG: GIDSignInButton!
    
    @IBAction func firsttaskbtn(_ sender: Any) {
    }
    
    @IBAction func loginG(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            print ("user is sign in")
        } else {
            // No user is signed in.
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().signIn()
            }
            print ("user is not sign in")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bgimg.image = nil
        getImgFromFireBase(filename:"IMG_1584.JPG",imgview:self.bgimg)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
            let user = Auth.auth().currentUser
            print(">>>> has got uid? page 2",user?.email ?? "default")
            if Auth.auth().currentUser != nil {
                self.nametx.text = user?.email
                self.fstbtn.isEnabled = true
            }
            else{                
                self.nametx.text = "Please click Login"
                self.fstbtn.isEnabled = false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func connectFDB(){
        ref = Database.database().reference()
        ref?.child("theme").child("0").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let theme = value?["folderName"] as? String ?? ""
            print(">>>>> folder name should see CNY:",theme)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //get img from firebase
    func getImgFromFireBase(filename:String,imgview:UIImageView){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imgname = "firsttoolimg/"+filename
        let bgimgRef = storageRef.child(imgname)
        bgimgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(">>>> downloading img error :",error)
            } else {
                //self.bg.image = UIImage(data: data!)
                imgview.image = UIImage(data: data!)
            }
        }
    }
    

}


//
//  FirstTaskController.swift
//  firsttool
//
//  Created by 张乐 on 11/3/18.
//  Copyright © 2018 张乐. All rights reserved.
//

import UIKit
import Firebase

class FirstTaskController: UIViewController {
    var xiayao:Decimal = 0
    var shangyao:Decimal = 0
    var ref: DatabaseReference? = nil
    
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var firstbtn: UIButton!
    @IBOutlet weak var secondbtn: UIButton!
    @IBOutlet weak var thirdbtn: UIButton!
    @IBOutlet weak var fourthbtn: UIButton!
    @IBOutlet weak var fifthbtn: UIButton!
    @IBOutlet weak var sixthbtn: UIButton!    
    
    @IBOutlet weak var yaoimg1: UIImageView!
    @IBOutlet weak var yaoimg2: UIImageView!
    @IBOutlet weak var yaoimg3: UIImageView!
    @IBOutlet weak var yaoimg4: UIImageView!
    @IBOutlet weak var yaoimg5: UIImageView!
    @IBOutlet weak var yaoimg6: UIImageView!
    
    @IBOutlet weak var shangyaolatx: UILabel!
    @IBOutlet weak var xiayaotx: UILabel!
    
    @IBOutlet weak var sixtyfourname: UILabel!
    @IBOutlet weak var desctx: UITextView!
    
    @IBAction func clickCarrer(_ sender: Any) {
        let p1 = String(describing: self.shangyao)
        let p2 = String(describing: self.xiayao)
        let pNo = p1+":"+p2
        ref = Database.database().reference()
        ref?.child("sixtyfour").child(pNo).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let nickname = value?["name"] as? String ?? ""
            let carrer = value?["carrer"] as? String ?? ""
            self.showAlertWithTitle(title: "Carrer Furture of "+nickname, message: carrer)
            })
    }
    
    @IBAction func clickLove(_ sender: Any) {
        let p1 = String(describing: self.shangyao)
        let p2 = String(describing: self.xiayao)
        let pNo = p1+":"+p2
        ref = Database.database().reference()
        ref?.child("sixtyfour").child(pNo).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let nickname = value?["name"] as? String ?? ""
            let love = value?["love"] as? String ?? ""
            self.showAlertWithTitle(title: "Relationship Furture of "+nickname, message: love)
        })
    }
    
    @IBAction func backhome(_ sender: Any) {
    }
    
    @IBAction func firstlineclick(_ sender: Any) {
        self.firstbtn.isEnabled = false;
        get4yao(position: 0,imgview:self.yaoimg1)
    }
    @IBAction func secondlineclick(_ sender: Any) {
        self.secondbtn.isEnabled = false;
        get4yao(position: 1,imgview:self.yaoimg2)
    }
    @IBAction func thirdlineclick(_ sender: Any) {
        self.thirdbtn.isEnabled = false
        get4yao(position: 2,imgview:self.yaoimg3)
    }
    @IBAction func fourthlineclick(_ sender: Any) {
        self.fourthbtn.isEnabled = false
        get4yao(position: 3,imgview:self.yaoimg4)
    }
    @IBAction func fifthlineclick(_ sender: Any) {
        self.fifthbtn.isEnabled = false
        get4yao(position: 4,imgview:self.yaoimg5)
    }
    @IBAction func sixthlineclick(_ sender: Any) {
        self.sixthbtn.isEnabled = false
        get4yao(position: 5,imgview:self.yaoimg6)
    }
    
    @IBAction func checkresult(_ sender: Any) {
        let p1 = String(describing: self.shangyao)
        ref = Database.database().reference()
        ref?.child("bagua").child(p1).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let nickname = value?["nickname"] as? String ?? ""
            self.shangyaolatx.text = nickname
        }) { (error) in
            print(error.localizedDescription)
        }
        let p2 = String(describing: self.xiayao)
        ref = Database.database().reference()
        ref?.child("bagua").child(p2).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let nickname = value?["nickname"] as? String ?? ""
            self.xiayaotx.text = nickname
        }) { (error) in
            print(error.localizedDescription)
        }
        let pNo = p1+":"+p2
        self.getDesc(codeNo:pNo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.timelabel.text = dateFormat.string(from: Date())
        self.xiayao = 0
        self.shangyao = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func get4yao(position:Int,imgview:UIImageView){
        let no1 = Int(arc4random())%2
        let no2 = Int(arc4random())%2
        let no3 = Int(arc4random())%2
        let noall = no1+no2+no3
        if(position<3){
            let p = 2 - position
            self.xiayao = self.xiayao + Decimal(noall%2) * (pow(2,p))
            print(">>>> xiayao is ,",self.xiayao)
        }else{
            let p = 5 - position
            self.shangyao = self.shangyao + Decimal(noall%2) * (pow(2,p))
            print(">>>> shangyao is ,",self.shangyao)
        }
        
        ref = Database.database().reference()
        ref?.child("liuyao").child(String(noall)).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let name8 = value?["filename"] as? String ?? ""
            print(">>>>> name of liuyao:",name8)
            self.getImgFromFireBase(filename: name8,imgview: imgview)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getImgFromFireBase(filename:String,imgview:UIImageView){
        //download img from firebase
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imgname = "firsttoolimg/"+filename
        let bgimgRef = storageRef.child(imgname)
        bgimgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(">>>> downloading img error :",error)
            } else {
                imgview.image = UIImage(data: data!)
            }
        }
    }
    
    func getDesc(codeNo:String){
        ref = Database.database().reference()
        ref?.child("sixtyfour").child(codeNo).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let nickname = value?["nickname"] as? String ?? ""
            let desc = value?["desc"] as? String ?? ""
            self.sixtyfourname.text = nickname
            self.desctx.text = desc
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func showAlertWithTitle( title:String, message:String ) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (act) in
            print(">>>> click ok.")
        }
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    

}

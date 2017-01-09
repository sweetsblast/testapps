//
//  ViewController.swift
//  testapps
//
//  Created by 志村晃央 on 2016/12/03.
//  Copyright © 2016年 志村晃央. All rights reserved.
//

import UIKit

class MyReceiver {
    public static let notificationName = "TESTNOTIFICATION"
    @objc func testFunction(_ notification : NSNotification){
        NSLog("*NOTIFICATION* exe testFunction notification:%@", notification)
    }
}

class ViewController: UIViewController {

    let receiver = MyReceiver()
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var btn1: UIButton!

    // ルートViewを作成する
    override func loadView() {
        print("*VC* " + #function)
        super.loadView()
    }
    
    // ルートViewがメモリにロードされた直後に呼ばれる
    override func viewDidLoad() {
        print("*VC* " + #function)
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // ドキュメントパス
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

        var contents : [String]? = nil
        do {
            contents = try FileManager.default.contentsOfDirectory( atPath: documentsPath)
        }catch{
            // エラー発生
            print("エラー");
        }
    }

    // ルートViewがView階層に追加される直前、表示アニメーションが設定されるより前に呼ばれる
    override func viewWillAppear(_ animated: Bool) {
        print("*VC* " + #function)
        NSLog("animated:%@",animated.description)
        super.viewWillAppear(animated)
    }

    // ルートViewがView階層に追加された直後に呼ばれる
    override func viewDidAppear(_ animated: Bool) {
        print("*VC* " + #function)
        NSLog("animated:%@",animated.description)
        super.viewDidAppear(animated)

        NSLog("   addObserver")
        NotificationCenter.default.addObserver(receiver, selector: #selector(MyReceiver.testFunction), name: nil, object: nil)
    }
    
    // ルートViewがView階層から削除される直前で、非表示のアニメーションが設定されるより前に呼ばれる
    override func viewWillDisappear(_ animated: Bool) {
        print("*VC* " + #function)
        NSLog("animated:%@",animated.description)
        super.viewWillDisappear(animated)
        
        NSLog("   removeObserver")
        NotificationCenter.default.removeObserver(receiver, name: nil, object: nil)
    }

    // ルートViewがView階層から削除された後に呼ばれる
    override func viewDidDisappear(_ animated: Bool) {
        print("*VC* " + #function)
        NSLog("animated:%@",animated.description)
        super.viewDidDisappear(animated)
    }
    
    // ルートViewにその子Viewが配置される直前に呼ばれる
    override func viewWillLayoutSubviews() {
        print("*VC* " + #function)
        super.viewWillLayoutSubviews()
    }

    // ルートViewにその子Viewが配置された直後によばっる
    override func viewDidLayoutSubviews() {
        print("*VC* " + #function)
        super.viewDidLayoutSubviews()
    }

    // アプリがメモリ警告を受け取った時に呼ばれる
    override func didReceiveMemoryWarning() {
        print("*VC* " + #function)
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pushButton(_ sender: Any) {
        print("*VC* " + #function)
        label1.text = "押されたよ"
    }
    
    @IBAction func pushButtonII(_ sender: Any) {
        print("*VC* " + #function)
        label1.text = "押されたよII"
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MyReceiver.notificationName), object: nil)
    }

    func testFunction(){
        
    }
}


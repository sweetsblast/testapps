//
//  ViewController.swift
//  testapps
//
//  Created by 志村晃央 on 2016/12/03.
//  Copyright © 2016年 志村晃央. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RxSwift

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
            print("contents サイズ=" + String(contents?.count ?? 0))
            for filename in contents! {
                print(filename)
            }
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
        
        getArticles()
        
        testFunction()
    }

    func testFunction(){
        _ = MyClass().extcute(0).subscribe(
            onNext:{value in
                print("myClass - onNext")
            },
            onError:{error in
                print("myClass - onError")
            },
            onCompleted:{
                print("myClass - onCompleted")
            }
        )
    }
    
    func getArticles() {
        Alamofire.request("https://qiita.com/api/v2/items").responseJSON{ response in
            guard response.result.value != nil else {
                print(" object nil")
                return
            }
            
            let json = JSON(response.result.value ?? "")
            print(json)
        }
    }
}

class MyClass {
    func extcute(_ aaa:Int) -> Observable<Int> {
        return Observable<Int>.create { observer in
            observer.onNext(aaa)
            observer.onCompleted()
            return Disposables.create {
                print("cancel")
            }
        }
    }
    
    var value : Observable<Bool> {
        return Observable<Bool>.create { observer in
            let value : Int = 0
            switch value {
            case 0...3:
                observer.onNext(true)
                observer.onCompleted()
            case 4:
                observer.onError(NSError())
            default:
                observer.onError(NSError())
            }
            return Disposables.create {
                print("cancel")
            }
        }
    }
}


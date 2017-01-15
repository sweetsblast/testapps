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

struct Sweetsblast<Base> {
    let base: Base
    init (_ base: Base) {
        self.base = base
    }
}

protocol SweetsblastCompatible {
    associatedtype Compatible
    static var sb: Sweetsblast<Compatible>.Type { get }
    var sb: Sweetsblast<Compatible> { get }
}

extension SweetsblastCompatible {
    static var sb: Sweetsblast<Self>.Type {
        return Sweetsblast<Self>.self
    }
    var sb: Sweetsblast<Self> {
        return Sweetsblast(self)
    }
}

extension UIColor: SweetsblastCompatible {}

extension Sweetsblast where Base: UIColor {
    static var sweetsblast: UIColor {
        return UIColor(red: 0.97, green: 0.71, blue: 0.00, alpha: 1.00)
    }
}

// ↓ みたいに書ける
// label?.rx.base.textColor = UIColor.sb.sweetsblast


class MyReceiver {
    public static let notificationName = "TESTNOTIFICATION"
    @objc func testFunction(_ notification : NSNotification){
//        NSLog("*NOTIFICATION* exe testFunction notification:%@", notification)
    }
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    let receiver = MyReceiver()
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var btn1: UIButton!

    @IBOutlet weak var controlView: UICollectionView!
    
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
        /* PDFビュアー向け start */
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
        let files = getDocumentFiles()
        print("filesサイズ=" + String(files.count))
        /* PDFビュアー向け end */
        
        /* ここにRXコードを追加予定 */
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
        
        getHoroI()
        
        testFunction()
    }
    
    // UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var number : Int = 0
        switch section {
        case 0:
            number = 4
        case 1:
            number = 3
        case 2:
            number = 2
        case 3:
            number = 1
        default:
            number = 0
        }
        
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell
        if(indexPath.row%2==0){
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath)
            cell.backgroundColor = UIColor.yellow
            let label = cell.viewWithTag(1) as? UILabel
            label?.text = "A" + String(indexPath.row)
        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath)
            cell.backgroundColor = UIColor.blue
            let label = cell.viewWithTag(1) as? UILabel
            // label?.text = "B" + String(indexPath.row)
            label?.rx.base.text = "B" + String(indexPath.row)
            label?.rx.base.textColor = UIColor.sb.sweetsblast
        }
        
        return cell
    }

    // UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog( "row = %d, section = %d", indexPath.row, indexPath.section)
    }

    
    // Original Method

    func getDocumentFiles() -> [String] {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        var fileNames: [String]
        
        do {
            fileNames = try FileManager.default.contentsOfDirectory(atPath: documentPath)
        } catch {
            fileNames = []
        }
        
        return fileNames.map{ documentPath + "/" + $0 }
        /*
                texts = try String(contentsOfFile: documentPath + "/" + fileName, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)).lines
                texts = texts.deleteSpaceOnly(texts: texts)
                return texts
 */
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
    
    func getHoroI() {
        
        _ = MyClass().request(dateString:"2017/01/16")
        .subscribe(
            onNext:{ json in
                print(#function + "onNext:" + json.debugDescription)
                self.getHoroII()
            },
            onError:{ error in
                print(#function + "onError: " + error.localizedDescription)
            },
            onCompleted:{
                print(#function + "onCompleted")
            }
        )
    }
    
    func getHoroII(){
        _ = MyClass().request(dateString:"2017/01/17")
            .subscribe(
                onNext:{ json in
                    print(#function + "onNext:" + json.debugDescription)
            },
                onError:{ error in
                    print(#function + "onError: " + error.localizedDescription)
            },
                onCompleted:{
                    print(#function + "onCompleted")
            }
        )
    }
}

class MyClass {
    func request(dateString: String) -> Observable<JSON> {
        return Observable<JSON>.create { observer in
            Alamofire.request("http://api.jugemkey.jp/api/horoscope/free/" + dateString).responseJSON{ response in
                let json = JSON(response.result.value ?? "")
                print("REQUEST: \(response.request)")
                print("RESPONSE: \(response.response)")
                print("STATUS CODE: \(response.response?.statusCode)")
                print("HEADERS: \(response.response?.allHeaderFields)")
                print("RESULT: \(response.result)")
                print("JSON: \(json)")
                print("Error: " + response.result.error.debugDescription)
                let ddd = json["horoscope"]["2017/01/16"]
                print("[horoscope][2017/02/16]:  \(ddd)")
                observer.onNext(json)
                observer.onCompleted()
            }
            
            return Disposables.create {
                print("cancel")
            }
        }
    }
    
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

    private let eventSubject = PublishSubject<Int>()    // Observableでありつつ、ObserverのIF（onNext,onError,onCompleted）を持つ
    // BehaviorSubject は 最後の値を覚えていて、subscribeすると即座にそれを最初に通知する。生成時に初期値を設定できる
    // Variable は BehaviorSubjectのラッパーでonErrorを発生させる必要がない場合に使用する。ただし、Observalbeではないため、asObservableメソッドで変換する
    //   private let aaa = Variable(false)
    //   var bbb: Observable<Bool> { return aaa.asObservable() }
    //   func start() { aaa.value = true }  // Valiableのvalueに値を入れるとイベントが発行される
    //   func stop() { aaa.value = false }
    
    var event: Observable<Int> { return eventSubject }  // Subjectを公開するとonNextなども外部から使えてしまうので、Observableで公開する
    
    func doSomething() {
        // 処理
        eventSubject.onNext(1)  // イベント発行
    }
    
    /*
    private let
    // Int型の変数
    var event: Observable<Int> {
        
    }
    // 使い方
    let disposable = MyClass.event.subscribe(
        onNext: { value in
            // 通常イベント発生時の処理
        },
        onError: { error in
            // エラー発生時の処理
        },
        onCompleted: {
            // 完了時の処理
        }
     )
     disposable.dispose()   // 購読解除
     */
    
    // extension ObservableType { func AAA<R>( arg: @escaping (E) -> R ) -> Observable<R> { return Observable.create{ observable in ... return subscription } } } 的に書くとカスタムoperatorsが作れる
    
}

class MyClassII {
    let stream = PublishSubject<Int>()
    var response: Observable<Int> {
        return stream
    }
    
    func execute(){
        
    }
}

// developで追加

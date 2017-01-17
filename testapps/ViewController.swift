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
    
    var disposable :Disposable? = nil
    
    var disposableII : Disposable? = nil
    
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
/*
        if let _ = self.disposable {
            self.disposable?.dispose()
            self.disposable = nil
        }else{
            getHoroI()
        }
        
        let disposable = testFunction().subscribe{
            print("testFunction : \($0)")
        }
*/
        self.disposableII = testFunctionII()
            .do(onNext: { (bool) in
                print("pBII doOnNext")
            }, onError: { (error) in
                print("pBII doOnError")
            }, onCompleted: { 
                print("pBII doOnCompleted")
            }, onSubscribe: { 
                print("pBII doOnSubscribe")
            }, onDispose: { 
                print("pBII doOnDispose")
            })
            .subscribe(
                onNext: { (bool) in
                    print("pBII onNext : " + bool.description)
            }, onError: { (error) in
                print("pBII onError : " + error.localizedDescription)
            }, onCompleted: {
                print("pBII onCompleted")
            }, onDisposed: {
                print("pBII onDisposed")
            })
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
    
    func testFunction() -> Observable<Bool> {
        print(#function)
        
        return MyClass().request(dateString: "2016/12/31").flatMap({ (json) -> Observable<Bool> in
            return Observable<Bool>.just(true)
        })
    }
    
    func testFunctionII() -> Observable<Bool> {
        print(#function)
        
        return MyClass().generate()
        .catchErrorJustReturn("AAA")
        .flatMap({ (string) -> Observable<JSON> in
            print("tFII flapMap")
            return MyClass().request(dateString: string)
        }).do(onNext: { (json) in
            print("tFII do.onNext")
        }, onError: { (error) in
            print("tFII do.onError : " + error.localizedDescription)
        }, onCompleted: {
            print("tFII do.onCompleted")
        }, onSubscribe: { 
            print("tFII do.onSubscribe")
        }, onDispose: { 
            print("tFII do.onDisponse")
        }).catchError({ (error) -> Observable<JSON> in
            print("tFII catchError : " + error.localizedDescription)
            return Observable.just(JSON(NSData()))
        }).flatMap({ (json) -> Observable<Bool> in
            print("tFII flatMap2")
            return Observable<Bool>.just(true)
        })
    }
    
    func getHoroI() {
        
        disposable = MyClass().request(dateString:"2017/01/17")
            .catchErrorJustReturn(JSON(Data()))
            .flatMap{ json -> Observable<JSON> in
                return MyClass().request(dateString:"2017/01/18")
            }
            .subscribe(
            onNext:{ json in
                print(#function + "onNext:" + json.debugDescription)
                self.disposable = nil
                self.getHoroII()
            },
            onError:{ error in
                print(#function + "onError: " + error.localizedDescription)
                self.disposable = nil
            },
            onCompleted:{
                print(#function + "onCompleted")
            }
        )
    }
    
    func getHoroII(){
        disposable = MyClass().request(dateString:"2017/01/18")
            .subscribe(
                onNext:{ json in
                    print(#function + "onNext:" + json.debugDescription)
                    self.disposable = nil
            },
                onError:{ error in
                    print(#function + "onError: " + error.localizedDescription)
                    self.disposable = nil
            },
                onCompleted:{
                    print(#function + "onCompleted")
            }
        )
    }
}

class MyClass {
    
    private var request : Alamofire.DataRequest? = nil
    
    func generate() -> Observable<String> {
        print("generate")
        return Observable<String>.create{ observer in
            print("observer.onNext(2017/01/15)")
            observer.onNext("2017/01/15")
            print("observer.onNext(2017/01/16)")
            observer.onNext("2017/01/16")
            print("observer.onNext(2017/01/17)")
            observer.onNext("2017/01/17")
            print("observer.onError")
            observer.onError(NSError(domain:"MY CUSTOM ERROR",code:111))
            print("observer.onNext(2017/01/18)")
            observer.onNext("2017/01/18")
//            observer.onCompleted()
            return Disposables.create{
                print("Disposables cancel")
            }
        }
    }
    
    func request(dateString: String) -> Observable<JSON> {
        print("request : " + dateString)
        return Observable<JSON>.create { observer in
            self.request = Alamofire.request("http://api.jugemkey.jp/api/horoscope/free/" + dateString)
            self.request?.responseJSON{ response in
                let json = JSON(response.result.value ?? "")
                print("REQUEST: \(response.request)")
                print("RESPONSE: \(response.response)")
                print("STATUS CODE: \(response.response?.statusCode)")
                print("HEADERS: \(response.response?.allHeaderFields)")
                print("RESULT: \(response.result)")
                print("JSON: \(json.arrayValue)")
                print("Error: " + response.result.error.debugDescription)
                let ddd = json["horoscope"][dateString]
                if ( (response.response?.statusCode ?? 999) != 200 ){
                    print("requeset sentError")
                    observer.onError(NSError(domain: "Request Status Error", code: response.response?.statusCode ?? 999, userInfo: nil))
                }else{
                    print("request sendOnNext")
                    observer.onNext(ddd)
//                    print("request sendOnCompleted")
//                    observer.onCompleted()
                }
            }
            
            return Disposables.create {
                print("request cancel")
                self.request?.cancel()
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

// testブランチで追加
// testブランチで追加2
// developで追加

/* // ボタン２押下のログ
 *VC* pushButtonII
 testFunctionII()
 generate
 pBII doOnSubscribe
 tFII do.onSubscribe
 observer.onNext(2017/01/15)
 tFII flapMap
 request : 2017/01/15
 observer.onNext(2017/01/16)
 tFII flapMap
 request : 2017/01/16
 observer.onNext(2017/01/17)
 tFII flapMap
 request : 2017/01/17
 observer.onError
 tFII flapMap
 request : AAA
 observer.onNext(2017/01/18)
 Disposables cancel
 REQUEST: Optional(http://api.jugemkey.jp/api/horoscope/free/2017/01/16)
 RESPONSE: Optional(<NSHTTPURLResponse: 0x6000004282a0> { URL: http://api.jugemkey.jp/api/horoscope/free/2017/01/16 } { status code: 200, headers {
 Connection = "keep-alive";
 "Content-Length" = 3642;
 "Content-Type" = "application/json; charset=utf-8";
 Date = "Tue, 17 Jan 2017 21:22:38 GMT";
 Server = "nginx/1.11.1";
 } })
 STATUS CODE: Optional(200)
 HEADERS: Optional([AnyHashable("Content-Type"): application/json; charset=utf-8, AnyHashable("Content-Length"): 3642, AnyHashable("Connection"): keep-alive, AnyHashable("Date"): Tue, 17 Jan 2017 21:22:38 GMT, AnyHashable("Server"): nginx/1.11.1])
 RESULT: SUCCESS
 JSON: []
 Error: nil
 request sendOnNext
 tFII do.onNext
 tFII flatMap2
 pBII doOnNext
 pBII onNext : true
 REQUEST: Optional(http://api.jugemkey.jp/api/horoscope/free/2017/01/15)
 RESPONSE: Optional(<NSHTTPURLResponse: 0x608000225120> { URL: http://api.jugemkey.jp/api/horoscope/free/2017/01/15 } { status code: 200, headers {
 Connection = "keep-alive";
 "Content-Length" = 3720;
 "Content-Type" = "application/json; charset=utf-8";
 Date = "Tue, 17 Jan 2017 21:22:38 GMT";
 Server = "nginx/1.11.1";
 } })
 STATUS CODE: Optional(200)
 HEADERS: Optional([AnyHashable("Content-Type"): application/json; charset=utf-8, AnyHashable("Content-Length"): 3720, AnyHashable("Connection"): keep-alive, AnyHashable("Date"): Tue, 17 Jan 2017 21:22:38 GMT, AnyHashable("Server"): nginx/1.11.1])
 RESULT: SUCCESS
 JSON: []
 Error: nil
 request sendOnNext
 tFII do.onNext
 tFII flatMap2
 pBII doOnNext
 pBII onNext : true
 REQUEST: Optional(http://api.jugemkey.jp/api/horoscope/free/2017/01/17)
 RESPONSE: Optional(<NSHTTPURLResponse: 0x6080002250c0> { URL: http://api.jugemkey.jp/api/horoscope/free/2017/01/17 } { status code: 200, headers {
 Connection = "keep-alive";
 "Content-Length" = 3690;
 "Content-Type" = "application/json; charset=utf-8";
 Date = "Tue, 17 Jan 2017 21:22:38 GMT";
 Server = "nginx/1.11.1";
 } })
 STATUS CODE: Optional(200)
 HEADERS: Optional([AnyHashable("Content-Type"): application/json; charset=utf-8, AnyHashable("Content-Length"): 3690, AnyHashable("Connection"): keep-alive, AnyHashable("Date"): Tue, 17 Jan 2017 21:22:38 GMT, AnyHashable("Server"): nginx/1.11.1])
 RESULT: SUCCESS
 JSON: []
 Error: nil
 request sendOnNext
 tFII do.onNext
 tFII flatMap2
 pBII doOnNext
 pBII onNext : true
 REQUEST: Optional(http://api.jugemkey.jp/api/horoscope/free/AAA)
 RESPONSE: Optional(<NSHTTPURLResponse: 0x608000224de0> { URL: http://api.jugemkey.jp/api/horoscope/free/AAA } { status code: 404, headers {
 Connection = "keep-alive";
 "Content-Length" = 25;
 "Content-Type" = "application/json; charset=utf-8";
 Date = "Tue, 17 Jan 2017 21:22:38 GMT";
 Server = "nginx/1.11.1";
 } })
 STATUS CODE: Optional(404)
 HEADERS: Optional([AnyHashable("Content-Type"): application/json; charset=utf-8, AnyHashable("Content-Length"): 25, AnyHashable("Connection"): keep-alive, AnyHashable("Date"): Tue, 17 Jan 2017 21:22:38 GMT, AnyHashable("Server"): nginx/1.11.1])
 RESULT: SUCCESS
 JSON: []
 Error: nil
 requeset sentError
 tFII do.onError : The operation couldn’t be completed. (Request Status Error error 404.)
 tFII catchError : The operation couldn’t be completed. (Request Status Error error 404.)
 tFII flatMap2
 pBII doOnNext
 pBII onNext : true
 pBII doOnCompleted
 pBII onCompleted
 pBII onDisposed
 request cancel
 request cancel
 request cancel
 request cancel
 tFII do.onDisponse
 pBII doOnDispose
*/

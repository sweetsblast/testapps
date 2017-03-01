//
//  testappsTests.swift
//  testappsTests
//
//  Created by 志村晃央 on 2016/12/03.
//  Copyright © 2016年 志村晃央. All rights reserved.
//

import XCTest
import RxTest
import SwiftyJSON
@testable import testapps

var responseData:NSData? = nil
var responseDatas:[NSData?] = []
var responseCount: Int = 0
var statusCode:Int = 200
var errorResponse:Error? = nil

// モック（ここから）
public extension URLSessionConfiguration {
    
    // .defaultをモック用と入れ替えるメソッド
    public class func setupMockDefaultSessionConfiguration() {
        let defaultSessionConfiguration = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.default))
        let swizzledDefaultSessionConfiguration = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.mock))
        method_exchangeImplementations(defaultSessionConfiguration, swizzledDefaultSessionConfiguration)
    }
    
    // .defaultと入れ替えるプロパティ変数
    private dynamic class var mock: URLSessionConfiguration {
        let configuration = self.mock
        configuration.protocolClasses?.insert(MockURLProtocol.self, at: 0)
        URLProtocol.registerClass(MockURLProtocol.self)
        return configuration
    }
}

public class MockURLProtocol: URLProtocol {
    
    // 引数のURLRequestを処理できる場合はtrue
    override open class func canInit(with request:URLRequest) -> Bool {
        return true
    }
    
    // URLRequestの修正が必要でなければそのまま返す。
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    // 通信開始時に呼ばれるメソッド、ここに通信のモックを実装します。
    override open func startLoading() {
        let delay: Double = 1.0 // 通信に1秒かかるモック
        print("startLoading")
        DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
            print("asyncAfter")
            if errorResponse != nil {
                // エラー時のハンドリングもこちらで可能です。
                self.client?.urlProtocol(self, didFailWithError: errorResponse!)
                
            } else {
                self.client?.urlProtocol(self, didReceive: HTTPURLResponse(url: self.request.url!, statusCode: statusCode, httpVersion:"1.1", headerFields: nil)!, cacheStoragePolicy: URLCache.StoragePolicy.allowed)
                self.client?.urlProtocol(self, didLoad: self.response!) // 結果を返す
                self.client?.urlProtocolDidFinishLoading(self)     // 通信が終了したことを伝える
            }
        }
    }
    
    // 通信停止時に呼ばれるメソッド
    override open func stopLoading() {
        print("stopLoading")
    }
    
    private var response: Data? {
        if responseDatas.count <= responseCount || responseDatas[responseCount] == nil {
            // URLなどでパターンマッチングすることで結果を切り替えることも出来る
            // self.request.url
            let json = "{\"mock\": \"data\"}"  // モック用のJSONデータ
            print("response = " + json.data(using: .utf8).debugDescription)
            return json.data(using: .utf8)
        }else{
            let resdata = (responseDatas[responseCount] as Data?)
            print("response = " + resdata.debugDescription)
            responseCount += 1
            return resdata
        }
    }
}
// モック（ここまで）

class testappsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        URLSessionConfiguration.setupMockDefaultSessionConfiguration()
        responseDatas = []
        errorResponse = nil
        statusCode = 200
        responseCount = 0
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testRequest() {
        let celientExpectation:XCTestExpectation? = self.expectation(description: "Server Connect1")
        responseDatas = [testappsTests.readJSONFile(name:"01"),]
        _ = MyClass().request(dateString:"2017/01/23")
            .subscribe( onNext:{ res in
                print("onNext:" + res.debugDescription)
                XCTAssertNotNil( res, "レスポンスがnil")
                XCTAssertFalse( res.isEmpty, "レスポンスが空")
                celientExpectation?.fulfill()
            }, onError:{ error in
                print("onError:" + error.localizedDescription )
                XCTFail("エラーが発生")
            })
        self.waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testRequestMock() {
        let celientExpectation:XCTestExpectation? = self.expectation(description: "Server Connect2")
        statusCode = 404
        _ = MyClass().request(dateString:"2017/01/22")
            .subscribe( onNext:{ res in
                print("onNext:" + res.debugDescription)
                XCTFail("エラーでない")
            }, onError:{ error in
                print("onError:" + error.localizedDescription )
                XCTAssertNotNil( error as NSError, "errorがNSErrorでない")
                XCTAssertEqual((error as NSError).domain, "Request Status Error", "エラードメイン不一致")
                XCTAssertEqual((error as NSError).code, 404, "エラーコード不一致")
                celientExpectation?.fulfill()
            })
        self.waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testRequest20170224() {
        let celientExpectation:XCTestExpectation? = self.expectation(description: "Server Connect3")
        errorResponse = NSError(domain: "ng", code: -1009, userInfo: nil)
        let obj = MyClass().request(dateString:"2017/01/24")
            .subscribe( onNext:{ res in
                print("onNext:" + res.debugDescription)
                XCTFail("エラーでない")
            }, onError:{ error in
                print("onError:" + error.localizedDescription )
                XCTAssertNotNil( error as NSError, "errorがNSErrorでない")
                XCTAssertEqual((error as NSError).domain, "ng", "エラードメイン不一致")
                XCTAssertEqual((error as NSError).code, -1009, "エラーコード不一致")
                celientExpectation?.fulfill()
            })
        
        self.waitForExpectations(timeout: 1.1, handler: { error in
            print("timeout error = " + error.debugDescription)
            obj.dispose()
        })
    }

    static func readJSONFile(name: String) -> NSData {
        let path: String? = Bundle(for: self).path(forResource: name, ofType: "json")
        let fileHandle: FileHandle? = FileHandle(forReadingAtPath: path!)
        let data: NSData! = fileHandle?.readDataToEndOfFile() as NSData!
        return data
//        let str = NSString(data: data! as Data, encoding:String.Encoding.utf8.rawValue)
//        let resdata = str?.data(using: String.Encoding.shiftJIS.rawValue)
//        return resdata! as NSData
    }
}

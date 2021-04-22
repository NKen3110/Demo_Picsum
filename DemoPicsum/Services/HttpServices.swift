//
//  HttpServices.swift
//  DemoPicsum
//
//  Created by Nguyen Kiem on 4/20/21.
//

import UIKit

public enum HttpRequestType : String {
    case POST = "POST"
    case GET = "GET"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

public enum HttpRequestContentType : String {
    case ApplicationJson = "application/json"
    case UrlEncoded = "application/x-www-form-urlencoded"
}

class HttpServices: NSObject {
    
    public func sendHttpRequestForGetData(_ url:String, param:String? = nil, header: NSDictionary? = nil, type: HttpRequestType = .GET, _ contentType: HttpRequestContentType = .ApplicationJson, handleComplete: @escaping ( _ isSuccess: Bool, _ error: String, _ code: Int, _ data: Data?) -> ()) {
        if let urlRequest = URL(string: url) {
            var request = URLRequest(url: urlRequest)
            request.httpShouldHandleCookies = false
            
            print("Path: \(String(describing: request))")

            if type != .GET {
                request.httpMethod = type.rawValue
                request.addValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")

                // add param
                request.httpBody = param!.data(using: String.Encoding.utf8)
            }

            //add header
            if header != nil {
                for keyObject in header!.allKeys {
                    let key = keyObject as! String
                    if !key.isEmpty {
                        if let value = header![key] as? String {
                            request.addValue(value, forHTTPHeaderField: key)
                        }
                    }
                }
            }

            let httpConfig = URLSessionConfiguration.default
            httpConfig.timeoutIntervalForRequest = 60
            httpConfig.timeoutIntervalForResource = 60

            let session = URLSession(configuration: httpConfig)
            let task = session.dataTask(with: request, completionHandler: { (data, res, error) in
                DispatchQueue.main.async {
                    var code = 200
                    //check status code
                    if let httpResponse = res as? HTTPURLResponse {
                        code = httpResponse.statusCode
                    }
                    if  error != nil {
                        handleComplete(false, error!.localizedDescription, code , nil)
                    } else {
                        if data != nil && data!.count > 0 {
                            handleComplete(true, "", code, data!)
                        } else {
                            handleComplete(false, "Unknow Error", code, nil)
                        }
                    }
                }
            })
            task.resume()
        }
    }
}

extension Data {
    func toNSDictionary() -> NSDictionary? {
        var jsonObj : Any?
        do {
            jsonObj = try JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions(rawValue: 0))
            return jsonObj as? NSDictionary
        } catch {
            return nil
        }
    }
    
    func toArray() -> NSArray? {
        var jsonObj : Any?
        do {
            jsonObj = try JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions(rawValue: 0))
            return jsonObj as? NSArray
        } catch {
            return nil
        }
    }
}

extension NSDictionary {
    func JsonStringWithPrettyPrint() -> String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            return NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
        } catch {
            return nil
        }
    }
}

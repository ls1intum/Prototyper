//
//  APIHandler.swift
//  Prototyper
//
//  Created by Stefan Kofler on 17.06.15.
//  Copyright (c) 2015 Stefan Kofler. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift

// MARK: - Constants

struct UserDefaultKeys {
    static let AppId = "AppId"
    static let ReleaseId = "ReleaseId"
    static let Username = "Username"
}

fileprivate struct KeychainKeys {
    static let userNameKey = "PrototyperUserName"
    static let passwordKey = "PrototyperPassword"
}

fileprivate enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

fileprivate enum MimeType: String {
    case JSON = "application/json"
    case Multipart = "multipart/form-data"
}

fileprivate enum HTTPHeaderField: String {
    case ContentType = "Content-Type"
    case Accept = "Accept"
}

fileprivate struct API {
    static let BaseURL = URL(string: "https://prototyper-bruegge.in.tum.de/")
    
    struct EndPoints {
        static let Login = "login"
        static func fetchReleaseInfo(bundleId: String, bundleVersion: String) -> String {
            return "apps/find_release?bundle_id=\(bundleId)&bundle_version=\(bundleVersion)"
        }
        
        static func feedback(_ appId: String, releaseId: String, text: String, username: String? = nil) -> String {
            if let username = username {
                return "apps/\(appId)/releases/\(releaseId)/feedbacks?feedback[text]=\(text)&feedback[username]=\(username)"
            }
            return "apps/\(appId)/releases/\(releaseId)/feedbacks?feedback[text]=\(text)"
        }
        static func share(_ appId: String, releaseId: String, sharedEmail: String, explanation: String, username: String? = nil) -> String {
            if let username = username {
                return "apps/\(appId)/releases/\(releaseId)/share_app?share_email=\(sharedEmail)&explanation=\(explanation)&username=\(username)"
            }
            return "apps/\(appId)/releases/\(releaseId)/share_app?share_email=\(sharedEmail)&explanation=\(explanation)"
        }
    }
    
    struct DataTypes {
        struct Session {
            static let Session = "session"
            static let Email = "email"
            static let Password = "password"
        }
    }
}

let sharedInstance = APIHandler()
private let defaultBoundary = "------VohpleBoundary4QuqLuM1cE5lMwCy"

// MARK: - APIHandler

class APIHandler {
    let session: URLSession
    var appId: String! {
        return Bundle.main.object(forInfoDictionaryKey: "PrototyperAppId") as? String ?? UserDefaults.standard.string(forKey: UserDefaultKeys.AppId)
    }
    var releaseId: String! {
        return Bundle.main.object(forInfoDictionaryKey: "PrototyperReleaseId") as? String ?? UserDefaults.standard.string(forKey: UserDefaultKeys.ReleaseId)
    }
    
    var isLoggedIn: Bool = false
    
    init() {
        let sessionConfig = URLSessionConfiguration.default
        session = URLSession(configuration: sessionConfig)
    }
    
    class var sharedAPIHandler: APIHandler {
        return sharedInstance
    }
    
    // MARK: Release Infos
    
    static func tryToFetchReleaseInfos() {
        APIHandler.sharedAPIHandler.fetchReleaseInformation(success: { (appId, releaseId) in
            UserDefaults.standard.set(appId, forKey: UserDefaultKeys.AppId)
            UserDefaults.standard.set(releaseId, forKey: UserDefaultKeys.ReleaseId)
        }) { error in
            print("No release information found on Prototyper.")
        }
    }
    
    func fetchReleaseInformation(success: @escaping (_ appId: String, _ releaseId: String) -> Void, failure: @escaping (_ error : Error?) -> Void) {
        let bundleId = Bundle.main.infoDictionary?[kCFBundleIdentifierKey as String] as? String ?? ""
        let bundleVersion = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String ?? ""
        
        let url = URL(string: API.EndPoints.fetchReleaseInfo(bundleId: bundleId, bundleVersion: bundleVersion), relativeTo: API.BaseURL)!
        
        let request = jsonRequestForHttpMethod(.GET, requestURL: url)
        executeRequest(request as URLRequest) { (data, response, error) in
            guard let data = data else {
                failure(error)
                return
            }
            
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Int]
                if let dict = dict, let appId = dict["app_id"], let releaseId = dict["release_id"] {
                    success("\(appId)", "\(releaseId)")
                } else {
                    failure(error)
                }
            } catch {
                failure(error)
            }
        }
    }
    
    // MARK: Login
    
    static func tryToLogin() {
        let keychain = KeychainSwift()
        let oldUsername = keychain.get(KeychainKeys.userNameKey)
        let oldPassword = keychain.get(KeychainKeys.passwordKey)
        
        if let oldUsername = oldUsername, let oldPassword = oldPassword {
            APIHandler.sharedAPIHandler.login(oldUsername, password: oldPassword, success: {}, failure: { _ in })
        }
    }
    
    func login(_ id: String, password: String,  success: @escaping () -> Void, failure: @escaping (_ error: Error?) -> Void) {
        let params = postParamsForLogin(email: id, password: password)
        let articlesURL = URL(string: API.EndPoints.Login, relativeTo: API.BaseURL as URL?)
        
        guard let requestURL = articlesURL else {
            failure(PrototyperError.APIURLError)
            return
        }
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted) else {
            failure(PrototyperError.dataEncodeError)
            return
        }
        
        let request = jsonRequestForHttpMethod(.POST, requestURL: requestURL, bodyData: bodyData)
        executeRequest(request as URLRequest) { (data, response, networkError) in
            let httpURLResponse: HTTPURLResponse! = response as? HTTPURLResponse
            let error = (data == nil || httpURLResponse.statusCode != 200) ? PrototyperError.dataParseError : networkError
            if error != nil {
                failure(error)
            } else {
                let keychain = KeychainSwift()
                keychain.set(id, forKey: KeychainKeys.userNameKey)
                keychain.set(password, forKey: KeychainKeys.passwordKey)
                
                success()
            }
            self.isLoggedIn = error == nil
        }
    }
    
    // MARK: Feedback
    
    static func send(feedback: Feedback, success: @escaping () -> Void, failure: @escaping (_ error : Error?) -> Void) {
        guard let screenshot = feedback.screenshot else {
            sharedAPIHandler.sendGeneralFeedback(description: feedback.description,
                                                 name: feedback.creatorName,
                                                 success: success,
                                                 failure: failure)
            return
        }
        sharedAPIHandler.sendScreenFeedback(screenshot: screenshot,
                                            description: feedback.description,
                                            name: feedback.creatorName,
                                            success: success,
                                            failure: failure)
    }
    
    private func sendGeneralFeedback(description: String, name: String? = nil, success: @escaping () -> Void, failure: @escaping (_ error : Error?) -> Void) {
        guard let appId = appId, let releaseId = releaseId else {
            print("You need to set the app and release id first")
            failure(nil)
            return
        }
        
        let url = URL(string: API.EndPoints.feedback(appId,
                                                     releaseId: releaseId,
                                                     text: description.escaped,
                                                     username: name?.escaped),
                      relativeTo: API.BaseURL)!
        
        let request = jsonRequestForHttpMethod(.POST, requestURL: url)
        executeRequest(request as URLRequest) { (data, response, error) in
            error != nil ? failure(error) : success()
        }
    }
    
    private func sendScreenFeedback(screenshot: UIImage, description: String, name: String? = nil, success: @escaping () -> Void, failure: @escaping (_ error : Error?) -> Void) {
        guard let appId = appId, let releaseId = releaseId else {
            print("You need to set the app and release id first")
            failure(nil)
            return
        }

        let contentType = "\(MimeType.Multipart.rawValue); boundary=\(defaultBoundary)"
        let bodyData = bodyDataForImage(screenshot)
        
        let url = URL(string: API.EndPoints.feedback(appId,
                                                     releaseId: releaseId,
                                                     text: description.escaped,
                                                     username: name?.escaped),
                      relativeTo: API.BaseURL)!
        
        let request = jsonRequestForHttpMethod(.POST,
                                               requestURL: url,
                                               bodyData: bodyData,
                                               contentType: contentType)
        executeRequest(request as URLRequest) { (data, response, error) in
            error != nil ? failure(error) : success()
        }
    }
    
    // MARK: Share
    
    static func send(shareRequest: ShareRequest, success: @escaping () -> Void, failure: @escaping (_ error : Error?) -> Void) {
        sharedAPIHandler.sendShareRequest(for: shareRequest.email,
                                          because: shareRequest.content,
                                          name: shareRequest.creatorName,
                                          success: success,
                                          failure: failure)
    }
    
    private func sendShareRequest(for email: String, because explanation: String, name: String? = nil, success: @escaping () -> Void, failure: @escaping (_ error : Error?) -> Void) {
        guard let appId = appId, let releaseId = releaseId else {
            print("You need to set the app and release id first")
            failure(nil)
            return
        }

        let url = URL(string: API.EndPoints.share(appId,
                                                  releaseId: releaseId,
                                                  sharedEmail: email.escaped,
                                                  explanation: explanation.escaped,
                                                  username: name?.escaped),
                      relativeTo: API.BaseURL)!
        
        let request = jsonRequestForHttpMethod(.POST,
                                               requestURL: url)
        executeRequest(request as URLRequest) { (data, response, error) in
            error != nil ? failure(error) : success()
        }
    }

    // MARK: Helper
    
    fileprivate func jsonRequestForHttpMethod(_ method: HTTPMethod, requestURL: URL, bodyData: Data? = nil, contentType: String = MimeType.JSON.rawValue) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: requestURL)
        
        request.httpMethod = method.rawValue
        request.setValue(contentType, forHTTPHeaderField: HTTPHeaderField.ContentType.rawValue)
        request.setValue(MimeType.JSON.rawValue, forHTTPHeaderField: HTTPHeaderField.Accept.rawValue)
        request.httpBody = bodyData
        
        return request
    }
    
    fileprivate func bodyDataForImage(_ image: UIImage, boundary: String = defaultBoundary) -> Data {
        let bodyData = NSMutableData()
        
        let imageData = UIImageJPEGRepresentation(image, 0.4)
        
        bodyData.append("--\(boundary)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        bodyData.append("Content-Disposition: form-data; name=\"[feedback]screenshot\"; filename=\"screenshot.jpg\"\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        bodyData.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        bodyData.append(imageData!)
        bodyData.append("\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        
        return bodyData as Data
    }
    
    fileprivate func executeRequest(_ request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            OperationQueue.main.addOperation {
                completionHandler(data, response, error)
            }
            return ()
        }) 
        dataTask.resume()
    }
    
    // MARK: Post params
    
    fileprivate func postParamsForLogin(email: String, password: String) -> [String: Any] {
        typealias Session = API.DataTypes.Session
        return [Session.Session: [Session.Email: email, Session.Password: password]]
    }
}

//
//  APIHandler.swift
//  Prototyper
//
//  Created by Stefan Kofler on 17.06.15.
//  Copyright (c) 2015 Stefan Kofler. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

// MARK: - UserDefaultKeys
/// The key to be specified to retrieve the appID, releaseID and the username being stored in UserDefaults.
enum UserDefaultKeys {
    static let appId = "AppId"
    static let releaseId = "ReleaseId"
    static let username = "Username"
}


// MARK: - KeychainKeys
/// The key to be specified to retrieve the username and passwor being stored in the Keychain.
private enum KeychainKeys {
    static let userNameKey = "PrototyperUserName"
    static let passwordKey = "PrototyperPassword"
}


// MARK: - HTTPMethod
/// The HTTP method used to access the prototyper endpoint.
private enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}


// MARK: - MimeType
/// The content type to be specified while accessing endpoints.
private enum MimeType: String {
    case json = "application/json"
    case multipart = "multipart/form-data"
}


// MARK: - HTTPHeaderField
/// HTTPHeaderField options while accessing endpoints.
private enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case accept = "Accept"
}


// MARK: - API
/// Constants that would be specified while accessing endpoints.
private enum API {
    /// The actions to be executed when the endpoints are reached.
    enum EndPoints {
        static let login = "login"
        
        
        static func fetchReleaseInfo(bundleId: String, bundleVersion: String) -> String {
            "apps/find_release?bundle_id=\(bundleId)&bundle_version=\(bundleVersion)"
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
    
    /// Datatypes enum consisting of the Session enum.
    enum DataTypes {
        /// The Session enum consisting of the session, email and password.
        enum Session {
            static let session = "session"
            static let email = "email"
            static let password = "password"
        }
    }
}


/// The default boundary string.
private let defaultBoundary = "------VohpleBoundary4QuqLuM1cE5lMwCy"


// MARK: - APIHandler
///This class deals with making all the HTTP calls to the prototyper api, to login, send feedback and share request.
class APIHandler: ObservableObject {
    ///The URL for the prototyper instance
    let prototyperInstance: URL
    
    /// This boolean variable is used to check if the user is submitting feedback with or without logging in.
    @Published var continueWithoutLogin: Bool = false
    /// This boolean variable is used to check if the user is logged in
    @Published var userIsLoggedIn: Bool = false
    
    
    /// The appID of the current Bundle
    var appId: String? {
        let readPrototyperAppId = Bundle.main.object(forInfoDictionaryKey: "PrototyperAppId") as? String
        return readPrototyperAppId ?? UserDefaults.standard.string(forKey: UserDefaultKeys.appId)
    }
    
    /// The releaseID of the current bundle
    var releaseId: String? {
        let readPrototyperReleaseId = Bundle.main.object(forInfoDictionaryKey: "PrototyperReleaseId") as? String
        return readPrototyperReleaseId ?? UserDefaults.standard.string(forKey: UserDefaultKeys.releaseId)
    }
    
    
    init(prototyperInstance: URL) {
        self.prototyperInstance = prototyperInstance
        tryToFetchReleaseInfos()
        tryToLogin()
    }
    
    
    // MARK: Release Infos
    /// This function tries to fetch the release inforrmation and store it in the Userdefauts
    func tryToFetchReleaseInfos() {
        fetchReleaseInformation(success: { appId, releaseId in
            UserDefaults.standard.set(appId, forKey: UserDefaultKeys.appId)
            UserDefaults.standard.set(releaseId, forKey: UserDefaultKeys.releaseId)
        }, failure: { _ in
            print("No release information found on Prototyper.")
        })
    }
    
    /// This function tries to fetch the release inforrmation from the Keychain
    func fetchReleaseInformation(success: @escaping (_ appId: String, _ releaseId: String) -> Void,
                                 failure: @escaping (_ error: Error?) -> Void) {
        let bundleId = Bundle.main.infoDictionary?[kCFBundleIdentifierKey as String] as? String ?? ""
        let bundleVersion = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String ?? ""
        
        guard let url = URL(string: API.EndPoints.fetchReleaseInfo(bundleId: bundleId,
                                                                   bundleVersion: bundleVersion),
                            relativeTo: prototyperInstance) else {
            print("Coule not create URL for API Endpoint")
            failure(nil)
            return
        }
        
        let request = jsonRequestForHttpMethod(.GET, requestURL: url)
        executeRequest(request as URLRequest) { data, _, error in
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
    /// Retrives the username and password stored in the keychain and calls the login function.
    func tryToLogin() {
        let oldUsername = KeyChain.load(KeychainKeys.userNameKey)
        let oldPassword = KeyChain.load(KeychainKeys.passwordKey)
        
        if let oldUsername = oldUsername, let oldPassword = oldPassword {
            login(oldUsername, password: oldPassword, success: {}, failure: { _ in })
        }
    }
    
    /// The login task is performed here.
    func login(_ id: String, password: String, success: @escaping () -> Void, failure: @escaping (_ error: Error?) -> Void) {
        let params = postParamsForLogin(email: id, password: password)
        let articlesURL = URL(string: API.EndPoints.login, relativeTo: prototyperInstance)
        
        guard let requestURL = articlesURL else {
            failure(PrototyperError.APIURLError)
            return
        }
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: params,
                                                         options: JSONSerialization.WritingOptions.prettyPrinted) else {
            failure(PrototyperError.dataEncodeError)
            return
        }
        
        let request = jsonRequestForHttpMethod(.POST, requestURL: requestURL, bodyData: bodyData)
        executeRequest(request as URLRequest) { data, response, networkError in
            let httpURLResponse = response as? HTTPURLResponse
            let error = (data == nil || httpURLResponse?.statusCode != 200) ? PrototyperError.dataParseError : networkError
            if error != nil {
                failure(error)
                self.userIsLoggedIn = false
            } else {
                KeyChain.store(element: id, for: KeychainKeys.userNameKey)
                KeyChain.store(element: password, for: KeychainKeys.passwordKey)
                self.userIsLoggedIn = true
                self.continueWithoutLogin = false
                success()
            }
        }
    }
    
    
    // MARK: Feedback
    /// The screenshot feedback is sent to the prototyper by calling this function with inturn calls the actual send function.
    func send(feedback: Feedback, success: @escaping () -> Void, failure: @escaping (_ error: Error?) -> Void) {
        guard let screenshot = feedback.screenshot else {
            sendGeneralFeedback(description: feedback.description,
                                name: feedback.creatorName,
                                success: success,
                                failure: failure)
            return
        }
        sendScreenFeedback(screenshot: screenshot,
                           description: feedback.description,
                           name: feedback.creatorName,
                           success: success,
                           failure: failure)
    }
    
    /// The feedback text is sent to the prototyper by calling this function with inturn calls the actual send function.
    private func sendGeneralFeedback(description: String,
                                     name: String? = nil,
                                     success: @escaping () -> Void,
                                     failure: @escaping (_ error: Error?) -> Void) {
        guard let appId = appId, let releaseId = releaseId else {
            print("You need to set the app and release id first")
            failure(nil)
            return
        }
        
        guard let url = URL(string: API.EndPoints.feedback(appId,
                                                           releaseId: releaseId,
                                                           text: description.escaped,
                                                           username: name?.escaped),
                            relativeTo: prototyperInstance) else {
            print("Coule not create URL for API Endpoint")
            failure(nil)
            return
        }
        
        let request = jsonRequestForHttpMethod(.POST, requestURL: url)
        executeRequest(request as URLRequest) { _, _, error in
            error != nil ? failure(error) : success()
        }
    }
    
    /// The feedback is sent to the prototyper by calling this function
    private func sendScreenFeedback(screenshot: UIImage,
                                    description: String,
                                    name: String? = nil,
                                    success: @escaping () -> Void,
                                    failure: @escaping (_ error: Error?) -> Void) {
        guard let appId = appId, let releaseId = releaseId else {
            print("You need to set the app and release id first")
            failure(nil)
            return
        }
        
        let contentType = "\(MimeType.multipart.rawValue); boundary=\(defaultBoundary)"
        let bodyData = bodyDataForImage(screenshot)
        
        guard let url = URL(string: API.EndPoints.feedback(appId,
                                                           releaseId: releaseId,
                                                           text: description.escaped,
                                                           username: name?.escaped),
                            relativeTo: prototyperInstance) else {
            print("Coule not create URL for API Endpoint")
            failure(nil)
            return
        }
        
        let request = jsonRequestForHttpMethod(.POST,
                                               requestURL: url,
                                               bodyData: bodyData,
                                               contentType: contentType)
        executeRequest(request as URLRequest) { _, _, error in
            error != nil ? failure(error) : success()
        }
    }
    
    
    // MARK: Share
    /// Internally calls another function that send the share request to the specified user
    func send(shareRequest: ShareRequest,
              success: @escaping () -> Void,
              failure: @escaping (_ error: Error?) -> Void) {
        sendShareRequest(for: shareRequest.email,
                         because: shareRequest.content,
                         name: shareRequest.creatorName,
                         success: success,
                         failure: failure)
    }
    
    ///Sends the share request to the email id specified.
    private func sendShareRequest(for email: String,
                                  because explanation: String,
                                  name: String? = nil,
                                  success: @escaping () -> Void,
                                  failure: @escaping (_ error: Error?) -> Void) {
        guard let appId = appId, let releaseId = releaseId else {
            print("You need to set the app and release id first")
            failure(nil)
            return
        }
        
        guard let url = URL(string: API.EndPoints.share(appId,
                                                        releaseId: releaseId,
                                                        sharedEmail: email.escaped,
                                                        explanation: explanation.escaped,
                                                        username: name?.escaped),
                            relativeTo: prototyperInstance) else {
            print("Coule not create URL for API Endpoint")
            failure(nil)
            return
        }
        
        let request = jsonRequestForHttpMethod(.POST,
                                               requestURL: url)
        executeRequest(request as URLRequest) { _, _, error in
            error != nil ? failure(error) : success()
        }
    }
    
    
    // MARK: Helper
    fileprivate func jsonRequestForHttpMethod(_ method: HTTPMethod,
                                              requestURL: URL,
                                              bodyData: Data? = nil,
                                              contentType: String = MimeType.json.rawValue) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: requestURL)
        
        request.httpMethod = method.rawValue
        request.setValue(contentType, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        request.setValue(MimeType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.accept.rawValue)
        request.httpBody = bodyData
        
        return request
    }
    
    fileprivate func bodyDataForImage(_ image: UIImage, boundary: String = defaultBoundary) -> Data {
        let bodyData = NSMutableData()
        
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            return bodyData as Data
        }
        
        bodyData.append(Data("--\(boundary)\r\n".utf8))
        let contentdisposition = "Content-Disposition: form-data; name=\"[feedback]screenshot\"; filename=\"screenshot.jpg\"\r\n"
        bodyData.append(Data(contentdisposition.utf8))
        bodyData.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
        bodyData.append(imageData)
        bodyData.append(Data("\r\n--\(boundary)--\r\n".utf8))
        
        return bodyData as Data
    }
    
    fileprivate func executeRequest(_ request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
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
        return [Session.session: [Session.email: email, Session.password: password]]
    }
}

# Prototyper

[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

The Prototyper Framework allows you to integrate prototypes into an iOS application and receive feedback using Prototyper service. When you deploy an application using the [Prototyper service](https://prototyper-bruegge.in.tum.de) the Prototyper Framework allows users to send feedback from within the application.

## Example

Open `PrototyperExample.xcodeproj` under the Example directory to test the Prototyper framework. To work on the framework, open the `Prototyper` directory in xcode, which opens as a swift package.

## Requirements

To use the Prototyper framework you need an account at the [Prototyper online service](https://prototyper-bruegge.in.tum.de).
Your users can use the feedback button to give feedback and share the application with other users. The feedback will be displayed on the website of the [Prototyper service](https://prototyper-bruegge.in.tum.de).

## Installation

1. Add the Prototyper framework to your application as a swift package dependency:

    * Go to File > Swift Packages > Add Package Dependency...
    * Enter https://github.com/ls1intum/Prototyper.git as the package respository URL.
    * Select the branch as `master` in the rules section.
    * Make sure the target is right and then click Finish.

2. Display the feedback button in the `scene(: UIScene, willConnectTo: UISceneSession, options: UIScene.ConnectionOptions)` method of your `SceneDelegate`. Don't forget to import the Prototyper framework.

    ```swift
    import Prototyper
    ```

    ```swift
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        let contentView = ContentView()

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            
            PrototyperController.showFeedbackButton = true
            
            window.makeKeyAndVisible()
        }
    }
    ```
3. Deploy your application using the [Prototyper service](https://prototyper-bruegge.in.tum.de)

## Author

Paul Schmiedmayer, [@PSchmiedmayer](https://twitter.com/pschmiedmayer), Chair of Applied Software Engineering, ios@in.tum.de
Stefan Kofler, grafele@gmail.com
Raymond Pinto, Masters Informatics, raymond.pinto@tum.de

## License

Prototyper is available under the MIT license. See the LICENSE file for more info.

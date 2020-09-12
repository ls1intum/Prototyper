# Prototyper

[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
![platforms](https://img.shields.io/cocoapods/p/Prototyper)
![license](https://img.shields.io/github/license/ls1intum/prototyper)

The Prototyper Framework allows you to integrate prototypes into an iOS application and receive feedback using Prototyper service. When you deploy an application using the [Prototyper service](https://prototyper-bruegge.in.tum.de) the Prototyper Framework allows users to send feedback from within the application.

## Example

Open `PrototyperExample.xcodeproj` under the Example directory to test the Prototyper framework. You can find [here](https://ls1intum.github.io/Prototyper/docs/Classes) the list of globally available classes. To work on the framework, open the `Prototyper` directory in xcode, which opens as a swift package. 

## Requirements

To use the Prototyper framework you need an account at the [Prototyper online service](https://prototyper-bruegge.in.tum.de).
Your users can use the feedback button to give feedback and share the application with other users. The feedback will be displayed on the website of the [Prototyper service](https://prototyper-bruegge.in.tum.de).

## Installation

1. Add the Prototyper framework to your application as a swift package dependency. Follow the instructions specified [here](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) and use https://github.com/ls1intum/Prototyper.git as the package respository URL.

2. Display the feedback button in the `scene(: UIScene, willConnectTo: UISceneSession, options: UIScene.ConnectionOptions)` method of your `SceneDelegate`. Don't forget to import the Prototyper framework. You can configure the `Prototyper` framework using `Prototyper.configure(_: PrototyperSettings)` using the `PrototyperSettings`.

    ```swift
    import Prototyper
    ```

    ```swift
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        
        let contentView = ContentView()
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: contentView)
        self.window = window
        
        Prototyper.configure(.default)
        
        window.makeKeyAndVisible()
    }
    ```
3. Deploy your application e.g. using the [Prototyper service found at https://prototyper.ase.in.tum.de](https://prototyper.ase.in.tum.de)

## Authors

- Paul Schmiedmayer, [@PSchmiedmayer](https://twitter.com/pschmiedmayer)
- Stefan Kofler, [@kofse](https://twitter.com/kofse)
- Raymond Pinto, [@RaymondPinto94](https://twitter.com/RaymondPinto94)

## License

Prototyper is available under the MIT license. See the LICENSE file for more info.
Prototyper wurde initital im Rahmen des vom BMBF geförderten Softwarecampus Projekt ProCeeD unter der Leitung von Dr. Lukas Alperowitz entwickelt.

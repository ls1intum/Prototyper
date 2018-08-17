# Prototyper

[![Version](https://img.shields.io/cocoapods/v/Prototyper.svg?style=flat)](http://cocoapods.org/pods/Prototyper)
[![License](https://img.shields.io/cocoapods/l/Prototyper.svg?style=flat)](http://cocoapods.org/pods/Prototyper)
[![Platform](https://img.shields.io/cocoapods/p/Prototyper.svg?style=flat)](http://cocoapods.org/pods/Prototyper)

The Prototyper Framework allows you to integrate prototypes into an iOS application and receive feedback using Prototyper service. When you deploy an application using the [Prototyper service](https://prototyper-bruegge.in.tum.de) the Prototyper Framework allows users to send feedback from within the application.

## Example

Run `pod install` from the Example directory first and open the `Prototyper Example.workspace` and run the iOS application.

## Requirements

To use the Prototyper framework you need an account at the [Prototyper online service](https://prototyper-bruegge.in.tum.de).
To integrate a prototype into your application follow the instructions of the [Prototype Framework](https://github.com/ls1intum/Prototype).
Your users can use the feedback button to give feedback and share the application with other users. The feedback will be displayed on the website of the [Prototyper service](https://prototyper-bruegge.in.tum.de).

## Installation

1. Integrate the Prototype Framework using CocoaPods

    ```swift
    pod 'Prototyper'
    ```

    If you want to add prototypes to the application using the `PrototypeView` add the following lines at the end of your Podfile. Follow the instructions of the [Prototype Framework](https://github.com/ls1intum/Prototype) for more details:

    ```swift
    post_install do |installer|
      installer.pods_project.targets.each do |target|
        target.new_shell_script_build_phase.shell_script = "mkdir -p $PODS_CONFIGURATION_BUILD_DIR/#{target.name}"
        target.build_configurations.each do |config|
          config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
        end
      end

      installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
      end
    end
    ```
2. Display the feedback button in the `applicationDidFinishLaunchingWithOptions` method of your `AppDelegate`. Don't forget to import the Prototyper framework.

    ```swift
    import Prototyper
    ```

    ```swift
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        PrototyperController.showFeedbackButton = true

        return true
    }
    ```
3. Deploy your application using the [Prototyper service](https://prototyper-bruegge.in.tum.de)

## Author

Paul Schmiedmayer, [@PSchmiedmayer](https://twitter.com/pschmiedmayer), Chair of Applied Software Engineering, ios@in.tum.de
Stefan Kofler, grafele@gmail.com

## License

Prototyper is available under the MIT license. See the LICENSE file for more info.

Pod::Spec.new do |s|
  s.name             = 'Prototyper'
  s.version          = '1.0'
  s.summary          = 'Framework that allows you to integrate prototypes into an iOS application and receive feedback using the Prototyper service.'

  s.description      = <<-DESC
The Prototyper Framework allows you to integrate prototypes into an iOS application and receive feedback using Prototyper service. When you deploy an application using the Prototyper service (https://prototyper-bruegge.in.tum.de) the Prototyper Framework allows users to send feedback from within the application.
                       DESC

  s.homepage         = 'https://www1.in.tum.de'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Paul Schmiedmayer' => 'paul.schmiedmayer@tum.de',
                         'Chair of Applied Software Engineering' => 'ios@in.tum.de',
                         'Stefan Kofler' => 'grafele@gmail.com' }
  s.source           = { :git => 'https://github.com/ls1intum/prototyper.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/PSchmiedmayer'

  s.ios.deployment_target = '10.0'

  s.source_files = 'Prototyper/Classes/**/*'
  s.resources = 'Prototyper/Assets/*'

  s.dependency 'KeychainSwift'
  s.dependency 'Prototype'
end

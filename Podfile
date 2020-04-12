# Uncomment the next line to define a global platform for your project
platform :ios, '12.1'
workspace 'WeatherAppDemo'
project 'WeatherAppDemo'

def utilities_pods
  pod 'SwiftLint', '0.39.1'
  pod 'AlamofireActivityLogger' , :git => 'https://github.com/ManueGE/AlamofireActivityLogger.git', :tag => '2.4.0'
  pod 'Alamofire', '4.7'
  pod 'Kingfisher', '4.0.1'
end

target 'WeatherAppDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WeatherAppDemo
  utilities_pods

  target 'WeatherAppDemoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'WeatherAppDemoUITests' do
    # Pods for testing
  end

end

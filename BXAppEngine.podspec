#
# Be sure to run `pod lib lint BXAppEngine.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'BXAppEngine'
    s.version          = '0.0.4'
    s.summary          = 'A short description of BXAppEngine.'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = <<-DESC
    TODO: Add long description of the pod here.
    DESC
    
    s.homepage         = 'https://github.com/xudusheng/BXAppEngine'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'xudusheng' => 'xudusheng@bisinuolan.com' }
    s.source           = { :git => 'https://github.com/xudusheng/BXAppEngine.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.ios.deployment_target = '8.0'
    
    # s.source_files = 'BXAppEngine/Classes/**/*'
    s.dependency 'BXToolKit'
    
    s.subspec 'TaskQueue' do |task|
        task.source_files = 'BXAppEngine/Classes/TaskQueue/**/*'
    end
    
    s.subspec 'BXRequestPageView' do |pageView|
        pageView.source_files = 'BXAppEngine/Classes/BXRequestPageView/*'
        pageView.subspec 'BXSpinKitView' do |spinKit|
            spinKit.source_files = 'BXAppEngine/Classes/BXRequestPageView/BXSpinKitView/**/*'
        end
    end
    
end

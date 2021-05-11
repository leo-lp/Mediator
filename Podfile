install! 'cocoapods',
:generate_multiple_pod_projects => true
#:incremental_installation => true

platform :ios, '10.0'
use_frameworks!

workspace 'Mediator.xcworkspace'

abstract_target 'Mediator-Example' do

    #target 'MediatorDemo' do
        #project 'MediatorDemo/MediatorDemo.xcodeproj'
        #
        ## https://github.com/apple/swift-protobuf
        #pod 'SwiftProtobuf', '= 1.12.0'
    #end

    target 'Mediator-Example' do
        project 'Mediator-Example/Mediator-Example.xcodeproj'

        # https://github.com/apple/swift-protobuf
        #pod 'SwiftProtobuf', '= 1.12.0'

        # Pods for Example
        pod 'BusinessModule', :path => './'
        pod 'Mediator+BusinessModule', :path => './'
        pod 'BasicComponents', :path => './'

    end

end

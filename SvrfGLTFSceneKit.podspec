Pod::Spec.new do |s|
  s.name = "SvrfGLTFSceneKit"
  s.version = "1.0.2"
  s.summary = "SvrfGLTF loader for SceneKit"
  s.homepage = "https://github.com/SVRF/SvrfGLTFSceneKit"
  s.license = "MIT"
  s.author = "SVRF"
  s.ios.deployment_target = "11.0"
  s.osx.deployment_target = "10.13"
  s.source = { :git => "https://github.com/SVRF/SvrfGLTFSceneKit.git", :tag => "#{s.version}" }
  s.source_files = "Source/**/*.swift"
  s.resources = "Source/**/*.shader"
  s.requires_arc = true
  s.swift_version = "4.0"
  s.pod_target_xcconfig = {
    "SWIFT_VERSION" => "4.0",
    "SWIFT_ACTIVE_COMPILATION_CONDITIONS" => "SEEMS_TO_HAVE_VALIDATE_VERTEX_ATTRIBUTE_BUG SEEMS_TO_HAVE_PNG_LOADING_BUG"
  }
end

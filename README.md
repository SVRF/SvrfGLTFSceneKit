# SvrfGLTFSceneKit
glTF loader for SceneKit

![ScreenShot](https://raw.githubusercontent.com/svrf/SvrfGLTFSceneKit/master/screenshot.png)

## Installation
### Using [CocoaPods](http://cocoapods.org/)

Add the following to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html):

```rb
pod 'SvrfGLTFSceneKit'
```

### Manually

Download **SvrfGLTFSceneKit_vX.X.X.zip** from [Releases](https://github.com/SVRF/SvrfGLTFSceneKit/releases).

## Usage

### Swift
```
import SvrfGLTFSceneKit

var scene: SCNScene
do {
  let sceneSource = try GLTFSceneSource(named: "art.scnassets/Box/glTF/Box.gltf")
  scene = try sceneSource.scene()
} catch {
  print("\(error.localizedDescription)")
  return
}
```

### Objective-C
```
@import SvrfGLTFSceneKit;

GLTFSceneSource *source = [[GLTFSceneSource alloc] initWithURL:url options:nil];
NSError *error;
SCNScene *scene = [source sceneWithOptions:nil error:&error];
if (error != nil) {
  NSLog(@"%@", error);
  return;
}
```

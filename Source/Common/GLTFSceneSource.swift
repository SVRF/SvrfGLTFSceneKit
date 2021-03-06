//
//  GLTFSceneSource.swift
//  GLTFSceneKit
//
//  Created by magicien on 2017/08/17.
//  Copyright © 2017 DarkHorse. All rights reserved.
//

import SceneKit
import SpriteKit

@objcMembers
public class GLTFSceneSource : SCNSceneSource {
    private var loader: GLTFUnarchiver! = nil
    public var loaded: Bool {
        get {
            return self.loader != nil
        }
    }

    public override init() {
        super.init()
    }
    
    public convenience init(path: String, options: [SCNSceneSource.LoadingOption : Any]? = nil, extensions: [String:Codable.Type]? = nil) throws {
        self.init()
        
        let loader = try GLTFUnarchiver(path: path, extensions: extensions)
        self.loader = loader
    }
    
    public override convenience init(url: URL, options: [SCNSceneSource.LoadingOption : Any]? = nil) {
        self.init(url: url, options: options, extensions: nil)
    }
    
    public convenience init(url: URL, options: [SCNSceneSource.LoadingOption : Any]?, extensions: [String:Codable.Type]?) {
        self.init()
        
        do {
            self.loader = try GLTFUnarchiver(url: url, extensions: extensions)
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    public static func load(remoteURL: URL,
                            animationManager: GLTFAnimationManager? = nil,
                            onSuccess success: @escaping (_ sceneSource: GLTFSceneSource) -> Void,
                            onFailure failure: Optional<(_ error: Error) -> Void> = nil,
                            extensions: [String:Codable.Type]? = nil) -> URLSessionDataTask {
        
        struct UnexpectedResponseError: Error {
            enum ErrorType {
                case unexpectedResponseType
                case noData
                indirect case status(Int)
            }
            
            let errorType: ErrorType
        }
        
        let dataTask = URLSession.shared.dataTask(with: remoteURL) { data, response, error in
            // Handle various error cases
            if let error = error {
                failure?(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                failure?(UnexpectedResponseError(errorType: .unexpectedResponseType))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                failure?(UnexpectedResponseError(errorType: .status(httpResponse.statusCode)))
                return
            }
            
            // Construct object and return
            guard let data = data else {
                failure?(UnexpectedResponseError(errorType: .noData))
                return
            }

            let directoryPath = httpResponse.url?.deletingLastPathComponent()
            let sceneSource = GLTFSceneSource(data: data, withDirectoryPath: directoryPath, animationManager: animationManager)
            success(sceneSource)
        }
        dataTask.resume()
        
        return dataTask
    }

    public convenience init(data: Data,
                            withDirectoryPath directoryPath: URL? = nil,
                            animationManager: GLTFAnimationManager? = nil,
                            options: [SCNSceneSource.LoadingOption : Any]? = nil) {
        self.init()
        do {
            self.loader = try GLTFUnarchiver(data: data, withDirectoryPath: directoryPath, animationManager: animationManager)
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    public convenience init(named name: String, options: [SCNSceneSource.LoadingOption : Any]? = nil, extensions: [String:Codable.Type]? = nil) throws {
        let filePath = Bundle.main.path(forResource: name, ofType: nil)
        guard let path = filePath else {
            throw URLError(.fileDoesNotExist)
        }
        try self.init(path: path, options: options, extensions: extensions)
    }
    
    public override func scene(options: [SCNSceneSource.LoadingOption : Any]? = nil) throws -> SCNScene {
        guard self.loaded else {
            throw GLTFLoadingError.LoaderNotInitialized
        }

        let scene = try self.loader.loadScene()
        #if SEEMS_TO_HAVE_SKINNER_VECTOR_TYPE_BUG
            let sceneData = NSKeyedArchiver.archivedData(withRootObject: scene)
            let source = SCNSceneSource(data: sceneData, options: nil)!
            let newScene = source.scene(options: nil)!
            return newScene
        #else
            return scene
        #endif
    }
    
    public func sceneOverlay() -> SvrfSceneOverlay? {
        return self.loader.loadSceneOverlay()
    }

    /*
    public func cameraNodes() -> [SCNNode] {
        var cameraNodes = [SCNNode]()
        
        let scene = try self.loader.loadScene()
        scene.rootNode.childNodes
        
        return cameraNodes
    }
     */
}

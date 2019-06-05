//
//  Asset.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import SceneKit

enum Asset {
    enum Directory {
        static let characters = "assets.scnassets/"
        static let worldResources = "assets.scnassets/"
        static let music = "Audio/"

        case images
        case scenes
        case textures
        case props
        case items
        case templates
        case floor
        
        case item
        case actor
        case custom(String)
        
        var path: String {
            switch self {
            case .images:
                return directoryName()!
                
            case .scenes, .textures, .props, .items, .floor, .templates:
                return Directory.worldResources + directoryName()!
            
            case .item:
                return Directory.worldResources
                
            case .actor:
                return Directory.characters
                
            case let .custom(path):
                return path
            }
        }
        
        /// Returns the name of the directory.
        func directoryName() -> String? {
            switch self {
            case .scenes: return "_Scenes/"
            case .textures: return "textures/"
            case .images: return "Images/"
            case .props: return "props/"
            case .items: return "items/"
            case .templates: return "Custom/"
            case .floor: return "floor/"
            default: return nil
            }
        }
        
        static var environmentSound: Directory {
            return .custom(music + "ENVIRONMENT/")
        }
    }
    
    static func animations(for group: EventGroup, in directory: Directory) -> [CAAnimation] {
        return group.identifiers.compactMap { name in
            guard let animation = animation(named: name, in: directory) else {
                log(message: "Failed to load '\(directory.path)\(name).dae' animation.")
                return nil
            }
            return animation
        }
    }
    
    static func animation(named: String, in directory: Directory) -> CAAnimation? {
        return CAAnimation.animation(fromResource: directory.path + named)
    }
    
    static func sound(named: String, in directory: Directory) -> SCNAudioSource? {
        guard let url = Bundle.main.url(forResource: named, withExtension: "m4a", subdirectory: directory.path) else {
            log(message: "Failed to load '\(directory.path)\(named).m4a' audio.")
            return nil
        }
        
        return SCNAudioSource(url: url)
    }
    
    static func sounds(for group: EventGroup, in directory: Directory) -> [SCNAudioSource] {
        return group.identifiers.compactMap { name in
            return sound(named: name, in: directory)
        }
    }
    
    static func neutralPose(in directory: Directory, fileExtension: String = "dae") -> SCNNode? {
        return node(named: "NeutralPose", in: directory, fileExtension: fileExtension)
    }
    
    static func node(named name: String, in directory: Directory, fileExtension: String = "dae") -> SCNNode? {
        let path = directory.path + name
        guard let url = Bundle.main.url(forResource: path, withExtension: fileExtension) else {
            return nil
        }
        
        do {
            let scene: SCNScene
            scene = try SCNScene(url: url, options: [:])
            return scene.rootNode.childNodes[0]
        }
        catch {
            log(message: "Failed to find node at: '\(directory.path)\(name).\(fileExtension)'.")
            return nil
        }
    }
    
    static func map(named name: String) -> SCNScene {
        return scene(named: name, in: .scenes)
    }
    
    static func scene(named name: String, in directory: Directory) -> SCNScene {
        let dirPath = directory.path
        guard let scene = SCNScene(named: name, inDirectory: dirPath, options: [:]) else {
            fatalError("Failed to load scene: \(name).")
        }
        return scene
    }
    
    static func texture(named: String) -> Texture? {
        return Texture(named: named)
    }
}

//
//  SCNCyclops.swift
//  ByteMe
//
//  Created by Eric Internicola on 6/6/19.
//  Copyright © 2019 iColasoft. All rights reserved.
//

import SceneKit


class SCNCyclops: SCNNode {

    var cyclopsNode: SCNNode!

    convenience init?(from scene: SCNScene) {
        guard let cyclopsNode = scene.cyclopsNode else {
            return nil
        }
        self.init()
        self.cyclopsNode = cyclopsNode
        addChildNode(cyclopsNode)
    }

    class func loadFromSceneFile() -> SCNCyclops? {
        guard let scene = SCNScene(named: "assets.scnassets/NeutralPose.scn") else {
            return nil
        }
        return SCNCyclops(from: scene)
    }

    func animate(event: EventGroup) {
        let animations = Asset.animations(for: event, in: .actor)
        assert(animations.count > 0)
        assert(animations.count == event.identifiers.count)

        for i in 0..<event.identifiers.count {
            cyclopsNode.addAnimation(animations[i], forKey: event.identifiers[i])
        }
    }

}

extension SCNScene {

    /// Finds you the Cyclops node in your scene.
    var cyclopsNode: SCNNode? {
        return rootNode.childNode(withName: "CHARACTER_Cyclops", recursively: true)
    }

}

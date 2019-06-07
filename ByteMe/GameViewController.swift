//
//  GameViewController.swift
//  ByteMe
//
//  Created by Eric Internicola on 6/4/19.
//  Copyright © 2019 iColasoft. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    let cyclops = SCNCyclops.loadFromSceneFile()!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.pushViewController(ARViewController(), animated: false)
        
        // create a new scene
        let scene = SCNScene()

        // retrieve the SCNView
        let scnView = self.view as! SCNView

        // set the scene to the view
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)

        scene.rootNode.addChildNode(cyclops)
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object

        guard let cyclops = hitResults.first?.node.cyclopsParent as? SCNCyclops else {
            return
        }

        cyclops.animate(event: .celebration)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}

extension SCNNode {

    var cyclopsParent: SCNNode? {
        guard let parent = parent else {
            return nil
        }
        if parent is SCNCyclops {
            return parent
        }
        return parent.cyclopsParent
    }

}

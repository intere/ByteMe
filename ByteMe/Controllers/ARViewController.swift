//
//  ARViewController.swift
//  ByteMe
//
//  Created by Eric Internicola on 6/6/19.
//  Copyright © 2019 iColasoft. All rights reserved.
//

import Cartography
import ARCL
import UIKit

class ARViewController: UIViewController {

    let arView = SceneLocationView()
    var locationTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(arView)

        constrain(view, arView) { view, arView in
            arView.top == view.top
            arView.left == view.left
            arView.bottom == view.bottom
            arView.right == view.right
        }

        arView.showAxesNode = true
        arView.locationEstimateMethod = .mostRelevantEstimate
        arView.run()

        queueLocationCheckTimer()
    }

}

// MARK: - Implementation

private extension ARViewController {

    /// Queues up a timer that delegates off to `checkForLocation`
    func queueLocationCheckTimer() {
        locationTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(checkForLocation), userInfo: nil, repeats: false)
    }

    @objc
    /// Checks to see if we have your location yet, if not queues the timer again, if so, calls `setupARCLScene()` to setup AR
    func checkForLocation() {
        guard arView.sceneLocationManager.currentLocation != nil else {
            return queueLocationCheckTimer()
        }

        setupARCLScene()
    }

    /// Adds a cyclops to the scene
    func setupARCLScene() {
        for _ in 0..<3 {
            guard let location = arView.sceneLocationManager.currentLocation?.randomLocation(maxDistance: 10),
                let cyclops = SCNCyclops.loadFromSceneFile() else {
                    return
            }

            let locNode = LocationNode(location: location)
            locNode.addChildNode(cyclops)

            arView.addLocationNodeWithConfirmedLocation(locationNode: locNode)
        }
    }
}

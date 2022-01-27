//
//  ViewController.swift
//  poke3D
//
//  Created by Thiago Antonio Ramalho on 23/01/22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imageTracking = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main) {
            
            configuration.trackingImages = imageTracking
            configuration.maximumNumberOfTrackedImages = 1
            
            print("Image succefully added")
        }
        
        

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
   
    fileprivate func addPoke(pokeResource: String, planeNode: SCNNode) {
        if let pokeScene = SCNScene(named: "art.scnassets/\(pokeResource)") {
            
            if let pokeNode =  pokeScene.rootNode.childNodes.first {
                
                pokeNode.eulerAngles.x = .pi / 2
                
                planeNode.addChildNode(pokeNode)
                
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }
        
        let physicalSize = imageAnchor.referenceImage.physicalSize
        
        let plane = SCNPlane(width: physicalSize.width, height: physicalSize.height)
        
        plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.7)
        
        let planeNode = SCNNode(geometry: plane)
        
        planeNode.eulerAngles.x = -Float.pi / 2
        
        node.addChildNode(planeNode)
        
        addPoke(pokeResource: "eevee.scn", planeNode: planeNode)
        
        return node
    }
}

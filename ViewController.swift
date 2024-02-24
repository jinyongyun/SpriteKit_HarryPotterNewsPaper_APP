//
//  ViewController.swift
//  HarryPotterNewsPaper
//
//  Created by jinyong yun on 2/21/24.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    
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
        
        // 이미지 인식을 위해, 뚱이 파트에서 했죠?!
        let configuration = ARImageTrackingConfiguration()
        
        // Assets안에 AR group 폴더 이름으로 안에 있는 인식 대상 이미지 가져오기
        if let trackedImage = ARReferenceImage.referenceImages(inGroupNamed: "HarryPotterNewsPaper", bundle: Bundle.main) {
            // 인식되는 이미지
            configuration.trackingImages = trackedImage
            // 인식한 이미지의 개수
            configuration.maximumNumberOfTrackedImages = 1
        }
        
        sceneView.session.run(configuration)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
}


extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        //빈 노드 생성
        let node = SCNNode()
        
        //renderer가 인식한 이미지의 anchor 주면 이거 받아서 ARImageAnchor로 다운캐스팅
        guard let imageAnchor = anchor as? ARImageAnchor else { return node }
        
        //우리가 플젝에 넣어준 HarryPotter.mp4를 실제 SKScene 객체로 돌려주는 메서드
        let HarryVideo = addVideo()
        
        //imageAnchor에(Anchor는 위치와 방향 관련 객체) content로 videoScene을 설정!
        let planeNode = addPlane(on: imageAnchor, addVideo: HarryVideo)
        
        node.addChildNode(planeNode)
        
        return node
    }
    
    func addVideo() -> SKScene { //SKScene으로 리턴
        
        // 동영상을 노드로 바꾸기 위해 SpriteKit의 SKVideoNode를 생성
        let videoNode = SKVideoNode(fileNamed: "HarryPotter.mp4")
        
        // 동영상 재생
        videoNode.play()
        
        // 리턴할 SKScene 객체 생성 (2D)
        // 장면의 크기는 동영상의 크기로 맞춰 준다
        // 아직 동영상 넣지 않았음에 주의 ⚠️
        let videoScene = SKScene(size: CGSize(width: 1454, height: 2144))
        
        // 비디오 노드의 위치를 조정한다
        // videoNode의 위치를 videoScene의 중간에 위치하도록 한다.
        videoNode.position = CGPoint(x: videoScene.size.width / 2,
                                     y: videoScene.size.height / 2)
        
        // 노드 회전시키는 방법 2가지!
        // 1. zRotation을 통해 돌려주기
        // 2. yScale는 기본값이 +1이다. -1로 설정해주면 반전
        videoNode.yScale = -1.35
        
        // VideoScene에 노드를 자식으로 추가해 줬으니 이제 2D로 표시할 준비가 됐다.
        // 현재까지는 3D 환경에서 작업을 하는 중이기 때문에 2D인 SKScene는 나타나지 않는다.
        // addPlane 메서드에서 plane노드의 material의 diffuse.contents를 SKScene로 바꿔줘야 한다.(일종의 확산을 통해 입혀주는 거라고 제일 처음에 배웠죠?!)
        videoScene.addChild(videoNode)
        
        return videoScene
    }
    
    func addPlane(on imageAnchor: ARImageAnchor, addVideo: SKScene) -> SCNNode {
        // SCNPlane으로 plane 객체 생성, 위의 이미지 anchor는 Renderer에서의 그 anchor
        // 즉 인식 이미지의 너비와 높이로 plane 생성
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                             height: imageAnchor.referenceImage.physicalSize.height)
        
        // plane에 나타낼 contents로 비디오 즉 SKScene 추가 ⭐️
        plane.firstMaterial?.diffuse.contents = addVideo
        
        // plane 객체로 planeNode 생성
        let planeNode = SCNNode(geometry: plane)
        
        // 뚱이 때 배웠죠! planeNode는 생성 시 수직평면으로 생성되어 90도 회전시켜야 한다고!!
        planeNode.eulerAngles.x = -(Float.pi/2)
        
        return planeNode
    }
}



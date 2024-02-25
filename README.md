# SpriteKit_HarryPotterNewsPaper_APP
해리포터 예언자 일보 만들기 앱!
<br>
![hRry](https://github.com/jinyongyun/SpriteKit_HarryPotterNewsPaper_APP/assets/102133961/df3489a4-bcca-4a98-9401-e64d6757683e)



저번에는 2D 이미지를 인식해서 3D 모델(뚱이)를 띄워보았다.

이번 시간에는 2D 이미지를 인식해서 그곳에 동영상을 띄워보려고 한다.

2D 이미지 속에 움직이는 동영상 → 이건 해리포터 세계관의 신문이 딱 떠오르지 않은가?!

그래서 오늘 만들어 볼 것은!

해리포터 세계관의 대중적인 신문

바로 [예언자 일보]이다.

오늘 필요한 준비물은 다음과 같다.

**해리포터 신문(멈춰있는 거, gif 안된다)**

**그 이미지 위에 덧씌울 mp4 파일**

해리 포터 신문은 우리 스네이프 교수님이 나와 계신 걸로 정했다.

이미지에 덧씌울 파일은 유튜브 프리미엄 기능을 활용해서 유튜브 영상을 다운받았다. 

(물론 편집도 했다. 규격이나 사운드 제거)

일단 영상부터 프로젝트에 포함시키자

프로젝트 명은 HarryPotterNewsPaper로 했고, SceneKit를 선택해줬다.
<img width="1398" alt="스크린샷 2024-02-24 오전 10 27 43" src="https://github.com/jinyongyun/SpriteKit_HarryPotterNewsPaper_APP/assets/102133961/10b76476-89f0-4bc9-9161-cbf767ffe147">


동영상 넣을 때 꼭 **Add to targets** 선택하기!

뚱이 만들 때 처럼, Assets > AR and Textures > new AR Resource Groups를 선택하고

만들어진 AR 리소스 폴더에 인식할 이미지를 넣어준다.

(여기까지 과정은 뚱이랑 똑같다)

저번에도 그랬듯이 사이즈를 정해주지 않으면 에러가 나기 때문에

사이즈를 꼭 정해준다! (너비나 높이 둘 중 하나만 정하면 자동으로 정해준다)
<img width="1126" alt="스크린샷 2024-02-24 오전 10 35 37" src="https://github.com/jinyongyun/SpriteKit_HarryPotterNewsPaper_APP/assets/102133961/cb0d1d02-ed3b-4ddf-8923-27e32ac8c493">


이러면 이제 리소스는 준비 끝!

이미지 인식을 위해 ARImageTrackingConfiguration을 설정해주자.

WorldTracking으로도 이미지 인식은 할 수 있다고 했다. 하지만 저녀석이 더 한 두개에 적합하다고 뚱이편에서 조사한 바 있다.

```swift
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
```

viewWillAppear에 configuration 관련 내용을 작성해줬다.

ARReferenceImage.referenceImages 메서드로 Bundle.main을 베이스로 해서 Assets에서 만들어줬던 AR 리소스 폴더 안에 이미지를 가져온다.

그리고 configuration의 trackingImages로 해당 이미지를 설정해, 인식할 수 있도록 해준다.

## SpriteKit

2D 화면에 비디오 재생을 하기 위해서 필요한 도구

바로 SpriteKit이다.

공식문서에서는 SpriteKit에 대해 다음과 같이 설명한다.

> SpriteKit is a general-purpose framework for drawing shapes, particles, text, images, and video in two dimensions. It leverages Metal to achieve high-performance rendering, while offering a simple programming interface to make it easy to create games and other graphics-intensive apps. Using a rich set of animations and physics behaviors, you can quickly add life to your visual elements and gracefully transition between screens.
> 

> (한국어)
> 
> 
> SpriteKit은 모양, 입자, 텍스트, 이미지 및 **비디오를** 2차원으로 그리기 위한 범용 프레임워크입니다. Metal을 활용하여 고성능 렌더링을 달성하는 동시에 간단한 프로그래밍 인터페이스를 제공하여 게임 및 기타 그래픽 집약적인 앱을 쉽게 만들 수 있습니다. 다양한 애니메이션 및 물리 동작을 사용하여 시각적 요소에 신속하게 생명력을 더하고 화면 간을 우아하게 전환할 수 있습니다.
> 

`[class SKScene](https://developer.apple.com/documentation/spritekit/skscene)`

모든 활성 SpriteKit 콘텐츠를 구성하는 객체입니다.

`class SKScene : [SKEffectNode](https://developer.apple.com/documentation/spritekit/skeffectnode)`

## **[Overview](https://developer.apple.com/documentation/spritekit/skscene#overview)**

An `SKScene` object represents a scene of content in SpriteKit. A scene is the root node in a tree of SpriteKit nodes (SKNode). These nodes provide content that the scene animates and renders for display. To display a scene, you present it from an SKView, SKRenderer, or WKInterfaceSKScene.

`SKScene` is a subclass of SKEffectNode and enables certain effects to apply to the entire scene. Though applying effects to an entire scene can be an expensive operation, creativity, and ingenuity may help you find some interesting ways to use effects.

# **SKVideoNode**

A graphical element that plays video content.

iOS 7.0+iPadOS 7.0+macOS 10.9+Mac Catalyst 13.0+tvOS 9.0+watchOS 3.2+visionOS 1.0+

class SKVideoNode : SKNode

## **[Overview](https://developer.apple.com/documentation/spritekit/skvideonode#overview)**

This class renders a video at a given size and location in your scene with no exposed player controls.

일단 구성을 어떻게 할거냐면

```swift
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
```

다음과 같이 일반 노드를 하나 만든 다음

renderer 메서드에서 우리 스네이프 이미지의 anchor를 인식하면 이를 가져와서

addVideo 메서드로 우리가 넣어준 HarryPotter.mp4의 SKScene 객체를 받고

인식한 이미지에 planeNode를 올릴건데, 이 planeNode의 컨텐츠를 addVideo에서의 SKScene 객체를 넣어줘야 한다. 

이제 구조를 대충 만들었으니, 실제로 addVideo()와 addPlane(on: addVideo:) 메서드를 만들어보자!

```swift
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
        // ***addPlane 메서드에서 plane노드의 material의 diffuse.contents를 SKScene로 바꿔줘야 한다.(일종의 확산을 통해 입혀주는 거라고 제일 처음에 배웠죠?!)***
        videoScene.addChild(videoNode)
        
        return videoScene
    }
```

## contents는 뭐하는 녀석일까

공식문서에서는 다음과 같이 설명한다.

> The visual contents of the material property—a color, image, or source of animated content. Animatable.
> 

즉 애니메이션 시킬 수 있는 이미지나 색상이나 그런 자원의 visual content를 나타내는 인스턴스 속성 즉 객체이다.

뭐를 지정할 수 있냐면 우리가 이번에 넣을 

• SpriteKit 장면

은 물론이고

- 재료 표면의 균일한 색상을 지정하는 색상( NSColor/ UIColor / CGColor )
- [NSNumber](https://developer.apple.com/documentation/foundation/nsnumber)재료 표면의 균일한 스칼라 값을 지정하는 숫자( )(예: 물리적 기반 특성에 유용함 [metalness](https://developer.apple.com/documentation/scenekit/scnmaterial/1640554-metalness))
- 재료 표면 전체에 매핑될 텍스처를 지정하는 이미지( [NSImage](https://developer.apple.com/documentation/appkit/nsimage)/ [UIImage](https://developer.apple.com/documentation/uikit/uiimage)또는 )[CGImage](https://developer.apple.com/documentation/coregraphics/cgimage)
- 이미지 파일의 위치를 지정하는 [NSString](https://developer.apple.com/documentation/foundation/nsstring)또는 객체[NSURL](https://developer.apple.com/documentation/foundation/nsurl)
- 비디오 플레이어( [AVPlayer](https://developer.apple.com/documentation/avfoundation/avplayer)) 또는 실시간 비디오 캡처 미리보기(iOS에서만 해당) [AVCaptureDevice](https://developer.apple.com/documentation/avfoundation/avcapturedevice)
- 핵심 애니메이션 레이어( [CALayer](https://developer.apple.com/documentation/quartzcore/calayer))
- 텍스처( [SKTexture](https://developer.apple.com/documentation/spritekit/sktexture), [MDLTexture](https://developer.apple.com/documentation/modelio/mdltexture), [MTLTexture](https://developer.apple.com/documentation/metal/mtltexture)또는 )[GLKTextureInfo](https://developer.apple.com/documentation/glkit/glktextureinfo)
- 큐브 맵의 면을 지정하는 특별히 형식화된 이미지 또는 6개 이미지의 배열

을 넣을 수 있다.

이제 addPlane 메서드를 작성해서 컨텐츠가 위에서 만든 SKScene을 갖는 planeNode를 리턴하도록 만들어보자.

```swift
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
```

## 실제 구동 화면

- 해리포터 앱을 켜면!
  


https://github.com/jinyongyun/SpriteKit_HarryPotterNewsPaper_APP/assets/102133961/5e65916b-d981-4cad-9443-89a2fe39336b




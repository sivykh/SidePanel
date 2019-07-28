import XCTest
import class UIKit.UIViewController
@testable import SidePanelController

class Tests: XCTestCase {
    private var sp: SPViewControllerType!
    
    override func setUp() {
        super.setUp()
        let spViewController = SPViewController()
        _ = spViewController.view
        self.sp = spViewController
    }
    
    override func tearDown() {
        sp = nil
        super.tearDown()
    }
    
    func testGestures() {
        XCTAssertNotNil(sp.leftEdgeGesture, "leftEdgeGesture is not created")
        XCTAssertTrue(sp.leftEdgeGesture.edges == .left, "leftEdgeGesture doesn't handle left edge")
        XCTAssertNotNil(sp.rightEdgeGesture, "rightEdgeGesture is not created")
        XCTAssertTrue(sp.rightEdgeGesture.edges == .right, "rightEdgeGesture doesn't handle right edge")
        XCTAssertNotNil(sp.panGesture, "panGesture is not created")
        
        XCTAssertFalse(sp.leftEdgeGesture!.isEnabled, "there is no left controller, gesture should be disabled")
        XCTAssertFalse(sp.rightEdgeGesture!.isEnabled, "there is no right controller, gesture should be disabled")
        XCTAssertFalse(sp.panGesture!.isEnabled, "there is no controllers, gesture should be disabled")
        
        sp.leftViewController = .init()
        XCTAssertTrue(sp.leftEdgeGesture!.isEnabled, "there is a left controller, gesture should be enabled")
        
        sp.rightViewController = .init()
        XCTAssertTrue(sp.rightEdgeGesture!.isEnabled, "there is a right controller, gesture should be enabled")
        
        XCTAssertTrue(sp.leftAppearanceRule == .above, "Left appearance is not above by default")
        XCTAssertTrue(sp.rightAppearanceRule == .above, "Right appearance is not above by default")
        
        sp.centerViewController = .init()
        XCTAssertFalse(sp.panGesture!.isEnabled,
                       "there is a center controller but appearance is above, gesture should be disabled")
        sp.setAppearance(.under)
        XCTAssertTrue(sp.panGesture!.isEnabled,
                      "There are all controllers and the appearance is under, gesture should be enabled")
    }
    
    func testToggleLeft() {
        sp.centerViewController = .init()
        
        sp.toggleLeft(animated: false)
        XCTAssertFalse(sp.presentedContent == .left,
                       "There is no left controller, side panel can't present left")
        
        sp.leftViewController = .init()
        sp.toggleLeft(animated: false)
        XCTAssertTrue(sp.presentedContent == .left, "Side panel does not present left content")
        
        sp.toggleLeft()
        XCTAssertTrue(sp.presentedContent == .center, "Side panel does not present center content")
    }
    
    func testToggleRight() {
        sp.centerViewController = .init()
        
        sp.toggleRight(animated: false)
        XCTAssertFalse(sp.presentedContent == .right,
                       "There is no right controller, side panel can't present right")
        
        sp.rightViewController = .init()
        sp.toggleRight(animated: false)
        XCTAssertTrue(sp.presentedContent == .right, "Side panel does not present right content")
        
        sp.toggleRight()
        XCTAssertTrue(sp.presentedContent == .center, "Side panel does not present center content")
    }
    
    func testPresent() {
        sp.centerViewController = .init()
        sp.leftViewController = .init()
        sp.rightViewController = .init()
        
        sp.present(content: .left, animated: false)
        XCTAssertTrue(sp.presentedContent == .left, "Side panel should present left")
        
        sp.present(content: .right, animated: false)
        XCTAssertTrue(sp.presentedContent == .right, "Side panel should present right")
        
        sp.present(content: .right, animated: false)
        XCTAssertTrue(sp.presentedContent != .left, "Side panel shouldn't present left")
        XCTAssertTrue(sp.presentedContent != .center, "Side panel shouldn't present center")
        
        sp.present(content: .center)
        XCTAssertTrue(sp.presentedContent == .center, "Side panel should present center")
    }
    
    func testOverlayDisabling() {
        guard let button = (sp as? SPViewController)?.overlayButton else {
            XCTAssertTrue(false, "Can't cast to SPViewController")
            return
        }
        XCTAssertTrue(button.isEnabled, "Overlay button should be enabled by default")
        sp.setOverlayButton(enabled: false)
        XCTAssertFalse(button.isEnabled, "Overlay button should be disabled after such call")
    }
    
    func testRuntimeTypeProperty() {
        let center1 = UIViewController()
        let center2 = UIViewController()
        sp.centerViewController = center1
        
        XCTAssertNotNil(center1.sidePanelController, "ViewController hasn't side panel")
        XCTAssertNil(center2.sidePanelController, "ViewController does have side panel unexpectedly")
        
        sp.centerViewController = center2
        
        XCTAssertNotNil(center2.sidePanelController, "ViewController hasn't side panel")
        XCTAssertNil(center1.sidePanelController, "ViewController does have side panel unexpectedly")
    }
    
}

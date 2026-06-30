import UIKit
import Flutter

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  private lazy var flutterEngine: FlutterEngine = {
    let engine = FlutterEngine(name: "main_engine")
    engine.run()
    GeneratedPluginRegistrant.register(with: engine)
    return engine
  }()

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    let window = UIWindow(windowScene: windowScene)
    let controller = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
    window.rootViewController = controller
    self.window = window
    window.makeKeyAndVisible()
  }

  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that it will not need when it resumes.
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }

  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Save changes only if appropriate to do so, as the app may terminate in the background.
  }
}

# Memo


<details>
<summary>1. 최초 팝업 화면</summary>
`FirstLaunchHelper.swift`

```swift
import Foundation

class FirstLaunch {
    let wasLaunchedBefore: Bool
    var isFirstLaunch: Bool {
        return !wasLaunchedBefore
    }
    
    init(source: FirstLaunchDataSource) {
        let wasLaunchedBefore = source.getWasLaunchedBefore()
        self.wasLaunchedBefore = wasLaunchedBefore
        if !wasLaunchedBefore {
            source.setWasLaunchedBefore(true)
        }
    }
}

extension FirstLaunch {
    static func alwaysFirst() -> FirstLaunch {
        let source = AlwaysFirstLaunchDataSource()
        let firstLaunch = FirstLaunch(source: source)
        return firstLaunch
    } }

protocol FirstLaunchDataSource {
    func getWasLaunchedBefore() -> Bool
    func setWasLaunchedBefore(_ wasLaunchedBefore: Bool)
    
}

struct AlwaysFirstLaunchDataSource : FirstLaunchDataSource {
    func getWasLaunchedBefore() -> Bool { return false }
    func setWasLaunchedBefore(_ wasLaunchedBefore: Bool) {
        // do nothing
    }
}

struct UserDefaultsFirstLaunchDataSource : FirstLaunchDataSource {
    let defaults: UserDefaults
    let key: String
    func getWasLaunchedBefore() -> Bool {
        return defaults.bool(forKey: key)
    }
    func setWasLaunchedBefore(_ wasLaunchedBefore: Bool) {
        defaults.set(wasLaunchedBefore, forKey: key)
    }
}
```



`AppDelegate` - ` func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool`

```swift
#if DEBUG
  self.firstLaunch = FirstLaunch.alwaysFirst()
#else
  let source = UserDefaultsFirstLaunchDataSource(defaults: .standard, key: "com.arie.Memo")
  self.firstLaunch = FirstLaunch(source: source)
#endif
```



```swift
func showFirstInfoVC() {
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  if appDelegate.firstLaunch?.isFirstLaunch == true {
    print("first launch")
    let vc = FirstInfoViewController.instantiate()
    self.present(vc, animated: true, completion: nil)
  } else {
    print("not first")
  }
}
```

</details>




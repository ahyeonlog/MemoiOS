# Memo

|  iPhone 13 Pro MAX    | iPhone 8 |
| ---- | ---- |
|  ![화면-기록-2021-11-12-오후-5.31.40](README.assets/화면-기록-2021-11-12-오후-5.31.40.gif)    |      |






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


<details>
<summary>2. 수정화면</summary>


- swipe, back, 완료 시 메모 저장

1. 처음엔 swipe gesture를 커스텀해서 메모를 저장하는 방식으로 접근
```swift
override func viewDidLoad() {	            
 self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
  let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
  edgePan.edges = .left
  view.addGestureRecognizer(edgePan)
}
@objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
  if recognizer.state == .recognized {
    saveMemo()
  }
}

```

2. `isMovingFromParent` `didMove`

   좀 더 찾아보니 이런 프로퍼티와 함수가 있었다고 한다. 그런데 이게 기획 의도에 맞는 구현인지 헷갈립니다..

```swift
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if isMovingFromParent {
            saveMemo()
        }
    }
    override func didMove(toParent parent: UIViewController?) {
        print(#function, parent) // pop할시 parent가 nil
    }
```



- 첫 줄 제목

처음에는 두 개의 UITextView를 스크롤뷰에 넣어서 title과 content를 분리하려 했었다. 엔터를 치면 다음 textView로 responder를 옮기는 방식으로...

삽질하다가 알게된 스크롤뷰의 상식

```swift
Content Layout Guide: ScrollView가 보여질 영역
Frame Layout Guide: 스크롤뷰의 Frame에 해당하는 영역, 즉 스마트폰 화면에서 ScrollView가 보여질 영역
```
하지만 하나의 텍스트뷰로도 가능할 것 같아서 변경

```swift
guard let text = textView.text else {
    return
}
if text.isEmpty {
    if let memo = memo {
        try! realm.write {
            realm.delete(memo)
        }
    }
    self.navigationController?.popViewController(animated: true)
    return
}

var title = ""
var content = ""

if let firstLineEndIndex = text.firstIndex(of: "\n") {
    title = String(text[...firstLineEndIndex])
    content = String(text[text.index(after: firstLineEndIndex)...])
} else {
    title = text
}
```

</details>


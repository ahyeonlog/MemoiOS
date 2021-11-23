# Memo

|  iPhone 13 Pro MAX    | iPhone 8 |
| ---- | ---- |
|  ![화면-기록-2021-11-12-오후-5.31.40](README.assets/화면-기록-2021-11-12-오후-5.31.40.gif)    |   ![화면-기록-2021-11-12-오후-5.43.35](README.assets/화면-기록-2021-11-12-오후-5.43.35.gif)   |






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

<details>
<summary>+수정 (21.11.15)</summary>

팀원들과 프로젝트 회고를 하면서 내가 놓친 부분이 많다는걸 깨닫고 재빠르게(이미 늦었나요...? 늦었다고 생각할때가 제일 빠르다..) 수정

- 사용자가 공백 또는 줄바꿈을 입력할 수도 있다.
  - `trimmingCharacters(in: .whitespacesAndNewlines)` : 문자열의 앞 뒤 공백과 줄바꿈을 제거해줌

```swift
guard let text = textView.text else {
    return
}

if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
    if let memo = memo {
        try! realm.write {
            realm.delete(memo)
        }
    }
    self.navigationController?.popViewController(animated: true)
    return

}
        
```

- 키보드가 텍스트뷰를 가린다!

```swift
@IBOutlet weak var textViewBottonConstraints: NSLayoutConstraint!

override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // keyboard
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    
}

override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    // keyboard
    NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
    NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)

}

@objc private func keyboardWillAppear(notification: NSNotification) {
    if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
        let keyboardHeight = keyboardFrame.cgRectValue.height
        textViewBottonConstraints.constant -= (keyboardHeight - self.view.safeAreaInsets.bottom)
        
        // 애니메이션 효과를 키보드 애니메이션 시간과 동일하게
        guard let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}

@objc private func keyboardWillDisappear(notification: NSNotification) {
    // 애니메이션 효과를 키보드 애니메이션 시간과 동일하게
    let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
    self.textViewBottonConstraints.constant = 0

    UIView.animate(withDuration: animationDuration) {
        self.view.layoutIfNeeded()
    }
}

```
</details>

<details>
<summary>+feedback 정리</summary>

- 아이폰/아이패드 대응 상태 확인!
  - 아이패드가 자동으로 체크되어 있는데 아이패드 대응이 되어 있지 않다면 대부분 100% 리젝된다.
- 앱 Display name을 잊는다면 Xcode Product Name이 앱의 이름이 된다.
- 뷰컨트롤러가 여러 씬에서 사용된다면 열거형을 활용해서 명확성을 부여해주기!
- Realm Query 분리
- 메서드명에 `get` 쓰지않기!
- Bool 값인걸 굳이 `OOO == true` 로 비교하지말자!
- `protocol StoryboardInitializable: AnyObject` 
  - 해당 프로토콜이 Class에서만 동작하게 구현하고싶다면 AnyObject를 상속해보자



[스위프트 이름 짓기 참고](https://soojin.ro/blog/english-for-developers-swift)

- 나중에 봐야지 [Naver Engineering TV - 영어 변수명을 잘 지어보자](https://tv.naver.com/v/4980432/list/267189)  

스위프트의 getter  

스위프트에서 어떤 인스턴스를 리턴하는 함수나 메서드에 `get`을 쓰지 않는다. `get` 없이 바로 타입 이름(명사)으로 시작하면 된다.

```swift
func date(from string: String) -> Date?
func anchor(for node: SCNNode) -> ARAnchor?                          
func distance(from location: CLLocation) -> CLLocationDistance        
func track(withTrackID trackID: CMPersistentTrackID) -> AVAssetTrack? 
```

- 결과를 바로 리턴하는 `fetch` :공을 무조건 물어오는 강아지🐶
- 유저에게 요청하거나 작업이 실패할 수 있을 때 `request`



</details>




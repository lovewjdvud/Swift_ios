//
//  SignInViewController.swift
//  Schrodinger
//
//  Created by ido on 2021/07/29.
//

import UIKit

import KakaoSDKAuth // MARK: Kakao Login - 토큰 존재 여부 확인
import KakaoSDKUser // MARK: Kakao Login - 로그인 실행, 토큰 가져오기, 사용자 정보 관리, 사용자 정보 가져오기
import KakaoSDKCommon // MARK: Kakao Login - 토큰 존재 여부 확인 시 Error 처리

import Firebase // MARK: Google Login - Firebase 초기화
import GoogleSignIn // MARK: Google Login - 로그인 버튼, 로그인 실행 

let myUserDefaults = UserDefaults.standard // MARK: Email(id) UserDefault 선언
let usernoUserDefaults = UserDefaults.standard // MARK: User Number(userno) UserDefault 선언

var currentUserEmail = "방문자"

class SignInViewController: UIViewController {
    
    //    let myUserDefaults = UserDefaults.standard
   
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    @IBOutlet weak var privacyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        privacyLabel.text = "By continuing, you agree to Schrödingers’s Terms of Service and Privacy Policy."
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // MARK: Email UserDefault를 Label에 띄우기
        //        infoLabel.text = Share.userID
        //infoLabel.text = myUserDefaults.string(forKey: "userEmail")
        //        infoLabel.text = UserDefaults.standard.string(forKey: "userEmail")
        
        
        // MARK: Kakao Login - Email 필수동의 Alert 띄우기
        if myUserDefaults.string(forKey: "userEmail") == "방문자" {
            
            //infoLabel.text = myUserDefaults.string(forKey: "userEmail")
            let idAlert = UIAlertController(title: "주의", message: "카카오 로그인은 이메일 제공 동의 필수", preferredStyle: .alert)
            let idAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
            idAlert.addAction(idAction)
            present(idAlert, animated: true, completion: nil)
            
        }else{
            
            // MARK: Kakao Login - 토큰 존재 여부 확인
            // MARK: Kakao Login - Login email 확인
            //            if (AuthApi.hasToken() && myUserDefaults.string(forKey: "userEmail") != "방문자") {
            //                UserApi.shared.accessTokenInfo { (_, error) in
            //                    if let error = error {
            //                        if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
            //                            //로그인 필요
            //                        }
            //                        else {
            //                            //기타 에러
            //                        }
            //                    }
            //                    else {
            //                        //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
            //                        // MARK: Kakao Login - 자동 로그인
            //                        let storyboard = UIStoryboard(name: "JyKim", bundle: nil)
            //                        let destinationVC = storyboard.instantiateViewController(withIdentifier: "MyPageViewController") as! MyPageViewController
            //                        self.present(destinationVC, animated: true, completion: nil)
            //                    }
            //                }
            //            }
            //            else {
            //                //로그인 필요
            //            }
            guard let userDefault = myUserDefaults.string(forKey: "userEmail") else {
                print("Email =\(String(describing: myUserDefaults.string(forKey: "userEmail")))")
                return
            }
            print("UserDefault: \(userDefault)")
            performSegue(withIdentifier: "loginSegue", sender: self)
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let destinationVC = storyboard.instantiateViewController(withIdentifier: "MyPageViewController") as! MyPageViewController
//            self.present(destinationVC, animated: true, completion: nil)
//            if myUserDefaults.string(forKey: "userEmail") != "방문자" {
//                // MARK: Kakao Login - 자동 로그인
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let destinationVC = storyboard.instantiateViewController(withIdentifier: "MyPageViewController") as! MyPageViewController
//                print(myUserDefaults.string(forKey: "userEmail") ?? "nil")
//                self.present(destinationVC, animated: true, completion: nil)
//            }
            
            
        }
        
    }
    
    // MARK: Kakao Login - 카카오 로그인 버튼에 대한 로직 추가
    @IBAction func onKakaoLoginByAppTouched(_ sender: Any) {
        // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오톡 로그인. api 호출 결과를 클로저로 전달.
            // MARK: Kakao Login - 카카오톡 앱으로 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    // 예외 처리 (로그인 취소 등)
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    // do something
                    _ = oauthToken
                    // 어세스토큰
                    //                    let accessToken = oauthToken?.accessToken
                    //카카오 로그인을 통해 사용자 토큰을 발급 받은 후 사용자 관리 API 호출
                    self.setUserInfo()
                    // MARK: Kakao Login 성공 후 마이페이지 띄우기
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let destinationVC = storyboard.instantiateViewController(withIdentifier: "MyPageViewController") as! MyPageViewController
                    self.present(destinationVC, animated: true, completion: nil)
                }
                
            }
            
        }else{
            // MARK: Kakao Login - 웹으로 로그인
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    //do something
                    _ = oauthToken
                    //카카오 로그인을 통해 사용자 토큰을 발급 받은 후 사용자 관리 API 호출
                    self.setUserInfo()
                    // MARK: Kakao Login - 로그인 성공 후 마이페이지 띄우기
                    let storyboard = UIStoryboard(name: "JyKim", bundle: nil)
                    let destinationVC = storyboard.instantiateViewController(withIdentifier: "MyPageViewController") as! MyPageViewController
                    self.present(destinationVC, animated: true, completion: nil)
                    
                    
                }
                
            }
            
        }
        
        
    }
    
    // MARK: Kakao Login - 사용자 정보 가져오기
    func setUserInfo() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                //do something
                _ = user
                //                self.infoLabel.text = user?.kakaoAccount?.profile?.nickname
                
                // MARK: Kakao Login - user email 받아 UserDefault에 등록
                //                myUserDefaults.set(user?.kakaoAccount?.email, forKey: "userEmail")
                if user?.kakaoAccount?.email != nil {
                    myUserDefaults.set(user?.kakaoAccount?.email, forKey: "userEmail")
                }else{
                    myUserDefaults.set("방문자", forKey: "userEmail")
                }
                //                if user?.kakaoAccount?.email != nil {
                //                    Share.userID = (user?.kakaoAccount?.email)!
                //                }else{
                //                    Share.userID = "방문자"
                //                }
                
                //                self.infoLabel.text = Share.userID
                // MARK: Email UserDefault를 Label에 띄우기
                //self.infoLabel.text = myUserDefaults.string(forKey: "userEmail")
                
                //                if let url = user?.kakaoAccount?.profile?.profileImageUrl,
                //                    let data = try? Data(contentsOf: url) {
                //                    self.profileImageView.image = UIImage(data: data)
                //                }
                
                
            }
        }
        
    }
    
    
    // MARK: Google Login - 구글 로그인 버튼(View)에 대한 로직 추가
    @IBAction func btnGoogleGIDSignIn(_ sender: GIDSignInButton) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            
            if let error = error {
                // ...
                print("Google Login error = \(error)")
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            // ...
            
            print("clientID = \(clientID)")
            print("config = \(config)")
            print("authentication = \(authentication)")
            print("idToken = \(idToken)")
            print("credential = \(credential)")
            
            
            // MARK: Google Login - Firebase에 인증, 이전 단계에서 만든 인증 사용자 인증 정보를 사용하여 Firebase 로그인 프로세스를 완료
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    let authError = error as NSError
                    if authError.code == AuthErrorCode.secondFactorRequired.rawValue {  // MARK: if isMFAEnabled, - error
                        // The user is a multi-factor user. Second factor challenge is required.
                        let resolver = authError
                            .userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
                        var displayNameString = ""
                        for tmpFactorInfo in resolver.hints {
                            displayNameString += tmpFactorInfo.displayName ?? ""
                            displayNameString += " "
                        }
                        self.showTextInputPrompt(
                            withMessage: "Select factor to sign in\n\(displayNameString)",
                            completionBlock: { userPressedOK, displayName in
                                var selectedHint: PhoneMultiFactorInfo?
                                for tmpFactorInfo in resolver.hints {
                                    if displayName == tmpFactorInfo.displayName {
                                        selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
                                    }
                                }
                                PhoneAuthProvider.provider()
                                    .verifyPhoneNumber(with: selectedHint!, uiDelegate: nil,
                                                       multiFactorSession: resolver
                                                        .session) { verificationID, error in
                                        if error != nil {
                                            print(
                                                "Multi factor start sign in failed. Error: \(error.debugDescription)"
                                            )
                                        } else {
                                            self.showTextInputPrompt(
                                                withMessage: "Verification code for \(selectedHint?.displayName ?? "")",
                                                completionBlock: { userPressedOK, verificationCode in
                                                    let credential: PhoneAuthCredential? = PhoneAuthProvider.provider()
                                                        .credential(withVerificationID: verificationID!,
                                                                    verificationCode: verificationCode!)
                                                    let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator
                                                        .assertion(with: credential!)
                                                    resolver.resolveSignIn(with: assertion!) { authResult, error in
                                                        if error != nil {
                                                            print(
                                                                "Multi factor finanlize sign in failed. Error: \(error.debugDescription)"
                                                            )
                                                        } else {
                                                            self.navigationController?.popViewController(animated: true)
                                                        }
                                                    }
                                                }
                                            )
                                        }
                                    }
                            }
                        )
                    } else {
                        self.showMessagePrompt(error.localizedDescription)
                        return
                    }
                    // ...
                    return
                }
                // User is signed in
                // ...
                
                // MARK: Google Login - 사용자 프로필 가져오기
                let user = Auth.auth().currentUser
                if let user = user {
                    // The user's ID, unique to the Firebase project.
                    // Do NOT use this value to authenticate with your backend server,
                    // if you have one. Use getTokenWithCompletion:completion: instead.
                    let uid = user.uid
                    let email = user.email
                    let photoURL = user.photoURL
                    
                    
                    
                    var multiFactorString = "MultiFactor: "
                    for info in user.multiFactor.enrolledFactors {
                        multiFactorString += info.displayName ?? "[DispayName]"
                        multiFactorString += " "
                    }
                    // ...
                    print("uid = \(uid)")
                    print("email = \(String(describing: email))")
                    print("photoURL = \(String(describing: photoURL))")
                    
                    // MARK: Google Login - user email 받아 UserDefault에 등록
//                    if email != nil {
//                        currentUserEmail = email!
//                    }else{
//                        //currentUserEmail = "방문자"
//                    }
                    
                    guard let email = email else {
                        return
                    }
                    myUserDefaults.set(email, forKey: "userEmail")
                    
                    performSegue(withIdentifier: "loginSegue", sender: self)
                    
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let destinationVC = storyboard.instantiateViewController(withIdentifier: "MyPageViewController") as! MyPageViewController
//                    self.present(destinationVC, animated: true, completion: nil)
                }
                
                // MARK: Google Login - user email 받아 UserDefault에 등록
//                myUserDefaults.set(currentUserEmail, forKey: "userEmail")
//                print("currentUserEmail = \(myUserDefaults.string(forKey: "userEmail"))")
                
                
                // MARK: Email UserDefault를 Label에 띄우기
                //self.infoLabel.text = myUserDefaults.string(forKey: "userEmail")
                
                // MARK: Google Login - 로그인 성공 후 마이페이지 띄우기
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let destinationVC = storyboard.instantiateViewController(withIdentifier: "MyPageViewController") as! MyPageViewController
//                self.present(destinationVC, animated: true, completion: nil)
                
            }
            
            //            // MARK: Google Login - user email 받아 UserDefault에 등록
            //            myUserDefaults.set(currentUserEmail, forKey: "userEmail")
            //            print("currentUserEmail = \(myUserDefaults.string(forKey: "userEmail"))")
            //
            //
            //            // MARK: Email UserDefault를 Label에 띄우기
            //            self.infoLabel.text = myUserDefaults.string(forKey: "userEmail")
            //
            //            // MARK: Google Login - 로그인 성공 후 마이페이지 띄우기
            //            let storyboard = UIStoryboard(name: "JyKim", bundle: nil)
            //            let destinationVC = storyboard.instantiateViewController(withIdentifier: "MyPageViewController") as! MyPageViewController
            //            self.present(destinationVC, animated: true, completion: nil)
            
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.userEmailInsert(myUserDefaults.string(forKey: "userEmail")!)
        
        // MARK: userNumberQuery 실행
        self.userNumberQuery()
        Util.shared.id = usernoUserDefaults.string(forKey: "userno") ?? "0"
        print("id is \(Util.shared.id)")
    }
    
    // MARK: Google Login - Firebase에 인증 시 사용
    func showTextInputPrompt(withMessage message: String,
                             completionBlock: @escaping ((Bool, String?) -> Void)) {
        let prompt = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completionBlock(false, nil)
        }
        weak var weakPrompt = prompt
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            guard let text = weakPrompt?.textFields?.first?.text else { return }
            completionBlock(true, text)
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(cancelAction)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil)
    }
    
    // MARK: Google Login - Firebase에 인증 시 사용
    func showMessagePrompt(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
    }
    
    
    // MARK: 로그인 공통 - user email 받아 DB에 입력
    func userEmailInsert(_ id: String) {
        print("id to insert in userEmailInsert func = \(id)")
        if myUserDefaults.string(forKey: "userEmail") != "방문자" {
//            let id = myUserDefaults.string(forKey: "userEmail")
            
            let userInsertModel = UserInsertModel()
            let result = userInsertModel.insertItems(id: id)
            
            if result{
                print("입력 완료 - email : \(String(describing: myUserDefaults.string(forKey: "userEmail")))")
    //            let resultAlert = UIAlertController(title: "완료", message: "입력이 되었습니다!", preferredStyle: .alert)
    //            let onAction = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
    //                self.navigationController?.popViewController(animated: true)
    //            })
    //
    //            resultAlert.addAction(onAction)
    //            present(resultAlert, animated: true, completion: nil)
                
            }else{
                print("에러 발생 - email : \(String(describing: myUserDefaults.string(forKey: "userEmail")))")
    //            let resultAlert = UIAlertController(title: "실패", message: "에러가 발생 되었습니다!", preferredStyle: .alert)
    //            let onAction = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
    //                self.navigationController?.popViewController(animated: true)
    //            })
    //
    //            resultAlert.addAction(onAction)
    //            present(resultAlert, animated: true, completion: nil)
            }
            
        } else{
            return
        }

    }
    
    // MARK: 로그인 공통 - user email(id) 이용해 DB에서 user number(userno) 가져와 user default에 등록
    func userNumberQuery() {
        print("id to download userno in userNumberQuery func = \(String(describing: myUserDefaults.string(forKey: "userEmail")))")
        let queryModel = UserQueryModel()
        queryModel.downloadItems(id: myUserDefaults.string(forKey: "userEmail")!)
        
    }

    
    
}




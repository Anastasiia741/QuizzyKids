//  AuthentificationViewModel.swift
//  Quizzy Kids

import Foundation
import Firebase
import FirebaseAuth
import AuthenticationServices
import GoogleSignIn
import CryptoKit
internal import Combine

enum AuthentificationFlow {
    case login, signUp
}

enum AuthenticationState {
    case unauthenticated, authenticating, authenticated
}

@MainActor
final class AuthentificationViewModel: NSObject, ObservableObject  {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var displayName: String = ""
    @Published var errorMessage: String = ""
    @Published var user: User?
    @Published var flow: AuthentificationFlow = .login
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var currentNonce: String? = nil
    
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    private let db = Firestore.firestore()
    
    @Published var nameHasError: Bool = false
    @Published var emailHasError: Bool = false
    @Published var passwordHasError: Bool = false
    
    private static let minPasswordLength = 6
    
    override init () {
        super.init()
        registerAuthStateHandler()
    }
    
    var isValid: Bool {
        let emailTrimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let nameTrimmed = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        let okEmail = !emailTrimmed.isEmpty && emailTrimmed.contains("@") && emailTrimmed.contains(".")
        let okPass = password.count >= Self.minPasswordLength
        switch flow {
        case .login:
            return okEmail && okPass
        case .signUp:
            return nameTrimmed.count >= 2 && okEmail && okPass
        }
    }
    
    func registerAuthStateHandler() {
        guard authStateHandle == nil else { return }
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }
            self.user = user
            self.authenticationState = (user == nil) ? .unauthenticated : .authenticated
        }
    }
    
    private func clearFieldHighlights() {
        nameHasError = false
        emailHasError = false
        passwordHasError = false
    }
}

extension AuthentificationViewModel {
    func singInWithEmail() async -> Bool {
        authenticationState = .authenticating
        errorMessage = ""
        
        flow = .login
        guard validateAndHighlight() else {
            authenticationState = .unauthenticated
            errorMessage = mapAuthError(AuthFlowError.checkHighlightedFields)
            return false
        }
        
        let emailTrimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        do {
            let res = try await Auth.auth().signIn(withEmail: emailTrimmed, password: password)
            user = res.user
            return true
        } catch {
            let ns = error as NSError
            if ns.domain == AuthErrorDomain, let code = AuthErrorCode(rawValue: ns.code) {
                switch code {
                case .wrongPassword:
                    passwordHasError = true
                case .invalidEmail, .userNotFound:
                    emailHasError = true
                default:
                    break
                }
            }
            
            errorMessage = mapAuthError(error)
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func singUpWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        errorMessage = ""
        
        flow = .signUp
        guard validateAndHighlight() else {
            authenticationState = .unauthenticated
            errorMessage = mapAuthError(AuthFlowError.checkHighlightedFields)
            return false
        }
        
        let emailTrimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let nameTrimmed  = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        do {
            let res = try await Auth.auth().createUser(withEmail: emailTrimmed, password: password)
            user = res.user
            
            let change = res.user.createProfileChangeRequest()
            change.displayName = nameTrimmed
            try await change.commitChanges()
            
            try await db.collection("users").document(res.user.uid).setData([
                "name": nameTrimmed,
                "displayName": nameTrimmed,
                "email": emailTrimmed.lowercased(),
                "bonuses": 100,
                "createdAt": FieldValue.serverTimestamp()
            ], merge: true)
            
            return true
        } catch {
            let ns = error as NSError
            if ns.domain == AuthErrorDomain, let code = AuthErrorCode(rawValue: ns.code) {
                switch code {
                case .emailAlreadyInUse, .invalidEmail: emailHasError = true
                case .weakPassword: passwordHasError = true
                default: break
                }
            }
            errorMessage = mapAuthError(error)
            authenticationState = .unauthenticated
            return false
        }
    }
    
    private func validateAndHighlight() -> Bool {
        clearFieldHighlights()
        
        let emailTrimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let nameTrimmed  = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var ok = true
        
        if flow == .signUp {
            if nameTrimmed.count < 2 {
                nameHasError = true
                ok = false
            }
        }
        
        if !(emailTrimmed.contains("@") && emailTrimmed.contains(".")) {
            emailHasError = true
            ok = false
        }
        
        if password.count < Self.minPasswordLength {
            passwordHasError = true
            ok = false
        }
        
        return ok
    }
    
    private func mapAuthError(_ error: Error) -> String {
        if let flowError = error as? AuthFlowError {
            return flowError.localizedDescription
        }
        
        let ns = error as NSError
        
        guard ns.domain == AuthErrorDomain,
              let code = AuthErrorCode(rawValue: ns.code) else {
            return "Something went wrong"
        }
        
        switch code {
        case .emailAlreadyInUse:
            return "Email already in use"
        case .invalidEmail:
            return "Invalid email"
        case .weakPassword:
            return "Password is too weak"
        case .wrongPassword:
            return "Wrong password"
        case .userNotFound:
            return "Account not found"
        case .networkError:
            return "No internet"
        case .operationNotAllowed:
            return "Email sign-in disabled"
        case .invalidCredential:
            return "Invalid credentials"
        case .tooManyRequests:
            return "Try later"
        default:
            return "Something went wrong"
        }
    }
    
    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            user = nil
            authenticationState = .unauthenticated
            email = ""
            password = ""
            displayName = ""
            errorMessage = ""
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func deleteAccount() async -> Bool {
        guard let user = Auth.auth().currentUser else {
            errorMessage = "No user session."
            return false
        }
        
        authenticationState = .authenticating
        errorMessage = ""
        
        let uid = user.uid
        let db = Firestore.firestore()
        
        do {
            try await db.collection("users").document(uid).delete()
            
            try await user.delete()
            
            self.user = nil
            self.authenticationState = .unauthenticated
            self.email = ""
            self.password = ""
            self.displayName = ""
            
            return true
        } catch {
            let ns = error as NSError
            if ns.domain == AuthErrorDomain,
               let code = AuthErrorCode(rawValue: ns.code),
               code == .requiresRecentLogin {
                errorMessage = "Please log in again to delete your account."
            } else {
                errorMessage = error.localizedDescription
            }
            
            authenticationState = .authenticated
            return false
        }
    }
}

extension AuthentificationViewModel {
    func signInWithGoogle() async -> Bool {
        errorMessage = ""
        
        do {
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                throw AuthFlowError.missingGoogleClientID
            }
            
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
            
            guard let rootVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                .windows.first(where: { $0.isKeyWindow })?.rootViewController else {
                throw AuthFlowError.noRootViewController
            }
            
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)
            let user = result.user
            
            guard let idToken = user.idToken?.tokenString else {
                throw AuthFlowError.missingGoogleIDToken
            }
            
            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            let authResult = try await Auth.auth().signIn(with: credential)
            try await ensureUserDocumentForSocialSignIn(user: authResult.user)
            await SettingsViewModel.shared.loadProfileIfNeeded(user: authResult.user)
            return true
            
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}


extension AuthentificationViewModel {
    func sendPasswordReset(email: String) async -> Bool {
        errorMessage = ""
        emailHasError = false
        
        do {
            let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else {
                emailHasError = true
                throw AuthFlowError.emptyEmail
            }
            
            let settings = ActionCodeSettings()
            settings.handleCodeInApp = false
            settings.url = URL(string: "https://quizzy-kids-2026.web.app/pw")
            
            try await Auth.auth().sendPasswordReset(withEmail: trimmed, actionCodeSettings: settings)
            return true
            
        } catch {
            emailHasError = true
            errorMessage = mapAuthError(error)
            return false
        }
    }
}

private extension UIWindowScene {
    var keyWindow: UIWindow? { windows.first(where: { $0.isKeyWindow }) }
}

extension AuthentificationViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func startAppleSignIn() async {
        errorMessage = ""
        
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            self.errorMessage = mapAuthError(AuthFlowError.appleSignInFailed)
            return
        }
        
        guard
            let nonce = currentNonce,
            let appleIDToken = appleIDCredential.identityToken,
            let idTokenString = String(data: appleIDToken, encoding: .utf8)
        else {
            self.errorMessage = mapAuthError(AuthFlowError.appleTokenMissing)
            return
        }
        
        let credential = OAuthProvider.appleCredential(
            withIDToken: idTokenString,
            rawNonce: nonce,
            fullName: appleIDCredential.fullName
        )
        
        Task { @MainActor in
            do {
                let authResult = try await Auth.auth().signIn(with: credential)
                let uid = authResult.user.uid
                
                let exists = try await self.userProfileExists(uid: uid)
                if !exists {
                    try await self.createUserProfileIfNeeded(
                        uid: uid,
                        authResult: authResult,
                        appleCredential: appleIDCredential
                    )
                }
                await SettingsViewModel.shared.loadProfileIfNeeded(user: authResult.user)
                
            } catch {
                self.errorMessage = mapAuthError(error)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let ns = error as NSError
        if ns.domain == ASAuthorizationError.errorDomain,
           ns.code == ASAuthorizationError.canceled.rawValue {
            return
        }
        
        if let asError = error as? ASAuthorizationError, asError.code == .canceled {
            return
        }
        
        self.errorMessage = mapAuthError(error)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        
        guard let scene = scenes.first(where: { $0.activationState == .foregroundActive }) ?? scenes.first else {
            fatalError("No UIWindowScene available for Apple Sign-In presentation.")
        }
        
        return scene.windows.first(where: { $0.isKeyWindow }) ?? UIWindow(windowScene: scene)
    }
    
    @MainActor
    private func userProfileExists(uid: String) async throws -> Bool {
        let snap = try await Firestore.firestore()
            .collection("users")
            .document(uid)
            .getDocument()
        return snap.exists
    }
    
    @MainActor
    private func createUserProfileIfNeeded(
        uid: String,
        authResult: AuthDataResult,
        appleCredential: ASAuthorizationAppleIDCredential
    ) async throws {
        let nameFromApple = [appleCredential.fullName?.givenName, appleCredential.fullName?.familyName]
            .compactMap { $0 }
            .joined(separator: " ")
        
        let displayName = !nameFromApple.isEmpty ? nameFromApple : (authResult.user.displayName ?? "")
        let email = authResult.user.email ?? appleCredential.email ?? ""
        
        try await Firestore.firestore()
            .collection("users")
            .document(uid)
            .setData([
                "name": displayName,
                "displayName": displayName,
                "email": email.lowercased(),
                "bonuses": 100,
                "createdAt": FieldValue.serverTimestamp()
            ], merge: true)
    }
    
    private func ensureUserDocumentForSocialSignIn(user: User) async throws {
        let ref = db.collection("users").document(user.uid)
        let snap = try await ref.getDocument()
        guard !snap.exists else { return }
        
        let name = user.displayName ?? ""
        let email = user.email ?? ""
        try await ref.setData([
            "name": name,
            "displayName": name,
            "email": email.lowercased(),
            "bonuses": 100,
            "createdAt": FieldValue.serverTimestamp()
        ], merge: true)
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remaining = length
        
        while remaining > 0 {
            var randoms = [UInt8](repeating: 0, count: 16)
            let status = SecRandomCopyBytes(kSecRandomDefault, randoms.count, &randoms)
            if status != errSecSuccess { fatalError("Unable to generate nonce.") }
            
            randoms.forEach { random in
                if remaining == 0 { return }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remaining -= 1
                }
            }
        }
        return result
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.map { String(format: "%02x", $0) }.joined()
    }
}

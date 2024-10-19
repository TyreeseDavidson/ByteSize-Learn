//
//  UserAuthModel.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import Amplify
import AuthenticationServices

class UserAuthModel: ObservableObject {

    @Published var givenName: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = ""

    func signIn() {
        Amplify.Auth.signInWithWebUI(for: .google, presentationAnchor: UIApplication.shared.windows.first!) { result in
            switch result {
            case .success(let signInResult):
                DispatchQueue.main.async {
                    self.isLoggedIn = signInResult.isSignedIn
                    self.fetchCurrentAuthUser()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Sign-in error: \(error.localizedDescription)"
                }
            }
        }
    }

    func fetchCurrentAuthUser() {
        if let user = Amplify.Auth.getCurrentUser() {
            self.givenName = user.username
        } else {
            self.givenName = "Not Logged In"
        }
    }

    func signOut() {
        Amplify.Auth.signOut { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.isLoggedIn = false
                    self.givenName = "Not Logged In"
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Sign-out error: \(error.localizedDescription)"
                }
            }
        }
    }
}

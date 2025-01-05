//
//  AuthenticationView.swift
//  Maia
//
//  Created by José Ruiz on 7/6/24.
//

import SwiftUI

struct AuthenticationView: View {
    @StateObject private var authenticationViewModel: AuthenticationViewModel
    @Environment(\.colorScheme) var colorScheme
    
    // Local state for user inputs
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        ZStack {
            VStack(spacing: 25) {
                // App title
                Text("Maia")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()

                Spacer()

                // Sign-in Title and Body Text
                VStack(alignment: .leading, spacing: 10) {
                    Text("Welcome Back")
                        .font(.system(size: 36))
                        .fontWeight(.heavy)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    Text("Sign in to continue to Maia")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }

                Spacer()

                // Input Fields
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled(true)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(colorScheme == .dark ? .white : .black, lineWidth: 1)
                        )
                        .padding(.horizontal)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(colorScheme == .dark ? .white : .black, lineWidth: 1)
                        )
                        .padding(.horizontal)
                }

                // Sign-in Button
                Button(action: signIn) {
                    Text("Sign In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.top, 20)

                Spacer()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Authentication"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    // Initialize ViewModel
    init() {
        _authenticationViewModel = StateObject(wrappedValue: AuthenticationViewModel())
    }

    // Sign-in Logic
    private func signIn() {
        if email.isEmpty || password.isEmpty {
            alertMessage = "Please enter both email and password."
            showAlert = true
            return
        }

        // Replace with actual authentication logic
        authenticationViewModel.signIn(email: email, password: password) { success, error in
            if success {
                alertMessage = "Sign-in successful!"
            } else {
                alertMessage = error ?? "Something went wrong. Please try again."
            }
            showAlert = true
        }
    }
}


struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}

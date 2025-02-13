//
//  ContentView.swift
//  IHC
//
//  Created by Marcelo De Araújo on 13/02/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var path = NavigationPath()
    @State private var password: String = ""
    @State private var verificationCode: [String] = Array(repeating: "", count: 6)
    @State var isSecure: Bool = true
    @State private var showGovBrSheet = false
    @FocusState private var focusedField: Int?

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 20) {
                Text("Login")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)

                Image("IHC1")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()

                HStack {
                    Image(systemName: "envelope")
                        .padding(.vertical)
                        .padding(.leading, 5)
                        .foregroundStyle(.blue)

                    TextField("", text: $email, prompt: Text("Email").foregroundStyle(.blue))
                        .textFieldStyle(.plain)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding(.horizontal)
                }
                .cornerRadius(10)
                .foregroundStyle(.blue)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.blue), lineWidth: 2)
                )

                HStack {
                    Image(systemName: "lock")
                        .padding(.vertical)
                        .padding(.leading, 5)
                        .foregroundStyle(.blue)

                    if isSecure {
                        SecureField("", text: $password, prompt: Text("Senha").foregroundStyle(.blue))
                            .textFieldStyle(.plain)
                            .autocapitalization(.none)
                            .padding(.horizontal)

                    } else {
                        TextField("", text: $password, prompt: Text("Senha").foregroundStyle(.blue))
                            .textFieldStyle(.plain)
                            .autocapitalization(.none)
                            .padding(.horizontal)
                    }

                    Button(action: {
                        isSecure.toggle()
                    }) {
                        Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                            .padding(.vertical)
                            .padding(.horizontal)
                            .foregroundStyle(.blue)
                    }
                }
                .cornerRadius(10)
                .foregroundStyle(.blue)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.blue), lineWidth: 2)
                )

                Spacer()

                Button(action: {
                    path.append("dashboard")
                }) {
                    Text("Entrar")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    if let url = URL(string: "https://www.gov.br/pt-br") {
                        UIApplication.shared.open(url)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showGovBrSheet = true
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "person.badge.key.fill")
                        Text("Entrar com Gov.br")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .sheet(isPresented: $showGovBrSheet) {
                    VStack(spacing: 20) {
                        Text("Digite o código de 6 números")
                            .font(.headline)
                        HStack(spacing: 10) {
                            ForEach(0..<6, id: \ .self) { index in
                                TextField("", text: $verificationCode[index])
                                    .frame(width: 40, height: 50)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(.roundedBorder)
                                    .focused($focusedField, equals: index)
                                    .onChange(of: verificationCode[index]) { _, newValue in
                                        if newValue.count == 1 {
                                            focusedField = (index < 5) ? index + 1 : nil
                                        }
                                    }
                            }
                        }
                        Button("Confirmar") {
                            showGovBrSheet = false
                            path.append("dashboard")
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding()
                }

                Spacer()
            }
            .padding()
            .navigationDestination(for: String.self) { value in
                if value == "dashboard" {
                    DashboardView()
                }
            }
        }
    }
}

#Preview {
    LoginView()
}


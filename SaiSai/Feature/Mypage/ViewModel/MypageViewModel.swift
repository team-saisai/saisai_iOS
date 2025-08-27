//
//  MypageViewModel.swift
//  SaiSai
//
//  Created by 이창현 on 8/6/25.
//

import Foundation

final class MypageViewModel: ObservableObject {
    @Published var profile: ProfileInfo = ProfileInfo()
    @Published var version: String = "0.0.0"
    
    var authProvider: AuthProvider? = nil
    
    weak var delegate: AppConfigureViewModelDelegate?
    
    let myService: NetworkService<MyAPI> = .init()
    
    init(delegate: AppConfigureViewModelDelegate?) {
        self.delegate = delegate
    }
    
    func fetchData() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let response = try await myService.request(.getMyProfile, responseDTO: MyProfileResponseDTO.self)
                await setProfile(response.data)
                self.authProvider = AuthProvider(rawValue: response.data.provider)
                let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"
                await setVersion(version)
            } catch {
                print("프로필 조회 실패 😭")
                print(error)
            }
        }
    }
}

extension MypageViewModel {
    @MainActor
    private func setProfile(_ profile: ProfileInfo) {
        self.profile = profile
    }
    
    @MainActor
    private func setVersion(_ version: String) {
        self.version = version
    }
}

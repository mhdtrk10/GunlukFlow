//
//  BannerAdView.swift
//  GunlukFlow
//
//  Created by Mehdi Oturak on 21.04.2025.
//

import SwiftUI
import GoogleMobileAds
import UIKit

// google adMob Banner reklamını SwiftUI içinde gösteren yapı

struct BannerAdView: UIViewRepresentable {
    
    
    
    let adUnitID: String
    
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner)
        banner.adUnitID = adUnitID
        
        banner.rootViewController = UIApplication.shared
            .connectedScenes
            .first(where: {$0.activationState == .foregroundActive})
            .flatMap { $0 as? UIWindowScene }?
            .windows
            .first?
            .rootViewController
        
        
        banner.load(Request())
        return banner
    }
    func updateUIView(_ uiView: BannerView, context: Context) {
        // gerekirse güncelleme yapılır
    }
}



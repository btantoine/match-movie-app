//
//  AdsView.swift
//  Match Movie
//
//  Created by Antoine Boudet on 3/26/21.
//

import SwiftUI
import GoogleMobileAds

struct AdView: UIViewRepresentable {

    func makeUIView(context: UIViewRepresentableContext<AdView>) -> GADBannerView {
        let banner = GADBannerView(adSize: kGADAdSizeBanner)
        banner.adUnitID = "<your-id>"
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(GADRequest())
        return banner
    }

    func updateUIView(_ uiView: GADBannerView, context: UIViewRepresentableContext<AdView>) {
    }

}

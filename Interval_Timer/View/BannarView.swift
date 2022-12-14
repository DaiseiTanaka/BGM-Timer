//
//  BannarView.swift
//  Interval_Timer
//
//  Created by η°δΈ­ε€§θͺ on 2022/09/30.
//

import SwiftUI
import GoogleMobileAds

struct BannerView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = GADBannerViewController()
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

class GADBannerViewController: UIViewController, GADBannerViewDelegate {
    var bannerView: GADBannerView!
    let adUnitID = "ca-app-pub-2399448924069960/1723471864" // d.tnk.4004
    //let adUnitID = "ca-app-pub-5420043854714643/4185242383" // d.tnk.4448
    //let adUnitID = "ca-app-pub-3940256099942544/6300978111"  // for Test
    override func viewDidLoad() {
        super.viewDidLoad()

        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())

        bannerView.delegate = self
        setAdView(bannerView)
    }
    func setAdView(_ view: GADBannerView) {
        bannerView = view
        self.view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        let viewDictionary = ["_bannerView": bannerView!]
        self.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[_bannerView]|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        )
        self.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[_bannerView]|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        )
    }

    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("π: γγγΌεΊεγεδΏ‘γγΎγγ")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("π­: γγγΌεΊεγ?εδΏ‘γ«ε€±ζγγΎγγ β \(error.localizedDescription)")
    }
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("π: γγγΌεΊεγθ‘¨η€ΊγγΎγγ")
    }
}

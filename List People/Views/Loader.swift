//
//  Loader.swift
//  List People
//
//  Created by Engin Yildiz on 4.10.2021.
//

import UIKit

final class Loader: UIView {
    
    class func startLoading() {
        if let currentViewController = UIApplication.shared.keyWindowPresentedController {
            DispatchQueue.main.async {
                let loadingViewWidth: CGFloat = UIScreen.main.bounds.size.width * 0.5
                let loadingViewHeight: CGFloat = 110
                let loadingViewVerticalMargin: CGFloat = 8
                
                let shadowView: UIView = UIView(frame: currentViewController.view.frame)
                shadowView.tag = 1001
                shadowView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.25)
                
                let backImageView: UIImageView = UIImageView(frame: CGRect(x: (currentViewController.view.frame.size.width - loadingViewWidth) / 2, y: (currentViewController.view.frame.size.height - loadingViewHeight) / 2, width: loadingViewWidth, height: loadingViewHeight))
                backImageView.tag = 1002
                backImageView.layer.cornerRadius = 15
                backImageView.backgroundColor = UIColor.white
                
                let topView: UIView = UIView(frame: CGRect(x: (currentViewController.view.frame.size.width - loadingViewWidth) / 2, y: ((currentViewController.view.frame.size.height - loadingViewHeight) / 2) + 8, width: loadingViewWidth, height: (loadingViewHeight * 0.65) - loadingViewVerticalMargin))
                topView.tag = 1003
                let bottomView: UIView = UIView(frame: CGRect(x: (currentViewController.view.frame.size.width - loadingViewWidth) / 2, y: topView.frame.origin.y + topView.frame.size.height, width: loadingViewWidth, height: (loadingViewHeight * 0.35) - loadingViewVerticalMargin))
                bottomView.tag = 1004
                
                let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
                activityIndicatorView.frame = CGRect(x: (topView.frame.size.width - activityIndicatorView.frame.size.width) / 2, y: (topView.frame.size.height - activityIndicatorView.frame.size.height) / 2, width: activityIndicatorView.frame.size.width, height: activityIndicatorView.frame.size.height)
                activityIndicatorView.tag = 1005
                activityIndicatorView.style = .large
                activityIndicatorView.color = .black
                topView.addSubview(activityIndicatorView)
                
                let label: UILabel = UILabel(frame: CGRect(x: 4, y: 0, width: bottomView.frame.size.width - 8, height: bottomView.frame.size.height))
                label.tag = 1006
                label.textAlignment = .center
                label.textColor = .black
                label.font = UIFont.systemFont(ofSize: 17)
                label.adjustsFontSizeToFitWidth = true
                label.minimumScaleFactor = 0.65
                label.text = "Loading..."
                bottomView.addSubview(label)
                
                activityIndicatorView.startAnimating()
                
                currentViewController.view.addSubview(shadowView)
                currentViewController.view.addSubview(backImageView)
                currentViewController.view.addSubview(topView)
                currentViewController.view.addSubview(bottomView)
            }
        }
    }
    
    class func stopLoading() {
        if let currentViewController = UIApplication.shared.keyWindowPresentedController {
            DispatchQueue.main.async {
                let shadowView: UIView? = currentViewController.view.viewWithTag(1001)
                let backImageView: UIImageView? = currentViewController.view.viewWithTag(1002) as? UIImageView
                let topView: UIView? = currentViewController.view.viewWithTag(1003)
                let bottomView: UIView? = currentViewController.view.viewWithTag(1004)
                let activityIndicatorView: UIActivityIndicatorView? = currentViewController.view.viewWithTag(1005) as? UIActivityIndicatorView
                let label: UILabel? = currentViewController.view.viewWithTag(1006) as? UILabel
                
                activityIndicatorView?.stopAnimating()
                
                activityIndicatorView?.removeFromSuperview()
                label?.removeFromSuperview()
                bottomView?.removeFromSuperview()
                topView?.removeFromSuperview()
                backImageView?.removeFromSuperview()
                shadowView?.removeFromSuperview()
            }
        }
    }
}

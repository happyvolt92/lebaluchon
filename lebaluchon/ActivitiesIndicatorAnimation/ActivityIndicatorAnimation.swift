//
//  ActivityIndicatorAnimation.swift
//  lebaluchon
//
//  Created by Elodie Gage on 03/11/2023.
//

import Foundation

import UIKit

class ActivityIndicatorAnimation {
    func startLoading(for activityIndicator: UIActivityIndicatorView) {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }

    func stopLoading(for activityIndicator: UIActivityIndicatorView) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}

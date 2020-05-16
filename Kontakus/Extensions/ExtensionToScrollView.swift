//
//  ExtensionToScrollView.swift
//  Kontakus
//
//  Created by Cüneyd on 13.01.2020.
//  Copyright © 2020 com.kontakus.www. All rights reserved.
//

import UIKit

extension MainViewController: UIScrollViewDelegate {
    func scrollViewSetup(count: Int) {
        scrollView.delegate = self
        scrollView.indicatorStyle = .black
        let minHeight = CGFloat(UIScreen.main.bounds.height)
        let height = CGFloat(count / 3 * 120)
        let remainder = CGFloat(count % 3 * 120)
        if height > minHeight {
            scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: height + remainder)
        }
        else {
            scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: minHeight)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTheKeyboard))
        scrollView.addGestureRecognizer(tapGesture)
    }
}


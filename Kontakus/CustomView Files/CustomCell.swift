//
//  CustomCell.swift
//  CustomKontakusCell
//
//  Created by Cüneyd on 13.07.2019.
//  Copyright © 2019 J8R. All rights reserved.
//

import UIKit

class CustomCell: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var contentView: UIView!
    
    init(origin: CGPoint, size: CGSize = CGSize(width: 120, height: 120)) {
        super.init(frame: CGRect(origin: origin, size: size))
        xibSetup()
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupDesign()
    }
    
    private func setupDesign() {
        contentView.roundedCorners()
        imageView.roundedCorners()
        nameLabel.roundedCorners()
        timeLabel.roundedCorners()
    }
}

extension UIView {
    
    func xibSetup() {
        let view = loadFromNib()
        addSubview(view)
    }
    
    func loadFromNib<T: UIView>() -> T {
        let selfType = type(of: self)
        let bundle = Bundle(for: selfType)
        let nibName = String(describing: selfType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? T else {
            fatalError("Error loading nib with name \(nibName)")
        }
        return view
    }
    
    public func roundedCorners() {
        isUserInteractionEnabled = true
        layer.masksToBounds = true
        layer.cornerRadius = frame.width / 2.0
        contentMode = .scaleAspectFill
    }
}

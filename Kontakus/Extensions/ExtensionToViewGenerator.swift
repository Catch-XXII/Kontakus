//
//  ExtensionToViewGenerator.swift
//  Kontakus
//
//  Created by Cüneyd on 13.01.2020.
//  Copyright © 2020 com.kontakus.www. All rights reserved.
//

import UIKit

extension MainViewController: ViewGenerator, RandomAvatar {
    func randomAvatar() -> Data? {
        return UIImage(named: String.avatarArray.randomElement()!)!.pngData()
    }
    
    func positionCalculator(count: Int) {
        var pointArray: [CGPoint] = []
        let ToY = (count / 3 * 120 + 120)
        for j in stride(from: 0, to: ToY, by: 120) {
            for i in stride(from: 0, to: 295, by: 110) {
                pointArray.append(CGPoint(x: i, y: j))
            }
        }
        var k = 0
        for person in personArray {
            person.centerX = Float(pointArray[k].x)
            person.centerY = Float(pointArray[k].y)
            k += 1
        }
    }
    
    func viewGenerator() {
        for i in 0..<personArray.count {
            let origin = CGPoint(x: CGFloat(personArray[i].centerX), y: CGFloat(personArray[i].centerY))
            let profileView = CustomCell(origin: origin)
            profileView.roundedCorners()
            profileView.nameLabel.text = personArray[i].name
            profileView.timeLabel.isHidden = true
            
            if let image = personArray[i].imageData {
                profileView.imageView.image = UIImage(data: image as Data)
            }
            else {
                profileView.imageView.image = UIImage(named: String.avatarArray.randomElement()!)
                personArray[i].imageData = randomAvatar()
                DatabaseOperations.shared().saveContext()
            }
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(recognizer:)))
            panGesture.delegate = self
            profileView.addGestureRecognizer(panGesture)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(recognizer:)))
            profileView.addGestureRecognizer(tapGesture)
            
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(recognizer:)))
            profileView.addGestureRecognizer(longPressGesture)
            
            cellArray.append(profileView)
            scrollView.addSubview(profileView)
        }
        view.addSubview(scrollView)
        self.index = -1
    }
}

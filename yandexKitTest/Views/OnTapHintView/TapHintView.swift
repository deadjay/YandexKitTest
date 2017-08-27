//
//  OnTapHintView.swift
//  yandexKitTest
//
//  Created by Artem Alekseev on 27/08/2017.
//  Copyright © 2017 Artem Alekseev. All rights reserved.
//

import Foundation
import UIKit

enum WhichPlace: Int {
    case nearestPlace = 0
    case placesAround = 1
}


protocol PlacesDelegate: NSObjectProtocol {
    func buttonDidPressed(place: WhichPlace)
}

class TapHintView: UIView {
    
    let VIEW_HEIGHT: CGFloat = 70.0

    var isPresented = false
    var showNearestPlaceButton = UIButton()
    var showPlacesAroundButton = UIButton()
    var presentedView: UIView!
    
    weak var delegate: PlacesDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        showNearestPlaceButton.tag = WhichPlace.nearestPlace.rawValue
        showPlacesAroundButton.tag = WhichPlace.placesAround.rawValue
    }
    
    //typealias ShowPlacesButtonDidPressed = (_ place: WhichPlace) -> Void
    //var onClickShowPlaces = ShowPlacesButtonDidPressed()
    
    init(frame: CGRect, presentedView: UIView) {
        super.init(frame: frame)
        //self.onClickShowPlaces = onClickShowPlaces
        self.presentedView = presentedView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showView() {
        isPresented = !isPresented
        //hiding view if it's already presented
        if isPresented {
            hideView()
            return
        }
        
        createView()
        UIView.animate(withDuration: 0.5) {
            var newFrame = self.frame
            newFrame.origin.y = self.presentedView.frame.height - self.frame.height
            self.frame = newFrame
        }
    }
    
    func hideView() {
        UIView.animate(withDuration: 0.5) {
            var newFrame = self.frame
            newFrame.origin.y = self.presentedView.frame.height
            self.frame = newFrame
        }
    }
    
    func createView() {
        self.frame = CGRect(x: 0, y: presentedView.bounds.height,
                            width: presentedView.bounds.width, height: VIEW_HEIGHT)
        self.backgroundColor = .white
        showNearestPlaceButton.frame = CGRect(x: 0, y: 0, width: self.bounds.width/2, height: self.bounds.height)
        showNearestPlaceButton.setTitle("Show nearest place", for: .normal)
        showNearestPlaceButton.setTitleColor(.blue, for: .normal)
        showNearestPlaceButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        showNearestPlaceButton.addTarget(self, action: #selector(buttonDidTapped(_:)), for: .touchUpInside)
        self.addSubview(showNearestPlaceButton)
        
        showPlacesAroundButton.frame = CGRect(x: self.bounds.width/2, y: 0, width: self.bounds.width/2, height: self.bounds.height)
        showPlacesAroundButton.setTitle("Show places around", for: .normal)
        showPlacesAroundButton.setTitleColor(.blue, for: .normal)
        showPlacesAroundButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        showPlacesAroundButton.addTarget(self, action: #selector(buttonDidTapped(_:)), for: .touchUpInside)
        self.addSubview(showPlacesAroundButton)
        
        presentedView.addSubview(self)
    }
    
    //UIButton Actions
    func buttonDidTapped(_ sender: UIButton) {
        delegate?.buttonDidPressed(place: WhichPlace(rawValue: sender.tag)!)
    }
}

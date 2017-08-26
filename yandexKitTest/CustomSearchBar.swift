//
//  CustomSearchBar.swift
//  yandexKitTest
//
//  Created by Artem Alekseev on 26/08/2017.
//  Copyright © 2017 Artem Alekseev. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {
    //A hack to disable system cancel button of SearchBar
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setShowsCancelButton(false, animated: false)
    }
}

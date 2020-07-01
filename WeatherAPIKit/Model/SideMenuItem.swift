//
//  SideMenuItem.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 29.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import Foundation
import UIKit

public struct SideMenuItem {
    public var image: UIImage
    public var text: String
    
    public init(image: UIImage, text: String) {
        self.image = image
        self.text = text
    }
}

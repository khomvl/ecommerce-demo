//
//  NSAttributedString+Size.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 01.07.2022.
//

import UIKit

extension NSAttributedString {
    func size(boundingWidth: CGFloat) -> CGSize {
        boundingRect(
            with: CGSize(
                width: boundingWidth,
                height: CGFloat.greatestFiniteMagnitude
            ),
            options: [.usesLineFragmentOrigin],
            context: nil
        ).size
    }
}

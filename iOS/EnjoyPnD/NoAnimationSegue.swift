//
//  NoAnimationSegue.swift
//  EnjoyPnD
//
//  Created by Brian Vallelunga on 1/10/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

@objc(NoAnimationSegue)
class NoAnimationSegue: UIStoryboardSegue {
    override func perform () {
        let source = self.sourceViewController as UIViewController
        let destination = self.destinationViewController as UIViewController
        source.navigationController?.pushViewController(destination, animated:false)
    }
}
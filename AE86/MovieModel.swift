//
//  MovieModel.swift
//  AE86
//
//  Created by DQ on 16/11/23.
//  Copyright © 2016年 DQ. All rights reserved.
//

import UIKit
import Ono

class MovieModel: NSObject {
    var name: String?
    var size: String?
    var count: String?
    var source: String?
    var sourceName: String?
    var magnet: String?

    class func entity(element: ONOXMLElement, site: SiteModel) ->  MovieModel{
        let movie = MovieModel()
        if element.firstChild(withXPath: site.magnet) == nil {
            return movie;
        }

        var firstMagent = element.firstChild(withXPath: site.magnet).stringValue()
        if firstMagent!.hasSuffix(".html") {
            firstMagent = firstMagent!.replacingOccurrences(of: ".html", with: "" )

        }
        if firstMagent!.components(separatedBy: "&").count > 1  {
            firstMagent = firstMagent?.components(separatedBy: "&")[0]
        }
        let i  = firstMagent!.index(firstMagent!.endIndex, offsetBy: -40)

        let magent = firstMagent?.substring(from: i)

        movie.magnet = String(format: "magnet:?xt=urn:btih:%@", magent!)
        movie.name = element.firstChild(withXPath: site.name).stringValue()
        movie.size = element.firstChild(withXPath: site.size).stringValue()
        movie.count = element.firstChild(withXPath: site.count).stringValue()
        movie.sourceName = site.site
        return movie;
    }
}

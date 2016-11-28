//
//  SearchHelper.swift
//  AE86
//
//  Created by DQ on 16/11/23.
//  Copyright © 2016年 DQ. All rights reserved.
//

import UIKit
import Ono
import Alamofire

typealias success = (AnyObject) -> Void

class SearchHelper: NSObject {

    class func searchMoive(urlStr: String, site: SiteModel,success: @escaping success) -> Void {
        Alamofire.request(urlStr, method: .get).response { (response) in
            do{
                var array: [MovieModel] = Array()
                let doc = try ONOXMLDocument(data: response.data)
                doc.enumerateElements(withXPath: site.group, using: { (element, idx, stop) in
                    let model = MovieModel.entity(element: element!, site: site)
                    model.source = urlStr
                    array.append(model)
                })
                success(array as AnyObject)
            }catch{
                print("++++"+"111")
            }
        }
    }
}


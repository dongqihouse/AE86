//
//  AE86HomeViewController.swift
//  AE86
//
//  Created by DQ on 16/11/23.
//  Copyright © 2016年 DQ. All rights reserved.
//

import UIKit
import SwiftyJSON
import PKHUD

class AE86HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    //view
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    //data
    var sites = [SiteModel]()
    var movies = [[MovieModel]]()
    var keyWord: String = "西部世界"

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "AE86"
        let cancelButton: UIButton = searchBar.value(forKey: "_cancelButton") as! UIButton
        cancelButton.setTitle("🚘", for: .normal)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        self.handleData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - handle data
    func handleData() {
        //本地读取site 数据
        let path = Bundle.main.path(forResource: "rule", ofType: "json")
        let data = NSData(contentsOfFile: path!)
        let json = JSON(data: data as! Data)
        for (_,subJson):(String, JSON) in json {
            let site = SiteModel()
            site.site = subJson["site"].stringValue
            site.group = subJson["group"].stringValue
            site.name = subJson["name"].stringValue
            site.size = subJson["size"].stringValue
            site.waiting = subJson["waiting"].stringValue
            site.magnet = subJson["magnet"].stringValue
            site.source = subJson["source"].stringValue
            site.count = subJson["count"].stringValue
            sites.append(site)

        }
        self.requestData(keyWord: "西部世界")

    }
    func requestData(keyWord: String = "西部世界")  {
        //清空数据源
        movies.removeAll()
        let queue = DispatchQueue.global()
        let group = DispatchGroup()
        queue.async(group: group, execute: {

        })
        PKHUD.sharedHUD.contentView = PKHUDProgressView(title: "高速飘漂移中---", subtitle: "🚘")
        PKHUD.sharedHUD.show()
        for site in sites {
            let urlStr = site.source?.replacingOccurrences(of: "XXX", with: keyWord)
            let url = urlStr?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
                group.enter()
                SearchHelper.searchMoive(urlStr: url!, site: site, success: { array in
                    self.movies.append(array as! [MovieModel])
                    group.leave()

            })
        }
        group.notify(queue: DispatchQueue.main) {
            PKHUD.sharedHUD.hide()
            self.tableView.reloadData()

        }
    }
    // MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.movies.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "AE86Cell", for: indexPath) as! AE86Cell
        cell.model = self.movies[indexPath.section][indexPath.row] as MovieModel
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (movies[section][0] as MovieModel).sourceName
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let magnet = (movies[indexPath.section][indexPath.row] as MovieModel).magnet
        // paste board
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = magnet
        // alert view
        let alertView = UIAlertController(title: "提示", message: "地址：\(magnet!)已经复制，请打开其他下载工具下载", preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default, handler: nil)
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)

    }
    // MARK: - UISearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        keyWord = searchText
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.requestData(keyWord: keyWord)
        searchBar.endEditing(true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.requestData(keyWord: keyWord)
        searchBar.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

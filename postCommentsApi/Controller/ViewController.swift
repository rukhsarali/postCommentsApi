//
//  ViewController.swift
//  postCommentsApi
//
//  Created by Rukhsar on 25/08/2020.
//  Copyright © 2020 Rukhsar. All rights reserved.
//

import UIKit
import RealmSwift
import Reachability
class ViewController: UIViewController {
    let reachability = try! Reachability()
    let realm = try! Realm()
    var realmData : Results<RealmData>?
    var realmCommentData : Results<RealmCommentData>?
    let postApiRequest = PostApiRequest()
    var post = [PostApi]()
    let commentApiRequest = CommetnApiRequest()
    var comments = [CommentApi]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
    }
}
//MARK: - Load data
extension ViewController {
    func loadData() {
        if self.isConnectedToInternet() {
            fetchApiPostData()
        }else{
            self.loadOfflineData()
            updateUIOffline()
        }
    }
    func fetchApiPostData() {
        postApiRequest.performPostApiRequest{[weak self] postResult in
            switch postResult {
            case .failure(let error):
                print(error)
            case .success(let post):
                self?.post = post
                self?.fetchApiCommentData()
                DispatchQueue.main.async {
                    self!.titleLabel.text = self?.post[0].title
                    self?.bodyLabel.text = self!.post[0].body
                    self?.savePostData(postTitleBody: post)
                }
            }
        }
    }
    func fetchApiCommentData(){
        commentApiRequest.performCommentsApiRequest{[weak self] commentResult in
            switch commentResult {
            case .failure(let error):
                print(error)
            case .success(let comment):
                self?.comments = comment
                self?.saveCommentData(arrayComment: comment)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    func savePostData(postTitleBody : [PostApi]){
        for obj in postTitleBody {
            let dataObj = RealmData.init()
            dataObj.realmPostTitle = obj.title
            dataObj.realmPostBody = obj.body
            DispatchQueue.main.async {
                self.savePost(obj: dataObj)
            }
        }
    }
    func saveCommentData(arrayComment : [CommentApi]  ) {
        for obj in arrayComment{
            let dataObj = RealmCommentData.init()
            dataObj.realmCommentBody = obj.body
            DispatchQueue.main.async {
                self.saveComment(obj: dataObj)
            }
        }
    }
    func saveComment(obj : RealmCommentData){
        do {
            try realm.write {
                realm.add(obj)
            }
        }catch{
            print("Error saving comments Data")
        }
    }
    func savePost(obj : RealmData){
        do {
            try realm.write {
                realm.add(obj)
            }
        }catch{
            print("Error saving post Data")
        }
    }
    func loadOfflineData(){
        realmData = realm.objects(RealmData.self)
        realmCommentData = realm.objects(RealmCommentData.self)
    }
    func updateUIOffline(){
        titleLabel.text = realmData![0].realmPostTitle
        bodyLabel.text = realmData![0].realmPostBody
    }
}
//MARK: - TableView Delegate
extension ViewController :  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isConnectedToInternet() ? comments.count : realmCommentData!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! selfSizingTableViewCell
        if isConnectedToInternet() {
            let commentDetail = comments[indexPath.row]
            cell.cellTextLabel?.text = commentDetail.body
            cell.cellTextLabel?.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        } else {
            let realmDataSet = realmCommentData![indexPath.row]
            cell.cellTextLabel.text = realmDataSet.realmCommentBody
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//MARK: - check reachability
extension ViewController {
    func isConnectedToInternet() -> Bool {
        switch reachability.connection {
        case .cellular, .wifi:
            return true
        default:
            return false
        }
    }
}

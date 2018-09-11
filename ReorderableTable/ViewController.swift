//
//  ViewController.swift
//  ReorderableTable
//
//  Created by yonekan on 2018/09/10.
//  Copyright © 2018年 yonekan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tasks = [String]()
    
    // テーブルビュー
    @IBOutlet weak var tableView: UITableView!
    
    // テキストフィールド
    @IBOutlet weak var textField: UITextField!
    
    // 追加ボタン
    @IBOutlet weak var addButton: UIButton!
    
    // 編集ボタン
    @IBOutlet weak var editButton: UIButton!
    
    // テーブルに表示する要素数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    // テーブルセルに表示する文字
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            // 編集ボタンが押下された場合、編集アイコン表示
            return .delete
        }
        return .none
    }
    
    // 要素が場所を変更する場合の処理
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // 移動対象の要素を取得
        let moveObject = tasks[sourceIndexPath.row]

        // 移動対象を削除
        tasks.remove(at: sourceIndexPath.row)

        // 移動先に要素を追加
        tasks.insert(moveObject, at: destinationIndexPath.row)

        // データを更新
        let userDefaults = UserDefaults.standard
        userDefaults.set(tasks, forKey: "tasks")

        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // データを削除
        tasks.remove(at: indexPath.row)
        let userDefaults = UserDefaults.standard
        userDefaults.set(tasks, forKey: "tasks")
        
        //tableViewCellの削除
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    @IBAction func add(_ sender: UIButton) {
        if (textField.text?.isEmpty)! {
            // 何も文字が入力されていない場合は、処理を中断
            return
        }
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.object(forKey: "tasks") != nil {
            tasks = userDefaults.object(forKey: "tasks") as! [String]
        }
        
        tasks.append(textField.text!)
        
        userDefaults.set(tasks, forKey: "tasks")
        tableView.reloadData()
        textField.text = ""
    }
    
    @IBAction func edit(_ sender: UIButton) {
        tableView.isEditing = !tableView.isEditing
        
        if tableView.isEditing {
            editButton.setTitle("完了", for: .normal)
            addButton.isEnabled = false
        } else {
            editButton.setTitle("編集", for: .normal)
            addButton.isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "tasks") != nil {
            tasks = userDefaults.object(forKey: "tasks") as! [String]
        }

        tableView.reloadData()
    }

}

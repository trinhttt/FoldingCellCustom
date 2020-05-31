//
//  ViewController.swift
//  FoldingCard
//
//  Created by TrinhThai on 5/29/20.
//  Copyright © 2020 TrinhThai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    enum Const {
        static let closeCellHeight: CGFloat = 157
        static let openCellHeight: [CGFloat] = [307, 457, 607, 757, 907, 1057, 1207, 1357, 1507, 1657]
        static let rowsCount = 10
    }
    
    var cellHeights: [CGFloat] = []
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: Helpers
    private func setup() {
        let nib = UINib(nibName: "FoldingTableViewCell",bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FoldingCell")
        cellHeights = Array(repeating: Const.closeCellHeight, count: Const.rowsCount)
        tableView.estimatedRowHeight = Const.closeCellHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.white
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    // MARK: Actions
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.tableView.reloadData()
        })
    }
    
    private func updateTableView(withDuration duration: Double) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }, completion: nil)
    }
}

// MARK: - TableView

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return Const.rowsCount
    }
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as FoldingTableViewCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
//        cell.number = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.45, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35]

        cell.durationsForExpandedState = durations.map { $0 / 1.2}
        cell.durationsForCollapsedState = durations
        let height = Const.openCellHeight[indexPath.row]
        cell.itemCount = Int((height - 7.0) / 150.0)
        cell.containerViewHeight.constant = height - 7.0
        return cell
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight[indexPath.row]//Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.2 + Double(indexPath.row + 1) * 0.2
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = Double(indexPath.row + 1) * 0.5//2.6
        }
        
//        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
//            tableView.beginUpdates()
//            tableView.endUpdates()

            // fix https://github.com/Ramotion/folding-cell/issues/169
//            if cell.frame.maxY > tableView.frame.maxY {
//                tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
//            }

//        }, completion: nil)
        
        if cell.frame.maxY > tableView.frame.maxY {
            if !cellIsCollapsed {
                tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: false)
                self.updateTableView(withDuration: duration)
            } else {
                self.updateTableView(withDuration: duration)
                tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: false)
            }
        } else {
            self.updateTableView(withDuration: duration)
        }
    }
}

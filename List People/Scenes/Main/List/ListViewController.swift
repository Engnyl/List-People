//
//  ViewController.swift
//  List People
//
//  Created by Engin Yildiz on 4.10.2021.
//

import UIKit

final class ListViewController: UIViewController {
    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            listTableView.delegate = self
            listTableView.dataSource = self
            listTableView.tableFooterView = UIView(frame: CGRect.zero)
            listTableView.register(UINib.init(nibName: "PersonTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "personCell")
        }
    }
    @IBOutlet weak var emptyListLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshView: UIView!
    let refreshControl = UIRefreshControl()
    
    var viewModel: ListViewModelProtocol! {
        didSet {
            viewModel.delegate = self
            viewModel.loadView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ListViewModel()
        viewModel.reloadListTableViewClosure = {[weak self] in
            DispatchQueue.main.async {
                self?.listTableView.reloadData()
            }
        }
    }
    
    func retry() {
        viewModel.getPeopleList(initialListCall: false)
     }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        viewModel.getPeopleList(initialListCall: true)
     }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard (viewModel != nil) else { return 0 }
        
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as? PersonTableViewCell else {
            fatalError("Cell does not exists in storyboard")
        }
        
        let cellViewModel = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellViewModel
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("\(viewModel.getPerson(at: indexPath).fullName) (\(viewModel.getPerson(at: indexPath).id))")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == listTableView {
            let lastSectionIndex: Int = tableView.numberOfSections - 1
            let lastRowIndex: Int = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            
            if viewModel.canGetMorePeople && (indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex) {
                viewModel.getPeopleList(initialListCall: false)
            }
        }
    }
}

// MARK: - ListViewModelDelegate
extension ListViewController: ListViewModelDelegate {
    
    func handleViewModelOutput(_ output: ListViewModelOutput) {
        switch output {
        case .prepareView:
            refreshButton.addTarget(self, action: #selector(self.refresh(_:)), for: .touchUpInside)
            refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
            listTableView.addSubview(refreshControl)
            
        case .showListFethed(let message, let emptyList):
            refreshControl.endRefreshing()
            refreshView.isHidden = !emptyList
            
            if emptyList {
                emptyListLabel.text = message
            }
            
            print(message)
            
        case .showListError(let message):
            refreshControl.endRefreshing()
            
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default) { action -> Void in
                self.retry()
            })
            self.present(alert, animated: true, completion: nil)
            
            print(message)
        }
    }
}

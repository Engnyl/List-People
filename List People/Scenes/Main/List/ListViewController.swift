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
    @IBOutlet weak var resultLabel: UILabel!
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
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel.getInitialPeopleList()
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
            
            if (indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex) {
                viewModel.getMorePeopleList()
            }
        }
    }
}

// MARK: - ListViewModelDelegate
extension ListViewController: ListViewModelDelegate {
    
    func handleViewModelOutput(_ output: ListViewModelOutput) {
        switch output {
        case .prepareView:
            refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
            listTableView.addSubview(refreshControl)
            
        case .showListFethed(let message, let emptyList):
            resultLabel.isHidden = !emptyList
            refreshControl.endRefreshing()
            
            if emptyList {
                resultLabel.text = message
            }
            
            print(message)
            
        case .showListError(let message):
            resultLabel.isHidden = false
            refreshControl.endRefreshing()
            resultLabel.text = message
            
            print(message)
        }
    }
}

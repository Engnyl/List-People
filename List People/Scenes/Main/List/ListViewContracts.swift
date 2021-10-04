//
//  ListViewContracts.swift
//  List People
//
//  Created by Engin Yildiz on 4.10.2021.
//

import Foundation

protocol ListViewModelProtocol {
    var delegate: ListViewModelDelegate? { get set }
    var numberOfCells: Int { get }
    var next: Int? { get set }
    var reloadListTableViewClosure: (()->())? { get set }
    
    func loadView()
    func getPerson(at indexPath : IndexPath) -> Person
    func getCellViewModel(at indexPath: IndexPath) -> PersonCellViewModel
    func resetQuery()
    func getInitialPeopleList()
    func getMorePeopleList()
}

enum ListViewModelOutput {
    case prepareView
    case showListFethed(message: String, emptyList: Bool)
    case showListError(message: String)
}

protocol ListViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: ListViewModelOutput)
}

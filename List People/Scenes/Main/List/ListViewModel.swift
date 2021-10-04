//
//  ListViewModel.swift
//  List People
//
//  Created by Engin Yildiz on 4.10.2021.
//

import UIKit

final class ListViewModel: ListViewModelProtocol {
    var delegate: ListViewModelDelegate?
    
    var numberOfCells: Int {
        return people.count
    }
    var next: Int?
    
    var reloadListTableViewClosure: (()->())?
    
    private var people: [Person] = [Person]() {
        didSet {
            self.reloadListTableViewClosure?()
        }
    }
    
    private var cellViewModels: [PersonCellViewModel] = [PersonCellViewModel]() {
        didSet {
            self.reloadListTableViewClosure?()
        }
    }
    
    func loadView() {
        self.notifyViewController(.prepareView)
        self.getInitialPeopleList()
    }
    
    func getPerson(at indexPath : IndexPath) -> Person {
        return people[indexPath.row]
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> PersonCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func resetQuery() {
        self.next = nil
        self.people = [Person]()
        self.cellViewModels = [PersonCellViewModel]()
    }
    
    func getInitialPeopleList() {
        self.resetQuery()
        
        DataSource.fetch(next: ((self.next != nil) ? String(self.next!) : nil)) { (fetchResponse, fetchError) in
            if (fetchResponse != nil) {
                self.processPeopleList(fetchResponse: fetchResponse!)
                
                let emptyList = (self.people.count == 0)
                self.notifyViewController(.showListFethed(message: emptyList ? "No one here :)" : "Initial people list fetched successfully.", emptyList: emptyList))
            }
            else if (fetchError != nil) {
                self.notifyViewController(.showListError(message: fetchError!.errorDescription))
            }
        }
    }
    
    func getMorePeopleList() {
        
    }
    
    private func processPeopleList(fetchResponse: FetchResponse) {
        var people = [Person]()
        var cellViewModels = [PersonCellViewModel]()
        
        for person in fetchResponse.people {
            people.append(person)
            cellViewModels.append(createPersonCellViewModel(person: person))
        }
        
        if self.people.count > 0 {
            self.people.append(contentsOf: people)
        }
        else {
            self.people = people
        }
        
        if self.cellViewModels.count > 0 {
            self.cellViewModels.append(contentsOf: cellViewModels)
        }
        else {
            self.cellViewModels = cellViewModels
        }
    }
    
    private func createPersonCellViewModel(person: Person) -> PersonCellViewModel {
        return PersonCellViewModel(personId: String(person.id), personFullName: person.fullName)
    }
    
    private func notifyViewController(_ output: ListViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
}

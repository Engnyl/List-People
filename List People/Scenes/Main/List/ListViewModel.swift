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
    var next: String?
    var canGetMorePeople: Bool = false
    
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
        self.getPeopleList(initialListCall: true)
    }
    
    func getPerson(at indexPath : IndexPath) -> Person {
        return people[indexPath.row]
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> PersonCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func resetQuery() {
        self.next = nil
        self.canGetMorePeople = false
        self.people = [Person]()
        self.cellViewModels = [PersonCellViewModel]()
    }
    
    func getPeopleList(initialListCall: Bool) {
        Loader.startLoading()
        
        if initialListCall {
            self.resetQuery()
        }
        
        DataSource.fetch(next: self.next) { (fetchResponse, fetchError) in
            if (fetchResponse != nil) {
                self.processPeopleList(fetchResponse: fetchResponse!)
                
                self.next = fetchResponse!.next
                self.canGetMorePeople = self.people.count < fetchResponse!.peopleCount
                
                if initialListCall {
                    self.notifyViewController(.showListFethed(message: (self.people.count == 0) ? "No one here :)" : "Initial people list fetched successfully.", emptyList: (self.people.count == 0)))
                }
                else {
                    self.notifyViewController(.showListFethed(message: "More people list fetched successfully.", emptyList: false))
                }
            }
            else if (fetchError != nil) {
                self.notifyViewController(.showListError(message: fetchError!.errorDescription))
            }
            
            Loader.stopLoading()
        }
    }
    
    private func processPeopleList(fetchResponse: FetchResponse) {
        var people = [Person]()
        var cellViewModels = [PersonCellViewModel]()
        
        for person in fetchResponse.people {
            people.append(person)
        }
        
        if self.people.count > 0 {
            self.people.append(contentsOf: people)
            self.people = self.people.uniques(by: \.id)
        }
        else {
            self.people = people
        }
        
        self.people = self.people.sorted { $0.id < $1.id }
        
        for person in self.people {
            cellViewModels.append(createPersonCellViewModel(person: person))
        }
        
        self.cellViewModels = cellViewModels
    }
    
    private func createPersonCellViewModel(person: Person) -> PersonCellViewModel {
        return PersonCellViewModel(personId: String(person.id), personFullName: person.fullName)
    }
    
    private func notifyViewController(_ output: ListViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
}

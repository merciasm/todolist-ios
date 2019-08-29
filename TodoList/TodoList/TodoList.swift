//
//  TodoList.swift
//  TodoList
//
//  Created by Mercia Maguerroski on 23/08/19.
//  Copyright © 2019 Mércia. All rights reserved.
//

import Foundation

class TodoList {
    
    enum Priority: Int, CaseIterable {
        case high, medium, low, no
    }
    
    private var highPriorityTodos: [ChecklistItem] = []
    private var mediumPriorityTodos: [ChecklistItem] = []
    private var lowPriorityTodos: [ChecklistItem] = []
    private var noPriorityTodos: [ChecklistItem] = []
    
    init() {
        
        let row0Item = ChecklistItem()
        let row1Item = ChecklistItem()
        
        row0Item.text = "Take a jog"
        row1Item.text = "Watch a movie"
        
        addTodo(row0Item, for: .medium)
        addTodo(row1Item, for: .no)
    }
    
    func addTodo(_ item: ChecklistItem, for priority: Priority) {
        switch priority {
        case .high:
            return highPriorityTodos.append(item)
        case .medium:
            return mediumPriorityTodos.append(item)
        case .low:
            return lowPriorityTodos.append(item)
        case .no:
            return noPriorityTodos.append(item)
        }
    }
    
    func todoList(for priority: Priority) -> [ChecklistItem] {
        switch priority {
        case .high:
            return highPriorityTodos
        case .medium:
            return mediumPriorityTodos
        case .low:
            return lowPriorityTodos
        case .no:
            return noPriorityTodos
        }
    }
    
    func newTodo() -> ChecklistItem {
        let item = ChecklistItem()
        item.text = randomTitle()
        item.checked  = true
        mediumPriorityTodos.append(item)
        return item
    }
    
    func move(item: ChecklistItem, to index: Int) {
        //    guard let currentIndex = todos.index(of: item) else {
        //      return
        //    }
        //    todos.remove(at: currentIndex)
        //    todos.insert(item, at: index)
    }
    
    func remove(_ item: ChecklistItem, from priority: Priority, at index: Int) {
        switch priority {
        case .high:
            highPriorityTodos.remove(at: index)
        case .medium:
            mediumPriorityTodos.remove(at: index)
        case .low:
            lowPriorityTodos.remove(at: index)
        case .no:
            noPriorityTodos.remove(at: index)
        }
        
    }
    
    private func randomTitle() -> String {
        var titles = ["New todo item", "Generic todo", "Fill me out", "I need something to do", "Much todo about nothing"]
        let randomNumber = Int.random(in: 0 ... titles.count - 1)
        return titles[randomNumber]
    }
    
}

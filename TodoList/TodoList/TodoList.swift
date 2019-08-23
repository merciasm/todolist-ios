//
//  TodoList.swift
//  TodoList
//
//  Created by Mercia Maguerroski on 23/08/19.
//  Copyright © 2019 Mércia. All rights reserved.
//

import Foundation

class TodoList {
    
    var todos: [ChecklistItem] = []
    
    init() {
        
        let row0Item = ChecklistItem()
        let row1Item = ChecklistItem()
        
        row0Item.text = "Take a jog"
        row1Item.text = "Watch a movie"
        
        todos.append(row0Item)
        todos.append(row1Item)
    }
    
    func newTodo() -> ChecklistItem{
        let item = ChecklistItem()
        item.text = randomTitle()
        item.checked = true
        todos.append(item)
        return item
    }
    
    private func randomTitle() -> String {
        var titles = ["New todo item", "Generic todo", "fill me out", "I need something todo", "Much todo about nothing"]
        
        let randomNumber = Int.random(in: 0...titles.count-1)
        return titles[randomNumber]
    }
}

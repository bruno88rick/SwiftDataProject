//
//  ContentView.swift
//  SwiftDataProject
//
//  Created by Bruno Oliveira on 18/06/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    /*The filter starts with #Predicate<User>, which means we're writing a predicate (a fancy word for a test we're going to apply). That predicate gives us a single user instance to check. In practice that will be called once for each user loaded by SwiftData, and we need to return true if that user should be included in the results. Our test checks whether the user's name contains the capital letter R. If it does, the user will be included in the results, otherwise they won't.
    */
    
    /*The contains() method is case-sensitive: it considers capital R and lowercase R to be difference, which is why it didn't find the "r" in "Ed Sheeran". That works great for a simple test of predicates, but it's very rare users actually care about capital letters – they usually just want to write a few letters, and look for that match anywhere in the results, ignoring case. For this purpose, iOS gives us a separate method localizedStandardContains(). This also takes a string to search for, except it automatically ignores letter case, so it's a much better option when you're trying to filter by user text.*/
    
    /*@Query(filter: #Predicate<User> { user in
        //user.name.contains("R")
        user.name.localizedStandardContains("R") && user.city == "London"
    }, sort: \User.name) var users: [User]*/
    
    //for muli ckecks/filer use only && or || can ge a bit confusing, so we can use other logical operators that returns true or false (returning True means that the data that the Predicate for each is checking can be filter and false means that the result don`t match the filter). We can do this so:
    
    @Query(filter: #Predicate<User> { user in
        if user.name.localizedStandardContains("R") {
            if user.city == "London" {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }, sort: \User.name) var users: [User]
    
    /*Now, you might be thinking that's a little verbose – that could remove both else blocks and just end with return true, because if the user actually matched the predicate the return true would already have been hit. Like This:
     
     @Query(filter: #Predicate<User> { user in
         if user.name.localizedStandardContains("R") {
             if user.city == "London" {
                 return true
             }
         }

         return false
     }, sort: \User.name) var users: [User]
     
     
     But it isn't actually valid, because even though it looks like we're executing pure Swift code it's important you remember that doesn't actually happen – the #Predicate macro actually rewrites our code to be a series of tests it can apply on the database, which doesn't use Swift internally. To see what's happening internally, right-click on #Predicate and select Expand Macro, and you'll see a huge amount of code appears. Remember, this is the actual code that gets built and run – it's what our #Predicate gets converted into.
     
     So, that's just a little of how #Predicate works, and why some predicates you might try just don't quite work how you expect – this stuff looks easy, but it's really complex behind the scenes!*/
    
    @State private var path = [User]()
    
    var body: some View {
        NavigationStack(path: $path) {
            List(users) { user in
                NavigationLink(value: user) {
                    Text(user.name)
                }
            }
            .navigationTitle("Users")
            .navigationDestination(for: User.self) { user in
                EditUserView(user: user)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing){
                    Button("Add User", systemImage: "plus") {
                        let user = User(name: "", city: "", joinDate: .now)
                        modelContext.insert(user)
                        path = [user]
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Add Sample", systemImage: "book.pages") {
                        
                        try? modelContext.delete(model: User.self)
                        
                        let first = User(name: "Ed Sheeran", city: "London", joinDate: .now.addingTimeInterval(86400 * -10))
                        let second = User(name: "Rosa Diaz", city: "New Yourk", joinDate: .now.addingTimeInterval(86400 * -5))
                        let third = User(name: "Roy Kent", city: "London", joinDate: .now.addingTimeInterval(86400 * 5))
                        let fourth = User(name: "Johnny English", city: "London", joinDate: .now.addingTimeInterval(86400 * 10))
                        
                        modelContext.insert(first)
                        modelContext.insert(second)
                        modelContext.insert(third)
                        modelContext.insert(fourth)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

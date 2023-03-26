

import Foundation
import Combine


class TaskListModel {
    
    // replace this with
    // @Published var tasks = ["buy milk"]
    
    let tasks = CurrentValueSubject<[String], Never>(["buy milk"])
    var addNewTask = PassthroughSubject<String, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedItems")
    
    init() {
        
        //data stream to create new task
        addNewTask
            .filter({ $0.count > 3 })
            .sink { _ in
            } receiveValue: { [unowned self] newTask in
                self.tasks.send(self.tasks.value + [newTask])
                save()
            }.store(in: &subscriptions)
        
        // get initial values at launch like from file system
        // save changes to tasks in file system
        //Loading saved data
        do {
            let data = try Data(contentsOf: savePath)
            tasks.value = try JSONDecoder().decode([String].self, from: data)
        } catch {
            tasks.value = []
        }
        
    }
    
    //Saving Using data to disk
    func save(){
        do{
            let data = try JSONEncoder().encode(tasks.value)
            try data.write(to: savePath, options: [.atomicWrite,.completeFileProtection])
        } catch{
            print("Unable to show data ALERT")
        }
    }
    
    func deleteFiles(indexPath: Int) {
        do{
            var data = try Data(contentsOf: savePath)
            data.remove(at: indexPath)
            tasks.value.remove(at: indexPath)
            save()
        } catch{
            print("Unable to show data ALERT")
        }
    }
}

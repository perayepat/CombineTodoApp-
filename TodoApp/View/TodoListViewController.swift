import UIKit
import Combine

class TodoListViewController: UIViewController {
    
    // use viewmodel to populate table
    let taskViewModel  = TaskListModel()
    @IBOutlet weak var tableView: UITableView!
    
    var subscriptions = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        // add data stream that calls tableView.reloadData() when data changes
        taskViewModel.tasks.sink { [unowned self] values in
            /// Whenever the tasks are sent down stream the view should update
            print("receive values \(values)")
//            print("Table is reloading with : \(self.taskViewModel.tasks)")
            self.tableView.reloadData()
        }
        .store(in: &subscriptions)
    }
    
    @IBSegueAction func addNewViewIsGoingToAppear(_ coder: NSCoder) -> AddNewViewController? {
        let controller = AddNewViewController(coder: coder)
        // hande over viewmodel to controller
        controller?.taskListModel = taskViewModel
        return controller
    }
    
}

extension TodoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskViewModel.tasks.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = taskViewModel.tasks.value[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            taskViewModel.deleteFiles(indexPath: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

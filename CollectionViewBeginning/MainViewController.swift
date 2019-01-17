// colection view editing mode
// 1. add edit bar button item
// 2. disable "+" button in editing mode using outlet to addButton
// 3. create custom class for cell (accessing label using tag method won't work)
// 4. cast cell to new class in didSelect method



import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var addButton: UIBarButtonItem!
    @IBOutlet private weak var deleteButton: UIBarButtonItem!
    
    var arrayOfnumbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = (view.frame.size.width - 10 * 2) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        collectionView.refreshControl = refresh
        
        //creating tab button item, which toggles editing mode on and off
        navigationItem.leftBarButtonItem = editButtonItem
        
        navigationController?.isToolbarHidden = true
    }
    
    @IBAction func deleteSelected() {
        if let selected = collectionView.indexPathsForSelectedItems {
            
            // to avoid issue with removing wrong/not existing indexes - sort and reverse
            // how do I get item: Int from [IndexPath]
            let itemsToRemove = selected.map { $0.item }.sorted().reversed()
            for item in itemsToRemove {
                arrayOfnumbers.remove(at: item)
            }
            collectionView.deleteItems(at: selected)
        }
        navigationController?.isToolbarHidden = true
    }
    
    @IBAction func addItem() {
        let text = "\(arrayOfnumbers.count + 1)"
        arrayOfnumbers.append(text)
        let indexPath = IndexPath(row: arrayOfnumbers.count - 1, section: 0)
        collectionView.insertItems(at: [indexPath])
    }
    
    @objc func refresh() {
        addItem()
        collectionView.refreshControl?.endRefreshing()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        addButton.isEnabled = !editing
        deleteButton.isEnabled = editing
        collectionView.allowsMultipleSelection = editing
        
        // cleaning previously selected cells (if any) before entering editing mode
        collectionView.indexPathsForSelectedItems?.forEach({ (indexPath) in
            collectionView.deselectItem(at: indexPath, animated: false)
        })
        // activating editing mode for all cell
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
            cell.isEditing = editing
        }
        if !editing {
            navigationController?.isToolbarHidden = true
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            if let destination = segue.destination as? DetailViewController {
                if let index = sender as? IndexPath {
                    destination.selection = arrayOfnumbers[index.row]
                }
            }
        }
    }
    
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfnumbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.titleLabel.text = arrayOfnumbers[indexPath.row]
        
        // place to set isEditing property
        cell.isEditing = isEditing
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !isEditing {
            performSegue(withIdentifier: "DetailSegue", sender: indexPath)
        } else {
            navigationController?.isToolbarHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isEditing {
            if let selected = collectionView.indexPathsForSelectedItems, selected.count == 0 {
                navigationController?.isToolbarHidden = true
            }
        }
    }
}


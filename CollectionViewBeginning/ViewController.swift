import UIKit

class ViewController: UIViewController {
    
    // what actually gives you word "private"
    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrayOfnumbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = (view.frame.size.width - 10 * 2) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        collectionView.refreshControl = refresh
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

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfnumbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        if let label = cell.viewWithTag(100) as? UILabel {
            label.text = arrayOfnumbers[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "DetailSegue", sender: indexPath)
    }
    
    
}


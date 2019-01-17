import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet private weak var detailLabel: UILabel!
    
    var selection: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailLabel.text = selection
    }
}

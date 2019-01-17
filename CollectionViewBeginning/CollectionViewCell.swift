import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    // this time properties are not private, since we need to access them from main VC
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionImage: UIImageView!
    
    var isEditing: Bool = false {
        didSet {
            selectionImage.isHidden = !isEditing
        }
    }
    
    // overriding property of the cell
    override var isSelected: Bool {
        didSet {
            if isEditing {
                selectionImage.image = isSelected ? UIImage(named: "Checked")  : UIImage(named: "Unchecked")
            }
        }
    }
    
}

import UIKit

extension UIButton {

    func setup(with nameImage:String){
        self.frame = .zero
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle("", for: UIControl.State.normal)
        self.setImage(UIImage(named: nameImage), for: .normal)
        self.tintColor = .black
        self.setBackgroundImage(UIImage(named: nameImage), for: .normal)
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1

//        self.clipsToBounds = true
        let borderColor: UIColor = .systemGray2
        self.layer.borderColor = borderColor.cgColor
    }
}

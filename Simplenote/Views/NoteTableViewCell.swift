import UIKit

final class NoteTableViewCell: UITableViewCell {
    //MARK: - static let
    static let identifier = "NoteTableViewCell"

    //MARK: - IBOutlet
    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!

    //         cell.titileLabel.text = getNoteTitle(text: note.content!)
    //         cell.contentLabel.text = getNoteContent(text: note.content!)
    //         cell.dateLabel.text = note.date
    
    //MARK: - flow funcs
    func configure(with item: Item){
//        configureIcon(with: item.icon)
//        configureTitileLabel(with: item.title)
//        configureContentLabel(with: item.content)
        configureDateLabel(with: item.date ?? "")
        configureStackView()
        configurContentView()
    }

    func configureIcon(with name: String) {
        icon.rounded()
        icon.image = UIImage(named: "photo")
    }

    func configureTitileLabel(with text: String) {
        titileLabel.text = text
    }

    func configureContentLabel(with text: String) {
        contentLabel.text = text
    }

    func configureDateLabel(with text: String) {
        dateLabel.text = text
        dateLabel.textColor = .white
    }

    func configureStackView() {
        stackView.rounded(radius: 5)
        stackView.layer.borderWidth = 0.3
        stackView.layer.borderColor = UIColor.white.cgColor
        stackView.backgroundColor = .gray
    }

    func configurContentView() {
        contentView.backgroundColor = .darkGray
    }
}

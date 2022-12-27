import UIKit

final class NoteTableViewCell: UITableViewCell {
    //MARK: - static let
    static let identifier = "NoteTableViewCell"

    //MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    //MARK: - flow funcs
    func configure(with item: Item){
        configureTitleLabel(with: item.title ?? "")
        configureContentLabel(with: item.content ?? "")
        configureDateLabel(with: item.date ?? "")
        configureStackView()
        configurContentView()
    }

    func configureTitleLabel(with text: String) {
        titleLabel.text = text
        titleLabel.textColor = .white
    }

    func configureContentLabel(with text: String) {
        contentLabel.text = text
        contentLabel.textColor = .white
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

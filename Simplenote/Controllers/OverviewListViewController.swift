import RealmSwift
import UIKit

final class OverviewListViewController: UIViewController {

    //MARK: - let/var
    private enum Constants {
        static let offsetForButton: CGFloat = 100
        static let heightForRow: CGFloat = 60
        static let heightForButton: CGFloat = 50
        static var xBeforeAnimation: CGFloat = 0
        static var xAfterAnimation: CGFloat = 0
        static var isButtonShow = false
    }
    lazy var counter = items.count

    let item = Item().prepareForFirstUse()
    var items = RealmManager.shared.fetchData()
    var sortItems = [Item]()

    private let createNoteButton: UIButton = {
        let button: UIButton = .init()
        button.setImage(UIImage(named: "pencil"), for: .normal)
        button.backgroundColor = .lightOrange
        button.rounded(radius: Constants.heightForButton/2)
        button.bounds.size = .init(width: Constants.heightForButton,
                                   height: Constants.heightForButton)
        return button
    }()

    //MARK: - IBOutlet
    @IBOutlet weak var listOfNotesTableView: UITableView!
    
    //MARK: - life cycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


        sortItems = items.sorted {
             $0.title > $1.title
         }

        print(sortItems)

        listOfNotesTableView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Constants.isButtonShow ? setXForButton(x: Constants.xAfterAnimation) : setXForButton(x: Constants.xBeforeAnimation)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startButtonAnimation ()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setXForButton(x: Constants.xBeforeAnimation)
    }

    //MARK: - flow funcs
    private func configure() {
        if items.isEmpty {
//             item.title = "0"
            RealmManager.shared.saveItem(with: item)
        }


        view.addSubview(createNoteButton)

        createNoteButton.frame.origin.y = view.bounds.height - Constants.offsetForButton
        Constants.xBeforeAnimation = view.bounds.width
        Constants.xAfterAnimation = view.bounds.width - Constants.offsetForButton

        listOfNotesTableView.separatorColor = .white
        listOfNotesTableView.delegate = self
        listOfNotesTableView.dataSource = self
        let nib = UINib(nibName: NoteTableViewCell.identifier, bundle: nil)
        listOfNotesTableView.register(nib, forCellReuseIdentifier: NoteTableViewCell.identifier)

        createNoteButton.addTarget(self, action: #selector(createNoteButtonPressed), for: .touchUpInside)
    }

    private func setXForButton (x: CGFloat) {
        createNoteButton.frame.origin.x = x
    }

    private func startButtonAnimation () {
        UIView.animate(withDuration: 0.4, delay: 0.3) { [self] in
            setXForButton(x: Constants.xAfterAnimation)
        } completion: { _ in
            Constants.isButtonShow = true
        }
    }

    @objc private func createNoteButtonPressed() {
        let item = Item().prepareForFirstUse()

        counter += 1
        item.title = "\(counter)"
        RealmManager.shared.saveItem(with: item)
        Constants.isButtonShow = false
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: EditingViewController.identifier) as? EditingViewController else { return }
        controller.titleNote = item.title
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

//MARK: - extension Delegate, DataSource
extension OverviewListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let note = sortItems[indexPath.row]

        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: EditingViewController.identifier) as? EditingViewController else { return }
        controller.delegate = self
        controller.titleNote = note.title
        self.navigationController?.pushViewController(controller, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            RealmManager.shared.deletItem(with: sortItems[indexPath.row])
            listOfNotesTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightForRow
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as? NoteTableViewCell else { return UITableViewCell() }

        cell.configure(with: sortItems[indexPath.row])
        return cell
    }
}

extension OverviewListViewController: EditingViewControllerDelegate {
   func setting() {

   }
}


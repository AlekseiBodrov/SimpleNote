import RealmSwift
import UIKit

 final class OverviewListVC: UIViewController {
     //MARK: - static var
     private static var xBeforeAnimation: CGFloat = 0
     private static var xAfterAnimation: CGFloat = 0
     private static var isButtonVisible = false

     //MARK: - let/var
     private enum Constants {
         static let buttonOffset: CGFloat = 100
         static let rowHeight: CGFloat = 60
         static let buttonHeight: CGFloat = 50
         static let duration = 0.3
         static let delay = 0.3
     }
     
     private lazy var counter = notesArray.count

     private let firstNote = Item().prepareForFirstUse()
     private var notesArray: Results<Item> = RealmManager.shared.fetchData()
     private var notesArraySorted = [Item]()

     private let newNoteButton = UIButton()

    //MARK: - IBOutlet
    @IBOutlet weak var listOfNotesTableView: UITableView!
    

     //MARK: - life cycle funcs
     override func viewDidLoad() {
         super.viewDidLoad()
         configure()
         createNoteButton()
     }

     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)

         notesArraySorted = notesArray.sorted {
              $0.title > $1.title
          }
         listOfNotesTableView.reloadData()
     }

     override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         OverviewListVC.isButtonVisible ? setButtonX(x: OverviewListVC.xAfterAnimation) : setButtonX(x: OverviewListVC.xBeforeAnimation)
     }

     override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         buttonStartedAnimation()
     }

     override func viewDidDisappear(_ animated: Bool) {
         super.viewDidDisappear(animated)
         setButtonX(x: OverviewListVC.xBeforeAnimation)
     }

     //MARK: - flow funcs
     private func configure() {
         if notesArray.isEmpty {
             RealmManager.shared.saveItem(with: firstNote)
         }

         view.addSubview(newNoteButton)

         newNoteButton.frame.origin.y = view.bounds.height - Constants.buttonOffset
         OverviewListVC.xBeforeAnimation = view.bounds.width
         OverviewListVC.xAfterAnimation = view.bounds.width - Constants.buttonOffset

         listOfNotesTableView.separatorColor = .white
         listOfNotesTableView.delegate = self
         listOfNotesTableView.dataSource = self
         let nib = UINib(nibName: NoteTableViewCell.identifier, bundle: nil)
         listOfNotesTableView.register(nib, forCellReuseIdentifier: NoteTableViewCell.identifier)

         newNoteButton.addTarget(self, action: #selector(newNoteButtonPressed), for: .touchUpInside)
     }

     private func setButtonX (x: CGFloat) {
         newNoteButton.frame.origin.x = x
     }

     private func buttonStartedAnimation () {
         UIView.animate(withDuration: Constants.duration, delay: Constants.delay) { [self] in
             setButtonX(x: OverviewListVC.xAfterAnimation)
         } completion: { _ in
             OverviewListVC.isButtonVisible = true
         }
     }

     @objc private func newNoteButtonPressed() {
         let item = Item().prepareForFirstUse()

         counter += 1
         item.title = "\(counter)"
         RealmManager.shared.saveItem(with: item)
         OverviewListVC.isButtonVisible = false

         createViewController()
     }

     func createViewController() {
         guard let controller = self.storyboard?.instantiateViewController(withIdentifier: EditingVC.identifier) as? EditingVC else { return }
         self.navigationController?.pushViewController(controller, animated: true)
     }

 }

 //MARK: - extension Delegate, DataSource
 extension OverviewListVC: UITableViewDelegate, UITableViewDataSource {

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)

//         let note = sortItems[indexPath.row]

         createViewController()
     }

     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             RealmManager.shared.deletItem(with: notesArraySorted[indexPath.row])
             listOfNotesTableView.deleteRows(at: [indexPath], with: .automatic)
         }
     }

     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return Constants.rowHeight
     }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return notesArray.count
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

         guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as? NoteTableViewCell else { return UITableViewCell() }

         cell.configure(with: notesArraySorted[indexPath.row])
         return cell
     }
 }

//extension OverviewListViewController: EditingVС {
//    func setting() {
//
//    }
//}


extension OverviewListVC {
    func createNoteButton() {
        newNoteButton.setImage(UIImage(named: "pencil"), for: .normal)
        newNoteButton.backgroundColor = .lightOrange
        newNoteButton.rounded(radius: Constants.buttonHeight/2)
        newNoteButton.bounds.size = .init(width: Constants.buttonHeight,
                                             height: Constants.buttonHeight)
    }
}

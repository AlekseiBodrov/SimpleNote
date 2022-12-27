import UIKit
import RealmSwift

//MARK: - Delegate
protocol EditingVCDelegate: AnyObject {
    func save()
}

class EditingVC: UIViewController {
    //MARK: - static let
    static let identifier = "EditingVC"

    var titleNote: String = ""
    var contentNote: String = ""
    var indexPath: IndexPath?

    weak var delegate: EditingVCDelegate?

    //MARK: - IBOutlet
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!

    @IBOutlet weak var backBarButton: UIBarButtonItem!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!

    @IBAction func textFieldChanged(_ sender: UITextField) {
        titleNote = titleTextField.text!
    }


    //MARK: - life cycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        registerNotificationCenter()
        setRecognizer(with: .up)
        setRecognizer(with: .down)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if titleNote != "" || contentNote != "" {
            saveData()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    //MARK: - IBAction
    @IBAction func rigthBarButtonPressed(_ sender: UIBarButtonItem) {
        self.textView.resignFirstResponder()
    }

    //MARK: - flow funcs
    func getTextForNote() {
        print(#function)
        if let indexPath = self.indexPath {
            let notesArray: Results<Item> = RealmManager.shared.fetchData()
            let note = notesArray[indexPath.row]
            configureTextView(with: note.content ?? "")
            configureTextField(with: note.title ?? "")
        } else {
            configureTextView(with: Frase.newNote.rawValue.lacolized(), color: .lightGray)
            titleTextField.placeholder = Frase.header.rawValue.lacolized()
        }
    }

    private func saveData(){

        if indexPath != nil {
            let notes = RealmManager.shared.fetchData()
            RealmManager.shared.deletItem(with: notes[indexPath!.row])
        }

        RealmManager.shared.saveItem(with: getNoteForSaving())
        delegate?.save()
    }

    private func getNoteForSaving() -> Item {
        let note = Item()
        note.title = titleNote
        note.content = contentNote
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd.mm.yy"
        note.date = formatter.string(from: date)
        return note
    }
}

//MARK: - TextViewDelegate
extension EditingVC: UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print(#function)
        if contentNote.isEmpty {
            configureTextView(with: "")
        }
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        contentNote = textView.text
    }
}

//MARK: - private extension
private extension EditingVC {

    func configure() {
        getTextForNote()
        configureBarButtons()

        titleTextField.placeholder = titleNote
        titleTextField.backgroundColor = .gray
        titleTextField.textColor = .white

        view.backgroundColor = .darkGray
        textView.backgroundColor = .darkGray
        textView.textColor = .white

        textView.delegate = self
    }

    func configureBarButtons() {
        rightBarButton.title = Frase.done.rawValue.lacolized()
        backBarButton.title = Frase.back.rawValue.lacolized()
    }

    func setRecognizer(with direction: UISwipeGestureRecognizer.Direction) {
        let downSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRecognizerDetected))
        downSwipeRecognizer.direction = direction
        textView.addGestureRecognizer(downSwipeRecognizer)
    }

    @objc func swipeRecognizerDetected() {
        self.textView.resignFirstResponder()
    }

    func registerNotificationCenter () {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func updateTextView(param: Notification) {
        let userInfo = param.userInfo

        guard let getKeyboardRect = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        let keyboardFrame = self.view.convert(getKeyboardRect, to: view.window)

        if param.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0 , left: 0, bottom: keyboardFrame.height, right: 0)
            textView.scrollIndicatorInsets = textView.contentInset
        }
        textView.scrollRangeToVisible(textView.selectedRange)
    }

    func configureTextView(with text: String, color: UIColor = UIColor.white) {
        textView.text = text
        textView.textColor = color
    }

    func configureTextField(with text: String, color: UIColor = UIColor.white) {
        titleTextField.text = text
    }
}

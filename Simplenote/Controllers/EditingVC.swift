import UIKit
import RealmSwift

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
    @IBOutlet weak var textView: UITextView!

    @IBOutlet weak var backBarButton: UIBarButtonItem!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!

    //MARK: - life cycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureBarButtons()
        registerNotificationCenter()
        registerRecognizer(with: .up)
        registerRecognizer(with: .down)

        getTextForNote()
    }

    deinit {

        let note = Item()
        note.content = contentNote
        RealmManager.shared.saveItem(with: note)
        delegate?.save()

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
            configureText(with: note.content!)
        } else {
            configureText(with: Frase.newNote.rawValue.lacolized(), color: .lightGray)
            addAttributesInTextView()
        }
    }

    func addAttributesInTextView() {
        print(#function)
        let textStorage = textView.textStorage

        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
        let boldFontDescriptor = fontDescriptor.withSymbolicTraits(.traitBold)

        let boldFont = UIFont(descriptor: boldFontDescriptor!, size: 24)
        let normalFont = UIFont(descriptor: fontDescriptor, size: 20)

        let firstParagraph = textStorage.mutableString.paragraphRange(for: NSRange(location: 0, length: 0))
        let otherParagraphs = NSString(string: getNoteContent(text: textView.text))

        let titleNoteParagraphStyle = NSMutableParagraphStyle()
        let contentNoteParagraphsStyle = NSMutableParagraphStyle()

        textStorage.addAttribute(NSAttributedString.Key.paragraphStyle, value: titleNoteParagraphStyle, range: firstParagraph)
        textStorage.addAttribute(NSAttributedString.Key.font, value: boldFont, range: firstParagraph)

        if textView.text.contains("\n") {
            textStorage.addAttribute(NSAttributedString.Key.paragraphStyle, value: contentNoteParagraphsStyle, range: NSRange(location: firstParagraph.length - 1, length: otherParagraphs.length + 1))
            textStorage.addAttribute(NSAttributedString.Key.font, value: normalFont, range: NSRange(location: firstParagraph.length - 1, length: otherParagraphs.length + 1))
        }
    }

    private func getNoteTitle(text: String) -> String {
        print(#function)
        var firstParagraph: String
        if let endIndexOfFirstParagraph = text.firstIndex(of: "\n") {
            firstParagraph = String(text[..<endIndexOfFirstParagraph])
        } else {
            firstParagraph = text
        }
        return firstParagraph
    }

    private func getNoteContent(text: String) -> String {
        print(#function)
        var contentNote: String
        if let endIndexOfFirstParagraph = text.firstIndex(of: "\n") {
            let firstIndexOfContent = text.index(endIndexOfFirstParagraph, offsetBy: 1)
            contentNote = String(text[firstIndexOfContent...])
        } else {
            contentNote = ""
        }
        return contentNote
    }

}

extension EditingVC: UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print(#function)
        if contentNote.isEmpty {
            configureText(with: "")
        }
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        contentNote = textView.text
    }
}


private extension EditingVC {

    func configure() {
        view.backgroundColor = .darkGray
        textView.backgroundColor = .darkGray
        textView.textColor = .white

        textView.delegate = self
    }

    func configureBarButtons() {
        rightBarButton.title = Frase.done.rawValue.lacolized()
        backBarButton.title = Frase.back.rawValue.lacolized()
    }

    func registerRecognizer(with direction: UISwipeGestureRecognizer.Direction) {
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

    func configureText(with text: String, color: UIColor = UIColor.white) {
        textView.text = text
        textView.textColor = color
    }
}

import UIKit

class EditingVC: UIViewController {
    //MARK: - static let
    static let identifier = "EditingVC"

    var indexPath: IndexPath?
    var isOldNote = false

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

//        getTextForNote()
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

    func getTextForNote(note: Item) {
        print(#function)
        if isOldNote, indexPath != nil {
//            let note = note
//            textView.attributedText = note.content
        } else {
            textView.text = ""
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

        //Нужно для определения длинны первого параграфа и остальных параграфов
        let firstParagraph = textStorage.mutableString.paragraphRange(for: NSRange(location: 0, length: 0))
        let otherParagraphs = NSString(string: getNoteContent(text: textView.text))

        let titleNoteParagraphStyle = NSMutableParagraphStyle()
        let contentNoteParagraphsStyle = NSMutableParagraphStyle()

        //Атрибуты заголовка заметки (Первый абзац)
        textStorage.addAttribute(NSAttributedString.Key.paragraphStyle, value: titleNoteParagraphStyle, range: firstParagraph)
        textStorage.addAttribute(NSAttributedString.Key.font, value: boldFont, range: firstParagraph)

        //Атрибуты содержания заметки (Текст начиная со второго абзаца)
        if textView.text.contains("\n") {
            textStorage.addAttribute(NSAttributedString.Key.paragraphStyle, value: contentNoteParagraphsStyle, range: NSRange(location: firstParagraph.length - 1, length: otherParagraphs.length + 1))
            textStorage.addAttribute(NSAttributedString.Key.font, value: normalFont, range: NSRange(location: firstParagraph.length - 1, length: otherParagraphs.length + 1))
        }
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


private extension EditingVC {

    func configure() {
        view.backgroundColor = .darkGray
        textView.backgroundColor = .darkGray
        textView.textColor = .white
    }

    func configureBarButtons() {
        rightBarButton.title = "Done".lacolized()
        backBarButton.title = "Back".lacolized()
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
}

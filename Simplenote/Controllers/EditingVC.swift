import UIKit

class EditingVC: UIViewController {
    //MARK: - static let
    static let identifier = "EditingVC"

    //MARK: - IBOutlet
    @IBOutlet weak var textView: UITextView!

    @IBOutlet weak var backBarButton: UIBarButtonItem!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!

    //MARK: - life cycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()

        configureBarButtons()
        registerNotificationCenter()
        registerRecognizer(with: .up)
        registerRecognizer(with: .down)
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

    private func configureBarButtons() {
        rightBarButton.title = "Done".lacolized()
        backBarButton.title = "Back".lacolized()
    }

    private func registerRecognizer(with direction: UISwipeGestureRecognizer.Direction) {
        let downSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRecognizerDetected))
        downSwipeRecognizer.direction = direction
        textView.addGestureRecognizer(downSwipeRecognizer)
    }

    @objc func swipeRecognizerDetected() {
        self.textView.resignFirstResponder()
    }

    private func registerNotificationCenter () {
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

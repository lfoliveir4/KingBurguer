import UIKit

final class TextField: UIView {
    
    var placeholder: String? {
        willSet {
            editText.placeholder = newValue
        }
    }
    
    var returnKeyType: UIReturnKeyType = .default {
        willSet {
            editText.returnKeyType = newValue
        }
    }
    
    var text: String {
        get {
            return editText.text!
        }
    }
    
    var delegate: UITextFieldDelegate? {
        willSet {
            editText.delegate = newValue
        }
    }
    
    var failure: (() -> Bool)?
    
    var error: String?
    
    var heightConstraint: NSLayoutConstraint!
    
    let editText: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(editText)
        addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            editText.trailingAnchor.constraint(equalTo: trailingAnchor),
            editText.leadingAnchor.constraint(equalTo: leadingAnchor),
            editText.heightAnchor.constraint(equalToConstant: 50.0)
        ])
        
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: editText.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: editText.trailingAnchor),
            errorLabel.topAnchor.constraint(equalTo: editText.bottomAnchor)
        ])
        
        heightConstraint = heightAnchor.constraint(equalToConstant: 50)
        heightConstraint.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        guard let failure else { return }
        
        if let error {
            if failure() {
                errorLabel.text = error
                heightConstraint.constant = 70
            } else {
                errorLabel.text = ""
                heightConstraint.constant = 50
            }
        }
        
        layoutIfNeeded()
    }
}

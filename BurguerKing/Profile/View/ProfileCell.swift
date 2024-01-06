import UIKit

final class ProfileCell: UITableViewCell {
    static let identifier = "profileviewcell"
    
    var data: (String, String)! {
        willSet {
            leftLabel.text = newValue.0
            rightlabel.text = newValue.1
        }
    }
    
    private let leftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rightlabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightlabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            leftLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            leftLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            leftLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rightlabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            rightlabel.leadingAnchor.constraint(equalTo: leftLabel.trailingAnchor, constant: 10),
            rightlabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            rightlabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

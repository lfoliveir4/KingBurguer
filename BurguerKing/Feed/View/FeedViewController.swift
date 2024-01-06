import UIKit

final class FeedViewController: UIViewController {
    var sections: [Category] = []
    private var tableHeaderView: HighlightView!
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        
        table.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.cellIdentifier)
        table.backgroundColor = .systemBackground
        return table
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.backgroundColor = .systemBackground
        activity.startAnimating()
        return activity
    }()
    
    var viewModel: FeedViewModel? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.tabBarItem.title = "Inicio"
        navigationController?.tabBarItem.image = UIImage(systemName: "house")
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableHeaderView = HighlightView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 300))
        tableHeaderView.backgroundColor = .darkText
        tableHeaderView.delegate = self
        
        tableView.tableHeaderView = tableHeaderView
        tableView.delegate = self
        tableView.dataSource = self
        configureNavBar()
        
        viewModel?.fetch()
        viewModel?.fetchHighlight()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        activityIndicator.frame = view.bounds
    }
    
    private func configureNavBar() {
        navigationItem.title = "Produtos"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .red
        
        var image = UIImage(named: "icon")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "power"), style: .done, target: self, action: #selector(logoutDidTap)),
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
        ]
    }
    
    @objc private func logoutDidTap() {
        viewModel?.logout()
    }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FeedTableViewCell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.cellIdentifier, for: indexPath) as! FeedTableViewCell
    
        cell.products.append(contentsOf: sections[indexPath.section].products)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        220.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].name
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        header.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        header.textLabel?.textColor = .label
        header.textLabel?.frame = CGRect(
            x: header.bounds.origin.x,
            y: header.bounds.origin.y,
            width: 120,
            height: header.bounds.height
        )
    }
}

extension FeedViewController: FeedViewModelDelegate {
    func viewModelDidChange(state: FeedState) {
        switch state {
        case .loading:
            break
        case .success(let response):
            activityIndicator.stopAnimating()
            sections = response.categories
            tableView.reloadData()
            break
        case .successHighlight(let response):
            tableHeaderView.imageView.sd_setImage(with: URL(string: response.pictureURL))
            tableHeaderView.id = response.productId
            break
        case .error(let message):
            activityIndicator.stopAnimating()
            tableView.reloadData()
            break
        }
    }
}

extension FeedViewController: FeedCollectionViewDelegate {
    func itemSelected(productId: Int) {
        viewModel?.goToProductDetail(productId)
    }
}

extension FeedViewController: HighlightViewDelegate {
    func highlightSelected(productId: Int) {
        viewModel?.goToProductDetail(productId)
    }
}

#Preview {
    FeedViewController()
}

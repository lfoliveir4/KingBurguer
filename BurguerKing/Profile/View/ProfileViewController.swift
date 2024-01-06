import UIKit

final class ProfileViewController: UITableViewController {
    var data: [(String, String)] = []
    
    var viewModel: ProfileViewModel? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        
        self.tabBarItem.image = UIImage(systemName: "person.circle")
        self.tabBarItem.title = "Perfil"
        
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Perfil"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel?.state == .loading {
            viewModel?.fetch()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
        cell.data = data[indexPath.row]
        return cell
    }
}

extension ProfileViewController: ProfileViewModelDelegate {
    func viewModelDidChanged(state: ProfileState) {
        switch state {
        case .loading:
            break
        case .success(let response):
            DispatchQueue.main.async { [self] in
                buildProfile(response: response)
                tableView.reloadData()
            }
            break
        case .error(let message):
            print("error is \(message)")
            break
        }
    }
    
    private func buildProfile(response: ProfileResponse) {
        data.append(("Identificador", "\(response.id)"))
        data.append(("Nome", "\(response.name)"))
        data.append(("Email", "\(response.email)"))
        data.append(("Documento", "\(response.document)"))
        data.append(("Data de Nascimento", "\(response.birthday)"))
    }
}

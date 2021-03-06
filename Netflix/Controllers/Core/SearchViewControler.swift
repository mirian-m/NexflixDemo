import UIKit

class SearchViewControler: UIViewController {
    
    private var details = [Details]()
    
    let searchController: UISearchController = {
        var controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search Movie or TV Show "
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    private var discoveredTable: UITableView = {
        var table = UITableView()
        table.register(UpcomingCell.self, forCellReuseIdentifier: UpcomingCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        discoveredTable.dataSource = self
        discoveredTable.delegate = self
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        view.addSubview(discoveredTable)
        searchController.searchResultsUpdater = self
        fetchDiscoveredMovie()
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        discoveredTable.frame = view.bounds
    }
    
    func fetchDiscoveredMovie(){
        let url =  "\(Constant.baseURL)/3/discover/movie?api_key=\(Constant.API_Key)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
        APIColler.shared.fetchMovieFromAPI(url: url) { (result) in
            switch result{
            case .success(let movies):
                self.details = movies.details
                self.details.shuffle()
                DispatchQueue.main.async {[weak self] in
                    self?.discoveredTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
extension SearchViewControler: UITableViewDataSource, UITableViewDelegate, SearchResultViewControllerDelegat {
    func SearchResultViewControllerDidselet(with model: TrailerViewModel) {
        DispatchQueue.main.async {[weak self] in
                let vc = TrailerVideoViewController()
            vc.configure(with: model)
                self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingCell.identifier, for: indexPath) as? UpcomingCell else{return UITableViewCell()}
        let movie = details[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: movie.name  ?? movie.original_name ?? "I dont kwnow", posterUrl: movie.poster_path ?? ""))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        let title = details[indexPath.row].original_name ?? details[indexPath.row].name ?? ""
        let overview = details[indexPath.row].overview ?? ""
        APIColler.shared.getMovie(with: title + " trailer") { (result) in
            switch result{
            case .success(let result):
                DispatchQueue.main.async {[weak self] in
                    let vc = TrailerVideoViewController()
                    vc.configure(with: TrailerViewModel(movieTitle: title, overview: overview, youtubeId: result.items[0].id) )
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
}
extension SearchViewControler: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultViewController
        else {return}
        resultController.delegat = self
        APIColler.shared.search(with: query) { (result) in
            DispatchQueue.main.async {
                switch result{
                case .success(let movie):
                    resultController.details = movie.details
                    resultController.searchResultCollectionView.reloadData()
                case.failure(let error):
                    print(error)
                }
            }
        }
    }
}

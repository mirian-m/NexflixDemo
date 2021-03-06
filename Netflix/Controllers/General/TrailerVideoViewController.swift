import UIKit
import WebKit

class TrailerVideoViewController: UIViewController {
    private var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private var titleLb: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = .systemFont(ofSize: 22, weight: .bold)
        return lb
    }()
    
    private var overviewLb: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = .systemFont(ofSize: 18, weight: .regular)
        lb.numberOfLines = 0
        return lb
    }()
    private var downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Download", for: .normal)
        button.backgroundColor = .red
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 8
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(titleLb)
        view.addSubview(overviewLb)
        view.addSubview(downloadButton)
        setConstraints()
    }
    
    func setConstraints(){
//view.layoutMarginsGuide get constraint to safe area
        
        let webViewConstraint = [
            webView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: -40),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 500)
        ]
        let titleLbConstraint = [
            titleLb.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 10),
            titleLb.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ]
        let overviewLbconstraint = [
            overviewLb.topAnchor.constraint(equalTo: titleLb.bottomAnchor, constant: 10),
            overviewLb.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            overviewLb.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        let downloadButtonConstraint = [
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overviewLb.bottomAnchor, constant: 20),
            downloadButton.widthAnchor.constraint(equalToConstant: 140),
            downloadButton.heightAnchor.constraint(equalToConstant: 50)
        
        ]
        NSLayoutConstraint.activate(webViewConstraint)
        NSLayoutConstraint.activate(titleLbConstraint)
        NSLayoutConstraint.activate(overviewLbconstraint)
        NSLayoutConstraint.activate(downloadButtonConstraint)
    }
    
    func configure(with model: TrailerViewModel){
        self.titleLb.text = model.movieTitle
        self.overviewLb.text = model.overview
        guard let url = URL(string: "https://www.youtube.com/watch?v=\(model.youtubeId.videoId)") else{return}
        self.webView.load(URLRequest(url: url))
    }
}

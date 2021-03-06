import UIKit
class Poster: UIView {
    var posterUrl: String?
    
    private var playButton: UIButton = {
        var button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.black
        return button
    }()
    private var downloadButton: UIButton = {
        var button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.black
        return button
    }()
    
    private var posterView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(posterView)
        addSubview(playButton)
        addSubview(downloadButton)
        addButtonConstraints()
    }
    
    private func addButtonConstraints(){
        
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            playButton.widthAnchor.constraint(equalToConstant: 100),
        ]
        let downloadButtonConstraint = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            downloadButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraint)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterView.frame = bounds
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    func configure(with posterUrl: String){
        let url = Constant.PosterBaseURL + posterUrl
        posterView.getImageFromWeb(by: url)
    }
}

import UIKit

class FeedViewController: UIViewController {
    
    var feedView: FeedView
    
    init() {
        feedView = FeedView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

//
//  ImageViewController.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/12/22.
//

import UIKit
import ReactorKit
import SnapKit
import RxCocoa

final class ImageViewController : UIViewController, View {
    
    // MARK: properties
    var disposeBag : DisposeBag = .init()
    typealias Reactor = ImageReactor
    
    // MARK: UI
    private var imageSearchBar : UISearchBar = {
        let searchbar = UISearchBar(frame: .zero)
        searchbar.placeholder = "검색어를 입력하세요."
        searchbar.searchBarStyle = .prominent
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        return searchbar
    }()
    
    private var imageCollectionView : UICollectionView = {
        let layout: UICollectionViewFlowLayout = .init()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.bounces = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //MARK: initialize
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    //MARK: methods
    
    func configureUI(){
        
        view.backgroundColor = .white
        [imageSearchBar, imageCollectionView].forEach {
            view.addSubview($0)
        }
        
        let guide = view.safeAreaLayoutGuide
        imageSearchBar.snp.makeConstraints { make in
            make.top.equalTo(guide)
            make.leading.equalTo(guide)
            make.trailing.equalTo(guide)
        }
        
        let layout: UICollectionViewFlowLayout = .init()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let width = (view.frame.width ) / 3
        layout.itemSize = CGSize(width: width, height: width)
        imageCollectionView.collectionViewLayout = layout
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(imageSearchBar.snp.bottom)
            make.leading.equalTo(guide)
            make.trailing.equalTo(guide)
            make.bottom.equalTo(guide)
        }
    }
}

//MARK: Binding
extension ImageViewController {
    
    func bind(reactor: ImageReactor) {
        
        // action binding
        imageSearchBar.rx.text
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .filter { $0 != nil && $0?.isEmpty == false }
            .map { Reactor.Action.inputQuery($0!) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // state binding
        reactor.state
            .map { $0.imageList}
            .subscribe { list in
                print("Debug : state binding list -> \(list) ")
            }

    }
}

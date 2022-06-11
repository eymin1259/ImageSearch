//
//  SearchImageViewController.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/12/22.
//

import UIKit
import ReactorKit
import SnapKit
import RxCocoa
import RxDataSources
import RxOptional
import Loaf

final class SearchImageViewController : UIViewController, View {
    
    // MARK: properties
    typealias Reactor = SearchImageReactor
    var disposeBag : DisposeBag = .init()
    let collectionDataSource = RxCollectionViewSectionedReloadDataSource<ImageListSection> { datasource, collectionview, index, item in
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: SearchImageCell.id, for: index) as! SearchImageCell
        cell.setImage(with: item.thumbnail_url)
        return cell
    }
    struct Metric {
        static let lineSpacing : CGFloat = 2
        static let interitemSpacing : CGFloat = 2
        static let cellNumberPerRow : CGFloat = 3
        static let sectionInset : UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        static let itemSize : CGSize = .init(
            width: (UIScreen.main.bounds.width - (Metric.interitemSpacing * 2) ) / Metric.cellNumberPerRow,
            height: (UIScreen.main.bounds.width - (Metric.interitemSpacing * 2) ) / Metric.cellNumberPerRow
        )
    }
    
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
        layout.sectionInset = Metric.sectionInset
        layout.minimumLineSpacing = Metric.lineSpacing
        layout.minimumInteritemSpacing = Metric.interitemSpacing
        layout.itemSize = Metric.itemSize
        imageCollectionView.collectionViewLayout = layout
        imageCollectionView.register(SearchImageCell.self, forCellWithReuseIdentifier: SearchImageCell.id)
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(imageSearchBar.snp.bottom)
            make.leading.equalTo(guide)
            make.trailing.equalTo(guide)
            make.bottom.equalTo(guide)
        }
    }
}

//MARK: Binding
extension SearchImageViewController {
    
    func bind(reactor: SearchImageReactor) {
        
        // action binding
        imageSearchBar.rx.text
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .filter { $0 != nil && $0?.isEmpty == false }
            .map { Reactor.Action.inputQuery($0!) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        imageCollectionView.rx.isReachedBottom
            .map { Reactor.Action.loadMore }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // state binding
        reactor.state
            .map{$0.imageSection}
            .bind(to: imageCollectionView.rx.items(dataSource: collectionDataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.errResult }
            .filterNil()
            .subscribe(onNext: { [weak self] err in
                guard let this = self else {return}
                Loaf("\(err.localizedDescription)", state: .error,location: .bottom, sender: this).show()
            }).disposed(by: self.disposeBag)
    }
}

//
//  PhotoViewController.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/12/22.
//

import UIKit
import ReactorKit

class PhotoViewController : UIViewController, View {
    
    var disposeBag: DisposeBag = .init()
    typealias Reactor = PhotoReactor
    
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }

    
    func bind(reactor: PhotoReactor) {
        print("Debug : vc bind")
    }
    

}


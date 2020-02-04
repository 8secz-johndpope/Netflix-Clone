//
//  ContinueWatchingCell.swift
//  TableViews
//
//  Created by Mezut on 03/02/2020.
//  Copyright © 2020 Mezut. All rights reserved.
//

import UIKit
import Firebase




class ContinueWatchingCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var imageUrls =  [VideoData]()
    
    
    
    var homeScreen: HomeScreen?
    
    let InnerWatchinCellId = "InnerWatchinCellId"
    let padding: CGFloat = 18
    
    lazy var innerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        layout.scrollDirection = .horizontal
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = Colors.settingBg
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        innerCollectionView.register(InnerWatchingCell.self, forCellWithReuseIdentifier: InnerWatchinCellId)
        
        
        getFirebaseDatabase()
        setupLayout()
    }
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 4 + padding, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = innerCollectionView.dequeueReusableCell(withReuseIdentifier: InnerWatchinCellId, for: indexPath) as? InnerWatchingCell
        cell?.videoInformation = imageUrls[indexPath.row]
        return cell!
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        homeScreen?.goToVideoController(video: imageUrls[indexPath.item])
    }
    
    
    
    
    
    func getFirebaseDatabase(){
        
        
        let firebaseDatabase = Database.database().reference()
        firebaseDatabase.observeSingleEvent(of: .value) { (snapShot) in
            guard let dictionary = snapShot.value as? [String: [Dictionary<String,AnyObject>]] else {return }
            guard let firstItem = dictionary["Videocategories"] else {return}
            guard let videoSection = firstItem[1]["videoData"] else {return}
            guard let videoInformation = videoSection as? [Dictionary<String, AnyObject>] else {return}
            
            
            
            for item in videoInformation {
                
                guard let videoUrl = item["videoUrl"] as? String else {return}
                
                let singleVideo = VideoData()
                singleVideo.videoName = videoUrl
                self.imageUrls.append(singleVideo)
                
                
                
            }
            
            
            self.innerCollectionView.reloadData()
            
            
            
            
        }
        
    }
    
    func setupLayout(){
        
        
        addSubview(innerCollectionView)
        
        NSLayoutConstraint.activate([
            
            innerCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            innerCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            innerCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            innerCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            
            
            ])
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

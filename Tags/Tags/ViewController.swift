//
//  ViewController.swift
//  Tags
//
//  Created by Tatevik Tovmasyan on 5/26/20.
//  Copyright © 2020 Helix Consulting LLC. All rights reserved.
//

import UIKit
import Kingfisher

struct Tags {
    let title: String
    let imageURL: String
    var image: UIImage?
    
    func adapt(image: UIImage?) -> Tags {
        return Tags(
            title: self.title,
            imageURL: self.imageURL,
            image: image
        )
    }
    
    func load(completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: imageURL) else {
            completion(nil)
            return
        }
        KingfisherManager.shared.retrieveImage(with: imageURL) { result in
            switch result {
            case .success(let resultImage):
                completion(resultImage.image)
            case .failure(let error):
                completion(nil)
            }
        }
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var tagCells: [TagCollectionViewCell] = []
    var tags: [String] = ["Fix you",
                             "Burn my bridges down",
                             "Lose Somebody",
                             "Paradise",
                             "Paris in the rain",
                             "Lights will guide you home",
                             "Who are you?",
                             "Fake love",
                             "Better days",
                             "Doin time",
                             "Lost on you",
                             "Monster",
                             "Say something I am giving up on you",
                             "AI",
                             "Tear",
                             "Ugh",
                             "Take my hand now",
                             "Ocean eyes",
                             "Bellyache",
                             "Lie",
                             "Mama",
                             "Mocking birdMocking birdMocking birdMocking birdMocking birdMocking birdMocking birdMocking birdMocking birdMocking birdMocking bird",
                             "Demian",
                             "Thank u, next",
                             "Demons",
                             "Do I wanna know?"]
    
    let images = [
        "https://staging-image.fptplay.net/media/photo/OTT/2024/04/23/star23-04-2024_10g02-45.png",
        "https://images.fptplay.net/media/photo/OTT/2024/04/23/douban23-04-2024_10g02-05.png",
        "https://images.fptplay.net/media/photo/OTT/2024/04/23/imdb-123-04-2024_10g02-27.png"
    ]
    
    var tagsData: [Tags] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tagsData = makeTags()
        
        self.configCollectionView()
        
        loadAllImage { [weak self] in
            self?.configCells()
        }
    }
    
    func makeTags() -> [Tags] {
        return (tags.shuffled() + tags + tags).compactMap({ title in
            guard let image = images.randomElement() else {
                return nil
            }
            return Tags(
                title: title,
                imageURL: image
            )
        })
    }
    
    func loadAllImage(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        for (index, item) in tagsData.enumerated() {
            group.enter()
            item.load { [weak self] image in
                guard let self = self else {
                    group.leave()
                    return
                }
                
                self.tagsData[index] = tagsData[index].adapt(image: image)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
    func configCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "default")
        self.collectionView.setCollectionViewLayout(UICollectionViewFlowLayout(), animated: false)
    }
    
    func configCells() {
        self.tagCells = tagsData.enumerated().map({ (index, option) -> TagCollectionViewCell in
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: IndexPath(item: index, section: 0)) as! TagCollectionViewCell
            cell.config(tag: option)
            return cell
        })
        
        let optimalCells = self.collectionView.getOptimalCells(self.tagCells, maxWidth: UIScreen.main.bounds.width)
        self.tagCells = optimalCells.reduce(into: [TagCollectionViewCell](), { (cells, resultCells) in
            cells.append(resultCells)
        }) as! [TagCollectionViewCell]
        self.collectionView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        configCells()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tagCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.tagCells[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = tagCells[indexPath.item]
        return cell.intrinsicContentSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
}

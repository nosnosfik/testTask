//
//  CollectionViewController.swift
//  Newsly
//
//  Created by Nikita Taranov on 10/23/16.
//  Copyright © 2016 Nikita Taranov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private let reuseIdentifier = "newsSouceCell"

private let url =  URL(string:"https://newsapi.org/v1/sources")

private let itemsPerRow: CGFloat = 2

private var sources = [[String:AnyObject]]()

private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

extension CollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    
}

extension CollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        collectionView.reloadData()
        return sources.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! SourceViewCell
        var dict = sources[indexPath.row]
        let dict1 = dict["urlsToLogos"] as? Dictionary<String,AnyObject>
        let imgLogoURL = dict1?["small"] as? String
        if let url = NSURL(string: imgLogoURL!) {
            if let data = NSData(contentsOf: url as URL) {
                cell.sourceImage.image = UIImage(data: data as Data)
            }
        }
        
        
        return cell
    }
    
}

class CollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(url!).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let jsonVar = JSON(responseData.result.value!)
                
                if let resData = jsonVar["sources"].arrayObject {
                    sources = resData as! [[String:AnyObject]]
                }
                if sources.count > 0 {
                    self.collectionView?.reloadData()
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

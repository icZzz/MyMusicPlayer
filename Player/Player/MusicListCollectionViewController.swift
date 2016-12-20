//
//  MusicListCollectionViewController.swift
//  Player
//
//  Created by 趙傳龍 on 2016/10/8.
//  Copyright © 2016年 Huan. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import MediaPlayer

private let reuseIdentifier = "ioCell"

class MusicListCollectionViewController: UICollectionViewController {
    
    var mp3Datas :[String] = []
    var mp3Data: [String : Any] = [:]
    
    
    
    var dataCener = HWDataCenter.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch{
            print("error \(error)")
        }
        
        mp3Datas = dataCener.musicList
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little l,
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //根据点击的cell，获取对应的音乐数据
        let cell = sender as! MusicCollectionViewCell
        let indexPath = self.collectionView?.indexPath(for: cell)
        
        let playerViewController: MusicPlayerViewController = segue.destination as! MusicPlayerViewController
        playerViewController.modalPresentationStyle = UIModalPresentationStyle.custom
        playerViewController.view.superview?.bounds = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        playerViewController.indexRow = (indexPath?.row)!
    }


    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return mp3Datas.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MusicCollectionViewCell
        
        let path = mp3Datas[indexPath.row]
        //后续做缓存处理
        let dic = dataCener.getMusicInfo(path)
        cell.mp3ImageView.image    = dic["image"] as! UIImage?
        cell.mp3Name.text          = dic["title"] as! String?
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

// MARK - AVAudioPlayerDelegate
extension MusicListCollectionViewController: AVAudioPlayerDelegate{
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
       print("error \(error.debugDescription)")
    }
}

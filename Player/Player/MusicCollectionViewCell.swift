//
//  MusicCollectionViewCell.swift
//  Player
//
//  Created by 趙傳龍 on 2016/10/8.
//  Copyright © 2016年 Huan. All rights reserved.
//

import UIKit

class MusicCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mp3ImageView: UIImageView!
    @IBOutlet weak var mp3Name: UILabel!
    
    var _musicPath: String = ""
    var dic = [String : Any]()
    var musicPath :String {
        
        get{
            return _musicPath
        }
        set (newVal) {
            if _musicPath == ""{
                _musicPath = newVal
                dic = HWDataCenter.sharedInstance.getMusicInfo(_musicPath)
            }
            self.mp3ImageView.image     = dic["image"] as! UIImage?
            self .mp3Name.text          = dic["title"] as! String?
        }
    }
}

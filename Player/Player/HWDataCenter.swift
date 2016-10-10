//
//  HWDataCenter.swift
//  Player
//
//  Created by 趙傳龍 on 2016/10/10.
//  Copyright © 2016年 Huan. All rights reserved.
//

import UIKit
import AVFoundation

class HWDataCenter: NSObject {
    
    static let sharedInstance = HWDataCenter()
    
    //歌曲路径数组
    var musicList = [[String:Any]]()
    
    //获取文件共享路径下的文件
    func getPlayerData() -> [[String:Any]]{
        
        let fm = FileManager.default
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if paths.count > 0 {
            
            let documentsDirectory = paths[0] as String
            do {
                
                let files = try fm.contentsOfDirectory(atPath: documentsDirectory)
                for file in files {
                    var mp3Datas = [String : Any]()
                    
                    print(file)
                    //将其中的mp3文件加入array
                    if file.hasSuffix(".mp3"){
                        let fileFullDocPath = self.getDocumentsPathOfFile(file)
                        
                        mp3Datas["mp3Path"] = fileFullDocPath
                        //获取mp3中的信息
                        let avUrlAsset = AVURLAsset.init(url: URL.init(fileURLWithPath: fileFullDocPath))
                        for item in avUrlAsset.metadata {
                            
                            guard let key = item.commonKey, let value = item.value else{
                                continue
                            }
                            
                            switch key {
                            case "title" : mp3Datas["title"]    = value as? String
                            case "artist": mp3Datas["artist"]   = value as? String
                            case "artwork": mp3Datas["image"]   = UIImage(data: (value as! NSData) as Data)
                            default:
                                continue
                            }
                        }
                    }
                    
                    musicList += [mp3Datas]
                }
            }   catch {
                
            }
        }
     return musicList
    }
    
    //获取歌曲的根路径
    func getDocumentsPathOfFile(_ fileName: String) -> String {
        
        let documentsPath = NSHomeDirectory().appending("/Documents/")
        let fm = FileManager.default
        var filePath: String = ""
        if fm.fileExists(atPath: documentsPath) {
            filePath = documentsPath.appending(fileName)
        }else{
            print("Documents目录不存在")
        }
        return filePath
    }
    
    //包括文件路径以及文件名
    func getMusicLists() -> [[String:Any]] { return musicList }
}

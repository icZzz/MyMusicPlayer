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
    
    var musicList = [String]()
    
    
    private override init() {
        super.init()
        musicList = self.getPlayerList()
    }
    
    //获取音乐数据
    func getMusicData(_ data:Data) {
        
        _ = "iczzz"
    }
    
    //根据歌曲路径获取歌曲的信息
    func getMusicInfo(_ path:String) -> [String:Any] {
        
        var mp3Datas = [String : Any]()
        //获取mp3中的信息
        let avUrlAsset = AVURLAsset.init(url: URL.init(fileURLWithPath: path))
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
        return mp3Datas
    }
    
    //获取文件共享路径下的文件
    private func getPlayerList() -> [String]{
        
        var lists = [String]()
        
        let fm = FileManager.default
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if paths.count > 0 {
            
            let documentsDirectory = paths[0] as String
            do {
                
                let files = try fm.contentsOfDirectory(atPath: documentsDirectory)
                for file in files {
                    
                    print(file)
                    //将其中的mp3文件加入array
                    if file.hasSuffix(".mp3"){
                        lists += [self.getDocumentsPathOfFile(file)]
                    }
                }
            }   catch {}
        }
     return lists
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
}

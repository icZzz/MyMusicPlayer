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

private let reuseIdentifier = "ioCell"

class MusicListCollectionViewController: UICollectionViewController {
    
    //音乐播放器
    var player: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch{
            print("error \(error)")
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.getPlayerData()
    }
    
    func getMp3Data() {
        let fm = FileManager.default
        let bundlePath = Bundle.main.bundlePath
        
        let file: [String] = try! fm.contentsOfDirectory(atPath: bundlePath)
        
        for fileName in file {
         
            let fileFullDocPath = self.getDocumentsPathOfFile(fileName)
            
            if fileFullDocPath.hasSuffix(".mp3") {
                
                self.createAudioPlayer(fileFullDocPath)
            }
        }
    }
    
    func getPlayerData(){
        
        let fm = FileManager.default
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if paths.count > 0 {
            let documentsDirectory = paths[0] as String
//            let documentUrl = NSURL(fileURLWithPath: documentsDirectory, isDirectory: true)
            do {
                
                let files = try fm.contentsOfDirectory(atPath: documentsDirectory)
                for file in files {
//                   print("file \(file)")
                    let fileFullDocPath = self.getDocumentsPathOfFile(file)
                    self.createAudioPlayer(fileFullDocPath)
                }
            }   catch {
                
            }
        }
    }
    
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
    
    func createAudioPlayer(_ musicPath: String){
        
        //创建播放器
//        let path = Bundle.main.path(forResource: "Beyond.mp3", ofType:nil)!
        let url: URL = URL.init(fileURLWithPath: musicPath)
        print("url\(url)")
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
        } catch {
            print(error)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 30
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MusicCollectionViewCell
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("sss \(indexPath.row)")
    }

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

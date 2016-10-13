//
//  MusicPlayerViewController.swift
//  Player
//
//  Created by 趙傳龍 on 2016/10/10.
//  Copyright © 2016年 Huan. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

//播放器的状态
enum MusicPlayerStatus: Int{
    case none
    
    case playerPlay
    
    case playerPause
    
    case playerNext
    
    case playerPrevious
}

class MusicPlayerViewController: UIViewController {
    
    @IBOutlet weak var musicImageView: UIImageView!
    @IBOutlet weak var musicTitle: UILabel!
    @IBOutlet weak var musicArtist: UILabel!
    @IBOutlet weak var playButton: UIButton!

    //音乐播放器
    var player: AVAudioPlayer!
    
    //音乐数据所在数组的位置
    var indexRow :Int = 0
    var musicLists = HWDataCenter.sharedInstance.musicList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setPlayerInfo(musicLists[indexRow])
    }
    
    
    // MARK: - AVAudioPlayer
    func createAudioPlayer(_ musicPath: String){

        let url: URL = URL.init(fileURLWithPath: musicPath)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            player.prepareToPlay()
            player.play()
        } catch {
            print("播放失败: \(error)")
        }
    }
    
    func setPlayerInfo(_ musicPath:String) {
        
        //创建播放器
        self.createAudioPlayer(musicPath)
        
        let dic = HWDataCenter.sharedInstance.getMusicInfo(musicPath)
        self.setLockView(dic)
        
        musicImageView.image    = dic["image"] as! UIImage?
        musicTitle.text         = dic["title"] as! String?
        musicArtist.text        = dic["artist"] as! String?
    }
    
    
    //设置锁屏界面
    func setLockView(_ musicData:[String:Any]){
        
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            //演唱者
            MPMediaItemPropertyArtist : musicData["artist"] as! String,
            //歌曲名称
            MPMediaItemPropertyTitle : musicData["title"] as! String,
            
            MPNowPlayingInfoPropertyPlaybackRate:1.0,
            // 总时长
            MPMediaItemPropertyPlaybackDuration:player.duration,
            // 当前时间
            MPNowPlayingInfoPropertyElapsedPlaybackTime:player.currentTime
        ]
        
        //如果存在封面，传递给控制面板
        if((musicData["image"]) != nil){
           MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] = MPMediaItemArtwork.init(image: musicData["image"] as! UIImage)
        }
    }
    
    //锁屏界面的事件接收
    override func remoteControlReceived(with event: UIEvent?) {
        
        let type = event?.subtype
        switch type! {
        case .remoteControlPlay:            self.setPlayerStatus(.playerPlay)
        case .remoteControlPause:           self.setPlayerStatus(.playerPause)
        case .remoteControlNextTrack:       self.setPlayerStatus(.playerNext)
        case .remoteControlPreviousTrack:   self.setPlayerStatus(.playerPrevious)
        default:
            print("none")
        }
    }
    
    //设置player状态
    func setPlayerStatus(_ status:MusicPlayerStatus) {
        
        switch status {
        case .playerPlay:       player.play(); playButton.isSelected = false
        case .playerPause:      player.pause(); playButton.isSelected = true
        case .playerNext:       self.setPlayerInfo(musicLists[self.changeIntValue(true)])
        case .playerPrevious:   self.setPlayerInfo(musicLists[self.changeIntValue(false)])
        default:
            print("未知命令")
        }
    }
    
    // MARK: - Button Click Event
    
    @IBAction func playOrPuse(_ sender: UIButton) {
        if sender.isSelected{
            self.setPlayerStatus(.playerPlay)
        }else{
           self.setPlayerStatus(.playerPause)
        }
    }

    @IBAction func nextMusicClick(_ sender: UIButton) {
        self.setPlayerStatus(.playerNext)
    }
    @IBAction func previousMusicClick(_ sender: UIButton) {
        self.setPlayerStatus(.playerPrevious)
    }
    
    func changeIntValue(_ add:Bool) -> Int{
        
        if add{
            if(indexRow == musicLists.count - 1){
                indexRow = -1
            }
            indexRow += 1
        }else{
            
            if(indexRow == 0){
                indexRow = musicLists.count
            }
            indexRow -= 1
        }
        
        return indexRow
    }
}

// MARK: - AVAudioPlayerDelegate
extension MusicPlayerViewController: AVAudioPlayerDelegate{
    
    //当播放器歌曲结束的时候，调用的函数
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.setPlayerStatus(.playerNext)
    }
}



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

class MusicPlayerViewController: UIViewController {
    
    @IBOutlet weak var musicImageView: UIImageView!
    @IBOutlet weak var musicTitle: UILabel!
    @IBOutlet weak var musicArtist: UILabel!

    //音乐播放器
    var player: AVAudioPlayer!
    
    //音乐数据
    var musicData :[String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //创建播放器
        self.createAudioPlayer(musicData["mp3Path"] as! String)
        self.setLockView(musicData)
        
        // Do any additional setup after loading the view.
        musicImageView.image = musicData["image"] as! UIImage?
        musicTitle.text = musicData["title"] as! String?
        musicArtist.text = musicData["artist"] as! String?
    }
    
    
    // MARK: - AVAudioPlayer
    func createAudioPlayer(_ musicPath: String){
        
        //创建播放器
        let url: URL = URL.init(fileURLWithPath: musicPath)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
        } catch {
            print("播放失败: \(error)")
        }
    }
    
    //设置锁屏界面
    func setLockView(_ musicData:[String:Any]){
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            //演唱者
            MPMediaItemPropertyArtist : musicData["artist"] as! String,
            //歌曲名称
            MPMediaItemPropertyTitle : musicData["title"] as! String,
            // 锁屏图片
            MPMediaItemPropertyArtwork:MPMediaItemArtwork.init(image: musicData["image"] as! UIImage),
            MPNowPlayingInfoPropertyPlaybackRate:1.0,
            // 总时长
            MPMediaItemPropertyPlaybackDuration:player.duration,
            // 当前时间
            MPNowPlayingInfoPropertyElapsedPlaybackTime:player.currentTime
        ]
    }
    
    
    @IBAction func playOrPuse(_ sender: UIButton) {
        if sender.isSelected{
            player.play()
        }else{
           player.pause()
        }
        
        sender.isSelected = !sender.isSelected
    }

    @IBAction func nextMusicClick(_ sender: UIButton) {
        
        
    }
    @IBAction func previousMusicClick(_ sender: UIButton) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

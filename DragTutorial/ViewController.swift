//
//  ViewController.swift
//  DragTutorial
//
//  Created by 輝幸友金 on 2015/11/09.
//  Copyright © 2015年 wimmity. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    let currentImageView = UIImageView()
    let appFrameSize: CGSize = UIScreen.mainScreen().bounds.size
    var imageOldCareView: Array<UIImageView> = []
    
    var touchPoint: CGPoint?
    var isContorolImageCurrentCardView = false
    var startImagePoint: CGPoint?
    var currentImagePoint: CGPoint?
    var startTouchPoint: CGPoint?
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        ボタンを生成するよ
        let btn: UIButton = UIButton()
        btn.frame = CGRectMake(0, 0, 50, 40)
        btn.center = CGPointMake(appFrameSize.width/2 - 100, appFrameSize.height/2)
        btn.backgroundColor = UIColor.blackColor()
        btn.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn)
        
//        空のUIImageViewの生成〜
        currentImageView.image = UIImage(named: "")
        currentImageView.frame = CGRectMake(0, 0, 128, 128)
        currentImageView.center = CGPointMake(appFrameSize.width/2, appFrameSize.height/2)
        currentImageView.userInteractionEnabled = true
        currentImageView.tag = 999
        self.view.addSubview(currentImageView)
        
    }
    
/**
     set button action.
     
     @param sender UIButton
*/
    func btnAction(sender: UIButton){
        
        let initialPoint = CGPointMake(appFrameSize.width/2, appFrameSize.height/2)       //center座標格納変数point作成 (初期値に戻す)
        let initialSize = CGSizeMake(100, 100)
        currentImageView.contentMode = UIViewContentMode.ScaleToFill        //contentModeを変更
        displayImageCardViewWithPoint(initialPoint, size: initialSize, imgName: "imgres.jpg", imageView: currentImageView, isCurrentMode: true)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    画像が押され始めた時
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        touchPoint = touch.locationInView(self.view)
        let tag = touch.view!.tag
        startTouchPoint = touchPoint
        
        if tag == 999 {
            let size = CGSizeMake(100, 100)
            currentImageView.contentMode = UIViewContentMode.ScaleAspectFill
            displayImageCardViewWithPoint(touchPoint!, size: size, imgName: "imgres.jpg", imageView: currentImageView, isCurrentMode: true)
            
        } else if tag > 0 {
            startImagePoint = imageOldCareView[tag - 1].center
            self.view.bringSubviewToFront(imageOldCareView[tag - 1])
        } else {
//            Do nothing
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchEvent = touches.first!
        
        let tag  = touchEvent.view!.tag
        
        let deltaX = touchEvent.locationInView(self.view).x - startTouchPoint!.x //タッチの移動量を計算
        let deltaY = touchEvent.locationInView(self.view).y - startTouchPoint!.y //タッチの移動量を計算

        //tagに対応したcardViewを動かす
        if tag == 999 {
            currentImageView.center.x = startTouchPoint!.x + deltaX
            currentImageView.center.y = startTouchPoint!.y + deltaY
            
        } else if tag > 0 {
            imageOldCareView[tag - 1].center.x = startImagePoint!.x + deltaX
            imageOldCareView[tag - 1].center.y = startImagePoint!.y + deltaY
            
        } else {
            //Do nothing
        }
        
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        touchPoint = touch.locationInView(self.view)
        let tag = touch.view!.tag
        
        if tag == 999{
            
            //1. imageCurrectCardViewを初期状態に戻す
            let initialPoint = CGPointMake(appFrameSize.width/2, appFrameSize.height/2)       //center座標格納変数point作成 (初期値に戻す)
            let initialSize = CGSizeMake(0, 0)             //サイズ格納用変数size作成 (初期値に戻す)
            currentImageView.contentMode = UIViewContentMode.ScaleToFill        //contentModeを変更
            displayImageCardViewWithPoint( initialPoint,
                size: initialSize,
                imgName: "",
                imageView: currentImageView,
                isCurrentMode:false)          //cardViewを見える化(コレは厳密に言うと見えない化...)関数を実行
            self.view.sendSubviewToBack(currentImageView)                       //imageCurrectCardViewは最背面へ
            
            
            //2. imageCurrectCardViewをimageOldCardViewArrayに格納する（ようなイメージの処理）
            var img = UIImage(named: " ")
            imageOldCareView.append(UIImageView(image:img))                    //imageOldCardViewArrayに要素を追加
            let count = imageOldCareView.count                                 //imageOldCardViewArrayの数を保存
            let size = CGSizeMake(100, 100)                                                 //サイズ格納用変数size作成
            
            imageOldCareView[count - 1].contentMode = UIViewContentMode.ScaleAspectFit //contentModeを変更
            imageOldCareView[count - 1].tag = count                                    //配列番号でタグ付け
            displayImageCardViewWithPoint(touchPoint!,
                size: size,
                imgName: "imgres.jpg",
                imageView: imageOldCareView[count - 1],
                isCurrentMode: false)                  //cardViewを見える化関数を実行
            self.view.addSubview(imageOldCareView[count - 1])                          //画像生成
            
            imageOldCareView[count - 1].userInteractionEnabled = true
            
        } else {
            //            Do nothing
        }
    }
    
    /**
     image is setted this method
     
     - point: set place point
     - size: set image size
     - imgName: set path of image.
     - imageView: imageview.
     - isCurrentMode: recycle image.
     
     */
    func displayImageCardViewWithPoint(point: CGPoint, size: CGSize, imgName: String, imageView: UIImageView, isCurrentMode: Bool){
        imageView.frame.size = size
        imageView.center = point
        imageView.image = UIImage(named: imgName)
        isContorolImageCurrentCardView = isCurrentMode
        self.view.bringSubviewToFront(imageView)
        
    }


}


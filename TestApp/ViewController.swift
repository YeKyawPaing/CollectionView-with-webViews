//
//  ViewController.swift
//  TestApp
//
//  Created by TatsuMurasaki on 20/9/17.
//  Copyright © 2017 YeKyawPaing. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIWebViewDelegate {
    
    @IBOutlet var addBtn: UIButton!
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var prevBtn: UIButton!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var emptyState: UIView!
    var modifiedIndexPath : Int = 0
    var indexArray : NSMutableArray = [0,1,2]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //For Empty State
        self.emptyState.frame = CGRect(x: 0, y: 74, width: self.view.frame.width, height: 561)
        self.emptyState.removeFromSuperview()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
        layout.minimumLineSpacing = 35
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView!.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.lightGray
        
        self.prevBtn.alpha = 0.3
        self.prevBtn.isUserInteractionEnabled = false
        
        self.collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Collection View Deletegate and Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(indexArray.count == 0)
        {
            self.deleteBtn.alpha = 0.5
            self.deleteBtn.isUserInteractionEnabled = false
            
            self.emptyState.frame = CGRect(x: 0, y: 74, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(self.emptyState)
            self.emptyState.superview?.bringSubview(toFront: self.emptyState)
            self.bottomView.superview?.bringSubview(toFront: self.bottomView)
        }
        return indexArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCollectionViewCell
        
        let localfilePath = Bundle.main.url(forResource: "randomGenerator", withExtension: "html");
        let myRequest = URLRequest(url: localfilePath!);
        cell.webView.loadRequest(myRequest);
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.size.width, height: self.view.frame.size.height)
    }
    
    //MARK: - Auto Scroll
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            
            let autoScrollString = getCurrentOffset()
            let autoScrollInteger = (autoScrollString as NSString).integerValue
            
            let toScroll = IndexPath(row: autoScrollInteger, section: 0)
            self.collectionView.scrollToItem(at: toScroll, at: .centeredHorizontally, animated: true)
            
            if(autoScrollInteger != 0)
            {
                self.prevBtn.alpha = 1
                self.prevBtn.isUserInteractionEnabled = true
                
                if(autoScrollInteger < self.indexArray.count - 1)
                {
                    self.nextBtn.alpha = 1
                    self.nextBtn.isUserInteractionEnabled = true
                }
                else{
                    self.nextBtn.alpha = 0.3
                    self.nextBtn.isUserInteractionEnabled = false
                }
            }
            else
            {
                self.prevBtn.alpha = 0.3
                self.prevBtn.isUserInteractionEnabled = false
                
                self.nextBtn.alpha = 1
                self.nextBtn.isUserInteractionEnabled = true
            }
        }
    }
    
    //MARK: - Button Actions
    @IBAction func deletePressed(_ sender: Any) {
        if(indexArray.count != 0)
        {
            let deleteString = getCurrentOffset()
            let deleteInteger = (deleteString as NSString).integerValue
            
            modifiedIndexPath = deleteInteger
            indexArray.removeObject(at: modifiedIndexPath)
            
            if(deleteInteger == 0)
            {
                self.prevBtn.alpha = 0.3
                self.prevBtn.isUserInteractionEnabled = false
            }
            else if(deleteInteger == indexArray.count - 1)
            {
                self.nextBtn.alpha = 0.3
                self.nextBtn.isUserInteractionEnabled = false
            }
            
            if(indexArray.count == 1)
            {
                self.prevBtn.alpha = 0.3
                self.prevBtn.isUserInteractionEnabled = false
                
                self.nextBtn.alpha = 0.3
                self.nextBtn.isUserInteractionEnabled = false
            }
            
            collectionView!.reloadData()
        }
    }
    
    @IBAction func addPressed(_ sender: Any) {
        //To add button delay time
        self.addBtn.isEnabled = false
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ViewController.enableButton), userInfo: nil, repeats: false)
        
        if(indexArray.count == 0)
        {
            self.deleteBtn.alpha = 1
            self.deleteBtn.isUserInteractionEnabled = true
            
            indexArray.add(0)
            self.emptyState.removeFromSuperview()
        }
        else
        {
            self.prevBtn.alpha = 1
            self.prevBtn.isUserInteractionEnabled = true
            
            let addString = getCurrentOffset()
            let addInteger = (addString as NSString).integerValue + 1
            indexArray.add(addInteger)
            
            self.collectionView.reloadData()
            
            let toScroll = IndexPath(row: addInteger, section: 0)
            self.collectionView.scrollToItem(at: toScroll, at: .centeredHorizontally, animated: true)
        }
        self.collectionView.reloadData()
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        self.prevBtn.alpha = 1
        self.prevBtn.isUserInteractionEnabled = true
        
        let nextBtnString = getCurrentOffset()
        var nextBtnInteger = (nextBtnString as NSString).integerValue
        
        if(nextBtnInteger < self.indexArray.count - 1)
        {
            nextBtnInteger += 1
            
            self.nextBtn.alpha = 1
            self.nextBtn.isUserInteractionEnabled = true
            
            if(nextBtnInteger == self.indexArray.count - 1)
            {
                self.nextBtn.alpha = 0.3
                self.nextBtn.isUserInteractionEnabled = false
            }
            
            let toScroll = IndexPath(row: nextBtnInteger, section: 0)
            self.collectionView.scrollToItem(at: toScroll, at: .centeredHorizontally, animated: true)
        }
    }
    
    @IBAction func previousPressed(_ sender: Any) {
        self.nextBtn.alpha = 1
        self.nextBtn.isUserInteractionEnabled = true
        
        let prevBtnString = getCurrentOffset()
        var prevBtnInteger = (prevBtnString as NSString).integerValue
        
        if(prevBtnInteger != 0){
            prevBtnInteger -= 1
            self.prevBtn.alpha = 1
            self.prevBtn.isUserInteractionEnabled = true
            
            if(prevBtnInteger == 0)
            {
                self.prevBtn.alpha = 0.3
                self.prevBtn.isUserInteractionEnabled = false
            }
            
            let toScroll = IndexPath(row: prevBtnInteger, section: 0)
            self.collectionView.scrollToItem(at: toScroll, at: .centeredHorizontally, animated: true)
        }
    }
    
    //MARK: - Get Current Offset
    func getCurrentOffset() -> String
    {
        var finalString = ""
        var currentCellOffset = self.collectionView.contentOffset
        currentCellOffset.x += self.collectionView.frame.width / 2
        
        if let indexPath = self.collectionView.indexPathForItem(at: currentCellOffset) {
            let toString = "\(indexPath)"
            let range = toString.range(of: "(?<=,)[^.]+(?=])", options:.regularExpression)
            let found = toString.substring(with: range!)
            finalString = String(describing: found)
        }
        return finalString
    }
    
    //MARK: - Set Button Delay
    func enableButton() {
        self.addBtn.isEnabled = true
    }
}

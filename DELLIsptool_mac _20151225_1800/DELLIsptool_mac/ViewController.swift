//
//  ViewController.swift
//  DELLIsptool_mac
//
//  Created by MNT-FW on 2015/11/22.
//  Copyright © 2015年 MNT-FW. All rights reserved.
//

import Cocoa
import Foundation
import AppKit
import QuartzCore

class browseColor : NSButton {
    var fontColor: NSColor! {
        didSet {
            
        }
    }
    
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)!
        
    }
}
@available(OSX 10.11, *)
class ViewController: NSViewController {
    @IBOutlet weak var tabView: NSTabView!
    @IBOutlet weak var tabVItem_initial: NSTabViewItem!
    @IBOutlet weak var tabVItem_isp: NSTabViewItem!
    @IBOutlet weak var dellLog: NSImageView!
    @IBOutlet weak var filePath: NSTextField!
    @IBOutlet weak var modelNo: NSTextField!
    @IBOutlet weak var currentFW: NSTextField!
    @IBOutlet weak var newFW: NSTextField!
    @IBOutlet weak var fileCKS: NSTextField!
    @IBOutlet weak var modelNoValue: NSTextField!
    @IBOutlet weak var filePathValue: NSTextField!
    @IBOutlet weak var currentFWValue: NSTextField!
    @IBOutlet weak var newFWValue: NSTextField!
    @IBOutlet weak var fileCKSValue: NSTextField!
    @IBOutlet weak var updateStatus: NSTextField!
    @IBOutlet weak var msgIcon: NSImageView!
    @IBOutlet weak var msgIcon2: NSImageView!
    @IBOutlet weak var browseButton: NSButton!
    @IBOutlet weak var updateButton: NSButton!
    @IBOutlet weak var closeWinButton: NSButton!
    @IBOutlet weak var zoomWinButton: NSButton!
    @IBOutlet weak var helpWinButton: NSButton!
    @IBOutlet weak var deIspBar: NSProgressIndicator!
    @IBOutlet weak var ispStatusBar: NSProgressIndicator!
    @IBOutlet var WinView: NSView!
    @IBOutlet weak var ispView: NSView!
    @IBOutlet weak var initialView: NSView!
    @IBOutlet weak var circleBar: NSImageView!
    @IBOutlet weak var msgInfo1: NSTextField!
    @IBOutlet weak var msgInfo2: NSTextField!
    //
    let ISP = ISPcommand()  //call the object file
    let ispMsg = IspMsg()  //call the IspMsg class
    
    var isCHKMonitor = false
    var preUSBConnection = false
    var isBinFileLoad = false
    var initialLocation = NSEvent.mouseLocation()
    var programTimer: Timer!
    var valueTarget: Double = 100
    var valueMinimum: Double = 0
    var msgInfoColor: NSColor = NSColor(red: 40, green: 40, blue: 40, alpha: 0)
    let pstyle = NSMutableParagraphStyle()
    
    @IBAction func closeWinButton(_ sender: AnyObject) {
        exit(EXIT_SUCCESS)  //close app
    }
    @IBAction func zoomWinButton(_ sender: AnyObject) {
        self.view.window?.miniaturize(self)  //minimize window in the dock
    }
    @IBAction func helpWinButton(_ sender: AnyObject) {
        NSWorkspace.shared().open(URL(string: "http://www.dell.com")!)  //open hyperlink
    }
    @IBAction func browseButton(_ sender: AnyObject) {
        openFileDialog()  //開啟目錄
    }
    
    let globalQueue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)

    override func viewDidLoad() {
        super.viewDidLoad()
        CheckMonitor()
    }
    func CheckMonitor()
    {
        //switch initial view for usb detect
        //if(ISP.MStar_USBConnect()==true)
        if(true)
        {
            if(isCHKMonitor==false)
            {
                //print("tabVItem_initial")

                isCHKMonitor = true
                tabView.selectTabViewItem(tabVItem_initial)

                //設定5秒後切換到isp view
                let detUsbTime = DispatchTime.now() + Double((Int64)(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
                globalQueue.asyncAfter(deadline: detUsbTime) { () -> Void in
                    self.view.window?.close()
                    self.SetupIspMenu()
                    self.tabView.selectTabViewItem(self.tabVItem_isp)
                    self.view.window?.makeKeyAndOrderFront(self)
                    //print("tabVItem_isp")
                }
            }
        }
        else
        {
            isCHKMonitor = false
            SetupIspMenu()
            self.tabView.selectTabViewItem(self.tabVItem_isp)
            //print("tabVItem_isp2")
        }
    }

    func ispComponent()
    {
        ispView.wantsLayer = true
        ispView.layer?.backgroundColor = NSColor.white.cgColor
        ispView.window?.backgroundColor = NSColor.white
        setLabelPostion()
        FindBinFile()
        readBinInfo()
        setBrowseTextColor()
        updateMenuLanguage()
    }
    func setLabelPostion()
    {
        if ispMsg.language == "ru" || ispMsg.language == "es"
        {
            self.filePath.frame.size = NSSize(width:200, height:28)
            self.modelNo.frame.size = NSSize(width:200, height:28)
            self.currentFW.frame.size = NSSize(width:200, height:28)
            self.newFW.frame.size = NSSize(width:200, height:28)
            self.fileCKS.frame.size = NSSize(width:200, height:28)
            
            self.filePathValue.frame.origin = CGPoint(x:280, y:354)
            self.modelNoValue.frame.origin = CGPoint(x:280, y:317)
            self.currentFWValue.frame.origin = CGPoint(x:280, y:281)
            self.newFWValue.frame.origin = CGPoint(x:280, y:242)
            self.fileCKSValue.frame.origin = CGPoint(x:280, y:201)
            
            self.filePathValue.frame.size = NSSize(width:318, height:22)
            self.modelNoValue.frame.size = NSSize(width:363, height:22)
            self.currentFWValue.frame.size = NSSize(width:363, height:22)
            self.newFWValue.frame.size = NSSize(width:363, height:22)
            self.fileCKSValue.frame.size = NSSize(width:363, height:22)
            
        }else if ispMsg.language == "ja"
        {
            self.filePath.frame.size = NSSize(width:230, height:28)
            self.modelNo.frame.size = NSSize(width:230, height:28)
            self.currentFW.frame.size = NSSize(width:230, height:28)
            self.newFW.frame.size = NSSize(width:230, height:28)
            self.fileCKS.frame.size = NSSize(width:230, height:28)
            
            self.filePathValue.frame.origin = CGPoint(x:280, y:354)
            self.modelNoValue.frame.origin = CGPoint(x:280, y:317)
            self.currentFWValue.frame.origin = CGPoint(x:280, y:281)
            self.newFWValue.frame.origin = CGPoint(x:280, y:242)
            self.fileCKSValue.frame.origin = CGPoint(x:280, y:201)
            
            self.filePathValue.frame.size = NSSize(width:318, height:22)
            self.modelNoValue.frame.size = NSSize(width:363, height:22)
            self.currentFWValue.frame.size = NSSize(width:363, height:22)
            self.newFWValue.frame.size = NSSize(width:363, height:22)
            self.fileCKSValue.frame.size = NSSize(width:363, height:22)
        }else if ispMsg.language == "pt" || ispMsg.language == "fr"
        {
            self.filePath.frame.size = NSSize(width:180, height:28)
            self.modelNo.frame.size = NSSize(width:180, height:28)
            self.currentFW.frame.size = NSSize(width:180, height:28)
            self.newFW.frame.size = NSSize(width:180, height:28)
            self.fileCKS.frame.size = NSSize(width:180, height:28)
            
            self.filePathValue.frame.origin = CGPoint(x:280, y:354)
            self.modelNoValue.frame.origin = CGPoint(x:280, y:317)
            self.currentFWValue.frame.origin = CGPoint(x:280, y:281)
            self.newFWValue.frame.origin = CGPoint(x:280, y:242)
            self.fileCKSValue.frame.origin = CGPoint(x:280, y:201)
            
            self.filePathValue.frame.size = NSSize(width:318, height:22)
            self.modelNoValue.frame.size = NSSize(width:363, height:22)
            self.currentFWValue.frame.size = NSSize(width:363, height:22)
            self.newFWValue.frame.size = NSSize(width:363, height:22)
            self.fileCKSValue.frame.size = NSSize(width:363, height:22)
        }
    }
    func SetupIspMenu()
    {
        ispComponent()
        DispatchQueue.main.async(execute: { () -> Void in
            self.programTimer = Timer.scheduledTimer(timeInterval: 1,target:self,selector:#selector(ViewController.ispUpdateMsg),userInfo:nil, repeats: true)
        })
    }
    func setBrowseTextColor()
    {
        let path = Bundle.main.path(forResource: ispMsg.language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        //設定browse button字型,大小,顏色屬性
        let browseColor = NSColor(red: 0.0/255.0, green: 112.0/255.0, blue: 170.0/255.0, alpha: 1.0)
        let pstyle = NSMutableParagraphStyle()
        let browse = bundle!.localizedString(forKey: "browse", value: "browse", table: "InfoPlist")
        self.browseButton.attributedTitle = NSAttributedString(string: browse, attributes: [ NSForegroundColorAttributeName : browseColor, NSParagraphStyleAttributeName : pstyle, NSFontAttributeName:NSFont(name: "Trebuchet MS", size: 16)!])
    }
    override func mouseDown(with theEvent: NSEvent)
    {
        //得到 mouse在視窗內的坐標
        self.initialLocation = theEvent.locationInWindow
    }
    override func mouseDragged(with theEvent: NSEvent)
    {
        let screenVisibleFrame = NSScreen.main()?.visibleFrame  //宣告screen window
        let windowFrame = self.view.window?.frame  //宣告window frame
        var newOrigin = windowFrame!.origin;  //宣告window坐標
        
        //get mouse在視窗內的坐標
        let currentLocation = theEvent.locationInWindow
        
        //update mouse新坐標與舊坐標之間相差的距離
        newOrigin.x += (currentLocation.x - initialLocation.x);
        newOrigin.y += (currentLocation.y - initialLocation.y);
        
        //計算新坐標
        if ((newOrigin.y + windowFrame!.size.height) > (screenVisibleFrame!.origin.y + screenVisibleFrame!.size.height)) {
            newOrigin.y = screenVisibleFrame!.origin.y + (screenVisibleFrame!.size.height - windowFrame!.size.height);
        }
        //移動視窗到新的坐標
        self.view.window!.setFrameOrigin(newOrigin)
    }
    
    @available(OSX 10.11, *)
    func enUpdateBtmColor()
    {
        let path = Bundle.main.path(forResource: ispMsg.language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        //設定update button color
        let updBtmlayer = CALayer()
        updBtmlayer.backgroundColor = CGColor(red: 228.0/255.0, green: 228.0/255.0, blue: 228/255.0, alpha: 1.0)
        self.updateButton.wantsLayer = true
        self.updateButton.layer = updBtmlayer
        //設定update button字型,大小,顏色屬性
        let updateColor = NSColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.0)
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = NSTextAlignment.center  //文字置中
        let update = bundle!.localizedString(forKey: "Update", value: "Update", table: "InfoPlist")
        self.updateButton.attributedTitle = NSAttributedString(string: update, attributes: [ NSForegroundColorAttributeName : updateColor, NSParagraphStyleAttributeName : pstyle, NSFontAttributeName:NSFont(name: "Trebuchet MS", size: 12)!])
    }
    func disUpdateBtmColor()
    {
        let path = Bundle.main.path(forResource: ispMsg.language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        //設定update button color
        let updBtmlayer = CALayer()
        updBtmlayer.backgroundColor = CGColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        self.updateButton.wantsLayer = true
        self.updateButton.layer = updBtmlayer
        //設定update button字型,大小,顏色屬性
        let closeColor = NSColor(red: 136.0/255.0, green: 136.0/255.0, blue: 136.0/255.0, alpha: 1.0)
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = NSTextAlignment.center  //文字置中
        let Update = bundle!.localizedString(forKey: "Update", value: "Update", table: "InfoPlist")
        self.updateButton.attributedTitle = NSAttributedString(string: Update, attributes: [ NSForegroundColorAttributeName : closeColor, NSParagraphStyleAttributeName : pstyle, NSFontAttributeName:NSFont(name: "Trebuchet MS", size: 12)!])
    }
    func runtimeCloseBtmColor()
    {
        //設定update button color
        let updBtmlayer = CALayer()
        updBtmlayer.backgroundColor = CGColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        self.updateButton.wantsLayer = true
        self.updateButton.layer = updBtmlayer
        //設定update button字型,大小,顏色屬性
        let closeColor = NSColor(red: 136.0/255.0, green: 136.0/255.0, blue: 136.0/255.0, alpha: 1.0)
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = NSTextAlignment.center  //文字置中
        self.updateButton.attributedTitle = NSAttributedString(string: "Close", attributes: [ NSForegroundColorAttributeName : closeColor, NSParagraphStyleAttributeName : pstyle, NSFontAttributeName:NSFont(name: "Trebuchet MS", size: 12)!])
    }
    func finishCloseBtomColor()
    {
        //設定update button color
        let updBtmlayer = CALayer()
        updBtmlayer.backgroundColor = CGColor(red: 00.0/255.0, green: 133.0/255.0, blue: 195.0/255.0, alpha: 1.0)
        self.updateButton.wantsLayer = true
        self.updateButton.layer = updBtmlayer
        //設定update button字型,大小,顏色屬性
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = NSTextAlignment.center  //文字置中
        //change text to "Close"
        self.updateButton.attributedTitle = NSAttributedString(string: "Close", attributes: [ NSForegroundColorAttributeName : NSColor.white, NSParagraphStyleAttributeName : pstyle, NSFontAttributeName:NSFont(name: "Trebuchet MS", size: 12)!])
        self.updateButton.setNeedsDisplay()
    }
    func setPressUpdateBtmColor()
    {
        let updBtmlayer = CALayer()
        updBtmlayer.backgroundColor = NSColor.gray.cgColor//CGColorCreateGenericRGB(59.0/255, 52.0/255.0, 152.0/255.0, 1.0)
        self.updateButton.wantsLayer = true
        self.updateButton.layer = updBtmlayer
    }
    func updateMenuLanguage()
    {
        let path = Bundle.main.path(forResource: ispMsg.language, ofType: "lproj")
        let bundle = Bundle(path: path!)
      
        self.filePath.stringValue = bundle!.localizedString(forKey: "File Path", value: "File Path", table: "InfoPlist")
        self.modelNo.stringValue = bundle!.localizedString(forKey: "Model No", value: "Model No", table: "InfoPlist")
        self.currentFW.stringValue = bundle!.localizedString(forKey: "Current Firmware", value: "Current Firmware", table: "InfoPlist")
        self.newFW.stringValue = bundle!.localizedString(forKey: "New Firmware", value: "New Firmware", table: "InfoPlist")
        self.fileCKS.stringValue = bundle!.localizedString(forKey: "File Checksum", value: "File Checksum", table: "InfoPlist")

    }
    func readBinInfo()
    {
        self.modelNoValue.stringValue = "P4317Q"
        self.currentFWValue.stringValue = "M3C101"
        self.newFWValue.stringValue = "M3C102"
        self.fileCKSValue.stringValue = "0xFFFF"
    }
    
    func FindBinFile()->Bool
    {
        var isFindBinFile = false
        // Create a FileManager instance
        let fileManager = FileManager.default
        // Get current directory path
        let path = fileManager.currentDirectoryPath
        print(path)
        let exist = fileManager.fileExists(atPath: path)
        if exist
        {
            let fileFolder = fileManager.enumerator(atPath: path)
            var BinFilePath = ""
            while let file = fileFolder?.nextObject() {
                if (file as AnyObject).pathExtension.lowercased() == "bin"
                {
                    if(isFindBinFile==true)
                    {
                        isFindBinFile=false
                        break
                    }
                    else
                    {
                        isFindBinFile = true
                        //BinFilePath = "file:" + path //+"/"+ (file as! String)
                        BinFilePath = "file:" + path + "/" + (file as! String)
                        //print("binfile:",file)
                    }
                }
                //print(file)
            }
            if isFindBinFile == true
            {
                self.LoadBinFile(BinFilePath);
            }
        }
        return isFindBinFile
    }
    func openFileDialog()
    {
        let openPanel = NSOpenPanel()
        
        openPanel.allowsMultipleSelection = false  //可選擇多個檔案
        openPanel.canChooseDirectories = true  //可選擇目錄
        openPanel.canCreateDirectories = true  //可新增目錄
        
        
        openPanel.begin { (result) -> Void in  //open dialog
            if result == NSFileHandlingPanelOKButton
            {
                openPanel.prompt = "Open"  //file dialog button string
                openPanel.worksWhenModal = true  //receiver keyboard and mouse event
                openPanel.resolvesAliases = true  //允許解析檔名
                
                let chosenfile = openPanel.url // Pathname of the file
                
                if chosenfile != nil  //如果chose file != nil
                {
                    
                    //判斷是否為bin file
                    if chosenfile!.pathExtension.lowercased() != "bin"
                    {
                        openPanel.canChooseFiles = true  //可選擇檔案
                    }
                    else
                    {
                        openPanel.canChooseFiles = true  //可選擇檔案
                        self.LoadBinFile(chosenfile!.absoluteString)
                    }
                }
            }
        }
        
    }
    func LoadBinFile(_ FilePath: String)
    {
        if(ISP?.setBinFile(FilePath)==true)
        {
            isBinFileLoad = true
            self.filePathValue.stringValue = FilePath;  //show path
            self.newFWValue.stringValue = "M3C102"
            self.fileCKSValue.stringValue = String(format: "0x%X", (ISP?.getBinFileCHKS())!)
        }
    }
    func ispUpdateMsg()
    {
        if(isBinFileLoad == false)
        {
            self.msgInfo1.stringValue = ispMsg.updatePassOrFailMsg(ispMsg.mFileNotFound)
            msgIcon.image = NSImage(named: "Errormsg")
        }
        else
        {
            msgInfo1.stringValue = " "
            msgIcon.image = nil
        }
        if (isCHKMonitor == true)
        {
            self.enUpdateBtmColor()
            self.msgIcon2.image = nil//NSImage(named: "Informsg")
            msgInfo2.stringValue = " "
        }
        else
        {
            self.disUpdateBtmColor()
            self.msgIcon2.image = NSImage(named: "Errormsg")
            msgInfo2.stringValue = ispMsg.updatePassOrFailMsg(ispMsg.mDetUSB)
           
        }
        
        if(((ISP?.getISPStep())! > ispMsg.Standby) && ((ISP?.getISPStep())! != ispMsg.Success))
        {
            self.updateStatus.stringValue = ispMsg.updateStepString()+ispMsg.dotString()
            programStep()
        }
        if(ISP?.mStar_USBConnect() != preUSBConnection)
        {
            preUSBConnection = (ISP?.mStar_USBConnect())!
            CheckMonitor()
        }        
    }
    
    func programStep()
    {
        print("run\n")
        if false//objectC.getUpdateStatus() == 4
        {
            self.finishCloseBtomColor()
            self.programTimer.invalidate()
	    self.browseButton.isEnabled = false
            self.closeWinButton.isEnabled = false
        }
        else
        {
            ispStatusBar.doubleValue = Double((ISP?.getISPProgress())!)
        }
    }
    
    @IBAction func updateButton(_ sender: AnyObject)
    {
        if false//ispProgramFinsished //objectC.getUpdateStatus() == 4
        {
            exit(EXIT_SUCCESS)
        }
        else
        {
            if true//self.isBinFile == true && self.detectUSB == true
            {
                self.runtimeCloseBtmColor()
                self.ispStatusBar.startAnimation(self)
                
                let QOS = DispatchQoS.QoSClass.background  //QOS(Quality Of Service)
                let backgroundQueue = DispatchQueue.global(qos: QOS)
                backgroundQueue.async(execute: {
                    print("This is run on the background queue")
                    self.ISP?.mStar_StartISP()
                    self.ISP?.mStar_FlashChipErase()
                    //self.ISP.MStar_FlashBlanking()
                    self.ISP?.mStar_FlashProgram()
                    //self.ISP.MStar_FlashVerify()
                    self.ISP?.mStar_EndISP()
                })
                
            }
        }
    }
}

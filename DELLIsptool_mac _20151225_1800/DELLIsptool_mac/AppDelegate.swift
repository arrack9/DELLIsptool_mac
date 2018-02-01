//
//  AppDelegate.swift
//  DELLIsptool_mac
//
//  Created by MNT-FW on 2015/11/22.
//  Copyright © 2015年 MNT-FW. All rights reserved.
//

import Cocoa
import AppKit

@NSApplicationMain
//AppDelegate為應用程式的進入點
class AppDelegate: NSObject, NSApplicationDelegate {
    //implement NSWindow的類別
    //NSWindow *window; ?表示這是一個可選的optional
    //?表示window = nil
    //var表示定義一個變數

    //applicationDidFinishLaunching為程式碼第一個run的function
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
//        NSUserDefaults.standardUserDefaults().setObject(["en"], forKey: "Application Languages")
//        NSUserDefaults.standardUserDefaults().synchronize()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application

    }

}


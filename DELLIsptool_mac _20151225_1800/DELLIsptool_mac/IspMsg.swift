//
//  IspMsg.swift
//  DELLIsptool_mac
//
//  Created by MNT-FW on 2015/11/27.
//  Copyright © 2015年 MNT-FW. All rights reserved.
//

import Cocoa
import Foundation 

class IspMsg: NSString {
    let Standby:Int32 = 0;
    let Preparing:Int32 = 2;
    let Erasing:Int32 = 10;
    let Updating:Int32 = 20;
    let Verifying:Int32 = 90;
    let Success:Int32 = 100;
    
    var dotCount:Int = 0
    var dotS:String = " "
    
    let mNormal:Int32 = 0
    let mDetUSB:Int32 = 1
    let mFileNotFound:Int32 = 2
    let mUpdateNoted:Int32 = 3
    let mProgramFail:Int32 = 4
    let mEraseFail:Int32 = 5
    let mUpdateError:Int32 = 6
    let mCHKError:Int32 = 7
    let ISP = ISPcommand()
    
//=============================================================================
// USA = "en"      ,German = "de"  ,Russian = "ru"   ,Portuguese = "pt"
// Spanish = "es"  ,French = "fr"  ,Japanese = "ja"  ,Chinese_S = "zh-Hans"
//=============================================================================
    var language = "ru"
    
    func selectLanguage()->String{
        return language
    }
    func updateStepString() -> String{
        var statusString:String = " "
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        switch ISP?.getISPStep()
        {
        case Standby?:
            statusString = " "
            break
        case Preparing?:
            statusString = (bundle?.localizedString(forKey: "preparing monitor to update", value: "Preparing monitor to update", table: "InfoPlist"))!
            break
        case Erasing?:
            statusString = (bundle?.localizedString(forKey: "Erasing flash", value: "Erasing flash", table: "InfoPlist"))!
            break
        case Updating?:
            statusString = (bundle?.localizedString(forKey: "Updateing", value: "Updateing", table: "InfoPlist"))!
            break
        case Verifying?:
            statusString = (bundle?.localizedString(forKey: "Verify update", value: "Verify update", table: "InfoPlist"))!
            break
        case Success?:
            statusString = (bundle?.localizedString(forKey: "Update Successful", value: "Update Successful", table: "InfoPlist"))!
            break
        default:
            statusString = (bundle?.localizedString(forKey: "preparing monitor to update", value: "preparing monitor to update", table: "InfoPlist"))!
            break
        }
        return statusString
    }
    
    func dotString() -> String{
        dotCount = (dotCount + 1) % 4
        if(ISP?.getISPStep() == Success)
        {
            dotCount = 0
        }
        
        return dotCount == 1 ? "." : dotCount == 2 ? ".." : dotCount == 3 ? "..." : " "
    }
    
    func updatePassOrFailMsg(_ passORfailStatus:Int32) -> String{
        var passORfailString:String = " "
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        switch passORfailStatus
        {
        case mNormal:
            passORfailString = (bundle?.localizedString(forKey: "mDNormal", value: "pdate may take several minutes, do not power off monitor or disconnect cable while updating.", table: "InfoPlist"))!
            break
        case mDetUSB:
            passORfailString = (bundle?.localizedString(forKey: "mDetUSB", value: "Monitor not detected. Ensure USB cable is connected and display is powered on. See Help for more information.", table: "InfoPlist"))!
            break
        case mFileNotFound:
            passORfailString = (bundle?.localizedString(forKey: "mFileNotFound", value: "Firmware file not found. Open firmware file (*.bin) to proceed.", table: "InfoPlist"))!
            break
        case mUpdateNoted:
            passORfailString = (bundle?.localizedString(forKey: "mUpdateNoted", value: "To complete update, turn off monitor replug power cord, turn on monitor.", table: "InfoPlist"))!
            break
        case mProgramFail:
            passORfailString = (bundle?.localizedString(forKey: "mProgramFail", value: "Write protection error. Close Monitor Firmware Update Utility, turn off monitor, replug power cord, turn on monitor and try updating again.", table: "InfoPlist"))!
            break
        case mEraseFail:
            passORfailString = (bundle?.localizedString(forKey: "mEraseFail", value: "Flash erase error. Close Monitor Firmware Update Utility, turn off monitor, replug power cord, turn on monitor and try updating again.", table: "InfoPlist"))!
            break
        case mUpdateError:
            passORfailString = (bundle?.localizedString(forKey: "mUpdateError", value: "Update error. Close Monitor Firmware Update Utility, turn off monitor, replug power cord, turn on monitor and try updating again.", table: "InfoPlist"))!
            break
        case mCHKError:
            passORfailString = (bundle?.localizedString(forKey: "mCHKError", value: "Monitor firmware checksum error. Close Monitor Firmware Update Utility, turn off monitor, replug power cord, turn on monitor and try updating again.", table: "InfoPlist"))!
            break
        default:
            passORfailString = (bundle?.localizedString(forKey: "mDefault", value: "Update may take several minutes, do not power off monitor or disconnect cable while updating.", table: "InfoPlist"))!
            break
        }
    return passORfailString
    }
    
    
}

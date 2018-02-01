#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "HID PnP.h"

@interface ISPcommand : NSObject {
    
}

- (id) init;

typedef enum ISPSteps{
    Standby = 0, Erase = 2, Blanking = 10, Program = 20, Verify = 90, Finished = 100
}ISPStep;

void SetISPProgress(int Progress, int TotalProgress);

-(BOOL) SetBinFile:(NSString *) FilePath;
//-(ISPStep) GetISPStep;
-(int) GetISPStep;
-(int) GetISPProgress;
-(int) GetBinFileCHKS;

-(BOOL) MStar_USBConnect;

-(BOOL) MStar_StartISP;
-(BOOL) MStar_EndISP;
-(BOOL) MStar_FlashChipErase;
-(BOOL) MStar_FlashProgram;
-(BOOL) MStar_FlashBlanking;
-(BOOL) MStar_FlashVerify;


@end

//////////////////////////////////////////////////////////

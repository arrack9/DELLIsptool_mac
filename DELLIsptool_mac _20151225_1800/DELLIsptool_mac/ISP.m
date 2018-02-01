
#import <Cocoa/Cocoa.h>

#import "ISP.h"

@implementation ISPcommand

HID_PnP *plugNPlay;

ISPStep CurrentISPStep = Standby;
int ISPProgress = 0;
BYTE *BinFile=NULL;


- (id)init {
    // Init routine for parent class
    if(!(self = [super init])) {
        NSLog(@"ISPcommand init Error");
        return nil;
    }
    
    // Allocate memory and initialize HID_PnP object to start HID USB communication
    plugNPlay = [[HID_PnP alloc]init];
    
    // Return self
    return self;
}
/////////////////////////////////////////////////////////////


-(BOOL) SetBinFile:(NSString *) FilePath
{
    //BinFile = file;
    FILE * pFile;
    //pFile = fopen("/Users/apple/Desktop/Mac/Mac OS X Cocoa Objective-C/FW_Qbic.BIN", "rb");
    char * cFilePath=[FilePath UTF8String];
    cFilePath=cFilePath+5;
    pFile = fopen((char *)cFilePath, "rb");
    
    if(pFile!=NULL)
    {
        fseek(pFile, 0, SEEK_END);
        long lSize= ftell(pFile);
        rewind(pFile);
        BinFile= (BYTE*) malloc (sizeof(BYTE)*lSize);
        FileSize = lSize*sizeof(BYTE);
        fread(BinFile, sizeof(BYTE), FileSize, pFile);
        fclose(pFile);
        if( FileSize>0)
            return true;
    }
    return false;
}

//-(ISPStep) GetISPStep
-(int) GetISPStep
{
    return CurrentISPStep;
}
ISPStep GetISPStep()
{
    return CurrentISPStep;
}

-(int) GetBinFileCHKS
{
    int ChkSum = 0;
    for(int i=0; i<FileSize; i++)
    {
        ChkSum+= *(BinFile+i);
    }
    return (ChkSum & 0xFFFF);
}
long FileSize=0;
-(int) GetISPProgress
{
    return ISPProgress;
}
void SetISPProgress(int Progress, int TotalProgress)
{
    int min = 0, max = 0;
    if (Progress <= TotalProgress && Progress >= 0)
    {
        switch (GetISPStep())
        {
            case Standby:
                max = (int)Erase;
                min = (int)Standby;
                break;
            case Erase:
                max = (int)Blanking;
                min = (int)Erase;
                break;
            case Blanking:
                max = (int)Program;
                min = (int)Blanking;
                break;
            case Program:
                max = (int)Verify;
                min = (int)Program;
                break;
            case Verify:
                max = (int)Finished - 2;
                min = (int)Verify;
                break;
            case Finished:
                max = (int)Finished;
                min = (int)Finished - 2;
                break;
            default:
                break;
        }
        ISPProgress = (int)((Progress + 1) * (max - min) / TotalProgress + min);
    }
}

void SetISPStep(ISPStep value)
{
    CurrentISPStep = value;
    printf("SetISPStep=%d", CurrentISPStep);
}

bool MStar_SendDDCLeavePMSMode()
{
    BYTE ISP_CMD[10] = { 0x51, 0x84, 0x03, 0xD6, 0x00, 0x01, 0xB8 };
    BYTE DeviceAddr = 0x6E >> 1;
    DWORD DataLen = 7;
    DWORD result = 0;
    if (USBDeviceAttached == TRUE)
        result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
    else
        return false;
    return true;
}
bool MStar_EnterSerialDebugMode()
{
    BYTE ISP_CMD[10] = { 0x53, 0x45, 0x52, 0x44, 0x42 };
    BYTE DeviceAddr = 0xB2 >> 1;
    DWORD DataLen = 5;
    DWORD result = 0;
    if (USBDeviceAttached == TRUE)
        result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
    else
        return false;
    return true;
}
bool MStar_ExitSerialDebugMode()
{
    BYTE ISP_CMD[10] = { 0x45 };
    BYTE DeviceAddr = 0xB2 >> 1;
    DWORD DataLen = 1;
    DWORD result = 0;
    if (USBDeviceAttached == TRUE)
        result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
    else
        return false;
    return true;
}
bool MStar_SetIICBusCtrl()
{
    {
        BYTE ISP_CMD[10] = { 0x35 };
        BYTE DeviceAddr = 0xB2 >> 1;
        DWORD DataLen = 1;
        DWORD result = 0;
        if (USBDeviceAttached == TRUE)
            result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
        else
            return false;
    }
    {
        BYTE ISP_CMD[10] = { 0x71 };
        BYTE DeviceAddr = 0xB2 >> 1;
        DWORD DataLen = 1;
        DWORD result = 0;
        if (USBDeviceAttached == TRUE)
            result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
        else
            return false;
    }
    return true;
}
bool MStar_EnterSingleStepMode()
{
    BYTE ISP_CMD[10] = { 0x10, 0xC0, 0xC1, 0x53 };
    BYTE DeviceAddr = 0xB2 >> 1;
    DWORD DataLen = 4;
    DWORD result = 0;
    if (USBDeviceAttached == TRUE)
        result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
    else
        return false;
    return true;
}
bool MStar_ExitSingleStepMode()
{
    BYTE ISP_CMD[10] = { 0x10, 0xC0, 0xC1, 0xFF };
    BYTE DeviceAddr = 0xB2 >> 1;
    DWORD DataLen = 4;
    DWORD result = 0;
    if (USBDeviceAttached == TRUE)
        result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
    else
        return false;
    return true;
}
bool MStar_EnterISPMode()
{
    BYTE ISP_CMD[10] = { 0x4D, 0x53, 0x54, 0x41, 0x52 };
    BYTE DeviceAddr = 0x92 >> 1;
    DWORD DataLen = 5;
    DWORD result = 0;
    if (USBDeviceAttached == TRUE)
        result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
    else
        return false;
    return true;
}
bool MStar_ExitISPMode()
{
    BYTE ISP_CMD[10] = { 0x24 };
    BYTE DeviceAddr = 0x92 >> 1;
    DWORD DataLen = 1;
    DWORD result = 0;
    if (USBDeviceAttached == TRUE)
        result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
    else
        return false;
    return true;
}
bool MStar_DisableHWWriteProtect()
{
    {
        BYTE ISP_CMD[10] = { 0x10, 0x02, 0x26, 0x01 };
        BYTE DeviceAddr = 0xB2 >> 1;
        DWORD DataLen = 4;
        DWORD result = 0;
        if (USBDeviceAttached == TRUE)
            result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
        else
            return false;
    }
    {
        BYTE ISP_CMD[10] = { 0x10, 0x04, 0x26, 0x01 };
        BYTE DeviceAddr = 0xB2 >> 1;
        DWORD DataLen = 4;
        DWORD result = 0;
        if (USBDeviceAttached == TRUE)
            result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
        else
            return false;
    }
    {
        BYTE ISP_CMD[10] = { 0x10, 0x04, 0x28, 0x00 };
        BYTE DeviceAddr = 0xB2 >> 1;
        DWORD DataLen = 4;
        DWORD result = 0;
        if (USBDeviceAttached == TRUE)
            result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
        else
            return false;
    }
    return true;
}
bool MStar_EndCMD()
{
    BYTE ISP_CMD[10] = { 0x12 };
    BYTE DeviceAddr = 0x92 >> 1;
    DWORD DataLen = 1;
    DWORD result = 0;
    if (USBDeviceAttached == TRUE)
        result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
    else
        return false;
    return true;
}


bool MStar_FlashDetectType()
{
    /* {
     BYTE ISP_CMD[10] = { 0x10, 0x9F };
     BYTE DeviceAddr = 0x92 >> 1;
     DWORD DataLen = 2;
     DWORD result = 0;
     if (USBDeviceAttached == TRUE)
     result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
     else
     return false;
     }
     {
     BYTE ISP_CMD[10] = { 0x11 };
     BYTE DeviceAddr = 0x92 >> 1;
     DWORD DataLen = 1;
     DWORD result = 0;
     if (USBDeviceAttached == TRUE)
     result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
     else
     return false;
     }
     {
     byte[] I2CReadDataBuffer = new byte[10000];
     BYTE DeviceAddr = 0x92 >> 1;
     DWORD DataLen = 3;
     DWORD result = 0;
     if (USBDeviceAttached == TRUE)
     result = ReadI2C(USBDeviceHandle, DeviceAddr, I2CReadDataBuffer, DataLen);
     if (result != 3)
     return false;
     }
     if (MStar_EndCMD() == false) return false;*/
    return true;
}
bool MStar_FlashReadStatus()
{
    bool resultdata = false;
    {
        BYTE ISP_CMD[10] = { 0x10, 0x05 };
        BYTE DeviceAddr = 0x92 >> 1;
        DWORD DataLen = 2;
        DWORD result = 0;
        if (USBDeviceAttached == true)
            result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
    }
    {
        BYTE ISP_CMD[10] = { 0x11 };
        BYTE DeviceAddr = 0x92 >> 1;
        DWORD DataLen = 1;
        DWORD result = 0;
        if (USBDeviceAttached == true)
            result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
    }
    {
        BYTE i2creaddatabuffer[10000];
        BYTE DeviceAddr = 0x92 >> 1;
        DWORD DataLen = 1;
        DWORD result = 3;
        if (USBDeviceAttached == true)
        {
            result = ReadI2C(plugNPlay.HIDDeviceHandle, DeviceAddr, i2creaddatabuffer, DataLen);
            resultdata = (i2creaddatabuffer[0] & 0x01) == 0 ? true : false;
        }
    }
    if (MStar_EndCMD() == false) return false;
    return resultdata;
}
bool MStar_FlashWriteEnable()
{
    {
        BYTE ISP_CMD[10] = { 0x10, 0x06 };
        BYTE DeviceAddr = 0x92 >> 1;
        DWORD DataLen = 2;
        DWORD result = 0;
        if (USBDeviceAttached == TRUE)
            result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
        if (MStar_EndCMD() == false) return false;
    }
    return true;
}
bool MStar_FlashWriteStatus()
{
    {
        BYTE ISP_CMD[10] = { 0x10, 0x01, 0x00 };
        BYTE DeviceAddr = 0x92 >> 1;
        DWORD DataLen = 3;
        DWORD result = 0;
        if (USBDeviceAttached == TRUE)
            result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
        else
            return false;
        if (MStar_EndCMD() == false) return false;
    }
    return true;
}
bool MStar_FlashWriteDisable()
{
    BYTE ISP_CMD[10] = { 0x10, 0x04 };
    BYTE DeviceAddr = 0x92 >> 1;
    DWORD DataLen = 2;
    DWORD result = 0;
    if (USBDeviceAttached == TRUE)
        result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
    else
        return false;
    if (MStar_EndCMD() == false) return false;
    
    return true;
}
bool MStar_FlashSpecialUnprotect()
{
    {
        BYTE ISP_CMD[10] = { 0x10, 0xC3 };
        BYTE DeviceAddr = 0x92 >> 1;
        DWORD DataLen = 2;
        DWORD result = 0;
        if (USBDeviceAttached == TRUE)
            result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
        else
            return false;
    }
    if (MStar_EndCMD() == false) return false;
    {
        BYTE ISP_CMD[10] = { 0x10, 0xA5 };
        BYTE DeviceAddr = 0x92 >> 1;
        DWORD DataLen = 2;
        DWORD result = 0;
        if (USBDeviceAttached == TRUE)
            result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
        else
            return false;
    }
    if (MStar_EndCMD() == false) return false;
    {
        BYTE ISP_CMD[10] = { 0x10, 0xC3 };
        BYTE DeviceAddr = 0x92 >> 1;
        DWORD DataLen = 2;
        DWORD result = 0;
        if (USBDeviceAttached == TRUE)
            result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
        else
            return false;
    }
    if (MStar_EndCMD() == false) return false;
    {
        BYTE ISP_CMD[10] = { 0x10, 0xA5 };
        BYTE DeviceAddr = 0x92 >> 1;
        DWORD DataLen = 2;
        DWORD result = 0;
        if (USBDeviceAttached == TRUE)
            result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
        else
            return false;
    }
    if (MStar_EndCMD() == false) return false;
    return true;
}
bool MStar_FlashReleaseDeepPowerDown()
{
    BYTE ISP_CMD[10] = { 0x10, 0xAB, 0x00, 0x00, 0x00 };
    BYTE DeviceAddr = 0x92 >> 1;
    DWORD DataLen = 5;
    DWORD result = 0;
    if (USBDeviceAttached == TRUE)
        result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
    else
        return false;
    if (MStar_EndCMD() == false) return false;
    
    return true;
}
bool MStar_FlashRead(unsigned char* RecieveData, int ReciveDataLen)
{
    uint count = 512;
    for (uint i = 0; i < ReciveDataLen; i = i + count)
    {
        {
            BYTE ISP_CMD[5];
            ISP_CMD[0] = 0x10;
            ISP_CMD[1] = 0x03;
            ISP_CMD[2] = (BYTE)((i >> 16) & 0xFF);  //AddrH
            ISP_CMD[3] = (BYTE)((i >> 8) & 0xFF);   //AddrM
            ISP_CMD[4] = (BYTE)(i & 0xFF);          //AddrL
            BYTE DeviceAddr = 0x92 >> 1;
            DWORD DataLen = 5;
            DWORD result = 0;
            
            if (USBDeviceAttached == TRUE)
                result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
            else
                return false;
        }
        {
            BYTE ISP_CMD[10] = { 0x11 };
            BYTE DeviceAddr = 0x92 >> 1;
            DWORD DataLen = 1;
            DWORD result = 0;
            if (USBDeviceAttached == TRUE)
                //result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
                result = I2CTransfer(plugNPlay.HIDDeviceHandle, false, DeviceAddr, ISP_CMD, DataLen, true, false, false);
            else
                return false;
        }
        {
            BYTE RecieveDataTemp[count];
            BYTE DeviceAddr = 0x92 >> 1;
            DWORD result = 3;
            if (USBDeviceAttached == TRUE)
            {
                //result = ReadI2C(plugNPlay.HIDDeviceHandle, DeviceAddr, RecieveDataTemp, count);
                result = I2CTransfer(plugNPlay.HIDDeviceHandle, true, DeviceAddr, RecieveDataTemp, count, true, true, true);
                for(int j=0; j<count; j++)
                    RecieveData[i+j]=RecieveDataTemp[j];
            }
            else
                return false;
            MStar_EndCMD();
        }
        SetISPProgress((int)i, ReciveDataLen);
    }
    
    return true;
}

-(BOOL) MStar_USBConnect
{
#if 0
    return USBDeviceAttached;
#else
    return true;
#endif
}

-(BOOL) MStar_StartISP
{
    int i = 0, step = 5;
    SetISPStep(Standby);
    
    plugNPlay = [[HID_PnP alloc]init];
    
    plugNPlay.HIDDeviceHandle = OpenDevice(0, I2C_SPEED_200KHZ);
    
    if ([self MStar_USBConnect] == false)
    {
        return false;
    }
    SetISPProgress(i++, step);
    MStar_EnterSerialDebugMode();
    SetISPProgress(i++, step);
    MStar_EnterSingleStepMode();
    SetISPProgress(i++, step);
    MStar_SetIICBusCtrl();
    SetISPProgress(i++, step);
    MStar_EnterISPMode();
    SetISPProgress(i++, step);
    
    MStar_DisableHWWriteProtect();
    SetISPProgress(i++, step);
    
    //MStar_FlashDetectType();
    //MStar_EndCMD();
    
    //MStar_FlashReadStatus();
    //MStar_EndCMD();
    
    return true;
}
-(BOOL) MStar_EndISP
{
    int i = 0, step = 4;
    SetISPStep(Finished);
    
    if ([self MStar_USBConnect] == false)
        return false;
    
    MStar_ExitSingleStepMode();
    SetISPProgress(i++, step);
    MStar_ExitSerialDebugMode();
    SetISPProgress(i++, step);
    MStar_ExitISPMode();
    SetISPProgress(i++, step);
    MStar_EndCMD();
    SetISPProgress(i++, step);
    
    return true;
}

-(BOOL) MStar_FlashChipErase
{
    int i = 0, step = 2;
    
    SetISPStep(Erase);
    
    if ([self MStar_USBConnect] == false)
        return false;
    
    MStar_FlashWriteEnable();
    MStar_FlashWriteStatus();
    MStar_FlashSpecialUnprotect();
    MStar_FlashWriteEnable();
    MStar_FlashWriteStatus();
    MStar_FlashWriteEnable();
    SetISPProgress(i++, step);
    
    BYTE ISP_CMD[10] = { 0x10, 0xC7 };
    BYTE DeviceAddr = 0x92 >> 1;
    DWORD DataLen = 2;
    DWORD result = 0;
    if (USBDeviceAttached == TRUE)
        result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
    MStar_EndCMD();
    SetISPProgress(i++, step);
    
    return true;
}
-(BOOL) MStar_FlashProgram
{
    SetISPStep(Program);
    
    if ([self MStar_USBConnect] == false)
        return false;
    
    BYTE ISP_CMD[261];
    memset(ISP_CMD, 0xFF, 261);
    
    BYTE DeviceAddr = 0x92 >> 1;
    DWORD DataLen = 256 + 5;
    DWORD result = 0;
    int blocksize = 256;
    int BinFileSize= (FileSize);//543060;
    
    ISP_CMD[0] = 0x10;
    ISP_CMD[1] = 0x02;
    ISP_CMD[2] = 0x00;  //AddrH
    ISP_CMD[3] = 0x00;  //AddrM
    ISP_CMD[4] = 0x00;  //AddrL
    for (int i = 0; i < BinFileSize; i = i + blocksize)
    {
#if 1
        while (true)
        {
            if (MStar_FlashReadStatus() == TRUE)
                break;
        }
        
        MStar_FlashWriteEnable();
        MStar_FlashWriteStatus();
        MStar_FlashSpecialUnprotect();
        MStar_FlashWriteEnable();
        MStar_FlashWriteStatus();
        MStar_FlashWriteDisable();
        MStar_FlashWriteEnable();
#endif
        
        ISP_CMD[2] = (BYTE)((i >> 16) & 0xFF);  //AddrH
        ISP_CMD[3] = (BYTE)((i >> 8) & 0xFF);   //AddrM
        ISP_CMD[4] = (BYTE)(i & 0xFF);          //AddrL
        
        if (BinFileSize - i < blocksize)  // last data smaller than block size
        {
            blocksize = (int)BinFileSize - i;
        }
        
        for(int j=0; j<blocksize; j++)
        {
            ISP_CMD[j+5] = BinFile[i+j];
            //printf("%X ", BinFile[i+j]);
        }
        
        //memccpy(ISP_CMD[5], BinFile[i], 1 , blocksize);
#if 1
        if ([self MStar_USBConnect] == TRUE)
            result = WriteI2C(plugNPlay.HIDDeviceHandle , DeviceAddr, &ISP_CMD[0], DataLen);
        else
            return false;
        
        MStar_EndCMD();
#endif
        SetISPProgress(i, BinFileSize);
    }
    
    return true;
}

-(BOOL) MStar_FlashBlanking
{
    bool isBlank = TRUE;
    
    SetISPStep(Blanking);
    
    //byte[] I2CReadDataBuffer = new byte[524288];
    //MStar_FlashRead(I2CReadDataBuffer, 524288);
    
    //byte[] I2CReadDataBuffer = new byte[4096];
    //MStar_FlashRead(I2CReadDataBuffer, 4096);
    //foreach (byte element in I2CReadDataBuffer)
    //{
    //    if (element != 0xFF)
    //    {
    //        isBlank = false;
    //        break;
    //    }
    //}
    //System.IO.File.WriteAllBytes("Blanking.bin", I2CReadDataBuffer);
    
    return isBlank;
}
-(BOOL) MStar_FlashVerify
{
    bool isVerify = false;
    SetISPStep(Verify);
    
    /* byte[] I2CReadDataBuffer = new byte[524288];
     MStar_FlashRead(I2CReadDataBuffer, 4096);
     
     isVerify = Array.Equals(BinFile, I2CReadDataBuffer);
     
     System.IO.File.WriteAllBytes("Verifying.bin", I2CReadDataBuffer);*/
    
    return isVerify;
}


@end

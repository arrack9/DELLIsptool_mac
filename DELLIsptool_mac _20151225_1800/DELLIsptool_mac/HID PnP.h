/********************************************************************
 FileName:      HID PnP.h
 Dependencies:  See INCLUDES section
 Processor:     PIC18, PIC24, dsPIC, and PIC32 USB Microcontrollers
 Hardware:      Mac OS X >=10.5 while interfacing with Microchip USB microcontroller
 Complier:      Use Xcode 4.2 or later
 Company:       Microchip Technology, Inc.
 
 Software License Agreement:
 
 The software supplied herewith by Microchip Technology Incorporated
 (the "Company") for its PIC(R) Microcontroller is intended and
 supplied to you, the Company's customer, for use solely and
 exclusively on Microchip PIC Microcontroller products. The
 software is owned by the Company and/or its supplier, and is
 protected under applicable copyright laws. All rights are reserved.
 Any use in violation of the foregoing restrictions may subject the
 user to criminal sanctions under applicable laws, as well as to
 civil liability for the breach of the terms and conditions of this
 license.
 
 THIS SOFTWARE IS PROVIDED IN AN "AS IS" CONDITION. NO WARRANTIES,
 WHETHER EXPRESS, IMPLIED OR STATUTORY, INCLUDING, BUT NOT LIMITED
 TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 PARTICULAR PURPOSE APPLY TO THIS SOFTWARE. THE COMPANY SHALL NOT,
 IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL OR
 CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
 
 ********************************************************************
 File Description:
 
 Change History:
 Rev   Description
 ----  -----------------------------------------
 1.0   Initial release
 ********************************************************************/

#import <Cocoa/Cocoa.h>
#import <IOKit/hid/IOHIDManager.h>
#include "hid.h"

//USB Product and Vendor ID numbers that this code will try to find on the USB bus.
//Make sure that these definitions match the USB descriptors in the USB device.
#define vendorID 0x0424
#define productID 0x274c


typedef int HANDLE;
typedef unsigned char BYTE;
typedef unsigned short int WORD;
typedef unsigned long int DWORD;

#define BYTE BYTE
#define WORD WORD

@interface HID_PnP : NSObject {
	//bool toggleLeds;
	//bool pushButton;
	bool isConnected;
    bool doI2CReadByte;
    int i2CWriteAddress;
    //int i2CInternalAddress;
    //unsigned char i2CWritePayloadByte;
    
    int i2CReadDeviceAddress;
    //int i2CReadInternalAddress;
    //unsigned char i2CReadByteValue;
    unsigned char ReadByteValue0;
    unsigned char ReadByteValue1;
    unsigned char ReadByteValue2;
    unsigned char ReadByteValue3;
    unsigned char ReadByteValue4;
    unsigned char ReadByteValue5;
    unsigned char ReadByteValue6;
    unsigned char ReadByteValue7;
    unsigned char ReadByteValue8;
    unsigned char ReadByteValue9;
    unsigned char ReadByteValue10;
    unsigned char ReadByteValue11;
    unsigned char ReadByteValue12;
    unsigned char ReadByteValue13;
    unsigned char ReadByteValue14;
    unsigned char ReadByteValue15;    
    bool i2CReadByteValueValid;
	
    //unsigned char I2CIndex;
    unsigned int PayloadByteCount;
    unsigned char DataPayload0;
    unsigned char DataPayload1;
    unsigned char DataPayload2;
    unsigned char DataPayload3;
    unsigned char DataPayload4;
    unsigned char DataPayload5;
    unsigned char DataPayload6;
    unsigned char DataPayload7;
    unsigned char DataPayload8;
    unsigned char DataPayload9;
    unsigned char DataPayload10;
    unsigned char DataPayload11;
    unsigned char DataPayload12;
    unsigned char DataPayload13;
    unsigned char DataPayload14;
    unsigned char DataPayload15;
    unsigned int ReadPayloadByteCount;
    
	IOHIDManagerRef hidManager;
    HANDLE HIDDeviceHandle;
}

// Read-write modifiers for class variables

@property(readwrite) bool isConnected, doI2CReadByte, i2CReadByteValueValid;
@property(readwrite) int i2CWriteAddress,i2CReadDeviceAddress;
@property(readwrite) unsigned char DataPayload0, DataPayload1, DataPayload2, DataPayload3, DataPayload4, DataPayload5, DataPayload6, DataPayload7, DataPayload8, DataPayload9, DataPayload10, DataPayload11, DataPayload12, DataPayload13, DataPayload14, DataPayload15, ReadByteValue0, ReadByteValue1, ReadByteValue2, ReadByteValue3, ReadByteValue4, ReadByteValue5, ReadByteValue6, ReadByteValue7, ReadByteValue8, ReadByteValue9, ReadByteValue10, ReadByteValue11, ReadByteValue12, ReadByteValue13, ReadByteValue14, ReadByteValue15;
@property(readwrite) unsigned int PayloadByteCount, ReadPayloadByteCount;

@property(readwrite) HANDLE HIDDeviceHandle;


// Objective C Functions
- (id) init;


 //Make sure these values match the USB endpoint size and report descriptor in the USB device firmware
#define HID_OUTPUT_REPORT_SIZE  64 
#define HID_INPUT_REPORT_SIZE   64
#define MAX_USB_I2C_PACKET_WRITE_PAYLOAD_SIZE 60
#define MAX_USB_I2C_PACKET_READ_PAYLOAD_SIZE 60
#define USB_PACKET_OFFSET_TO_PAYLOAD    4

#define COMMAND_BYTE_WRITE_I2C_EE_BYTE  0x90
#define COMMAND_BYTE_READ_I2C_EE_BYTE   0x91
#define COMMAND_BYTE_WRITE_I2C_PACKET   0x92
#define COMMAND_BYTE_READ_I2C_PACKET    0x93
#define COMMAND_RESPONSE_BYTE_READ_I2C_PACKET   0x94
#define COMMAND_BYTE_INIT_I2C_PACKET    0x95
#define COMMAND_BYTE_DEINIT_I2C_PACKET 0x96

#define I2C_SPEED_100KHZ    0
#define I2C_SPEED_200KHZ    1
#define I2C_SPEED_400KHZ    2
#define I2C_SPEED_600KHZ    3
#define I2C_SPEED_800KHZ    4
#define I2C_SPEED_1000KHZ   5
#define I2C_SPEED_MAXIMUM   6

#define I2CFL_SEND_START 0x02
#define I2CFL_SEND_STOP 0x01
#define I2CFL_SEND_NACK 0x04

#define INVALID_HANDLE_VALUE         0

//Possible error code return values when calling GetLastErrorCode()
#define ERROR_SUCCESS                           0   //No error, everything was successful
#define ERROR_INVALID_PARAMETER                 87  //One or more input parameters to the function was out of the expected range
#define ERROR_OTHER_ERROR                       1   //Some other uncategorized error occurred
#define ERROR_USB_TO_I2C_WRITE_FAILED           2   //A problem occurred on an OUT request
#define ERROR_USB_TO_I2C_READ_FAILED            3   //A problem occurred on an IN request
#define ERROR_NO_MATCHING_DEVICES_FOUND         4   //No devices with matching VID/PID were found
#define ERROR_DEVICE_INDEX_INVALID              5   //No devices with matching index were found (or the index is simply too high)


//API Function Prototypes
HANDLE OpenDevice(int index, BYTE busSpeed);
HANDLE OpenDeviceWithID(WORD VendorID, WORD ProductID, int index, BYTE busSpeed);
DWORD WriteI2C(HANDLE hdl, BYTE DeviceAddr, BYTE* pDataBuf, DWORD DataLen);
DWORD ReadI2C(HANDLE hdl, BYTE DeviceAddr, BYTE* pDataBuf, DWORD DataLen);
BYTE GetLastErrorCode(HANDLE hdl);
BOOL CloseDevice(HANDLE hdl);
DWORD I2CTransfer(HANDLE hdl,BOOL bDirection, BYTE DeviceAddr, BYTE* pDataBuf, DWORD DataLen, BOOL bStart,BOOL bStop, BOOL bNack);



// Callback C functions
//static void MyInputCallback(void *context, IOReturn result, void *sender, IOHIDReportType type, uint32_t reportID, BYTE *report, CFIndex reportLength);
//static void MyRemovalCallback(void *context, IOReturn result, void *sender, IOHIDDeviceRef device);
//static void MyNewDeviceCallback(void *context, IOReturn result, void *sender, IOHIDDeviceRef device);

@end

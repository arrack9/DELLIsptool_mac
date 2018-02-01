/********************************************************************
 FileName:      HID PnP.m
 Dependencies:  See INCLUDES section
 Processor:     PIC18, PIC24, dsPIC, and PIC32 USB Microcontrollers
 Hardware:      Mac OS X >=10.5 while interfacing with Microchip USB microcontroller
 Complier:      Use Xcode 4.2 or later
 Company:       Microchip Technology, Inc.
 
 Software License Agreement:
 
 The software supplied herewith by Microchip Technology Incorporated
 (the "Company") for its PIC(R) Microcontroller is intended and
 supplied to you, the Company's customer, for use solely and
 exclusively with Microchip PIC Microcontroller products. The
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

#import "HID PnP.h"


void *selfRef;


#define MAX_SUPPORTED_SIMULTANEOUS_DEVICES 255
BYTE LastErrorCodes[MAX_SUPPORTED_SIMULTANEOUS_DEVICES];




@implementation HID_PnP
@synthesize isConnected, i2CWriteAddress, i2CReadDeviceAddress, doI2CReadByte, i2CReadByteValueValid, PayloadByteCount, DataPayload0, DataPayload1, DataPayload2, DataPayload3, DataPayload4, DataPayload5, DataPayload6, DataPayload7, DataPayload8, DataPayload9, DataPayload10, DataPayload11, DataPayload12, DataPayload13, DataPayload14, DataPayload15, ReadPayloadByteCount, ReadByteValue0, ReadByteValue1, ReadByteValue2, ReadByteValue3, ReadByteValue4, ReadByteValue5, ReadByteValue6, ReadByteValue7, ReadByteValue8, ReadByteValue9, ReadByteValue10, ReadByteValue11, ReadByteValue12, ReadByteValue13, ReadByteValue14, ReadByteValue15, HIDDeviceHandle;

- (id) init {
	// Init routine for parent class
	if(!(self = [super init])) {
		NSLog(@"DemoApp init Error");
		return nil;
	}
	
	// Initialize class variables
	isConnected = FALSE;
	
	// Save pointer reference to self for C callback functions
	selfRef = (__bridge void *)(self);
    //Try to find and attach to the USB device.  Also sends it the command to set the I2C baud rate
    HIDDeviceHandle = OpenDevice(0, I2C_SPEED_400KHZ);
    if(HIDDeviceHandle != 0)
    {
        isConnected = TRUE;
    }
    else
    {
        isConnected = FALSE;
    }
    
//	// Initialize HID Manager
//	hidManager = IOHIDManagerCreate(kCFAllocatorDefault, kIOHIDOptionsTypeNone);
//	
//	// Initialize Dictionary with USB Product and Vendor IDs and find any devices matching them
//	NSMutableDictionary *deviceDictionary = [NSMutableDictionary dictionary];
//	[deviceDictionary setObject:[NSNumber numberWithLong:productID]
//						 forKey:[NSString stringWithCString:kIOHIDProductIDKey encoding:NSUTF8StringEncoding]];
//	[deviceDictionary setObject:[NSNumber numberWithLong:vendorID]
//						 forKey:[NSString stringWithCString:kIOHIDVendorIDKey encoding:NSUTF8StringEncoding]];
//	IOHIDManagerSetDeviceMatching(hidManager, (CFMutableDictionaryRef)deviceDictionary);	
//	
//	// Open HID Manager	
//	IOHIDManagerOpen(hidManager, 0L);
//	
//	// See if new device is detected
//	[self NewDeviceDetected];
	
	// Return self
	return self;
}

//- (void) DeviceRemoved{
//	// Remove device reference
//	HIDDeviceHandle = 0;
//	
//	// Set connected, toggle LEDs, and pushbutton flags to false. Set potentiometer reading to 0
//	isConnected = FALSE;
//	pushButton = FALSE;
//	toggleLeds = FALSE;
//	potentiometerVoltage = 0;
//	
//	// Unregsiter device removed callback, register the callback handler when a new device is enumerated to check if it matches VID and PID
//	IOHIDManagerRegisterDeviceRemovalCallback(hidManager, NULL, NULL);
//	IOHIDManagerRegisterDeviceMatchingCallback(hidManager, MyNewDeviceCallback, NULL);
//}

//- (void) NewDeviceDetected {
//	// Schedule HID Manger with current run loop with default mode and event tracking mode
//	IOHIDManagerScheduleWithRunLoop(hidManager, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
//	IOHIDManagerScheduleWithRunLoop(hidManager, CFRunLoopGetCurrent(), (CFStringRef)NSEventTrackingRunLoopMode);
//	
//	// Obtain current enumerated devices that match VID and PID; only take the first instance and throw away the rest
//	NSSet *allDevices = (NSSet *)IOHIDManagerCopyDevices(hidManager);
//	NSArray *myDevices = [allDevices allObjects];
//	HIDDeviceHandle = ([myDevices count]) ? (IOHIDDeviceRef)[myDevices objectAtIndex:0] : nil;
//		
//	// If a device is attached
//	if(HIDDeviceHandle) {
//		// Set connected flag to true
//		isConnected = TRUE;
//		
//		// Register the callback functions to handle when an IN data packet is received and when the device is removed
//        
//		IOHIDDeviceRegisterInputReportCallback(HIDDeviceHandle, (BYTE*)&INBuffer, 64, MyInputCallback, NULL);
//		
//        IOHIDManagerRegisterDeviceRemovalCallback(hidManager, MyRemovalCallback, NULL);
//		
//		// Setup output buffer with get pushbutton state command as first byte of packet and fill the rest of the packet
//		OUTBuffer[0] = 0x81;
//		memset((void*)&OUTBuffer[1], 0xFF, 63);
//		
//		// Send Output buffer to device with Report ID = 0
//		//IOHIDDeviceSetReport(HIDDeviceHandle, kIOHIDReportTypeOutput, 0, (BYTE*)&OUTBuffer, 64);
//		
//		// Unregister the callback function that handles new devices, since this example only supports one custom hid device at a time
//		IOHIDManagerRegisterDeviceMatchingCallback(hidManager, NULL, NULL);
//	}
//	// If device is not attached
//	else {
//		[self  DeviceRemoved];
//	}
//}




//This is the callback function that gets called whenever the firmware sends
//a new USB HID input report packet to the host.
//- (void) PacketReceived {
//    unsigned int i;
//    
//    //First make sure there is room in the packet buffer.
//    if(INPacketCount < IN_PACKET_BUFFER_DEPTH)
//    {
//        //Check for circular buffer index/pointer wraparound
//        if(INPacketWriteIndex >= IN_PACKET_BUFFER_DEPTH)
//            INPacketWriteIndex = 0;
//        
//        //Room exists in the buffer, save the most recently received USB IN packet to the buffer
//        for(i = 0; i < HID_INPUT_REPORT_SIZE; i++)
//        {
//            INPacketBuffer[INPacketWriteIndex][i] = INBuffer[i];        
//        }
//        INPacketCount++;  //Note: Careful - requires mutex protection depending upon usage
//        INPacketWriteIndex++;
//    }
//    
//	if(toggleLeds == TRUE)
//	{
//		// Clear toggle LEDs flag
//		toggleLeds = FALSE;
//        
//        //Prepare for next packet now
//        OUTBuffer[0] = 0x81;  //Get pushbutton state
//	}
//	if(INBuffer[0] == 0x81) {
//		// Set pushbutton status to pressed if if INBuffer[1] is 0, otherwise not pressed
//		pushButton = (INBuffer[1] == 0x00);
//			
//		// Setup output buffer with the get pushbutton state command
//		OUTBuffer[0] = 0x81;
//	}
//    if(doI2CReadByte == TRUE)
//    {
//		// Clear doI2C read byte command flag
//		doI2CReadByte = FALSE;
////        // Fill the the output buffer with 0xFF pad byte values.
////		memset((void*)&OUTBuffer[0], 0xFF, 64);	
////        
////		// Setup output buffer with do I2C Read packet  Command (0x93) as first byte of packet
////        OUTBuffer[0] = COMMAND_BYTE_READ_I2C_PACKET;
////        OUTBuffer[1] = i2CReadDeviceAddress;
////        OUTBuffer[2] = ReadPayloadByteCount;      //32-bit LSB of total byte count to read from I2C slave 
////        OUTBuffer[3] = 0;                         
////        OUTBuffer[4] = 0;     
////        OUTBuffer[5] = 0;                         //32-bit MSB of total byte count to read from I2C slave
//
//        
//		//IOHIDDeviceSetReport(HIDDeviceHandle, kIOHIDReportTypeOutput, 0, (BYTE*)&OUTBuffer, 64);        
//    }
//    if(INBuffer[0] == COMMAND_RESPONSE_BYTE_READ_I2C_PACKET)
//    {
//        unsigned int i;
//        //To update the GUI form text box for the I2C read byte value, we simply copy
//        //the value from the USB INBuffer to the i2CReadByteValue variable, which gets
//        //used in the GUI form update thread to update the form.
//        for(i = 4 + INBuffer[2]; i < 64; i++)
//        {
//            INBuffer[i] = 0x00;
//        }
//        
//        ReadByteValue0 = INBuffer[4];
//        ReadByteValue1 = INBuffer[5];
//        ReadByteValue2 = INBuffer[6];
//        ReadByteValue3 = INBuffer[7];
//        ReadByteValue4 = INBuffer[8];
//        ReadByteValue5 = INBuffer[9];
//        ReadByteValue6 = INBuffer[10];
//        ReadByteValue7 = INBuffer[11];
//        ReadByteValue8 = INBuffer[12];
//        ReadByteValue9 = INBuffer[13];
//        ReadByteValue10 = INBuffer[14];
//        ReadByteValue11 = INBuffer[15];
//        ReadByteValue12 = INBuffer[16];
//        ReadByteValue13 = INBuffer[17];
//        ReadByteValue14 = INBuffer[18];
//        ReadByteValue15 = INBuffer[19];
//        
//        i2CReadByteValueValid = TRUE;
//        
//        // Setup output buffer with get Push Button Status value (0x81) as first byte of packet
//		OUTBuffer[0] = 0x81;
//    }
//		
//    //Now actually queue up the USB OUT report packet to be sent to the USB device.
//	IOHIDDeviceSetReport(HIDDeviceHandle, kIOHIDReportTypeOutput, 0, (BYTE*)&OUTBuffer, 64);
//}



/*---------------------------------------------------------------------------------------
 Function: HANDLE OpenDevice(int index, BYTE busSpeed)
 Description: Opens the USB device with the specified index (which starts from 0), and the specified I2C bus speed.  If no devices are found with matching VID/PID/index, or some kind of problem occurs, and error will be logged and can be retrieved with GetLastErrorCode().  If the error code is ERROR_SUCCESS and the HANDLE returned is not equal to INVALID_HANDLE_VALUE, then it can be assumed that the device with matching index was opened successfully.
 Note: The index starts from 0.  If only one USB device with matching VID/PID is attached to the machine, the index value should be set to 0 when calling this function.  The busSpeed is an enumeration indicating the I2C baud rate that should be used.  See header file for allowed values (ex: I2C_SPEED_400KHZ).
     This function uses the VID/PID values when trying to find the USB device.  The VID/PID values are hardcoded as the vendorID and productID values (see header file for definition).  Make sure these values match the USB device descriptor in the USB device firmware.
 ---------------------------------------------------------------------------------------*/
HANDLE OpenDevice(int index, BYTE busSpeed)
{
    //Use hardcoded "vendorID" and "productID" values, to open the device.
    return OpenDeviceWithID(vendorID, productID, index, busSpeed);
}

/*---------------------------------------------------------------------------------------
 Function: HANDLE OpenDeviceWithID(WORD VendorID, WORD ProductID, int index, BYTE busSpeed)
 Description: Opens the USB device with the specified USB Vendor ID, USB Product ID, and 
			  instance index (which starts from 0).  If opened successfully, it also sends
			  the necessary command to the firmware to set the I2C baud rate.
			  If no devices are found with matching VID/PID/index, or some kind of 
			  problem occurs, and error will be logged and can be retrieved with 
			  GetLastErrorCode(index+1).  If the error code is ERROR_SUCCESS and the HANDLE 
			  returned is not equal to INVALID_HANDLE_VALUE, 
			  then it can be assumed that the device with matching index was opened 
			  successfully.
 Note: The index starts from 0.  If only one USB device with matching VID/PID is attached
	   to the machine, the index value should be set to 0 when calling this function.  
	   The busSpeed is an enumeration indicating the I2C baud rate that should be used.  
	   See header file for allowed values (ex: I2C_SPEED_400KHZ). 
 ---------------------------------------------------------------------------------------*/
 HANDLE OpenDeviceWithID(WORD VendorID, WORD ProductID, int index, BYTE busSpeed)
{
    int BytesSent = 0;
    int DevicesOpened;
    static unsigned char LocalOUTBuffer[HID_OUTPUT_REPORT_SIZE];
    unsigned int ErrorIndex = index + 1;    
    
    //Make sure the index is within the error status array size.  If not, just save the error status to the last element.
    if(ErrorIndex >= MAX_SUPPORTED_SIMULTANEOUS_DEVICES)
        ErrorIndex = MAX_SUPPORTED_SIMULTANEOUS_DEVICES - 1;
    
    //Set error status to "success" until it gets changed to something else later if an actual error is detected
    LastErrorCodes[ErrorIndex] = ERROR_SUCCESS;
    
    //Before doing anything, do some error checking on the input parameters
    if(index > MAX_SUPPORTED_SIMULTANEOUS_DEVICES)
    {
        ErrorIndex = MAX_SUPPORTED_SIMULTANEOUS_DEVICES - 1;
        LastErrorCodes[ErrorIndex] = ERROR_DEVICE_INDEX_INVALID;
    }
    

    //Try to find and open the device with the requested index
    DevicesOpened = rawhid_open(index + 1, VendorID, ProductID, -1, -1);
    if(DevicesOpened >= (index + 1))
    {
        //Fill the the output buffer with 0xFF pad byte values initially.
		memset((void*)&LocalOUTBuffer[0], 0xFF, 64);	
        
        //Prepare and send a USB OUT packet to tell the I2C master what baud rate it should run at
        LocalOUTBuffer[0] = COMMAND_BYTE_INIT_I2C_PACKET;
        LocalOUTBuffer[1] = 0x00;       //I2C device address, irrelevant for init
        LocalOUTBuffer[2] = busSpeed;   //Byte 2 is the I2C bus speed to operate at
        BytesSent = rawhid_send(index, &LocalOUTBuffer, HID_OUTPUT_REPORT_SIZE, 10000);
        if(BytesSent <= 0)
        {
            LastErrorCodes[ErrorIndex] = ERROR_USB_TO_I2C_WRITE_FAILED;
            ErrorIndex = MAX_SUPPORTED_SIMULTANEOUS_DEVICES - 1;
            LastErrorCodes[ErrorIndex] = ERROR_USB_TO_I2C_WRITE_FAILED;
        }
    }
    
    //Do error case checking/reporting
    if(DevicesOpened <= 0)
    {
        LastErrorCodes[ErrorIndex] = ERROR_NO_MATCHING_DEVICES_FOUND;
        ErrorIndex = MAX_SUPPORTED_SIMULTANEOUS_DEVICES - 1;
        LastErrorCodes[ErrorIndex] = ERROR_NO_MATCHING_DEVICES_FOUND;
    }
    else if(DevicesOpened < (index + 1))
    {
        LastErrorCodes[ErrorIndex] = ERROR_DEVICE_INDEX_INVALID;
        ErrorIndex = MAX_SUPPORTED_SIMULTANEOUS_DEVICES - 1;
        LastErrorCodes[ErrorIndex] = ERROR_DEVICE_INDEX_INVALID;
    }
        
    
    //Check if we were successful in opening the device and sending the command to set I2C baud rate
    if((DevicesOpened >= (index + 1)) && (BytesSent > 0))
    {
        //Successfully opened all the devices with lower or equal index as the user's one of interest
        return (index + 1); //The "HANDLE" will be the device index + 1.
    }
    else
    {
        //Failed to open the desired instance index
        return INVALID_HANDLE_VALUE;
    }
    
    return INVALID_HANDLE_VALUE;
}


/*---------------------------------------------------------------------------------------
 Function: BOOL CloseDevice(HANDLE hdl)
 Description: This function closes the USB device with the specified HANDLE.  The return values is a BOOLEAN indicating if the device was successfully closed or not.
 ---------------------------------------------------------------------------------------*/
BOOL CloseDevice(HANDLE hdl)
{
    unsigned int ErrorIndex = hdl;
    int BytesSent = 0;
	static unsigned char LocalOUTBuffer[HID_OUTPUT_REPORT_SIZE];
    
    //Make sure the index is within the error status array size.  If not, just save the error status to the last element.
    if(ErrorIndex >= MAX_SUPPORTED_SIMULTANEOUS_DEVICES)
        ErrorIndex = MAX_SUPPORTED_SIMULTANEOUS_DEVICES - 1;
    
    //Set error status to "success" until it gets changed to something else later if an actual error is detected
    LastErrorCodes[ErrorIndex] = ERROR_SUCCESS;
	
	//Fill the the output buffer with 0xFF pad byte values initially.
	memset((void*)&LocalOUTBuffer[0], 0xFF, 64);	
        
    //Prepare and send a USB OUT packet to tell the I2C master what baud rate it should run at
    LocalOUTBuffer[0] = COMMAND_BYTE_DEINIT_I2C_PACKET;

    BytesSent = rawhid_send(index, &LocalOUTBuffer, HID_OUTPUT_REPORT_SIZE, 10000);
    if(BytesSent <= 0)
    {
        LastErrorCodes[ErrorIndex] = ERROR_USB_TO_I2C_WRITE_FAILED;
        ErrorIndex = MAX_SUPPORTED_SIMULTANEOUS_DEVICES - 1;
        LastErrorCodes[ErrorIndex] = ERROR_USB_TO_I2C_WRITE_FAILED;
    }
    
    rawhid_close(hdl - 1);
    return TRUE;
}


/*---------------------------------------------------------------------------------------
Function: DWORD WriteI2C(HANDLE hdl, BYTE DeviceAddr, BYTE* pDataBuf, DWORD DataLen)
Description: This function sends USB commands to the USB device, so as to issue I2C write requests to an attached slave device.  The HANDLE hdl is an input parameter that should be the same as the value
 returned by the OpenDevice() call.  The DeviceAddr is the 7-bit I2C address of the slave device to write to, the pDataBuf is a pointer to a user allocated data buffer that contains the data bytes to be sent over I2C to the slave device.  The DataLen is the number of bytes that should be written to the I2C slave device.  The return value is the number of bytes that were successfully written (normally equal to DataLen in the event of success, or 0, in the event of some unexecpted failure during the write).  Error status infomration can be retrived by calling GetLastErrorCode() after calling this function.  If the function is successful, it returns ERROR_SUCCESS.
---------------------------------------------------------------------------------------*/
 DWORD WriteI2C(HANDLE hdl, BYTE DeviceAddr, BYTE* pDataBuf, DWORD DataLen)
{
    DWORD NumberofBytesActuallySent = 0;
    int BytesToSend;
    DWORD RemainingBytesToSend;
    unsigned int i;
    static unsigned char LocalOUTBuffer[HID_OUTPUT_REPORT_SIZE];
    unsigned int ErrorIndex = hdl;
    
    //Make sure the index is within the error status array size.  If not, just save the error status to the last element.
    if(ErrorIndex >= MAX_SUPPORTED_SIMULTANEOUS_DEVICES)
        ErrorIndex = MAX_SUPPORTED_SIMULTANEOUS_DEVICES - 1;
    
    //Set error status to "success" until it gets changed to something else later if an actual error is detected
    LastErrorCodes[ErrorIndex] = ERROR_SUCCESS;
    
    //Before doing anything, do some error checking on the input parameters
    if(DataLen == 0)
        return 0;
    if((pDataBuf == nil) || (hdl == 0) || (DeviceAddr > 127))
    {
        LastErrorCodes[ErrorIndex] = ERROR_INVALID_PARAMETER;
        return 0;
    }    
    
    //Keep track of the number of bytes to send, so we know how many packets to send
    RemainingBytesToSend = DataLen;
    
    //Keep sending packets until we have finished sending all of the data (or an error occurs)
    while(RemainingBytesToSend)
    {
        //Fill the the output buffer with 0xFF pad byte values initially.
		memset((void*)&LocalOUTBuffer[0], 0xFF, 64);	        
        
        //Compute how many valid data bytes of payload will be present in the next USB packet
        BytesToSend = MAX_USB_I2C_PACKET_WRITE_PAYLOAD_SIZE;
        if(RemainingBytesToSend < MAX_USB_I2C_PACKET_WRITE_PAYLOAD_SIZE)
        {
            BytesToSend = RemainingBytesToSend;
        }
        RemainingBytesToSend -= BytesToSend;  //Remove from running count of remaining bytes
        
        
        //Copy the data payload bytes from the user's buffer to the USB output endpoint packet buffer
        for(i = 0; i < BytesToSend; i++)
        {
            LocalOUTBuffer[i+USB_PACKET_OFFSET_TO_PAYLOAD] = *pDataBuf++;
        }
        
        //Setup the header info in the USB packet
        LocalOUTBuffer[0] = COMMAND_BYTE_WRITE_I2C_PACKET;
        LocalOUTBuffer[1] = DeviceAddr;
        LocalOUTBuffer[2] = BytesToSend;
        if(RemainingBytesToSend > 0)
        {
            LocalOUTBuffer[3] = 0xFF;    //A char bool "true", indicating we have more USB packets to send in this write request
        }
        else
        {
            LocalOUTBuffer[3] = 0; //A char bool "false", indicating that this is the last packet that we are going to send in this I2C write transaction.
        }
        
        //Now actually queue up the USB OUT report packet to be sent to the USB device.
        //IOHIDDeviceSetReport(hdl, kIOHIDReportTypeOutput, 0, (BYTE*)&OUTBuffer, HID_OUTPUT_REPORT_SIZE);
        BytesToSend = rawhid_send(hdl - 1, &LocalOUTBuffer, HID_OUTPUT_REPORT_SIZE, 10000);
        if(BytesToSend <= 0)
            LastErrorCodes[ErrorIndex] = ERROR_USB_TO_I2C_WRITE_FAILED;
        
        //Keep track of number of successfully sent bytes.
        if(BytesToSend > USB_PACKET_OFFSET_TO_PAYLOAD)
        {
            BytesToSend -= USB_PACKET_OFFSET_TO_PAYLOAD;   //Overhead chars on the USB packet
        }
        else
        {
            BytesToSend = 0;
        }
        NumberofBytesActuallySent += BytesToSend;
    }
    
    return NumberofBytesActuallySent;
}


/*---------------------------------------------------------------------------------------
 Function: DWORD ReadI2C(HANDLE hdl, BYTE DeviceAddr, BYTE* pDataBuf, DWORD DataLen)
 Description: This function sends USB commands to the firmware, to do an I2C read operation from the slave device.  The DataLen is an input parameter specifying the number of bytes that you wish to read from the slave device.  The hdl is the HANDLE that is returned when calling OpenDevice(), the DeviceAddr is the 7-bit I2C address to read from, and the pDataBuf is a pointer to the RAM buffer that should receive the I2C data that gets read from the slave device.  The buffer must be at least DataLen long.  After executing this function GetLastErrorCode() can be called to determine if any error occurred during the operation.  The return value is a DWORD, indicating the actual number of bytes that we successfully read from the device (usually the same as DataLen if successful, or 0 if something failed).
 ---------------------------------------------------------------------------------------*/
DWORD ReadI2C(HANDLE hdl, BYTE DeviceAddr, BYTE* pDataBuf, DWORD DataLen)
{
    DWORD NumberofBytesSuccessfullyRead = 0;
    unsigned int i;
    int BytesSent;
    int BytesRead;
    static unsigned char LocalOUTBuffer[HID_OUTPUT_REPORT_SIZE];
    static unsigned char LocalINBuffer[HID_INPUT_REPORT_SIZE];
    unsigned long long int EndAddress = (unsigned long long)pDataBuf + DataLen;
    unsigned int ErrorIndex = hdl;
    
    //Make sure the index is within the error status array size.  If not, just save the error status to the last element.
    if(ErrorIndex >= MAX_SUPPORTED_SIMULTANEOUS_DEVICES)
        ErrorIndex = MAX_SUPPORTED_SIMULTANEOUS_DEVICES - 1;
    
    //Set error status to "success" until it gets changed to something else later if an actual error is detected
    LastErrorCodes[ErrorIndex] = ERROR_SUCCESS;
    
    //Before doing anything, do some error checking on the input parameters
    if(DataLen == 0)
        return 0;
    if((pDataBuf == nil) || (hdl == 0) || (DeviceAddr > 127))
    {
        LastErrorCodes[ErrorIndex] = ERROR_INVALID_PARAMETER;
        return 0;
    }

    
    //Issue a USB OUT packet that contains the I2C read command and the number of bytes we are trying to read
    LocalOUTBuffer[0] = COMMAND_BYTE_READ_I2C_PACKET;
    LocalOUTBuffer[1] = DeviceAddr;
    LocalOUTBuffer[2] = DataLen;
    LocalOUTBuffer[3] = (unsigned char)(DataLen >> 8);
    LocalOUTBuffer[4] = (unsigned char)(DataLen >> 16);
    LocalOUTBuffer[5] = (unsigned char)(DataLen >> 24);
    
    //Now actually queue up the USB OUT report packet to be sent to the USB device.
    //IOHIDDeviceSetReport(hdl, kIOHIDReportTypeOutput, 0, (BYTE*)&OUTBuffer, HID_OUTPUT_REPORT_SIZE);    
    BytesSent = rawhid_send(hdl - 1, &LocalOUTBuffer, HID_OUTPUT_REPORT_SIZE, 10000);
    if(BytesSent <= 0)
        LastErrorCodes[ErrorIndex] = ERROR_USB_TO_I2C_WRITE_FAILED;
        
    
    //Now start reading IN packets from the USB device, until we have received all of the expected data.
    while(NumberofBytesSuccessfullyRead < DataLen)
    {
        //Now an IN report packet from the USB device
        BytesRead = rawhid_recv(hdl -1, &LocalINBuffer, HID_INPUT_REPORT_SIZE, 10000);
        if(BytesRead <= 0)
            LastErrorCodes[ErrorIndex] = ERROR_USB_TO_I2C_READ_FAILED;
            
        
        //Make sure the device actually sent a packet of the type we were expecting.
        if(LocalINBuffer[0] == COMMAND_RESPONSE_BYTE_READ_I2C_PACKET)
        {
            //Copy the data IN packet into the user's specified data buffer
            for(i = 0; i < MAX_USB_I2C_PACKET_READ_PAYLOAD_SIZE; i++)
            {
                //Check the remaining payload byte count byte in the packet
                if(LocalINBuffer[2] > 0)
                {
                    //Error check to make sure we don't overwrite the buffer in the case the firmware sends more data than we are expecting
                    if((unsigned long long)pDataBuf >= EndAddress)
                        break;
                    //Copy a byte from the USB packet buffer to the user's buffer
                    *pDataBuf++ = LocalINBuffer[i + USB_PACKET_OFFSET_TO_PAYLOAD];
                    //Keep track of byte counts
                    LocalINBuffer[2]--; //Read a byte out of the buffer
                    NumberofBytesSuccessfullyRead++;    //Successfully read an I2C byte from the device.
 
                }
            }
        }       
    }

    return NumberofBytesSuccessfullyRead;    
}
/*------------------------------------------------------------------------------------------------------------------------------------------------
Function:  DWORD I2CTransfer(HANDLE hdl,BOOL bDirection, BYTE DeviceAddr, BYTE* pDataBuf, DWORD DataLen, BOOL bStart,BOOL bStop, BOOL bNack)
---------------------------------------------------------------------------------------------------------------------------------------------------*/
DWORD I2CTransfer(HANDLE hdl,BOOL bDirection, BYTE DeviceAddr, BYTE* pDataBuf, DWORD DataLen, BOOL bStart,BOOL bStop, BOOL bNack)
{
	DWORD RemainingBytesToSend;
	DWORD NumberofBytes = 0;
	int i;
	int BytesToSend;
	int BytesSent;
    int BytesRead;
    BOOL bFirstTime = TRUE;
	static unsigned char LocalOUTBuffer[HID_OUTPUT_REPORT_SIZE];
	static unsigned char LocalINBuffer[HID_INPUT_REPORT_SIZE];
	unsigned int ErrorIndex = hdl;
	unsigned long long int EndAddress = (unsigned long long)pDataBuf + DataLen;
	BYTE byFlag = '\0',byWriteFlag;


	//Make sure the index is within the error status array size.  If not, just save the error status to the last element.
    if(ErrorIndex >= MAX_SUPPORTED_SIMULTANEOUS_DEVICES)
        ErrorIndex = MAX_SUPPORTED_SIMULTANEOUS_DEVICES - 1;

	//Set error status to "success" until it gets changed to something else later if an actual error is detected
    LastErrorCodes[ErrorIndex] = ERROR_SUCCESS;

	//Before doing anything, do some error checking on the input parameters
    if(DataLen == 0)
        return 0;
    if((pDataBuf == nil) || (hdl == 0) || (DeviceAddr > 127) )
    {
        LastErrorCodes[ErrorIndex] = ERROR_INVALID_PARAMETER;
        return 0;
    }
	// Consolidate all the flags into one byte
	if (bStart)
	{
		byFlag |= I2CFL_SEND_START;
	}
	if (bStop)
	{
		byFlag |= I2CFL_SEND_STOP;
	}
	if (bNack)
	{
		byFlag |= I2CFL_SEND_NACK;
	}
    byWriteFlag = byFlag;
	if(FALSE == bDirection) // 0 - I2C Write
	{
		//Keep track of the number of bytes to send, so we know how many packets to send
		RemainingBytesToSend = DataLen;

		//Keep sending packets until we have finished sending all of the data (or an error occurs)
		while(RemainingBytesToSend)
		{
			//Fill the the output buffer with 0xFF pad byte values initially.
			memset((void*)&LocalOUTBuffer[0], 0xFF, 64);

			//Compute how many valid data bytes of payload will be present in the next USB packet
			BytesToSend = MAX_USB_I2C_PACKET_WRITE_PAYLOAD_SIZE;
			if(RemainingBytesToSend < MAX_USB_I2C_PACKET_WRITE_PAYLOAD_SIZE)
			{
				BytesToSend = RemainingBytesToSend;
			}
			RemainingBytesToSend -= BytesToSend;  //Remove from running count of remaining bytes

			//Copy the data payload bytes from the user's buffer to the USB output endpoint packet buffer
			for(i = 0; i < BytesToSend; i++)
			{
				LocalOUTBuffer[i+USB_PACKET_OFFSET_TO_PAYLOAD] = *pDataBuf++;
			}
			 //Setup the header info in the USB packet
			LocalOUTBuffer[0] = COMMAND_BYTE_WRITE_I2C_EE_BYTE;
			LocalOUTBuffer[1] = DeviceAddr;
			LocalOUTBuffer[2] = BytesToSend;
            
            if (RemainingBytesToSend)
            {
                if (bFirstTime == FALSE)
                {
                    byWriteFlag &=~ I2CFL_SEND_START;
                }
                else
                {
                    byWriteFlag &=~ (I2CFL_SEND_STOP | I2CFL_SEND_NACK);
                }
            }
            if (RemainingBytesToSend == 0)
            {
                byWriteFlag =byFlag;
                if (bFirstTime == FALSE)
                {
                    byWriteFlag &=~ I2CFL_SEND_START;
                }
                
            }
			LocalOUTBuffer[3] = byWriteFlag;
			//Now actually queue up the USB OUT report packet to be sent to the USB device.
			//IOHIDDeviceSetReport(hdl, kIOHIDReportTypeOutput, 0, (BYTE*)&OUTBuffer, HID_OUTPUT_REPORT_SIZE);
	        BytesToSend = rawhid_send(hdl - 1, &LocalOUTBuffer, HID_OUTPUT_REPORT_SIZE, 10000);
	        if(BytesToSend <= 0)
	            LastErrorCodes[ErrorIndex] = ERROR_USB_TO_I2C_WRITE_FAILED;

			//Keep track of number of successfully sent bytes.
			if(BytesToSend > USB_PACKET_OFFSET_TO_PAYLOAD)
			{
				BytesToSend -= USB_PACKET_OFFSET_TO_PAYLOAD;   //Overhead chars on the USB packet
			}
			else
			{
				BytesToSend = 0;
			}
			NumberofBytes += BytesToSend;
            
            bFirstTime = FALSE;
        
		}
		return NumberofBytes;
	}
	else //1 - I2C Read
	{

		 //Issue a USB OUT packet that contains the I2C read command and the number of bytes we are trying to read
		LocalOUTBuffer[0] = COMMAND_BYTE_READ_I2C_EE_BYTE;
		LocalOUTBuffer[1] = DeviceAddr;
		LocalOUTBuffer[2] = (unsigned char)DataLen;
		LocalOUTBuffer[3] = (unsigned char)(DataLen >> 8);
		LocalOUTBuffer[4] = (unsigned char)(DataLen >> 16);
		LocalOUTBuffer[5] = (unsigned char)(DataLen >> 24);
		LocalOUTBuffer[6] = byFlag;

		//Now actually queue up the USB OUT report packet to be sent to the USB device.
		//IOHIDDeviceSetReport(hdl, kIOHIDReportTypeOutput, 0, (BYTE*)&OUTBuffer, HID_OUTPUT_REPORT_SIZE);    
		BytesSent = rawhid_send(hdl - 1, &LocalOUTBuffer, HID_OUTPUT_REPORT_SIZE, 10000);
	    
		
		if(BytesSent <= 0)
	        LastErrorCodes[ErrorIndex] = ERROR_USB_TO_I2C_WRITE_FAILED;
   

		//Now start reading IN packets from the USB device, until we have received all of the expected data.
		while(NumberofBytes < DataLen)
		{
			//Now an IN report packet from the USB device
			BytesRead = rawhid_recv(hdl -1, &LocalINBuffer, HID_INPUT_REPORT_SIZE, 10000);
        	if(BytesRead <= 0)
				LastErrorCodes[ErrorIndex] = ERROR_USB_TO_I2C_READ_FAILED;
			//Make sure the device actually sent a packet of the type we were expecting.
			if(LocalINBuffer[0] == COMMAND_RESPONSE_BYTE_READ_I2C_PACKET)
			{
				//Copy the data IN packet into the user's specified data buffer
				for(i = 0; i < MAX_USB_I2C_PACKET_READ_PAYLOAD_SIZE; i++)
				{
					//Check the remaining payload byte count byte in the packet
					if(LocalINBuffer[2] > 0)
					{
						if(LocalINBuffer[2] == 0)
						break;

						//Error check to make sure we don't overwrite the buffer in the case the firmware sends more data than we are expecting
						if((unsigned long long)pDataBuf >= EndAddress)
                        break;

						//Copy a byte from the USB packet buffer to the user's buffer
						*pDataBuf++ = LocalINBuffer[i + USB_PACKET_OFFSET_TO_PAYLOAD];
						//Keep track of byte counts
						NumberofBytes++;    //Successfully read an I2C byte from the device.
						LocalINBuffer[2]--; //Read a byte out of the buffer
					}
				}
			}
		}
		return NumberofBytes;
	}

}
//Returns the last error code that was logged by a call to ReadI2C(), WriteI2C() or OpenDevice()
BYTE GetLastErrorCode(HANDLE hdl)
{
    unsigned int ErrorIndex = hdl;
    
    //Make sure the index is within the error status array size.  If not, just save the error status to the last element.
    if((ErrorIndex >= MAX_SUPPORTED_SIMULTANEOUS_DEVICES) || (ErrorIndex == (unsigned int)INVALID_HANDLE_VALUE))
        ErrorIndex = MAX_SUPPORTED_SIMULTANEOUS_DEVICES - 1;

    return LastErrorCodes[ErrorIndex];
}


//static void MyInputCallback(void *context, IOReturn result, void *sender, IOHIDReportType type, uint32_t reportID, BYTE *report, CFIndex reportLength) {
//	[(id)selfRef PacketReceived];
//}
//
//static void MyRemovalCallback(void *context, IOReturn result, void *sender, IOHIDDeviceRef device) {
//	[(id)selfRef DeviceRemoved];
//}
//
//static void MyNewDeviceCallback(void *context, IOReturn result, void *sender, IOHIDDeviceRef device) {
//	[(id)selfRef NewDeviceDetected];
//}

@end

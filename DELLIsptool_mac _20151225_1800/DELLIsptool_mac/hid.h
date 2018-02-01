//
//  hid.h
//  HID PnP Demo
//
//  Created by Microchip on 5/15/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#ifndef HID_PnP_Demo_hid_h
#define HID_PnP_Demo_hid_h


int rawhid_open(int max, int vid, int pid, int usage_page, int usage);
int rawhid_recv(int num, void *buf, int len, int timeout);
int rawhid_send(int num, void *buf, int len, int timeout);
void rawhid_close(int num);

extern bool USBDeviceAttached;


#endif

//
//  ddKeycode.h
//  ClipdorieMac
//
//  Created by Seung-Chan Kim on 1/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#ifndef __DDKEYCODE__
#define __DDKEYCODE__

#import <Cocoa/Cocoa.h>

class CddKeycode
{
	
public:
	CddKeycode();
	

public:
	
	
	static void GetKeycodeFromChar(const char,CGKeyCode* pCode);
	static void GetIDFromKeycode(CGKeyCode code, int *nID);


};


#endif
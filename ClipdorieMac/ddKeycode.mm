//
//  ddKeycode.m
//  ClipdorieMac
//
//  Created by Seung-Chan Kim on 1/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#import "ddKeycode.h"
#include <CoreFoundation/CoreFoundation.h>
#include <Carbon/Carbon.h> /* For kVK_ constants, and TIS functions. */


CddKeycode::CddKeycode()
{
}


//should be changed

void CddKeycode::GetIDFromKeycode(CGKeyCode code, int *nID)
{
	
	switch (code) {
		case 18:		//1
			*nID = 1;
			break;
			
		case 19:
			*nID =  2;
			break;
			
		case 20:
			*nID =  3;
			break;
			
		case 21:
			*nID =  4;
			break;
			
		case 23:
			*nID =  5;
			break;
			
		case 22:
			*nID =  6;
			break;
			
		case 26:
			*nID =  7;
			break;
			
			
		case 28:
			*nID =  8;
			break;
			
		case 25:
			*nID =  9;
			break;
			
		case 29:
			*nID =  0;
			break;
			
			
			
		case 0:		//A
			*nID =  10;
			break;
			
			
		case 11:
			*nID =  11;
			break;
			
		case 8:
			*nID =  12;
			break;
			
		case 2:
			*nID =  13;
			break;
			
		case 14:
			*nID =  14;
			break;
			
		case 3:
			*nID =  15;
			break;
			
		case 5:
			*nID =  16;
			break;
			
		case 4:
			*nID =  17;
			break;
			
		case 34:
			*nID =  18;
			break;
			
		case 38:
			*nID =  19;
			break;
			
		case 40:
			*nID =  20;
			break;
			
		case 37:
			*nID =  21;
			break;
			
		case 46:
			*nID =  22;
			break;
			
		case 45:
			*nID =  23;
			break;
			
		case 31:
			*nID =  24;
			break;
			
		case 35:
			*nID =  25;
			break;
			
		case 12:
			*nID =  26;
			break;
			
		case 15:
			*nID =  27;
			break;
			
		case 1:
			*nID =  28;
			break;
			
		case 17:
			*nID =  29;
			break;
			
		case 32:
			*nID =  30;
			break;
			
		case 9:
			*nID =  31;
			break;
			
		case 13:
			*nID =  32;
			break;
			
		case 7:
			*nID =  33;
			break;
			
		case 16:
			*nID =  34;
			break;
			
		case 6:
			*nID =  35;
			break;
			
			
		default:
			*nID =  1;//'1'
			break;
	}
}
	
void CddKeycode::GetKeycodeFromChar(const char ch,CGKeyCode* pCode)
{

	switch (ch) {
		case '1':
			*pCode = 18;
			break;
			
		case '2':
			*pCode = 19;
			break;
			
		case '3':
			*pCode = 20;
			break;
			
		case '4':
			*pCode = 21;
			break;
			
		case '5':
			*pCode = 23;
			break;
			
		case '6':
			*pCode = 22;
			break;
			
		case '7':
			*pCode = 26;
			break;
			
			
		case '8':
			*pCode = 28;
			break;
			
		case '9':
			*pCode = 25;
			break;
			
		case '0':
			*pCode = 29;
			break;
			
		case 'A':
			*pCode = 0;
			break;
			
			
		case 'B':
			*pCode = 11;
			break;
			
		case 'C':
			*pCode = 8;
			break;
			
		case 'D':
			*pCode = 2;
			break;
			
		case 'E':
			*pCode = 14;
			break;
			
		case 'F':
			*pCode = 3;
			break;
			
		case 'G':
			*pCode = 5;
			break;
			
		case 'H':
			*pCode = 4;
			break;
			
		case 'I':
			*pCode = 34;
			break;
			
		case 'J':
			*pCode = 38;
			break;
			
		case 'K':
			*pCode = 40;
			break;
			
		case 'L':
			*pCode = 37;
			break;
			
		case 'M':
			*pCode = 46;
			break;
			
		case 'N':
			*pCode = 45;
			break;
			
		case 'O':
			*pCode = 31;
			break;
			
		case 'P':
			*pCode = 35;
			break;
			
		case 'Q':
			*pCode = 12;
			break;
			
		case 'R':
			*pCode = 15;
			break;
			
		case 'S':
			*pCode = 1;
			break;
			
		case 'T':
			*pCode = 17;
			break;
			
		case 'U':
			*pCode = 32;
			break;
			
		case 'V':
			*pCode = 9;
			break;
			
		case 'W':
			*pCode = 13;
			break;
			
		case 'X':
			*pCode = 7;
			break;
			
		case 'Y':
			*pCode = 16;
			break;
			
		case 'Z':
			*pCode = 6;
			break;
			
	
		default:
			*pCode = 18;//'1'
			break;
	}
	
	
	
	
	
}
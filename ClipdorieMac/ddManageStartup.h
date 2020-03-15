//
//  ddManageStartup.h
//  ClipdorieMac
//
//  Created by Seung-Chan Kim on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
// http://cocoatutorial.grapewave.com/tag/lssharedfilelist-h/
#import <Cocoa/Cocoa.h>


@interface ddManageStartup : NSObject {

}
+(void) addAppAsLoginItem;
+(void) deleteAppFromLoginItem;

@end

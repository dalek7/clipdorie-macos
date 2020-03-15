//
//  ddSoundPlay.m
//  ClipdorieMac
//
//  Created by Seung-Chan Kim on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ddSoundPlay.h"


@implementation ddSoundPlay

+(void) PlayFX:(NSString*)fname
{
	//NSLog(fname);
	
	[[NSSound soundNamed:fname] play];
	
	
}

@end

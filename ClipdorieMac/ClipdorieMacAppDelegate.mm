//
//  ClipdorieMacAppDelegate.m
//  ClipdorieMac
//
//  Created by Seung-Chan Kim on 1/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ClipdorieMacAppDelegate.h"
#import "DDHotKeyCenter.h"
#import "ddSoundPlay.h"
#import "ddManageStartup.h"
#import "ddKeycode.h"


@implementation ClipdorieMacAppDelegate

@synthesize window;
@synthesize btn_sound, btn_startup;
@synthesize btn_mod_shift, btn_mod_control, btn_mod_option, btn_mod_command;
@synthesize m_combo1;
@synthesize tf_disp1;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

	
	[self OnInitialUpdate];
	

}

-(void) ManageNoLaunch
{

	int nLaunch = [self GetNumberOfLaunch];
	NSLog(@"nLaunch : %d", nLaunch);

	//UI
	if(nLaunch==1)
	{
		[self RegisterAsStartupProgram:TRUE];
	}
	else if(nLaunch==100)
	{
		NSRunAlertPanel( @"Cool !", @"It's the 100th launch !", @"OK", nil, nil );
	}
	
	NSString *buf = [NSString stringWithFormat:@"%d", nLaunch];
	[tf_disp1 setStringValue:buf];
	
	pref_nLaunch = [NSString stringWithFormat:@"%d", ++nLaunch];
	
	NSUserDefaults *prefs	= [NSUserDefaults standardUserDefaults];
	[prefs setObject:pref_nLaunch forKey:@"nLaunch"];

	

}

-(void) OnInitialUpdate
{
	winsize = NSMakeRect(0,0,[[self window] frame].size.width,[[self window] frame].size.height);
	[self resizeWindowOnSpotWithRect:NSMakeRect(0,0,winsize.size.width,winsize.size.height-250) withAnimation:NO];
	
	[self ManageNoLaunch];
	[self UpdateUIFromPref];
	
	
	[self MinimizeWindow];
	[self RegisterTray];	
	//[self RegisterAsStartupProgram:TRUE];
	[self RegisterHotkey:FALSE];
	
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCalled) userInfo:nil repeats:YES];
    
	setupmode = 0;
    cntPress = -1;
    
    startTime= CACurrentMediaTime();
	
}

-(void) addOutput:(NSString*)str
{
	NSLog(@"%@",str);
}


- (void) loadPref
{
	NSUserDefaults *prefs	= [NSUserDefaults standardUserDefaults];
	pref_SndFX				= [prefs stringForKey:@"SndFX"];
	pref_bStartup			= [prefs stringForKey:@"bStartup"];
	
	if(pref_bStartup== nil)
	{
		NSLog(@"pref_bStartup== nil..... Now registering...");
		[self RegisterAsStartupProgram:TRUE];
		
	}
	if(pref_SndFX== nil)
	{
		NSLog(@"pref_SndFX== nil..... Now registering...");
		
		
		pref_SndFX = @"1";
		[prefs setObject:pref_SndFX forKey:@"SndFX"];

		
	}
	
	
	
	pref_vKey				= [prefs stringForKey:@"vKey"];//
	pref_fsModifier			= [prefs stringForKey:@"fsModifier"];
	
	m_kc.vKey				= [pref_vKey intValue];
	m_kc.fsModifier			= [pref_fsModifier intValue];
	
	NSLog(@"Loaded prefs.....");
	NSLog(@" snd : %@", pref_SndFX);
	NSLog(@" startup : %@", pref_bStartup);
	NSLog(@" m_kc.vKey : %d", m_kc.vKey);
	NSLog(@" m_kc.fsModifier: %d", m_kc.fsModifier);
	
	pref_nLaunch			= [prefs stringForKey:@"nLaunch"];
	
	if(pref_nLaunch == nil)
	{
		pref_nLaunch = @"1";
		[prefs setObject:pref_nLaunch forKey:@"nLaunch"];
		NSLog(@"Setting initial # of launch...");
	}	
	
	
	// It can be deleted from the Login item section
	// This case should be handled
	
	if(pref_vKey == nil || pref_fsModifier == nil)
	{
		NSLog(@"Trying to set to default key combination : Command + 1");
		m_kc.vKey = 18;
		m_kc.fsModifier = NSCommandKeyMask;
		
		[self SavePrefKeyComb:&m_kc];
		[self loadPref];
	}
	
	
	
	
}


-(void) SavePrefKeyComb:(keyComb*)kc
{
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	pref_vKey		= [NSString stringWithFormat:@"%d",kc->vKey ];
	pref_fsModifier	= [NSString stringWithFormat:@"%d",kc->fsModifier];
	
	
	[prefs setObject:pref_vKey forKey:@"vKey"];
	[prefs setObject:pref_fsModifier forKey:@"fsModifier"];
	
	[prefs synchronize];
	NSLog(@"== Saved pref (SavePrefKeyComb)==");
	
}

#pragma mark -
#pragma mark UI works

-(IBAction) OnComboSelected:(id) sender
{
	
	NSPopUpButtonCell *curCell = [sender selectedCell];
	
	NSString *str = curCell.title;
	

	const char *charr = [str UTF8String];
	char strchar = charr[0];
	
	[self UnRegisterHotkey];
	
	CGKeyCode keycode;
	CddKeycode::GetKeycodeFromChar(strchar, &keycode);//[ddKeycode GetKeycodeFromChar:strchar];
	
	m_kc.vKey = keycode;
	
	NSLog(@"%@ : %c(%d) %d", str, strchar, strchar, m_kc.vKey );
	
	
	[self SavePrefKeyComb:&m_kc];
	[self loadPref];
	
	[self RegisterHotkey:TRUE];
}


-(IBAction) OnCheckboxChanged:(id)sender
{
	
	//NSLog(@"%d", sender);
	
	BOOL bCheckedShift		= [btn_mod_shift state]		== NSOnState;
	BOOL bCheckedControl	= [btn_mod_control state]	== NSOnState;
	BOOL bCheckedOption		= [btn_mod_option state]	== NSOnState;
	BOOL bCheckedCommand	= [btn_mod_command state]	== NSOnState;
	
	
	NSLog(@"chk : %d %d %d %d", bCheckedShift, bCheckedControl, bCheckedOption, bCheckedCommand);
	//NSCommandKeyMask|NSShiftKeyMask | NSControlKeyMask | NSAlternateKeyMask 
	

	[self UnRegisterHotkey];
	
	m_kc.fsModifier =	bCheckedShift	* NSShiftKeyMask | 
						bCheckedControl	* NSControlKeyMask|
						bCheckedOption	* NSAlternateKeyMask|
						bCheckedCommand	* NSCommandKeyMask;
	
	
	if(m_kc.fsModifier ==0)
	{
		NSLog(@"-_-");
		[self UpdateUIFromPref];
	}
	
	[self SavePrefKeyComb:&m_kc];
	[self loadPref];
	
	[self RegisterHotkey:TRUE];

}
-(IBAction) OnChangedOptionSound:(id) sender
{
	int sndoption = [btn_sound selectedSegment];
	NSLog(@"%d", sndoption);
	
	if(sndoption==1)
	{
		[ddSoundPlay PlayFX:@"event1.wav"];
	}
	
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	pref_SndFX = [NSString stringWithFormat:@"%d",sndoption ];
	[prefs setObject:pref_SndFX forKey:@"SndFX"];
	[prefs synchronize];
	NSLog(@"== Saved pref ==");
}

-(IBAction) OnChangedOptionLogicItem:(id) sender
{
	
	int loginoption= [sender selectedSegment];
	NSLog(@"%d", loginoption);
	
	[self RegisterAsStartupProgram:loginoption];
		
	
}
-(IBAction) OnOpenWWW:(id) sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://clipdorie.appspot.com/?v=m1.0"]];
}


-(IBAction) Play:(id) sender
{
	[self CDTextWork];
}

-(IBAction) OnSetup:(id) sender
{
	
	if(++setupmode%2==0)
		[self resizeWindowOnSpotWithRect:NSMakeRect(0,0,winsize.size.width,winsize.size.height-250) withAnimation:YES];
	else
		[self resizeWindowOnSpotWithRect:winsize withAnimation:YES];
	
}


-(IBAction) OnCloseSetup:(id) sender
{
	[self resizeWindowOnSpotWithRect:NSMakeRect(0,0,winsize.size.width,winsize.size.height-250) withAnimation:YES];
	setupmode++;
}


- (void)resizeWindowOnSpotWithRect:(NSRect)aRect withAnimation:(BOOL) bAnimation
{
	//NSRect newFrame = [[self window] frame];
	
    NSRect r = NSMakeRect([[self window] frame].origin.x - 
						  (aRect.size.width - [[self window] frame].size.width), [[self window] frame].origin.y - 
						  (aRect.size.height - [[self window] frame].size.height), aRect.size.width, aRect.size.height);
    [[self window] setFrame:r display:YES animate:bAnimation];
}



#pragma mark -
#pragma mark Life cycles

-(void) UnRegisterHotkey
{
	DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
	[c unregisterHotKeyWithKeyCode:m_kc.vKey modifierFlags:m_kc.fsModifier ];
	[self addOutput:@"Unregistered hotkey for example 1"];
	[c release];
}

-(void) UpdateUIFromPref
{
	
		
	[self GetPrefKeyComb:&m_kc];
	BOOL bSndFX = [self GetPrefSoundFX];
	
	if(bSndFX)
	{
		NSLog(@"PREF : sound enabled");
		[btn_sound setSelectedSegment:1];
	}
	else 
	{
		NSLog(@"PREF : sound disabled");
		[btn_sound setSelectedSegment:0];
	}
	
	
	
	BOOL bStartup = [self GetPrefStartup];
	
	if(bStartup)
	{
		NSLog(@"PREF : startup enabled");
		[btn_startup setSelectedSegment:1];
	}
	else 
	{
		NSLog(@"PREF : startup disabled");
		[btn_startup setSelectedSegment:0];
	}
	
	
	
	
	
	
	if(m_kc.fsModifier&NSCommandKeyMask)
	{
		NSLog(@" NSCommandKeyMask");
		[btn_mod_command setState:1];
	}
	if(m_kc.fsModifier&NSShiftKeyMask)
	{
		NSLog(@" NSShiftKeyMask");
		[btn_mod_shift setState:1];
		
	}
	
	if(m_kc.fsModifier&NSControlKeyMask)
	{
		NSLog(@" NSControlKeyMask");
		[btn_mod_control setState:1];
	}
	
	if(m_kc.fsModifier&NSAlternateKeyMask)
	{
		NSLog(@" NSAlternateKeyMask");
		[btn_mod_option setState:1];
	}
	
	
	[m_combo1 removeAllItems];
	
	int i;
	for(i=0; i<10; i++)
	{
		[m_combo1 addItemWithTitle:[NSString stringWithFormat:@"%c", 48+i]];
	}
	
	for(i=0; i<26; i++)
	{
		[m_combo1 addItemWithTitle:[NSString stringWithFormat:@"%c", 65+i]];
	}
	
	int rowID;
	CddKeycode::GetIDFromKeycode(m_kc.vKey, &rowID);
	
	[m_combo1 selectItemAtIndex:rowID];
	
	
	
	
	
}

-(void) MinimizeWindow
{
	[window setIsVisible:NO];
}

-(void) RestoreWindow
{
	[window setIsVisible:YES];
}
-(void) RegisterHotkey:(BOOL)bDispAlert
{
	
	DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
	//NSShiftKeyMask
	if (![c registerHotKeyWithKeyCode:m_kc.vKey modifierFlags:m_kc.fsModifier target:self action:@selector(hotkeyWithEvent:) object:nil]) 
	{
		if(bDispAlert)
		NSRunAlertPanel( @"Error", @"-_-", @"OK", nil, nil );
	} 
	else 
	{
		if(bDispAlert)
		NSRunAlertPanel( @"Cool !", @"Successfully changed :-)", @"OK", nil, nil );
		//[self addOutput:@"Registered hotkey for example 1"];
		//[self addOutput:[NSString stringWithFormat:@"Registered: %@", [c registeredHotKeys]]];
	}
	
	[c release];
	
}
- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertFirstButtonReturn) {
		;//[self deleteRecord:currentRec];
    }
}

#pragma mark -
#pragma mark CD

-(void) CDTextWork{
	
    BOOL bSndFX = [self GetPrefSoundFX];
	[self SetTrayImage:@"0"];
	
    cntPress++;
    
    if(cntPress>2)
    {
        [ProcAction CDTextWork4];
        if(bSndFX)
            [ddSoundPlay PlayFX:@"event3.wav"];
        
        cntPress = -1;
    }
    else if(cntPress>1)
    {
        [ProcAction CDTextWork3];
        if(bSndFX)
            [ddSoundPlay PlayFX:@"event3.wav"];
    }
    else if(cntPress>0)
    {
        [ProcAction CDTextWork2];
        if(bSndFX)
            [ddSoundPlay PlayFX:@"event2.wav"];
    }
    else
    {
        [ProcAction CDTextWork];
        if(bSndFX)
            [ddSoundPlay PlayFX:@"event1.wav"];
    }
    
	
							
	[self performSelector:@selector(SetTrayImage:) withObject:@"1" afterDelay:0.2];
    
    startTime= CACurrentMediaTime();
}


-(void) RegisterAsStartupProgram:(BOOL) bStartup
{
	
	NSUserDefaults *prefs	= [NSUserDefaults standardUserDefaults];
	
	
	if(bStartup)
	{
		NSLog(@"Adding app as a startup item");
		[ddManageStartup addAppAsLoginItem];
		
		
		pref_bStartup = @"1";
    }
	else
	{
		NSLog(@"Delete app from the startup item list");
		[ddManageStartup deleteAppFromLoginItem];
		
		
		pref_bStartup = @"0";
		
	}
	
	[prefs setObject:pref_bStartup forKey:@"bStartup"];
}

#pragma mark -
#pragma mark Prefereces 

-(void) GetPrefKeyComb:(keyComb*)kc
{
	
	[self loadPref];
	
	kc = &m_kc;

	
}

-(int) GetNumberOfLaunch
{
	[self loadPref];
	return [pref_nLaunch intValue];
	
}

-(BOOL) GetPrefStartup
{
	[self loadPref];
	
	if([pref_bStartup isEqualToString:@"1"])
	{
		return TRUE;
		
	}
	else 
	{
		
		return FALSE;
	}
	
}


-(BOOL) GetPrefSoundFX
{
	[self loadPref];
	
	if([pref_SndFX isEqualToString:@"1"])
	{
		return TRUE;
		
	}
	else 
	{
		
		return FALSE;
	}
}

#pragma mark -
#pragma mark Tray

- (IBAction)OnShowWindow:(id)sender;
{
	[self RestoreWindow];
}

- (IBAction)quitAction:(id)sender;
{
	[NSApp terminate:sender];
}


-(void) RegisterTray
{
	
	NSZone *zone = [NSMenu menuZone];
	NSMenu *menu = [[[NSMenu allocWithZone:zone] init] autorelease];
	NSMenuItem *item;
	
	item = [menu addItemWithTitle:@"Clear Format" action:@selector(Play:) keyEquivalent:@""];
	[item setTarget:self];
	
	item = [menu addItemWithTitle:@"Show Window" action:@selector(OnShowWindow:) keyEquivalent:@""];
	[item setTarget:self];
	
	item = [menu addItemWithTitle:@"Quit" action:@selector(quitAction:) keyEquivalent:@""];
	[item setTarget:self];
	
	
	
	trayItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
	[trayItem setMenu:menu];
	[trayItem setHighlightMode:YES];
	//[trayItem setTitle:@"CD"];
	
	[trayItem setImage:[NSImage imageNamed:@"Clipdorie2_16.png"]];
}

-(void) SetTrayImage:(NSString*)bNormal
{
	if([bNormal isEqualToString:@"1"])
		[trayItem setImage:[NSImage imageNamed:@"Clipdorie2_16.png"]];
	else {
		NSLog(@"Hit");
		[trayItem setImage:[NSImage imageNamed:@"Clipdorie2_16_hit.png"]];
	}
}

#pragma mark -
#pragma mark Timer
-(void)timerCalled
{
    // NSLog(@"Timer Called");

    CFTimeInterval elapsedTime = fabs(CACurrentMediaTime() - startTime);
    [self addOutput:[NSString stringWithFormat:@"Timer called %d\t%.2f", cntPress, elapsedTime]];
    
    if(cntPress>=0)
    {
        if(elapsedTime>2)
        {
            cntPress = -1;
        }
    }
       
}


#pragma mark -
#pragma mark Delegates 



- (void) hotkeyWithEvent:(NSEvent *)hkEvent {
	//[self addOutput:[NSString stringWithFormat:@"Firing -[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]];
	//[self addOutput:[NSString stringWithFormat:@"Hotkey event: %@", hkEvent]];
	
	
	[self CDTextWork];
	
}

#pragma mark -
#pragma mark Cleanup


-(void) dealloc
{
	[trayItem release];
	[self UnRegisterHotkey];
	
}




@end

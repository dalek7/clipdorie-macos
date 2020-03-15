//
//  ClipdorieMacAppDelegate.h
//  ClipdorieMac
//
//  Created by Seung-Chan Kim on 1/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "ProcAction.h"
#import <QuartzCore/QuartzCore.h>

typedef struct __keyComb
{
	unsigned int    vKey;
	unsigned int    fsModifier;
	
} keyComb;

//NSCommandKeyMask|NSShiftKeyMask | NSControlKeyMask | NSAlternateKeyMask 

@interface ClipdorieMacAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	
	
	NSRect winsize;
	
	
	NSString* pref_SndFX;

	
	keyComb	 m_kc;
	NSString* pref_vKey;
	NSString* pref_fsModifier;
	NSString* pref_nLaunch;
	NSString* pref_bStartup;
	
	
	NSSegmentedControl* btn_sound;
	NSSegmentedControl* btn_startup;
	
	NSButton* btn_mod_shift;
	NSButton* btn_mod_control;
	NSButton* btn_mod_option;
	NSButton* btn_mod_command;
	NSPopUpButton* m_combo1;
	
	
	NSStatusItem *trayItem;
	NSTextField* tf_disp1;
	
	int setupmode;
    
    CFTimeInterval startTime;// = CACurrentMediaTime();
    int cntPress;
    
    //ProcAction *m_pa;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet NSSegmentedControl* btn_sound;
@property (nonatomic, retain) IBOutlet NSSegmentedControl* btn_startup;

@property (nonatomic, retain) IBOutlet NSButton* btn_mod_shift;
@property (nonatomic, retain) IBOutlet NSButton* btn_mod_control;
@property (nonatomic, retain) IBOutlet NSButton* btn_mod_option;
@property (nonatomic, retain) IBOutlet NSButton* btn_mod_command;
@property (nonatomic, retain) IBOutlet NSPopUpButton* m_combo1;

@property (nonatomic, retain) IBOutlet NSTextField* tf_disp1;



-(IBAction) OnChangedOptionSound:(id) sender;
-(IBAction) OnChangedOptionLogicItem:(id) sender;
		   
-(IBAction) Play:(id) sender;
-(IBAction) OnSetup:(id) sender;
-(IBAction) OnCloseSetup:(id) sender;

-(IBAction) OnCheckboxChanged:(id)sender;
-(IBAction) OnComboSelected:(id) sender;
-(IBAction) OnOpenWWW:(id) sender;
// Preference
-(void) UpdateUIFromPref;

-(BOOL) GetPrefStartup;


-(BOOL) GetPrefSoundFX;
-(void) GetPrefKeyComb:(keyComb*)kc;

-(void) SavePrefKeyComb:(keyComb*)kc;
-(int) GetNumberOfLaunch;
-(void) ManageNoLaunch;


-(void) OnInitialUpdate;
// Tray
-(void) RegisterTray;
-(void) SetTrayImage:(NSString*)bNormal;

- (IBAction)quitAction:(id)sender;
- (IBAction)OnShowWindow:(id)sender;


// Window proc
-(void) MinimizeWindow;
-(void) RestoreWindow;

//Hotkey
-(void) UnRegisterHotkey;
-(void) RegisterHotkey:(BOOL)bDispAlert;
-(void) addOutput:(NSString*)str;



-(void) RegisterAsStartupProgram:(BOOL) bStartup;

- (void)resizeWindowOnSpotWithRect:(NSRect)aRect withAnimation:(BOOL)b;


- (void) loadPref;

@end

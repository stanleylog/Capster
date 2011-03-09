//
//  StatusbarController.m
//  Capster
//
//  Created by Vasileios Georgitzikis on 9/3/11.
//  Copyright 2011 Tzikis. All rights reserved.
//

#import "StatusbarController.h"


@implementation StatusbarController
@synthesize statusItem;

- (id) initWithStatusbar: (NSUInteger*) bar statusbarMatrix:(NSMatrix*) matrix preferences: (NSUserDefaults*) prefs andState:(NSUInteger *)curState
{
	self = [super init];
    if (self)
	{
        // Initialization code here.
		statusbar = bar;
		statusbarMatrix = matrix;
		preferences = prefs;
		currentState = curState;
		
		//initialize the mini icon image
		NSString* path_mini = [[NSBundle mainBundle] pathForResource:@"capster_mini" ofType:@"png"];
		mini = [[NSImage alloc] initWithContentsOfFile:path_mini];
		
		NSString* path_mini_green = [[NSBundle mainBundle] pathForResource:@"capster_mini_green" ofType:@"png"];
		mini_green = [[NSImage alloc] initWithContentsOfFile:path_mini_green];
		
		NSString* path_mini_red = [[NSBundle mainBundle] pathForResource:@"capster_mini_red" ofType:@"png"];
		mini_red = [[NSImage alloc] initWithContentsOfFile:path_mini_red];
		
		NSString* path_led_green = [[NSBundle mainBundle] pathForResource:@"capster_led_green" ofType:@"png"];
		led_green = [[NSImage alloc] initWithContentsOfFile:path_led_green];
		
		NSString* path_led_red = [[NSBundle mainBundle] pathForResource:@"capster_led_red" ofType:@"png"];
		led_red = [[NSImage alloc] initWithContentsOfFile:path_led_red];

    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void) setIconState: (BOOL) state
{
//	NSLog(@"state %i and statusbar %i", state, *statusbar);
	if(*statusbar == 1)
	{
		[statusItem setImage:mini];
	}
	else if(*statusbar == 2)
	{
		if(state) [statusItem setImage:mini_green];
		else [statusItem setImage:mini_red];
	}
	else if(*statusbar == 3)
	{
		if(state) [statusItem setImage:led_green];
		else [statusItem setImage:led_red];		
	}
}

//set the status menu to the value of the checkbox sender
-(IBAction) setStatusMenuTo:(id) sender
{
	//merely a casting
	sender = (NSMatrix*) sender;
	NSUInteger status = 0;
	//	static NSUInteger oldStatus = 0;
	
	//got message from the nsmatrix radio buttons
	if([sender respondsToSelector:@selector(selectedRow)])
	{
		status = [sender selectedRow];		
	}
	//we got the message from the 'hide menu' menuitem. need to update our nsmatrix
	else
		[statusbarMatrix selectCellAtRow:0 column:0];
	
//	NSLog(@"selected row %i, old status %i", status, *statusbar);
	//update our status bar if needed
	[preferences setInteger:status forKey:@"statusMenu"];
	[preferences synchronize];
		
	if ((*statusbar == 0 &&  status !=0) || (*statusbar != 0 && status ==0))
	{
		//NULL
		//if we are adding a statusmenu, then run initStatusMenu
		//otherwise run disableStatusMenu
		if(status > 0)
		{
			[self initStatusMenu: mini];
		}
		else
		{
			[self disableStatusMenu:nil];
		}

	}
	
	//make sure we need to add or remove a menu
	if(*statusbar != status)
	{
		*statusbar = status;
		[self setIconState:*currentState];
	}
	else return;

}

-(IBAction) enableStatusMenu:(id)sender
{
	//not used
}
//update the user's preferences, and remove the item from the status bar
-(IBAction) disableStatusMenu: (id)sender
{
	[[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
}

//update the user's preferences, create a status bar item, and add it to the
//status bar
-(void) initStatusMenu: (NSImage*) menuIcon
{
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain]; 
	[statusItem setMenu:statusMenu];
	[statusItem setImage:mini];
	[statusItem setHighlightMode:YES];
}

@end

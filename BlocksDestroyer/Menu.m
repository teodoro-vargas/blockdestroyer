//
//  Menu.m
//  BlocksDestroyer
//
//  Created by Teodoro Vargas Cortés on 08/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import the interfaces
#import "Menu.h"
#import "mainGame.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - Menu

@implementation Menu

// Helper class method that creates a Scene with the Menu as the only child
+ (CCScene *)scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    // 'layer' is an autorelease object.
    Menu *menu = [Menu node];
    // Add layer as a child to scene
    [scene addChild:menu];
    // Return the scene
    return scene;
}

// On 'init' we initialize our instance
- (id)init
{
    // Always call 'super' init
    // Apple recommends to re-assign 'self' with the "super's" return value
    if ((self = [super init])) {
        // Create and initialize the label and menu items
        CCLabelTTF *mainTitle = [CCLabelTTF labelWithString:@"Block Destroyer" fontName:@"Marker Felt" fontSize:44];
        CCMenuItemFont *newGame = [CCMenuItemFont itemWithString:@"Nuevo juego" target:self selector:@selector(newGame:)];
        CCMenuItemFont *instructions = [CCMenuItemFont itemWithString:@"Instrucciones" target:self selector:@selector(instructions:)];
        CCMenuItemFont *bestScores = [CCMenuItemFont itemWithString:@"Mejores puntajes" target:self selector:@selector(bestScores:)];
        CCMenuItemFont *about = [CCMenuItemFont itemWithString:@"Acerca de" target:self selector:@selector(about:)];
        
        // Ask director for the window size
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        // Position the label on the screen
        mainTitle.position = ccp(size.width / 2, size.height - 50);
        
        // Adds the labels as children to this layer
        [self addChild:mainTitle];
        
        // Create the menu and add the menu items
        CCMenu *menu = [CCMenu menuWithItems:newGame, instructions, bestScores, about, nil];
        menu.position = ccp(size.width / 2, (size.height / 2) - 20);
        [menu alignItemsVerticallyWithPadding:20.0f];
        [self addChild:menu z:1];
    }
    return self;
}

-(void) makeTransition:(ccTime)dt{
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:1.0 scene:[mainGame scene]]];
}

- (void)newGame:(id)sender
{
    //in one second transition to the new scene
    [self scheduleOnce:@selector(makeTransition :) delay:0];
}

- (void)instructions:(id)sender
{
    NSLog(@"Pressed Instructions");
}

- (void)bestScores:(id)sender
{
    NSLog(@"Pressed Best Scores");
}

- (void)about:(id)sender
{
    NSLog(@"Pressed About");
}

@end

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
#import "Instructions.h"
#import "Scores.h"
#import "About.h"
#import "SimpleAudioEngine.h"

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
        CCMenuItemFont *newGame = [CCMenuItemFont itemWithString:@"New Game" target:self selector:@selector(newGame:)];
        CCMenuItemFont *instructions = [CCMenuItemFont itemWithString:@"Instructions" target:self selector:@selector(instructions:)];
        CCMenuItemFont *bestScores = [CCMenuItemFont itemWithString:@"Best Scores" target:self selector:@selector(bestScores:)];
        CCMenuItemFont *about = [CCMenuItemFont itemWithString:@"About" target:self selector:@selector(about:)];
        
        // Ask director for the window size
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        // Background
        CCSprite *background = [CCSprite spriteWithFile:@"TreeHouse.png"];
        CGSize backgroundSize = background.contentSize;
        background.scaleX = winSize.width / backgroundSize.width;
        background.scaleY = winSize.height / backgroundSize.height;
        background.position = CGPointMake(winSize.width / 2, winSize.height / 2);
        [self addChild:background z:-2];
        
        // Position the label on the screen
        mainTitle.position = ccp(winSize.width / 2, winSize.height - 50);
        
        // Adds the labels as children to this layer
        [self addChild:mainTitle];
        
        // Create the menu and add the menu items
        CCMenu *menu = [CCMenu menuWithItems:newGame, instructions, bestScores, about, nil];
        menu.position = ccp(winSize.width / 2, (winSize.height / 2) - 20);
        [menu alignItemsVerticallyWithPadding:20.0f];
        [self addChild:menu z:1];
        
        // Menu sound
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menu_sound.mp3" loop:YES];
    }
    return self;
}

- (void)newGame:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                               transitionWithDuration:1
                                               scene:[mainGame node]]
     ];
}

- (void)instructions:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                               transitionWithDuration:1
                                               scene:[Instructions node]]
     ];
}

- (void)bestScores:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                               transitionWithDuration:1
                                               scene:[Scores node]]
     ];
}

- (void)about:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[About node]]];
}

@end

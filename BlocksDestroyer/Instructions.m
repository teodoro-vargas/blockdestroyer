//
//  PauseGame.m
//  BlocksDestroyer
//
//  Created by Joel García on 4/18/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Instructions.h"
#import "mainGame.h"
#import "Menu.h"


@implementation Instructions

+(id) scene{
    CCScene *scene=[CCScene node];
    Instructions *layer = [Instructions node];
    [scene addChild: layer];
    return scene;
}

-(id)init{
    if( (self=[super init] )) {
        //Create and initialize the menu items
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF *pause_label = [CCLabelTTF labelWithString:@"Instructions" fontName:@"Marker Felt" fontSize:46];
        
        [CCMenuItemFont setFontName:@"Marker Felt"];
        [CCMenuItemFont setFontSize:36];
        
        CCMenuItem *Quit = [CCMenuItemFont itemWithString:@"Back to menu"
                                                   target:self selector:@selector(GoToMainMenu:)];
        //Set the position of the menu title and add it to the layer scene
        pause_label.position = ccp(winSize.width / 2, winSize.height - 50);
        [self addChild: pause_label];
        //Set the position of the menu content and add the content to the scene
        CCMenu *menu= [CCMenu menuWithItems: Quit, nil];
        menu.position = ccp(winSize.width / 2, (winSize.height / 2) - 20);
        [menu alignItemsVerticallyWithPadding:20.0f];
        [self addChild:menu];
        // Background
        CCSprite *background = [CCSprite spriteWithFile:@"TreeHouse.png"];
        CGSize backgroundSize = background.contentSize;
        background.scaleX = winSize.width / backgroundSize.width;
        background.scaleY = winSize.height / backgroundSize.height;
        background.position = CGPointMake(winSize.width / 2, winSize.height / 2);
        [self addChild:background z:-2];
        
    }
    return self;
}

-(void) GoToMainMenu: (id) sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[Menu node]]];
}


@end

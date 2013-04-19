//
//  PauseGame.m
//  BlocksDestroyer
//
//  Created by Joel García on 4/18/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "PauseGame.h"
#import "mainGame.h"
#import "Menu.h"


@implementation PauseGame

+(id) scene{
    CCScene *scene=[CCScene node];
    PauseGame *layer = [PauseGame node];
    [scene addChild: layer];
    return scene;
}

-(id)init{
    if( (self=[super init] )) {
        //Create and initialize the menu items
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCLabelTTF *pause_label = [CCLabelTTF labelWithString:@"Paused" fontName:@"Marker Felt" fontSize:46];
        
        [CCMenuItemFont setFontName:@"Marker Felt"];
        [CCMenuItemFont setFontSize:36];
        
        CCMenuItem *Resume= [CCMenuItemFont itemWithString:@"Resume"
                                            target:self selector:@selector(resume:)];
        CCMenuItem *Quit = [CCMenuItemFont itemWithString:@"Quit Game"
                                            target:self selector:@selector(GoToMainMenu:)];
        //Set the position of the menu title and add it to the layer scene
        pause_label.position = ccp(size.width / 2, size.height - 50);
        [self addChild: pause_label];
        //Set the position of the menu content and add the content to the scene
        CCMenu *menu= [CCMenu menuWithItems: Resume, Quit, nil];
        menu.position = ccp(size.width / 2, (size.height / 2) - 20);
        [menu alignItemsVerticallyWithPadding:20.0f];
        [self addChild:menu];
        
    }
    return self;
}

-(void) resume: (id) sender {
    [[CCDirector sharedDirector] popScene];
}

-(void) GoToMainMenu: (id) sender {
    [[CCDirector sharedDirector] sendCleanupToScene];
    [[CCDirector sharedDirector] popScene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                               transitionWithDuration:1
                                               scene:[Menu node]]
     ];
}

@end
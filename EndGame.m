//
//  EndGame.m
//  BlocksDestroyer
//
//  Created by Joel García on 4/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "EndGame.h"
#import "Menu.h"
#import "mainGame.h"

@implementation EndGame
+ (id)sceneWithParams:(int)points{
    CCScene *scene = [CCScene node];
    EndGame *layer = [EndGame node];
    layer->totalPoints = points;
    [scene addChild: layer];
    return scene;
}

-(id)init{
    if( (self=[super init] )) {
        //Create and initialize the menu items
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCLabelTTF *title_label = [CCLabelTTF labelWithString:@"Time is up!" fontName:@"Marker Felt" fontSize:46];
        
        [CCMenuItemFont setFontName:@"Marker Felt"];
        [CCMenuItemFont setFontSize:36];
        
        CCMenuItem *PlayAgain= [CCMenuItemFont itemWithString:@"Play again"
                                                    target:self selector:@selector(PLayAgain:)];
        CCMenuItem *Quit = [CCMenuItemFont itemWithString:@"Back to menu"
                                                   target:self selector:@selector(GoToMainMenu:)];
        //Set the position of the menu title and add it to the layer scene
        title_label.position = ccp(size.width / 2, size.height - 50);
        [self addChild: title_label];
        //Set the position of the menu content and add the content to the scene
        CCMenu *menu= [CCMenu menuWithItems: PlayAgain, Quit, nil];
        menu.position = ccp(size.width / 2, (size.height / 2) - 20);
        [menu alignItemsVerticallyWithPadding:10.0f];
        [self addChild:menu];
        
    }
    return self;
}

-(void) PlayAgain: (id) sender {
    [[CCDirector sharedDirector] sendCleanupToScene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                               transitionWithDuration:1
                                               scene:[mainGame node]]
     ];
}

-(void) GoToMainMenu: (id) sender {
    [[CCDirector sharedDirector] sendCleanupToScene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                               transitionWithDuration:1
                                               scene:[Menu node]]
     ];
}

@end

//
//  Scores.m
//  BlocksDestroyer
//
//  Created by Joel García on 5/4/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Scores.h"
#import "Menu.h"


@implementation Scores

+(id) scene{
    CCScene *scene=[CCScene node];
    Scores *layer = [Scores node];
    [scene addChild: layer];
    return scene;
}

-(id)init{
    if( (self=[super init] )) {
        // Background
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [CCSprite spriteWithFile:@"TreeHouse.png"];
        CGSize backgroundSize = background.contentSize;
        background.scaleX = winSize.width / backgroundSize.width;
        background.scaleY = winSize.height / backgroundSize.height;
        background.position = CGPointMake(winSize.width / 2, winSize.height / 2);
        [self addChild:background z:-2];
        
        //Cargamos el contenido guardado en la plits con los puntajes
        // NSString * path = [[NSBundle mainBundle] pathForResource:@"scoresList" ofType:@"plist"];
        // NSArray * best_scores = [[[NSArray alloc] initWithContentsOfFile:path] autorelease];
        
        //Create and initialize the menu items
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCLabelTTF *scores_label = [CCLabelTTF labelWithString:@"Best Scores" fontName:@"Marker Felt" fontSize:46];
        
        [CCMenuItemFont setFontName:@"Marker Felt"];
        [CCMenuItemFont setFontSize:36];
        
        
        CCMenuItem *Quit = [CCMenuItemFont itemWithString:@"Back to menu"
                                                   target:self selector:@selector(GoToMainMenu:)];
        //Set the position of the menu title and add it to the layer scene
        scores_label.position = ccp(size.width / 2, size.height - 50);
        [self addChild: scores_label];
        //Set the position of the menu content and add the content to the scene
        CCMenu *menu= [CCMenu menuWithItems: Quit, nil];
        menu.position = ccp(size.width / 2, size.height - 440);
        [menu alignItemsVerticallyWithPadding:20.0f];
        [self addChild:menu];
        
    }
    return self;
}

-(void) GoToMainMenu: (id) sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[Menu node]]];
}

@end
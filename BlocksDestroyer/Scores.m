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
        //Cargamos el contenido guardado en la plits con los puntajes
        NSString * path = [[NSBundle mainBundle] pathForResource:@"scoresList" ofType:@"plist"];
        NSArray * best_scores = [[NSArray alloc] initWithContentsOfFile:path];
        
        //Create and initialize the menu items
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCLabelTTF *scores_label = [CCLabelTTF labelWithString:@"BestScores" fontName:@"Marker Felt" fontSize:46];
        
        
        //METER LAS COSAS DENTRO DE UN CICLO ;)
        CCLabelTTF *score_1 = [CCLabelTTF labelWithString:[[best_scores objectAtIndex:0] objectAtIndex:0] fontName:@"Marker Felt" fontSize:30];
        
        
        
        [CCMenuItemFont setFontName:@"Marker Felt"];
        [CCMenuItemFont setFontSize:36];
        
        
        CCMenuItem *Quit = [CCMenuItemFont itemWithString:@"Back to menu"
                                                   target:self selector:@selector(GoToMainMenu:)];
        //Set the position of the menu title and add it to the layer scene
        scores_label.position = ccp(size.width / 2, size.height - 50);
        score_1.position = ccp(size.width / 2, size.height - 120);
        [self addChild: scores_label];
        [self addChild: score_1];
        //Set the position of the menu content and add the content to the scene
        CCMenu *menu= [CCMenu menuWithItems: Quit, nil];
        menu.position = ccp(size.width / 2, size.height - 480);
        [menu alignItemsVerticallyWithPadding:20.0f];
        [self addChild:menu];
        
    }
    return self;
}

-(void) GoToMainMenu: (id) sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[Menu node]]];
}

@end
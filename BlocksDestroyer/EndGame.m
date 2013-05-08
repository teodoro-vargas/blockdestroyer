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
@synthesize t_points;

+ (id)sceneWithParams:(int)points
{
    CCScene *scene = [CCScene node];
    EndGame *layer = [EndGame nodeWithPoints:points];
    [scene addChild: layer];
    return scene;
}

+ (id)nodeWithPoints:(int)points
{
    EndGame *toReturn = [[EndGame alloc] initWithPoints:points];
    return toReturn;
}

- (id)initWithPoints:(int)points
{
    if ( (self=[super init] )) {
        //Get the points and tell the user how many points he get
        t_points = [NSNumber numberWithInt:points];
        NSString * message = [NSString stringWithFormat:@"Time is up! you get %@ points", t_points];
        
        /*Get the values saved in the best score list*/
        NSString * path = [[NSBundle mainBundle] pathForResource:@"scoresList" ofType:@"plist"];
        NSMutableArray * best_scores = [[NSMutableArray alloc] initWithContentsOfFile:path];
        
        /*Get the index of the lowest value on the list*/
        NSNumber * menor = [[best_scores objectAtIndex:1] objectAtIndex:0];
        NSNumber * num;
        NSLog(@"SGIO");
        int lowestIndex;
        for(int i = 0; i<10; i++){
             num = [[best_scores objectAtIndex:i] objectAtIndex:0];
            if(menor > num){
                menor = num;
                lowestIndex = i;
                NSLog(@"ENTRE");
            }
        }
      
        
        
        NSString * nombre = @"Joel";
        NSLog(@"%@", menor);
        /*If the user get a higgest score, replace the lowest value with the users value and save it*/
        if (t_points > menor ) {
            NSArray * newValue = [NSArray arrayWithObjects:t_points, nombre, nil];
            [best_scores replaceObjectAtIndex:lowestIndex withObject:newValue];
            [best_scores writeToFile:path atomically:YES];
        }
        
        
        //Create and initialize the menu items
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCLabelTTF *title_label = [CCLabelTTF labelWithString:message fontName:@"Marker Felt" fontSize:46];
        
        [CCMenuItemFont setFontName:@"Marker Felt"];
        [CCMenuItemFont setFontSize:36];
        
        CCMenuItem *PlayAgain= [CCMenuItemFont itemWithString:@"Play again"
                                                       target:self selector:@selector(PlayAgain:)];
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
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                               transitionWithDuration:1
                                               scene:[mainGame node]]
     ];
}

-(void) GoToMainMenu: (id) sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                               transitionWithDuration:1
                                               scene:[Menu node]]
     ];
}

@end

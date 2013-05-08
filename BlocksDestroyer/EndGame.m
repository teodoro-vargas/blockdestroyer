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
    [scene addChild:layer];
    return scene;
}

+ (id)nodeWithPoints:(int)points
{
    EndGame *toReturn = [[[EndGame alloc] initWithPoints:points] autorelease];
    return toReturn;
}

- (id)initWithPoints:(int)points
{
    if ((self=[super init] )) {
        // Background
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [CCSprite spriteWithFile:@"TreeHouse.png"];
        background.position = CGPointMake(winSize.width / 2, winSize.height / 2);
        CGSize backgroundSize = background.contentSize;
        background.scaleX = winSize.width / backgroundSize.width;
        background.scaleY = winSize.height / backgroundSize.height;
        [self addChild:background z:-2];
        
        //Get the points and tell the user how many points he get
        t_points = [NSNumber numberWithInt:points];
        NSString * message = [NSString stringWithFormat:@"Time is up!\nYou get %@ points", t_points];

#if 0
        CCLabelTTF *congratulations = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:32];
        /* Get the values saved in the best score list */
        NSString *path = [[NSBundle mainBundle] pathForResource:@"scoresList" ofType:@"plist"];
        NSMutableArray *best_scores = [[[NSMutableArray alloc] initWithContentsOfFile:path] autorelease];
        NSComparisonResult (^comp)(id a, id b) = ^NSComparisonResult(id a, id b) {
            int num1 = [(NSNumber *)a intValue];
            int num2 = [(NSNumber *)b intValue];
            if (num1 > num2) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            if (num1 < num2) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            return  (NSComparisonResult)NSOrderedSame;
        };
        NSArray *sortedArray = [best_scores sortedArrayUsingComparator:comp];
        
        /* Check if the resulting points are bigger than any value */
        BOOL isBigScore = NO;
        for (NSNumber *singleScore in sortedArray) {
            int num = [singleScore intValue];
            if (points > num) {
                isBigScore = YES;
                break;
            }
        }
        
        /* Store the points with the corresponding date and show the message */
        if (isBigScore) {
            NSNumber *number = [[[NSNumber alloc] initWithInt:points] autorelease];
            NSMutableArray *sortedMutableArray = [[[NSMutableArray alloc] initWithArray:sortedArray copyItems:YES] autorelease];
            [sortedMutableArray replaceObjectAtIndex:([sortedMutableArray count] - 1) withObject:number];

            /* Re-order the array */
            NSArray *newReorderedArray = [[sortedMutableArray sortedArrayUsingComparator:comp] autorelease];
            [newReorderedArray writeToFile:@"scoresList.plist" atomically:YES];
            
            [congratulations setString:@"Felicidades!\nEstas dentro de\nlos mejores puntajes"];
        }
        congratulations.position = CGPointMake(winSize.width / 2, winSize.height - 100);
        [self addChild:congratulations];
#endif
        
        //Create and initialize the menu items
        CCLabelTTF *title_label = [CCLabelTTF labelWithString:message fontName:@"Marker Felt" fontSize:42];
        
        [CCMenuItemFont setFontName:@"Marker Felt"];
        [CCMenuItemFont setFontSize:36];
        
        CCMenuItem *PlayAgain= [CCMenuItemFont itemWithString:@"Play again"
                                                       target:self selector:@selector(PlayAgain:)];
        CCMenuItem *Quit = [CCMenuItemFont itemWithString:@"Back to menu"
                                                   target:self selector:@selector(GoToMainMenu:)];
        //Set the position of the menu title and add it to the layer scene
        title_label.position = ccp(winSize.width / 2, winSize.height - 50);
        [self addChild: title_label];
        //Set the position of the menu content and add the content to the scene
        CCMenu *menu= [CCMenu menuWithItems: PlayAgain, Quit, nil];
        menu.position = ccp(winSize.width / 2, (winSize.height / 2) - 120);
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

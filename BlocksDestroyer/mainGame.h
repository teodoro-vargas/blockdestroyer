//
//  Menu.h
//  BlocksDestroyer
//
//  Created by Teodoro Vargas Cortés on 08/04/13.
//  Copyright 2013 ITESM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"

#define kMinimumGestureLength 10
#define kMaximumVariance 5

@interface mainGame : CCLayer<GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    CCSprite * blocks_game[6][5];
}
@property CGPoint firstTouch;
@property BOOL inMovement;
@property BOOL touchInSpriteRect;
@property NSUInteger orientation;
@property CGRect initialRect;

// Returns a CCScene that contains the mainGame 
+ (CCScene *)scene;

@end
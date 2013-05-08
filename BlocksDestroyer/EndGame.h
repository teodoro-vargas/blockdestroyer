//
//  EndGame.h
//  BlocksDestroyer
//
//  Created by Joel García on 4/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EndGame : CCLayer
{
}

@property (retain, nonatomic) NSNumber *t_points;

+ (id)nodeWithPoints:(int)points;
+ (id) sceneWithParams: (int) points;
- (void) GoToMainMenu: (id) sender;
@end

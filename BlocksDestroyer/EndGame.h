//
//  EndGame.h
//  BlocksDestroyer
//
//  Created by Joel García on 4/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EndGame : CCLayer {
    int totalPoints;
}

+ (id) sceneWithParams: (int) points;
- (void) PlayAgain: (id) sender;
- (void) GoToMainMenu: (id) sender;

@end

//
//  About.m
//  BlocksDestroyer
//
//  Created by Teodoro Vargas Cortés on 29/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "About.h"
#import "Menu.h"

@implementation About

+ (CCScene *)scene
{
    // 'scene' is an autorelease object
    CCScene *scene = [CCScene node];
    // 'layer' is an autorelease object
    About *about = [About node];
    // Add layer as a child to scene
    [scene addChild:about];
    // Return the scene
    return scene;
}

- (id)init
{
    // Always call 'super' init
    if ((self = [super init])) {
        CGFloat ratio;
        // Create and initialize the labels and items
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [CCSprite spriteWithFile:@"AdventureTime_brothers.png"];
        background.position = CGPointMake(winSize.width / 2, winSize.height / 2);
        ratio = winSize.height / background.textureRect.size.height ;
        background.scale *= ratio;
        [self addChild:background z:-2];
        
        // First image: Joel
        CCMenuItem *joelImage = [CCMenuItemImage itemWithNormalImage:@"Joel.png" selectedImage:@"Joel.png" block:^(id sender) {
            NSURL *joelURL = [NSURL URLWithString:@"https://www.facebook.com/JEGVE"];
            [[UIApplication sharedApplication] openURL:joelURL];
        }];
        joelImage.scale /= 4;

        // Second image: Teo
        CCMenuItem *teoImage = [CCMenuItemImage itemWithNormalImage:@"Teo.png" selectedImage:@"Teo.png" block:^(id sender) {
            NSURL *teoURL = [NSURL URLWithString:@"https://plus.google.com/114250049241004557257"];
            [[UIApplication sharedApplication] openURL:teoURL];
        }];
        teoImage.scale /= 4;
        
        CCMenu *menu1 = [CCMenu menuWithItems:joelImage, teoImage, nil];
        menu1.position = CGPointMake(60, winSize.height - 135);
        [menu1 alignItemsVerticallyWithPadding:10];
        [self addChild:menu1];
        
        // Joel's labels
        CCLabelTTF *joelName = [CCLabelTTF labelWithString:@"Joel Garcia Verastica" fontName:@"Marker Felt" fontSize:24];
        CCLabelTTF *joelDescription = [CCLabelTTF labelWithString:@"ITC, sinaloense y\nboxeador" fontName:@"Marker Felt" fontSize:20];
        joelName.position = CGPointMake(210, winSize.height - 70);
        joelDescription.position = CGPointMake(200, winSize.height - 105);
        [self addChild:joelName];
        [self addChild:joelDescription];
        
        // Teo's labels
        CCLabelTTF *teoName = [CCLabelTTF labelWithString:@"Teodoro Vargas Cortes" fontName:@"Marker Felt" fontSize:24];
        CCLabelTTF *teoDescription = [CCLabelTTF labelWithString:@"ITC, costarricense y\nbicicletero" fontName:@"Marker Felt" fontSize:20];
        teoName.position = CGPointMake(215, winSize.height - 180);
        teoDescription.position = CGPointMake(200, winSize.height - 215);
        [self addChild:teoName];
        [self addChild:teoDescription];
        
        // Gratitude
        CCLabelTTF *gratitude = [CCLabelTTF labelWithString:@"Dedicado a Pendleton \"Pen\" Ward" fontName:@"Marker Felt" fontSize:22];
        gratitude.position = CGPointMake(winSize.width / 2, winSize.height - 280);
        [self addChild:gratitude];
        CCSprite *logo = [CCSprite spriteWithFile:@"AdventureTime_logo.png"];
        ratio = winSize.width / logo.textureRect.size.width;
        logo.scale *= ratio;
        logo.scaleY /= 1.2;
        logo.position = CGPointMake(winSize.width / 2, winSize.height - 370);
        [self addChild:logo];
        
        // Go to main menu
        CCMenuItemFont *go = [CCMenuItemFont itemWithString:@"Regresar al menu" target:self selector:@selector(gotoMainMenu:)];
        CCMenu *menu2 = [CCMenu menuWithItems:go, nil];
        menu2.position = CGPointMake(winSize.width / 2, winSize.height - 450);
        [menu2 alignItemsVerticallyWithPadding:5.0f];
        [self addChild:menu2];
    }
    return self;
}

- (void)gotoMainMenu:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[Menu node]]];
}

@end

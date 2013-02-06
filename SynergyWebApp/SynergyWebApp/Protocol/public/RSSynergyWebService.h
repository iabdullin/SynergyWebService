//
//  RSSynergyWebService.h
//  SynergyWebApp
//
//  Created by Ildar on 2/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum CardAction
{
    CardSwiped = 0,
    CardKeyed

} CardAction;

typedef enum AccountType
{
    CardNumber = 0,
    PhoneNumber,
    RefferalNumber

} AccountType;

typedef enum ResponseFormat
{
    Xml = 0,
    Json

} ResponseFormat;

@interface RSSynergyWebService : NSObject

@property(nonatomic, retain, setter = setUserName:) NSString* userName;
@property(nonatomic, retain, setter = setPassword:) NSString* password;

- (id)initWithUserName:(NSString*)_userName andPassword:(NSString*)_password;
- (BOOL)addPoints:(NSString*)merchantRockCommID customerCardNumber:(NSString*)customerCardNumber numPoints:(int)numPoints cardAction:(CardAction)cardAction
          clerkID:(NSString*)clerkID checkNumber:(NSString*)checkNumber accountType:(AccountType)accountType surveyFlag:(BOOL)surveyFlag responseFormat:(ResponseFormat)responseFormat;

@end

//
//  RSSynergyWebService.m
//  SynergyWebApp
//
//  Created by Ildar on 2/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "RSSynergyWebService.h"
#import "SoapService.h"
#import "Soap.h"
#import "SoapRequest.h"
#import "RSWebServiceHandler.h"

#define ServiceUrl     @"http://www.synergywebservice.com/SynergyWebX.asmx"
#define SynergyXmlns   @"http://tempuri.org/"

#define SoapMethodAddPoints   @"AddPoints"

@interface RSSynergyWebService()

@property(nonatomic, assign) SoapService *soapService;

- (void)generateHeader;

@end

@implementation RSSynergyWebService

@synthesize userName, password, soapService;

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.soapService = [[SoapService alloc] initWithUrl:ServiceUrl];
    }

    return self;
}

- (id)initWithUserName:(NSString*)_userName andPassword:(NSString*)_password
{
    self = [self init];
    if (self != nil)
    {
        self.userName = _userName;
        self.password = _password;
    }

    return self;
}

- (void)dealloc
{
    self.userName = nil;
    self.password = nil;
    [self.soapService release];
}

- (void)setUserName:(NSString*)_userName
{
    [userName release];
    userName = [_userName retain];
    [self generateHeader];
}

- (void)setPassword:(NSString*)_password
{
    [password release];
    password = [_password retain];
    [self generateHeader];
}

- (void)generateHeader
{
    NSDictionary *credentialNodes = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"userName", password, @"password",nil];
    self.soapService.headers = [NSDictionary dictionaryWithObjectsAndKeys:credentialNodes, @"UserCredentials", nil];
}

- (BOOL)addPoints:(NSString*)merchantRockCommID customerCardNumber:(NSString*)customerCardNumber numPoints:(int)numPoints cardAction:(CardAction)cardAction
          clerkID:(NSString*)clerkID checkNumber:(NSString*)checkNumber accountType:(AccountType)accountType surveyFlag:(BOOL)surveyFlag responseFormat:(ResponseFormat)responseFormat
{
    if (merchantRockCommID == nil || customerCardNumber == nil || numPoints <= 0 || clerkID == nil ||
        checkNumber == nil)
    {
        return NO;
    }

    NSString *numPointStr = [NSString stringWithFormat:@"%d", numPoints];
    NSString *cardActionStr = cardAction == CardSwiped ? @"CardSwiped" : @"CardKeyed";

    NSString *accoutTypeStr = nil;
    if (accountType == CardNumber)
    {
        accoutTypeStr = @"CardNumber";
    }
    else if (accountType == PhoneNumber)
    {
        accoutTypeStr = @"PhoneNumber";
    }
    else
    {
        accoutTypeStr = @"ReferralNumber";
    }

    if ([merchantRockCommID length] > 12)
    {
        return NO;
    }

    NSString *surveyFlagStr = surveyFlag ? @"true" : @"false";
    NSString *responseFormatStr = responseFormat == Xml ? @"Xml" : @"Json";
    

    if ([customerCardNumber length] != 12 && [customerCardNumber length] != 16)
    {
        return NO;
    }

    if ([numPointStr length] > 12)
    {
        return NO;
    }

    if ([clerkID length] > 50)
    {
        return NO;
    }

    if ([checkNumber length] > 50)
    {
        return NO;
    }


    NSDictionary *bodyEnvelope = [NSDictionary dictionaryWithObjectsAndKeys:merchantRockCommID, @"MerchantRockCommID", customerCardNumber, @"CustomerCardNumber",
                                  numPointStr, @"NumPoints", cardActionStr, @"CardAction", clerkID, @"ClerkID", checkNumber, @"CheckNumber",
                                  accoutTypeStr, @"AccountType", surveyFlagStr, @"SurveyFlag", responseFormatStr, @"ResponseFormat", nil];

    NSString *soapXml = [Soap createEnvelope:SoapMethodAddPoints forNamespace:SynergyXmlns containing:bodyEnvelope withHeaders:self.soapService.headers];
    NSString *soapAction = [SynergyXmlns stringByAppendingString:SoapMethodAddPoints];
    RSWebServiceHandler *serviceHandler = [[RSWebServiceHandler alloc] initWithType:AddPointsReply];

    SoapRequest *soapRequest = [SoapRequest create:serviceHandler action:nil service:self.soapService soapAction:soapAction postData:soapXml deserializeTo:nil];
    soapRequest.logging = YES;
    [soapRequest send];
    [soapRequest retain];

    return YES;
}

@end

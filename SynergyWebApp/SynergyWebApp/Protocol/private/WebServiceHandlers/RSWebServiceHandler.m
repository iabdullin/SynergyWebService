//
//  RSWebServiceHandler.m
//  SynergyWebApp
//
//  Created by Ildar on 2/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "RSWebServiceHandler.h"
#import "SoapRequest.h"

@interface RSWebServiceHandler()

- (void)parsePostRegistration:(NSDictionary*)data;
- (void)parsePostRegistrationLong:(NSDictionary*)data;
- (void)parseAddPointsReply:(NSDictionary*)data;
- (BOOL)validateResponse:(CXMLDocument*)response;

@property(nonatomic, readwrite) SynergyReplyStatus responseReplyStatus;
@property(nonatomic, assign)    NSString           *responseDescription;

@end

@implementation RSWebServiceHandler

@synthesize replyType, soapRequest, replyObject, status, responseReplyStatus, responseDescription;

- (id)initWithType:(SynergyReplyType)_replyType
{
    self = [super init];
    if (self != nil)
    {
        replyType = _replyType;
    }

    return self;
}

- (void)dealloc
{
    [self.soapRequest cancel];
    self.soapRequest = nil;
    [super dealloc];
}

- (BOOL)handleAndPerformSelector:(SEL)_resultSelector onContext:(id)_context
{
    if (![_context respondsToSelector:_resultSelector])
    {
        return NO;
    }

    resultSelector = _resultSelector;
    context = _context;

    [soapRequest send];

    return YES;
}

- (void)onload:(id)value
{
    if (![value isKindOfClass:[NSDictionary class]])
    {
        status = RequestStatusInternalError;
        [context performSelector:resultSelector];
    }

    switch (replyType)
    {
        case rtPostRegistrationReply:
            [self parsePostRegistration:value];
            break;
        case rtPostRegistrationLongReply:
            [self parsePostRegistrationLong:value];
            break;
        case rtAddPointsReply:
            [self parseAddPointsReply:value];
            break;
        default:
            break;
    }

    [context performSelector:resultSelector];
}

- (void)onerror:(NSError*)error
{
    status = RequestStatusConnectionFailed;
    [context performSelector:resultSelector];
}

- (void)onfault:(SoapFault*)fault
{
    status = RequestStatusInternalError;
    [context performSelector:resultSelector];
}

#pragma mark Private
- (void)parsePostRegistration:(NSDictionary*)data
{
    NSString *postRegistrationResult = [data objectForKey:@"PostRegistrationResult"] == nil ?
                                       [data objectForKey:@"PostRegistrationToSynergyServerResult"] : [data objectForKey:@"PostRegistrationResult"];
    if (postRegistrationResult == nil)
    {
        status = RequestStatusInternalError;
        return;
    }

	CXMLDocument* doc = [[CXMLDocument alloc] initWithXMLString:postRegistrationResult options:0 error:nil];
    if (![self validateResponse:doc])
    {
        status = RequestStatusInternalError;
        return;
    }

    status = RequestStatusSuccess;
    RSPostRegistrationReply *reply = [[[RSPostRegistrationReply alloc] init] autorelease];
    reply.replyStatus = self.responseReplyStatus;
    reply.replyDescription = self.responseDescription;
}

- (void)parsePostRegistrationLong:(NSDictionary*)data
{
    NSString *postRegistrationLongResult = [data objectForKey:@"PostRegistrationLongResult"] == nil ?
    [data objectForKey:@"PostRegistrationLongToSynergyServerResult"] : [data objectForKey:@"PostRegistrationLongResult"];
    if (postRegistrationLongResult == nil)
    {
        status = RequestStatusInternalError;
        return;
    }
    
	CXMLDocument* doc = [[CXMLDocument alloc] initWithXMLString:postRegistrationLongResult options:0 error:nil];
    if (![self validateResponse:doc])
    {
        status = RequestStatusInternalError;
        return;
    }
    
    status = RequestStatusSuccess;
    RSPostRegistrationLongReply *reply = [[[RSPostRegistrationLongReply alloc] init] autorelease];
    reply.replyStatus = self.responseReplyStatus;
    reply.replyDescription = self.responseDescription;
}

- (void)parseAddPointsReply:(NSDictionary*)data
{
    NSString *addPointsResult = [data objectForKey:@"AddPointsResult"];
    if (addPointsResult == nil)
    {
        status = RequestStatusInternalError;
        return;
    }

	CXMLDocument* doc = [[CXMLDocument alloc] initWithXMLString:addPointsResult options:0 error:nil];
    if (![self validateResponse:doc])
    {
        status = RequestStatusInternalError;
        return;
    }

    status = RequestStatusSuccess;
    RSAddPointsReply *reply = [[[RSAddPointsReply alloc] init] autorelease];
    reply.replyStatus = self.responseReplyStatus;
    reply.replyDescription = self.responseDescription;
    CXMLElement *root = [doc rootElement];
    NSArray *childNodes = [root children];
    for (CXMLElement *node in childNodes)
    {
        if ([[node name] caseInsensitiveCompare:@"Reward"] == NSOrderedSame)
        {
            reply.reward = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"Approved"] == NSOrderedSame)
        {
            reply.approved = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"Clerk"] == NSOrderedSame)
        {
            reply.clerk = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"Check"] == NSOrderedSame)
        {
            reply.check = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"CardNumber"] == NSOrderedSame)
        {
            reply.cardNumber = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"CardName"] == NSOrderedSame)
        {
            reply.cardName = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"PointsAdded"] == NSOrderedSame)
        {
            reply.pointsAdded = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"TotalPoints"] == NSOrderedSame)
        {
            reply.totalPoints = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"RewardBalance"] == NSOrderedSame)
        {
            reply.rewardBalance = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"TotalSaved"] == NSOrderedSame)
        {
            reply.totalSaved = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"TotalVisits"] == NSOrderedSame)
        {
            reply.totalVisits = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"GiftCardBalance"] == NSOrderedSame)
        {
            reply.giftCardBalance = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"RewardCashBalance"] == NSOrderedSame)
        {
            reply.rewardCashBalance = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"Description"] == NSOrderedSame)
        {
            reply.description = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"CustomReceiptMessages"] == NSOrderedSame)
        {
            reply.description = [node stringValue];
        }
    }

    replyObject = reply;
}

- (BOOL)validateResponse:(CXMLDocument*)response
{
    if(response == nil)
    {
		return NO;
	}

    CXMLElement *root = [response rootElement];
    NSArray *childNodes = [root children];
    if (childNodes == nil)
    {
        return NO;
    }

    CXMLElement* node = [childNodes objectAtIndex:0];
    if ([[node name] caseInsensitiveCompare:@"Response"] == NSOrderedSame)
    {
        CXMLNode *statusAttribute = [node attributeForName:@"Status"];
        NSString *statusValue = [statusAttribute stringValue];
        if ([statusValue caseInsensitiveCompare:@"Error"] == NSOrderedSame)
        {
            CXMLNode *errorAttribute = [node attributeForName:@"Error"];
            NSString *errorValue = [errorAttribute stringValue];
            responseReplyStatus = ReplyStatusError;
            responseDescription = errorValue;
        }
        else if ([statusValue caseInsensitiveCompare:@"Success"] == NSOrderedSame)
        {
            CXMLNode *descAttribute = [node attributeForName:@"Description"];
            NSString *descValue = [descAttribute stringValue];
            responseReplyStatus = ReplyStatusSuccess;
            responseDescription = descValue;
        }
    }

    return YES;
}

@end

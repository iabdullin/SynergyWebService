//
//  RSSynergyReply.m
//  SynergyWebApp
//
//  Created by Ildar on 2/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "RSSynergyReply.h"

@implementation RSSynergyReply

@synthesize replyStatus, replyDescription;

- (void)dealloc
{
    self.replyDescription = nil;;
    [super dealloc];
}

- (SynergyReplyType)replyType
{
    return rtUnknownReply;
}

@end

@implementation RSPostRegistrationReply

- (SynergyReplyType)replyType
{
    return rtPostRegistrationReply;
}

@end

@implementation RSPostRegistrationLongReply

- (SynergyReplyType)replyType
{
    return rtPostRegistrationLongReply;
}

@end

@implementation RSAddPointsReply

@synthesize reward, approved, clerk, check, cardNumber, cardName, pointsAdded, totalPoints,
            rewardBalance, totalSaved, totalVisits, giftCardBalance, rewardCashBalance, description,
            customReceiptMessages;

- (SynergyReplyType)replyType
{
    return rtAddPointsReply;
}

@end
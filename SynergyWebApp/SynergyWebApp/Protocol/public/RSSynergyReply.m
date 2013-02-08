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

@implementation RSBalanceInquiryReply

@synthesize cardNumber, cardName, giftCardBalance, pointsBalance,
            rewardCashBalance, totalVisits;

- (SynergyReplyType)replyType
{
    return rtBalanceInquiryReply;
}

@end

@implementation RSDeductPointsReply

- (SynergyReplyType)replyType
{
    return rtDeductPointsReply;
}

@end

@implementation RSLoadActivateGiftCardReply

@synthesize approved, loadAmount, cardNumber, clerk,
            check, description1, giftCardBalance, pointsBalance,
            rewardCashBalance, customReceiptMessages;

- (SynergyReplyType)replyType
{
    return rtLoadActivateGiftCardReply;
}

@end

@implementation RSLoadRewardCardMoneyReply

@synthesize approved, cardNumber, rewardLoaded,
            giftCardBalance, pointsBalance, rewardCashBalance, totalVisits;

- (SynergyReplyType)replyType
{
    return rtLoadRewardCardMoneyReply;
}

@end

@implementation RSRedeemGiftCardOnlyReply : RSSynergyReply

@synthesize gift, approved, cardNumber, cardName, clerk, check,
            saleAmount, balanceUsed, giftCardBalance, pointsBalance,
            rewardCashBalance, customReceiptMessages;

- (SynergyReplyType)replyType
{
    return rtRedeemGiftCardOnlyReply;
}

@end

@implementation RSRedeemGiftCardOrRewardReply : RSSynergyReply

@synthesize reward, approved, cardNumber, cardName, clerk, check,
            saleAmount, rewardUsed, customerOwes, totalPoints,
            rewardBalance, totalSaved, totalVisits, giftCardBalance,
            rewardCashBalance, description1, customReceiptMessages;

- (SynergyReplyType)replyType
{
    return rtRedeemGiftCardOrRewardReply;
}

@end
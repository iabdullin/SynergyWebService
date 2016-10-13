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


-(void)testFunction2
{
    
}

-(void)testFunction
{
    
}

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

@implementation RSVoidReply : RSSynergyReply

@synthesize voidAmount, approved, cardNumber, transaction, voidedPoints, voidedAmount, giftCardBalance,
            pointsBalance, rewardCashBalance ,totalVisits;

- (SynergyReplyType)replyType
{
    return rtVoidReply;
}

@end

@implementation RSMerchantData : NSObject

@synthesize merchantId, salesPerson, businessName ,statusId, status, address,
            locationId, zip, location, neighborhood, categoryId, categoryName,
            foodType, categoryName2, phone, email, fax, webSite,city, dbaName, state, country,
            welcomeCredit, localReward, touristReward, createdOn, exported, ausrId, userId, userName,
            userPassword, userEmail, roleId, roleName, terminalType;
@end

@implementation RSGetMerchantRecordsReply : RSSynergyReply

@synthesize dataStatus, merchantData;

- (SynergyReplyType)replyType
{
    return rtGetMerchantRecordsReply;
}

@end

@implementation RSMerchantLogoData : NSObject

@synthesize logoId, merchantId, businessName, logoData, webSite;

@end

@implementation RSGetMerchantLogosReply : RSSynergyReply

@synthesize dataStatus, logosData;

- (SynergyReplyType)replyType
{
    return rtGetMerchantLogosReply;
}

@end

@implementation RSProgramFAQData : NSObject

@synthesize number, question, answer;

@end

@implementation RSGetProgramFAQToSynergyServerReply : RSSynergyReply

@synthesize programName, faqData;

- (SynergyReplyType)replyType
{
    return rtGetProgramFAQToSynergyServerReply;
}

@end

@implementation RSGetTotalSavingsToSynergyServerReply : RSSynergyReply

@synthesize totalSaved;

- (SynergyReplyType)replyType
{
    return rtGetTotalSavingsToSynergyServerReply;
}

@end

@implementation RSValidateCardNumberToSynergyServerReply : RSSynergyReply

- (SynergyReplyType)replyType
{
    return rtValidateCardNumberToSynergyServerReply;
}

@end

@implementation RSGetMerchantRecordsInPagesReply : RSSynergyReply

@synthesize dataStatus, maxNumPages, rowNum, iD, newMexicoCardFlag, merchantData;

- (SynergyReplyType)replyType
{
    return rtGetMerchantRecordsInPageReply;
}

@end




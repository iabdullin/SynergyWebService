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
- (void)parseBalanceInquiryReply:(NSDictionary*)data;
- (void)parseDeductPointsReply:(NSDictionary*)data;
- (void)parseLoadActivateGiftCardReply:(NSDictionary*)data;
- (void)parseLoadRewardCardMoneyReply:(NSDictionary*)data;
- (void)parseRedeemGiftCardOnlyReply:(NSDictionary*)data;
- (void)parseRedeemGiftCardOrRewardReply:(NSDictionary*)data;
- (void)parseVoidReply:(NSDictionary*)data;
- (void)parseGetMerchantRecordsReply:(NSDictionary*)data;
- (void)parseGetMerchantLogosReply:(NSDictionary*)data;
- (void)parseGetProgramFAQToSynergyServer:(NSDictionary*)data;
- (void)parseGetTotalSavingsToSynergyServer:(NSDictionary*)data;
- (void)parseValidateCardNumberToSynergyServer:(NSDictionary*)data;
- (void)parseGetMerchantRecordsInPages:(NSDictionary*)data;
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
        case rtBalanceInquiryReply:
            [self parseBalanceInquiryReply:value];
            break;
        case rtDeductPointsReply:
            [self parseDeductPointsReply:value];
            break;
        case rtLoadActivateGiftCardReply:
            [self parseLoadActivateGiftCardReply:value];
            break;
        case rtLoadRewardCardMoneyReply:
            [self parseLoadRewardCardMoneyReply:value];
            break;
        case rtRedeemGiftCardOnlyReply:
            [self parseRedeemGiftCardOnlyReply:value];
            break;
        case rtRedeemGiftCardOrRewardReply:
            [self parseRedeemGiftCardOrRewardReply:value];
            break;
        case rtVoidReply:
            [self parseVoidReply:value];
            break;
        case rtGetMerchantRecordsReply:
            [self parseGetMerchantRecordsReply:value];
            break;
        case rtGetMerchantLogosReply:
            [self parseGetMerchantLogosReply:value];
            break;
        case rtGetProgramFAQToSynergyServerReply:
            [self parseGetProgramFAQToSynergyServer:value];
            break;
        case rtGetTotalSavingsToSynergyServerReply:
            [self parseGetTotalSavingsToSynergyServer:value];
            break;
        case rtValidateCardNumberToSynergyServerReply:
            [self parseValidateCardNumberToSynergyServer:value];
            break;
        case rtGetMerchantRecordsInPageReply:
            [self parseGetMerchantRecordsInPages:value];
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

    replyObject = reply;
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

    replyObject = reply;
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

- (void)parseBalanceInquiryReply:(NSDictionary*)data
{
    NSString *balanceInquiryResult = [data objectForKey:@"BalanceInquiryResult"];
    if (balanceInquiryResult == nil)
    {
        status = RequestStatusInternalError;
        return;
    }

	CXMLDocument* doc = [[CXMLDocument alloc] initWithXMLString:balanceInquiryResult options:0 error:nil];
    if (![self validateResponse:doc])
    {
        status = RequestStatusInternalError;
        return;
    }

    status = RequestStatusSuccess;
    RSBalanceInquiryReply *reply = [[[RSBalanceInquiryReply alloc] init] autorelease];
    reply.replyStatus = self.responseReplyStatus;
    reply.replyDescription = self.responseDescription;
    CXMLElement *root = [doc rootElement];
    NSArray *childNodes = [root children];
    for (CXMLElement *node in childNodes)
    {
        if ([[node name] caseInsensitiveCompare:@"CardNumber"] == NSOrderedSame)
        {
            reply.cardNumber = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"CardName"] == NSOrderedSame)
        {
            reply.cardName = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"GiftCardBalance"] == NSOrderedSame)
        {
            reply.giftCardBalance = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"PointsBalance"] == NSOrderedSame)
        {
            reply.pointsBalance = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"RewardCashBalance"] == NSOrderedSame)
        {
            reply.rewardCashBalance = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"TotalVisits"] == NSOrderedSame)
        {
            reply.totalVisits = [node stringValue];
        }
    }

    replyObject = reply;
}

- (void)parseDeductPointsReply:(NSDictionary*)data
{
    NSString *deductPointsResult = [data objectForKey:@"DeductPointsResult"];
    if (deductPointsResult == nil)
    {
        status = RequestStatusInternalError;
        return;
    }
    
	CXMLDocument* doc = [[CXMLDocument alloc] initWithXMLString:deductPointsResult options:0 error:nil];
    if (![self validateResponse:doc])
    {
        status = RequestStatusInternalError;
        return;
    }
    
    status = RequestStatusSuccess;
    RSBalanceInquiryReply *reply = [[[RSBalanceInquiryReply alloc] init] autorelease];
    reply.replyStatus = self.responseReplyStatus;
    reply.replyDescription = self.responseDescription;

    replyObject = reply;
}

- (void)parseLoadActivateGiftCardReply:(NSDictionary *)data
{
    NSString *loadActivateGiftCardResult = [data objectForKey:@"LoadActivateGiftCardResult"];
    if (loadActivateGiftCardResult == nil)
    {
        status = RequestStatusInternalError;
        return;
    }
    
	CXMLDocument* doc = [[CXMLDocument alloc] initWithXMLString:loadActivateGiftCardResult options:0 error:nil];
    if (![self validateResponse:doc])
    {
        status = RequestStatusInternalError;
        return;
    }
    
    status = RequestStatusSuccess;
    RSLoadActivateGiftCardReply *reply = [[[RSLoadActivateGiftCardReply alloc] init] autorelease];
    reply.replyStatus = self.responseReplyStatus;
    reply.replyDescription = self.responseDescription;
    CXMLElement *root = [doc rootElement];
    NSArray *childNodes = [root children];
    for (CXMLElement *node in childNodes)
    {
        if ([[node name] caseInsensitiveCompare:@"Approved"] == NSOrderedSame)
        {
            reply.approved = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"LoadAmount"] == NSOrderedSame)
        {
            reply.loadAmount = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"CardNumber"] == NSOrderedSame)
        {
            reply.cardNumber = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"Clerk"] == NSOrderedSame)
        {
            reply.clerk = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"Check"] == NSOrderedSame)
        {
            reply.check = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"Description1"] == NSOrderedSame)
        {
            reply.description1 = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"GiftCardBalance"] == NSOrderedSame)
        {
            reply.giftCardBalance = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"PointsBalance"] == NSOrderedSame)
        {
            reply.pointsBalance = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"RewardCashBalance"] == NSOrderedSame)
        {
            reply.rewardCashBalance = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"CustomReceiptMessages"] == NSOrderedSame)
        {
            reply.customReceiptMessages = [node stringValue];
        }
    }
    
    replyObject = reply;
}

- (void)parseLoadRewardCardMoneyReply:(NSDictionary*)data
{
    NSString *loadRewardCardMoneyResult = [data objectForKey:@"LoadRewardCardMoneyResult"];
    if (loadRewardCardMoneyResult == nil)
    {
        status = RequestStatusInternalError;
        return;
    }
    
	CXMLDocument* doc = [[CXMLDocument alloc] initWithXMLString:loadRewardCardMoneyResult options:0 error:nil];
    if (![self validateResponse:doc])
    {
        status = RequestStatusInternalError;
        return;
    }
    
    status = RequestStatusSuccess;
    RSLoadRewardCardMoneyReply *reply = [[[RSLoadRewardCardMoneyReply alloc] init] autorelease];
    reply.replyStatus = self.responseReplyStatus;
    reply.replyDescription = self.responseDescription;
    CXMLElement *root = [doc rootElement];
    NSArray *childNodes = [root children];
    for (CXMLElement *node in childNodes)
    {
        if ([[node name] caseInsensitiveCompare:@"Approved"] == NSOrderedSame)
        {
            reply.approved = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"CardNumber"] == NSOrderedSame)
        {
            reply.cardNumber = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"RewardLoaded"] == NSOrderedSame)
        {
            reply.rewardLoaded = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"GiftCardBalance"] == NSOrderedSame)
        {
            reply.giftCardBalance = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"PointsBalance"] == NSOrderedSame)
        {
            reply.pointsBalance = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"RewardCashBalance"] == NSOrderedSame)
        {
            reply.rewardCashBalance = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"TotalVisits"] == NSOrderedSame)
        {
            reply.totalVisits = [node stringValue];
        }
    }

    replyObject = reply;
}

- (void)parseRedeemGiftCardOnlyReply:(NSDictionary *)data
{
    NSString *redeemGiftCardOnlyResult = [data objectForKey:@"RedeemGiftCardOnlyResult"];
    if (redeemGiftCardOnlyResult == nil)
    {
        status = RequestStatusInternalError;
        return;
    }
    
	CXMLDocument* doc = [[CXMLDocument alloc] initWithXMLString:redeemGiftCardOnlyResult options:0 error:nil];
    if (![self validateResponse:doc])
    {
        status = RequestStatusInternalError;
        return;
    }
    
    status = RequestStatusSuccess;
    RSRedeemGiftCardOnlyReply *reply = [[[RSRedeemGiftCardOnlyReply alloc] init] autorelease];
    reply.replyStatus = self.responseReplyStatus;
    reply.replyDescription = self.responseDescription;
    CXMLElement *root = [doc rootElement];
    NSArray *childNodes = [root children];
    for (CXMLElement *node in childNodes)
    {
        if ([[node name] caseInsensitiveCompare:@"Gift"] == NSOrderedSame)
        {
            reply.gift = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"Approved"] == NSOrderedSame)
        {
            reply.approved = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"CardNumber"] == NSOrderedSame)
        {
            reply.cardNumber = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"CardName"] == NSOrderedSame)
        {
            reply.cardName = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"Clerk"] == NSOrderedSame)
        {
            reply.clerk = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"Check"] == NSOrderedSame)
        {
            reply.check = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"SaleAmount"] == NSOrderedSame)
        {
            reply.saleAmount = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"BalanceUsed"] == NSOrderedSame)
        {
            reply.balanceUsed = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"GiftCardBalance"] == NSOrderedSame)
        {
            reply.giftCardBalance = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"PointsBalance"] == NSOrderedSame)
        {
            reply.pointsBalance = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"RewardCashBalance"] == NSOrderedSame)
        {
            reply.rewardCashBalance = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"CustomReceiptMessages"] == NSOrderedSame)
        {
            reply.customReceiptMessages = [node stringValue];
        }
    }

    replyObject = reply;
}

- (void)parseRedeemGiftCardOrRewardReply:(NSDictionary *)data
{
    NSString *redeemGiftCardOrRewardResult = [data objectForKey:@"RedeemGiftCardOrRewardResult"];
    if (redeemGiftCardOrRewardResult == nil)
    {
        status = RequestStatusInternalError;
        return;
    }
    
	CXMLDocument* doc = [[CXMLDocument alloc] initWithXMLString:redeemGiftCardOrRewardResult options:0 error:nil];
    if (![self validateResponse:doc])
    {
        status = RequestStatusInternalError;
        return;
    }
    
    status = RequestStatusSuccess;
    RSRedeemGiftCardOrRewardReply *reply = [[[RSRedeemGiftCardOrRewardReply alloc] init] autorelease];
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
        else if ([[node name] caseInsensitiveCompare:@"CardNumber"] == NSOrderedSame)
        {
            reply.cardNumber = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"CardName"] == NSOrderedSame)
        {
            reply.cardName = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"Clerk"] == NSOrderedSame)
        {
            reply.clerk = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"Check"] == NSOrderedSame)
        {
            reply.check = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"SaleAmount"] == NSOrderedSame)
        {
            reply.saleAmount = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"RewardUsed"] == NSOrderedSame)
        {
            reply.rewardUsed = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"GiftCardBalance"] == NSOrderedSame)
        {
            reply.giftCardBalance = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"CustomerOwes"] == NSOrderedSame)
        {
            reply.customerOwes = [node stringValue];
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
        else if ([[node name] caseInsensitiveCompare:@"Description"] == NSOrderedSame)
        {
            reply.description1 = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"RewardCashBalance"] == NSOrderedSame)
        {
            reply.rewardCashBalance = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"CustomReceiptMessages"] == NSOrderedSame)
        {
            reply.customReceiptMessages = [node stringValue];
        }
    }
    
    replyObject = reply;
}

- (void)parseVoidReply:(NSDictionary *)data
{
    NSString *voidResult = [data objectForKey:@"VoidResult"];
    if (voidResult == nil)
    {
        status = RequestStatusInternalError;
        return;
    }

	CXMLDocument* doc = [[CXMLDocument alloc] initWithXMLString:voidResult options:0 error:nil];
    if (![self validateResponse:doc])
    {
        status = RequestStatusInternalError;
        return;
    }

    status = RequestStatusSuccess;
    RSVoidReply *reply = [[[RSVoidReply alloc] init] autorelease];
    reply.replyStatus = self.responseReplyStatus;
    reply.replyDescription = self.responseDescription;
    CXMLElement *root = [doc rootElement];
    NSArray *childNodes = [root children];
    for (CXMLElement *node in childNodes)
    {
        if ([[node name] caseInsensitiveCompare:@"Void"] == NSOrderedSame)
        {
            reply.voidAmount = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"Approved"] == NSOrderedSame)
        {
            reply.approved = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"CardNumber"] == NSOrderedSame)
        {
            reply.cardNumber = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"Transaction"] == NSOrderedSame)
        {
            reply.transaction = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"VoidedPoints"] == NSOrderedSame)
        {
            reply.voidedPoints = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"VoidedAmount"] == NSOrderedSame)
        {
            reply.voidedAmount = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"GiftCardBalance"] == NSOrderedSame)
        {
            reply.giftCardBalance = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"PointsBalance"] == NSOrderedSame)
        {
            reply.pointsBalance = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"RewardCashBalance"] == NSOrderedSame)
        {
            reply.rewardCashBalance = [node stringValue];
        }
        else if ([[node name] caseInsensitiveCompare:@"TotalVisits"] == NSOrderedSame)
        {
            reply.totalVisits = [node stringValue];
        }
    }

    replyObject = reply;
}

- (void)parseGetMerchantRecordsReply:(NSDictionary *)data
{
    NSString *getMerchantRecordsResult = [data objectForKey:@"GetMerchantRecordsResult"];
    if (getMerchantRecordsResult == nil)
    {
        status = RequestStatusInternalError;
        return;
    }
    
	CXMLDocument* doc = [[CXMLDocument alloc] initWithXMLString:getMerchantRecordsResult options:0 error:nil];
    if (![self validateResponse:doc])
    {
        status = RequestStatusInternalError;
        return;
    }

    status = RequestStatusSuccess;
    RSGetMerchantRecordsReply *reply = [[[RSGetMerchantRecordsReply alloc] init] autorelease];
    reply.replyStatus = self.responseReplyStatus;
    reply.replyDescription = self.responseDescription;
    CXMLElement *root = [doc rootElement];
    NSArray *childNodes = [root children];
    for (CXMLElement *node in childNodes)
    {
        if ([[node name] caseInsensitiveCompare:@"GetMerchantsData"] == NSOrderedSame)
        {
            CXMLNode *statusAttribute = [node attributeForName:@"Status"];
            NSString *statusValue = [statusAttribute stringValue];
            if ([statusValue caseInsensitiveCompare:@"True"] == NSOrderedSame)
            {
                reply.dataStatus = YES;
            }
            else
            {
                reply.dataStatus = NO;
            }
            NSArray *merchantNodes = [node children];
            reply.merchantData = [[[NSMutableArray alloc] init] autorelease];
            for (CXMLElement *merchantNode in merchantNodes)
            {
                if ([[merchantNode name] caseInsensitiveCompare:@"row"] == NSOrderedSame)
                {
                    RSMerchantData *data = [[RSMerchantData alloc] init];
                    data.merchantId = [[merchantNode attributeForName:@"MerchantID"] stringValue];
                    data.salesPerson = [[merchantNode attributeForName:@"SalesPerson"] stringValue];
                    data.businessName = [[merchantNode attributeForName:@"BusinessName"] stringValue];
                    data.statusId = [[merchantNode attributeForName:@"StatusID"] stringValue];
                    data.address = [[merchantNode attributeForName:@"Address"] stringValue];
                    data.locationId = [[merchantNode attributeForName:@"LocationID"] stringValue];
                    data.zip = [[merchantNode attributeForName:@"Zip"] stringValue];
                    data.location = [[merchantNode attributeForName:@"Location"] stringValue];
                    data.neighborhood = [[merchantNode attributeForName:@"Neighborhood"] stringValue];
                    data.categoryId = [[merchantNode attributeForName:@"CategoryID"] stringValue];
                    data.categoryName = [[merchantNode attributeForName:@"CategoryName"] stringValue];
                    data.foodType = [[merchantNode attributeForName:@"FoodType"] stringValue];
                    data.categoryName2 = [[merchantNode attributeForName:@"CategoryName2"] stringValue];
                    data.phone = [[merchantNode attributeForName:@"Phone"] stringValue];
                    data.email = [[merchantNode attributeForName:@"Email"] stringValue];
                    data.fax = [[merchantNode attributeForName:@"Fax"] stringValue];
                    data.webSite = [[merchantNode attributeForName:@"Website"] stringValue];
                    data.city = [[merchantNode attributeForName:@"City"] stringValue];
                    data.dbaName = [[merchantNode attributeForName:@"DBAName"] stringValue];
                    data.state = [[merchantNode attributeForName:@"State"] stringValue];
                    data.country = [[merchantNode attributeForName:@"Country"] stringValue];
                    data.welcomeCredit = [[merchantNode attributeForName:@"WelcomeCredit"] stringValue];
                    data.localReward = [[merchantNode attributeForName:@"LocalReward"] stringValue];
                    data.touristReward = [[merchantNode attributeForName:@"TouristReward"] stringValue];
                    data.createdOn = [[merchantNode attributeForName:@"CreatedOn"] stringValue];
                    data.exported = [[merchantNode attributeForName:@"Exported"] stringValue];
                    data.ausrId = [[merchantNode attributeForName:@"AUSR_ID"] stringValue];
                    data.userId = [[merchantNode attributeForName:@"UserID"] stringValue];
                    data.userName = [[merchantNode attributeForName:@"UserName"] stringValue];
                    data.userPassword = [[merchantNode attributeForName:@"UserPassword"] stringValue];
                    data.userEmail = [[merchantNode attributeForName:@"UserEmail"] stringValue];
                    data.roleId = [[merchantNode attributeForName:@"RoleID"] stringValue];
                    data.roleName = [[merchantNode attributeForName:@"RoleName"] stringValue];
                    data.terminalType = [[merchantNode attributeForName:@"TerminalType"] stringValue];
                    [((NSMutableArray*)reply.merchantData) addObject:data];
                    [data release];
                }
            }
        }
    }

    replyObject = reply;
}

- (void)parseGetMerchantLogosReply:(NSDictionary *)data
{
    NSString *getMerchantLogosResult = [data objectForKey:@"GetMerchantLogosResult"];
    if (getMerchantLogosResult == nil)
    {
        status = RequestStatusInternalError;
        return;
    }
    
	CXMLDocument* doc = [[CXMLDocument alloc] initWithXMLString:getMerchantLogosResult options:0 error:nil];
    if (![self validateResponse:doc])
    {
        status = RequestStatusInternalError;
        return;
    }
    
    status = RequestStatusSuccess;
    RSGetMerchantLogosReply *reply = [[[RSGetMerchantLogosReply alloc] init] autorelease];
    reply.replyStatus = self.responseReplyStatus;
    reply.replyDescription = self.responseDescription;
    CXMLElement *root = [doc rootElement];
    NSArray *childNodes = [root children];
    for (CXMLElement *node in childNodes)
    {
        if ([[node name] caseInsensitiveCompare:@"GetMerchantLogos"] == NSOrderedSame)
        {
            CXMLNode *statusAttribute = [node attributeForName:@"Status"];
            NSString *statusValue = [statusAttribute stringValue];
            if ([statusValue caseInsensitiveCompare:@"True"] == NSOrderedSame)
            {
                reply.dataStatus = YES;
            }
            else
            {
                reply.dataStatus = NO;
            }
            NSArray *merchantNodes = [node children];
            reply.logosData = [[[NSMutableArray alloc] init] autorelease];
            for (CXMLElement *merchantNode in merchantNodes)
            {
                if ([[merchantNode name] caseInsensitiveCompare:@"row"] == NSOrderedSame)
                {
                    RSMerchantLogoData *data = [[RSMerchantLogoData alloc] init];
                    data.logoId = [[merchantNode attributeForName:@"Logo_ID"] stringValue];
                    data.merchantId = [[merchantNode attributeForName:@"MerchantID"] stringValue];
                    data.businessName = [[merchantNode attributeForName:@"BusinessName"] stringValue];
                    data.logoData = [[merchantNode attributeForName:@"Logo"] stringValue];
                    data.webSite = [[merchantNode attributeForName:@"Website"] stringValue];
                    [((NSMutableArray*)reply.logosData) addObject:data];
                    [data release];
                }
            }
        }
    }
    
    replyObject = reply;
}

- (void)parseGetProgramFAQToSynergyServer:(NSDictionary *)data
{
    NSString *getProgramFAQToSynergyServerResult = [data objectForKey:@"GetProgramFAQToSynergyServerResult"];
    if (getProgramFAQToSynergyServerResult == nil)
    {
        status = RequestStatusInternalError;
        return;
    }
    
	CXMLDocument* doc = [[CXMLDocument alloc] initWithXMLString:getProgramFAQToSynergyServerResult options:0 error:nil];
    if (![self validateResponse:doc])
    {
        status = RequestStatusInternalError;
        return;
    }
    
    status = RequestStatusSuccess;
    RSGetProgramFAQToSynergyServerReply *reply = [[[RSGetProgramFAQToSynergyServerReply alloc] init] autorelease];
    reply.replyStatus = self.responseReplyStatus;
    reply.replyDescription = self.responseDescription;
    CXMLElement *root = [doc rootElement];
    reply.programName = [[root attributeForName:@"Program"] stringValue];
    NSArray *childNodes = [root children];
    for (CXMLElement *node in childNodes)
    {
        if ([[node name] caseInsensitiveCompare:@"row"] == NSOrderedSame)
        {
            RSProgramFAQData *data = [[RSProgramFAQData alloc] init];
            data.number = [[node attributeForName:@"Number"] stringValue];
            data.question = [[node attributeForName:@"Question"] stringValue];
            data.answer = [[node attributeForName:@"Answer"] stringValue];
            [((NSMutableArray*)reply.faqData) addObject:data];
            [data release];
        }
    }
    
    replyObject = reply;
}

- (void)parseGetTotalSavingsToSynergyServer:(NSDictionary *)data
{
    NSString *getTotalSavingsToSynergyServerResult = [data objectForKey:@"GetTotalSavingsToSynergyServerResult"];
    if (getTotalSavingsToSynergyServerResult == nil)
    {
        status = RequestStatusInternalError;
        return;
    }
    
	CXMLDocument* doc = [[CXMLDocument alloc] initWithXMLString:getTotalSavingsToSynergyServerResult options:0 error:nil];
    if (![self validateResponse:doc])
    {
        status = RequestStatusInternalError;
        return;
    }
    
    status = RequestStatusSuccess;
    RSGetTotalSavingsToSynergyServerReply *reply = [[[RSGetTotalSavingsToSynergyServerReply alloc] init] autorelease];
    reply.replyStatus = self.responseReplyStatus;
    reply.replyDescription = self.responseDescription;
    CXMLElement *root = [doc rootElement];
    NSArray *childNodes = [root children];
    for (CXMLElement *node in childNodes)
    {
        if ([[node name] caseInsensitiveCompare:@"TotalSaved"] == NSOrderedSame)
        {
            reply.totalSaved = [node stringValue];
        }
    }

    replyObject = reply;
}

- (void)parseValidateCardNumberToSynergyServer:(NSDictionary *)data
{
    NSString *validateCardNumberToSynergyServerResult = [data objectForKey:@"ValidateCardNumberToSynergyServerResult"];
    if (validateCardNumberToSynergyServerResult == nil)
    {
        status = RequestStatusInternalError;
        return;
    }
    
	CXMLDocument* doc = [[CXMLDocument alloc] initWithXMLString:validateCardNumberToSynergyServerResult options:0 error:nil];
    if (![self validateResponse:doc])
    {
        status = RequestStatusInternalError;
        return;
    }
    
    status = RequestStatusSuccess;
    RSValidateCardNumberToSynergyServerReply *reply = [[[RSValidateCardNumberToSynergyServerReply alloc] init] autorelease];
    reply.replyStatus = self.responseReplyStatus;
    reply.replyDescription = self.responseDescription;
    
    replyObject = reply;
}

- (void)parseGetMerchantRecordsInPages:(NSDictionary *)data
{
    NSString *getMerchantRecordsInPagesResult = [data objectForKey:@"GetMerchantRecordsInPagesResult"];
    if (getMerchantRecordsInPagesResult == nil)
    {
        status = RequestStatusInternalError;
        return;
    }
    
	CXMLDocument* doc = [[CXMLDocument alloc] initWithXMLString:getMerchantRecordsInPagesResult options:0 error:nil];
    if (![self validateResponse:doc])
    {
        status = RequestStatusInternalError;
        return;
    }
    
    status = RequestStatusSuccess;
    RSGetMerchantRecordsInPagesReply *reply = [[[RSGetMerchantRecordsInPagesReply alloc] init] autorelease];
    reply.replyStatus = self.responseReplyStatus;
    reply.replyDescription = self.responseDescription;
    CXMLElement *root = [doc rootElement];
    NSArray *childNodes = [root children];
    for (CXMLElement *node in childNodes)
    {
        if ([[node name] caseInsensitiveCompare:@"GetMerchantsData"] == NSOrderedSame)
        {
            CXMLNode *statusAttribute = [node attributeForName:@"Status"];
            NSString *statusValue = [statusAttribute stringValue];
            if ([statusValue caseInsensitiveCompare:@"True"] == NSOrderedSame)
            {
                reply.dataStatus = YES;
            }
            else
            {
                reply.dataStatus = NO;
            }
            NSArray *merchantNodes = [node children];
            reply.merchantData = [[[NSMutableArray alloc] init] autorelease];
            for (CXMLElement *merchantNode in merchantNodes)
            {
                if ([[merchantNode name] caseInsensitiveCompare:@"row"] == NSOrderedSame)
                {
                    reply.maxNumPages = [[merchantNode attributeForName:@"MaxNumPages"] stringValue];
                    reply.rowNum = [[merchantNode attributeForName:@"RowNum"] stringValue];
                    reply.iD = [[merchantNode attributeForName:@"ID"] stringValue];
                    CXMLNode *attrNode = [merchantNode attributeForName:@"NewMexicoCardFlag"];
                    if (attrNode)
                    {
                        if ([[attrNode stringValue] caseInsensitiveCompare:@"Yes"] == NSOrderedSame)
                        {
                            reply.newMexicoCardFlag = YES;
                        }
                    }
                    RSMerchantData *data = [[RSMerchantData alloc] init];
                    data.merchantId = [[merchantNode attributeForName:@"MerchantID"] stringValue];
                    data.salesPerson = [[merchantNode attributeForName:@"SalesPerson"] stringValue];
                    data.businessName = [[merchantNode attributeForName:@"BusinessName"] stringValue];
                    data.statusId = [[merchantNode attributeForName:@"StatusID"] stringValue];
                    data.address = [[merchantNode attributeForName:@"Address"] stringValue];
                    data.locationId = [[merchantNode attributeForName:@"LocationID"] stringValue];
                    data.zip = [[merchantNode attributeForName:@"Zip"] stringValue];
                    data.location = [[merchantNode attributeForName:@"Location"] stringValue];
                    data.neighborhood = [[merchantNode attributeForName:@"Neighborhood"] stringValue];
                    data.categoryId = [[merchantNode attributeForName:@"CategoryID"] stringValue];
                    data.categoryName = [[merchantNode attributeForName:@"CategoryName"] stringValue];
                    data.foodType = [[merchantNode attributeForName:@"FoodType"] stringValue];
                    data.categoryName2 = [[merchantNode attributeForName:@"CategoryName2"] stringValue];
                    data.phone = [[merchantNode attributeForName:@"Phone"] stringValue];
                    data.email = [[merchantNode attributeForName:@"Email"] stringValue];
                    data.fax = [[merchantNode attributeForName:@"Fax"] stringValue];
                    data.webSite = [[merchantNode attributeForName:@"Website"] stringValue];
                    data.city = [[merchantNode attributeForName:@"City"] stringValue];
                    data.dbaName = [[merchantNode attributeForName:@"DBAName"] stringValue];
                    data.state = [[merchantNode attributeForName:@"State"] stringValue];
                    data.country = [[merchantNode attributeForName:@"Country"] stringValue];
                    data.welcomeCredit = [[merchantNode attributeForName:@"WelcomeCredit"] stringValue];
                    data.localReward = [[merchantNode attributeForName:@"LocalReward"] stringValue];
                    data.touristReward = [[merchantNode attributeForName:@"TouristReward"] stringValue];
                    data.createdOn = [[merchantNode attributeForName:@"CreatedOn"] stringValue];
                    data.exported = [[merchantNode attributeForName:@"Exported"] stringValue];
                    data.ausrId = [[merchantNode attributeForName:@"AUSR_ID"] stringValue];
                    data.userId = [[merchantNode attributeForName:@"UserID"] stringValue];
                    data.userName = [[merchantNode attributeForName:@"UserName"] stringValue];
                    data.userPassword = [[merchantNode attributeForName:@"UserPassword"] stringValue];
                    data.userEmail = [[merchantNode attributeForName:@"UserEmail"] stringValue];
                    data.roleId = [[merchantNode attributeForName:@"RoleID"] stringValue];
                    data.roleName = [[merchantNode attributeForName:@"RoleName"] stringValue];
                    data.terminalType = [[merchantNode attributeForName:@"TerminalType"] stringValue];
                    [((NSMutableArray*)reply.merchantData) addObject:data];
                    [data release];
                }
            }
        }
    }
    
    replyObject = reply;
}

#pragma mark Private
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

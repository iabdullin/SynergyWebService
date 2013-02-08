//
//  RSSynergyReply.h
//  SynergyWebApp
//
//  Created by Ildar on 2/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum SynergyReplyStatus
{
    ReplyStatusSuccess = 0,
    ReplyStatusError
    
} SynergyReplyStatus;

typedef enum SynergyReplyType
{
    rtPostRegistrationReply = 0,
    rtPostRegistrationLongReply,
    rtPostSkoopRegistrationLongReply,
    rtSkoopPostRegistrationReply,
    rtPostRegistrationSpecialReply,
    rtUpdateRegistrationLongReply,
    rtSkoopUpdateRegistrationReply,
    rtUpdateSkoopRegistrationReply,
    rtUpdateUpdateRegistrationSpecialReply,
    rtAddPointsReply,
    rtBalanceInquiryReply,
    rtBalanceInquiryWithNetworkReply,
    rtBalanceInquiryWithoutMerchantReply,
    rtDeductPointsReply,
    rtLoadActivateGiftCardReply,
    rtLoadRewardCardMoneyReply,
    rtRedeemGiftCardOnlyReply,
    rtRedeemGiftCardOrRewardReply,
    rtVoidReply,
    rtGetMerchantRecordsReply,
    rtGetMerchantLogosReply,
    rtGetProgramFAQToSynergyServerReply,
    rtGetTotalSavingsToSynergyServerReply,
    rtValidateCardNumberToSynergyServerReply,
    rtGetMerchantRecordsInPageReply,
    rtPushServiceToSynergyServerReply,
    rtGetIPhoneDeviceMessagesReply,
    rtDeactivateIPhoneMessageReply,
    rtGetRegistrationInfoReply,
    rtCheckRegistrationAccountReply,

    rtUnknownReply = 255

} SynergyReplyType;


@interface RSSynergyReply : NSObject
{
@protected
    SynergyReplyType   type;
    SynergyReplyStatus status;
}

@property(nonatomic, readwrite) SynergyReplyStatus replyStatus;
@property(nonatomic, retain)    NSString           *replyDescription;

- (SynergyReplyType)replyType;

@end


@interface RSPostRegistrationReply : RSSynergyReply
@end

@interface RSPostRegistrationLongReply : RSSynergyReply
@end


@interface RSAddPointsReply : RSSynergyReply

@property(nonatomic, assign) NSString   *reward;
@property(nonatomic, assign) NSString   *approved;
@property(nonatomic, assign) NSString   *clerk;
@property(nonatomic, assign) NSString   *check;
@property(nonatomic, assign) NSString   *cardNumber;
@property(nonatomic, assign) NSString   *cardName;
@property(nonatomic, assign) NSString   *pointsAdded;
@property(nonatomic, assign) NSString   *totalPoints;
@property(nonatomic, assign) NSString   *rewardBalance;
@property(nonatomic, assign) NSString   *totalSaved;
@property(nonatomic, assign) NSString   *totalVisits;
@property(nonatomic, assign) NSString   *giftCardBalance;
@property(nonatomic, assign) NSString   *rewardCashBalance;
@property(nonatomic, assign) NSString   *description;
@property(nonatomic, assign) NSString   *customReceiptMessages;

@end

@interface RSBalanceInquiryReply : RSSynergyReply

@property(nonatomic, assign) NSString   *cardNumber;
@property(nonatomic, assign) NSString   *cardName;
@property(nonatomic, assign) NSString   *giftCardBalance;
@property(nonatomic, assign) NSString   *pointsBalance;
@property(nonatomic, assign) NSString   *rewardCashBalance;
@property(nonatomic, assign) NSString   *totalVisits;

@end

@interface RSDeductPointsReply : RSSynergyReply
@end

@interface RSLoadActivateGiftCardReply : RSSynergyReply

@property(nonatomic, assign) NSString   *approved;
@property(nonatomic, assign) NSString   *loadAmount;
@property(nonatomic, assign) NSString   *cardNumber;
@property(nonatomic, assign) NSString   *clerk;
@property(nonatomic, assign) NSString   *check;
@property(nonatomic, assign) NSString   *description1;
@property(nonatomic, assign) NSString   *giftCardBalance;
@property(nonatomic, assign) NSString   *pointsBalance;
@property(nonatomic, assign) NSString   *rewardCashBalance;
@property(nonatomic, assign) NSString   *customReceiptMessages;

@end

@interface RSLoadRewardCardMoneyReply : RSSynergyReply

@property(nonatomic, assign) NSString   *approved;
@property(nonatomic, assign) NSString   *cardNumber;
@property(nonatomic, assign) NSString   *rewardLoaded;
@property(nonatomic, assign) NSString   *giftCardBalance;
@property(nonatomic, assign) NSString   *pointsBalance;
@property(nonatomic, assign) NSString   *rewardCashBalance;
@property(nonatomic, assign) NSString   *totalVisits;

@end

@interface RSRedeemGiftCardOnlyReply : RSSynergyReply

@property(nonatomic, assign) NSString   *gift;
@property(nonatomic, assign) NSString   *approved;
@property(nonatomic, assign) NSString   *cardNumber;
@property(nonatomic, assign) NSString   *cardName;
@property(nonatomic, assign) NSString   *clerk;
@property(nonatomic, assign) NSString   *check;
@property(nonatomic, assign) NSString   *saleAmount;
@property(nonatomic, assign) NSString   *balanceUsed;
@property(nonatomic, assign) NSString   *giftCardBalance;
@property(nonatomic, assign) NSString   *pointsBalance;
@property(nonatomic, assign) NSString   *rewardCashBalance;
@property(nonatomic, assign) NSString   *customReceiptMessages;

@end

@interface RSRedeemGiftCardOrRewardReply : RSSynergyReply

@property(nonatomic, assign) NSString   *reward;
@property(nonatomic, assign) NSString   *approved;
@property(nonatomic, assign) NSString   *cardNumber;
@property(nonatomic, assign) NSString   *cardName;
@property(nonatomic, assign) NSString   *clerk;
@property(nonatomic, assign) NSString   *check;
@property(nonatomic, assign) NSString   *saleAmount;
@property(nonatomic, assign) NSString   *rewardUsed;
@property(nonatomic, assign) NSString   *customerOwes;
@property(nonatomic, assign) NSString   *totalPoints;
@property(nonatomic, assign) NSString   *totalSaved;
@property(nonatomic, assign) NSString   *giftCardBalance;
@property(nonatomic, assign) NSString   *totalVisits;
@property(nonatomic, assign) NSString   *rewardCashBalance;
@property(nonatomic, assign) NSString   *rewardBalance;
@property(nonatomic, assign) NSString   *description1;
@property(nonatomic, assign) NSString   *customReceiptMessages;

@end

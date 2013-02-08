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

@interface RSVoidReply : RSSynergyReply

@property(nonatomic, assign) NSString   *voidAmount;
@property(nonatomic, assign) NSString   *approved;
@property(nonatomic, assign) NSString   *cardNumber;
@property(nonatomic, assign) NSString   *transaction;
@property(nonatomic, assign) NSString   *voidedPoints;
@property(nonatomic, assign) NSString   *voidedAmount;
@property(nonatomic, assign) NSString   *giftCardBalance;
@property(nonatomic, assign) NSString   *pointsBalance;
@property(nonatomic, assign) NSString   *rewardCashBalance;
@property(nonatomic, assign) NSString   *totalVisits;

@end

@interface RSMerchantData : NSObject

@property(nonatomic, assign) NSString   *merchantId;
@property(nonatomic, assign) NSString   *salesPerson;
@property(nonatomic, assign) NSString   *businessName;
@property(nonatomic, assign) NSString   *statusId;
@property(nonatomic, assign) NSString   *status;
@property(nonatomic, assign) NSString   *address;
@property(nonatomic, assign) NSString   *locationId;
@property(nonatomic, assign) NSString   *zip;
@property(nonatomic, assign) NSString   *location;
@property(nonatomic, assign) NSString   *neighborhood;
@property(nonatomic, assign) NSString   *categoryId;
@property(nonatomic, assign) NSString   *categoryName;
@property(nonatomic, assign) NSString   *foodType;
@property(nonatomic, assign) NSString   *categoryName2;
@property(nonatomic, assign) NSString   *phone;
@property(nonatomic, assign) NSString   *email;
@property(nonatomic, assign) NSString   *fax;
@property(nonatomic, assign) NSString   *city;
@property(nonatomic, assign) NSString   *webSite;
@property(nonatomic, assign) NSString   *dbaName;
@property(nonatomic, assign) NSString   *state;
@property(nonatomic, assign) NSString   *country;
@property(nonatomic, assign) NSString   *welcomeCredit;
@property(nonatomic, assign) NSString   *localReward;
@property(nonatomic, assign) NSString   *touristReward;
@property(nonatomic, assign) NSString   *createdOn;
@property(nonatomic, assign) NSString   *exported;
@property(nonatomic, assign) NSString   *ausrId;
@property(nonatomic, assign) NSString   *userId;
@property(nonatomic, assign) NSString   *userName;
@property(nonatomic, assign) NSString   *userPassword;
@property(nonatomic, assign) NSString   *userEmail;
@property(nonatomic, assign) NSString   *roleId;
@property(nonatomic, assign) NSString   *roleName;
@property(nonatomic, assign) NSString   *terminalType;

@end

@interface RSGetMerchantRecordsReply : RSSynergyReply

@property(nonatomic, readwrite) BOOL      dataStatus;
@property(nonatomic, assign)    NSArray   *merchantData;

@end

@interface RSMerchantLogoData : NSObject

@property(nonatomic, assign) NSString   *logoId;
@property(nonatomic, assign) NSString   *merchantId;
@property(nonatomic, assign) NSString   *businessName;
@property(nonatomic, assign) NSString   *logoData;
@property(nonatomic, assign) NSString   *webSite;

@end

@interface RSGetMerchantLogosReply : RSSynergyReply

@property(nonatomic, readwrite) BOOL      dataStatus;
@property(nonatomic, assign)    NSArray   *logosData;

@end

@interface RSProgramFAQData : NSObject

@property(nonatomic, assign) NSString   *number;
@property(nonatomic, assign) NSString   *question;
@property(nonatomic, assign) NSString   *answer;

@end

@interface RSGetProgramFAQToSynergyServerReply : RSSynergyReply

@property(nonatomic, assign) NSString  *programName;
@property(nonatomic, assign) NSArray   *faqData;

@end

@interface RSGetTotalSavingsToSynergyServerReply : RSSynergyReply

@property(nonatomic, assign) NSString  *totalSaved;

@end

@interface RSValidateCardNumberToSynergyServerReply : RSSynergyReply
@end

@interface RSGetMerchantRecordsInPagesReply : RSSynergyReply

@property(nonatomic, readwrite) BOOL      dataStatus;
@property(nonatomic, assign)    NSString  *maxNumPages;
@property(nonatomic, assign)    NSString  *rowNum;
@property(nonatomic, assign)    NSString  *iD;
@property(nonatomic, readwrite) BOOL      newMexicoCardFlag;
@property(nonatomic, assign)    NSArray   *merchantData;

@end


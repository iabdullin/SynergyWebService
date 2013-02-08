//
//  RSSynergyWebService.h
//  SynergyWebApp
//
//  Created by Ildar on 2/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum SynergyCardAction
{
    caCardSwiped = 0,
    caCardKeyed

} SynergyCardAction;

typedef enum SynergyAccountType
{
    atCardNumber = 0,
    atPhoneNumber,
    atRefferalNumber

} SynergyAccountType;

typedef enum SynergyMerchantLogoSize
{
    lsOriginalSize = 0,
    lsSmall
    
} SynergyMerchantLogoSize;

typedef enum SynergySearchType
{
    stCardNumber = 0,
    stCellPhone,
    stHomePhone,
    stEmail,
    stClientSurrogate
    
} SynergySearchType;

typedef enum SynergyMartialStatus
{
    msUnknown = 0,
    msSingle,
    msMarried,
    
} SynergyMartialStatus;

typedef enum SynergyGender
{
    sgUnknown = 0,
    sgMale,
    sgFemale,
    
} SynergyGender;

@class RSSynergyRequest;

@interface RSSynergyWebService : NSObject

@property(nonatomic, retain, setter = setUserName:) NSString* userName;
@property(nonatomic, retain, setter = setPassword:) NSString* userPassword;

- (id)initWithUserName:(NSString*)_userName andPassword:(NSString*)_password;

- (RSSynergyRequest*)postRegistration:(NSString*)cardNumber firstName:(NSString*)firstName
                             lastName:(NSString*)lastName address:(NSString*)address
                                 city:(NSString*)city state:(NSString*)state
                              zipCode:(NSString*)zipCode email:(NSString*)email
                            homePhone:(NSString*)homePhone
                           cellNumber:(NSString*)cellNumber birthDate:(NSString*)birthDate
                             password:(NSString*)password receiveEmailFlags:(BOOL)receiveEmailFlags
                 receiveThankYouFlags:(BOOL)receiveThankYouFlags merchantId:(NSString*)merchantId
                           refferalId:(NSString*)refferalId groupNumber:(NSString*)groupNumber
                           terminalId:(NSString*)terminalId streetSavingFlag:(BOOL)streetSavingFlag
                      anniversaryDate:(NSString*)anniversaryDate
                       youGotCashFlag:(BOOL)youGotCashFlag
                      toSynergyServer:(NSString*)toSynergyServer;

- (RSSynergyRequest*)postRegistrationLong:(NSString*)cardNumber firstName:(NSString*)firstName
                                 lastName:(NSString*)lastName address:(NSString*)address
                                     city:(NSString*)city state:(NSString*)state
                                  zipCode:(NSString*)zipCode email:(NSString*)email
                                homePhone:(NSString*)homePhone
                               cellNumber:(NSString*)cellNumber birthDate:(NSString*)birthDate
                                 password:(NSString*)password martialStatus:(SynergyMartialStatus)martialStatus
                                   gender:(SynergyGender)gender country:(NSString*)country
                               occupation:(NSString*)occupation receiveEmailFlags:(BOOL)receiveEmailFlags
                     receiveThankYouFlags:(BOOL)receiveThankYouFlags textMessageFlag:(BOOL)textMessageFlag
                        receiveCouponFlag:(BOOL)receiveCouponFlag
                               merchantId:(NSString*)merchantId refferalId:(NSString*)refferalId
                              groupNumber:(NSString*)groupNumber terminalId:(NSString*)terminalId
                                 serverId:(NSString*)serverId primaryCardNumber:(NSString*)primaryCardNumber
                       primaryPhoneNumber:(NSString*)primaryPhoneNumber
                                 cardType:(NSString*)cardType streetSavingFlag:(BOOL)streetSavingFlag
                          anniversaryDate:(NSString*)anniversaryDate
                           youGotCashFlag:(BOOL)youGotCashFlag toSynergyServer:(NSString*)toSynergyServer;

- (RSSynergyRequest*)postSkoopRegistrationLong:(NSString*)cardNumber firstName:(NSString*)firstName
                                      lastName:(NSString*)lastName address:(NSString*)address
                                          city:(NSString*)city state:(NSString*)state
                                       zipCode:(NSString*)zipCode email:(NSString*)email
                                     homePhone:(NSString*)homePhone
                                    cellNumber:(NSString*)cellNumber birthDate:(NSString*)birthDate
                                      password:(NSString*)password martialStatus:(SynergyMartialStatus)martialStatus
                                        gender:(SynergyGender)gender country:(NSString*)country
                                    occupation:(NSString*)occupation receiveEmailFlags:(BOOL)receiveEmailFlags
                          receiveThankYouFlags:(BOOL)receiveThankYouFlags textMessageFlag:(BOOL)textMessageFlag
                             receiveCouponFlag:(BOOL)receiveCouponFlag
                                    merchantId:(NSString*)merchantId refferalId:(NSString*)refferalId
                                   groupNumber:(NSString*)groupNumber terminalId:(NSString*)terminalId
                                      serverId:(NSString*)serverId primaryCardNumber:(NSString*)primaryCardNumber
                            primaryPhoneNumber:(NSString*)primaryPhoneNumber cardType:(NSString*)cardType
                              streetSavingFlag:(BOOL)streetSavingFlag anniversaryDate:(NSString*)anniversaryDate
                                youGotCashFlag:(BOOL)youGotCashFlag toSynergyServer:(NSString*)toSynergyServer;

- (RSSynergyRequest*)skoopPostRegistration:(NSString*)cardNumber firstName:(NSString*)firstName
                                  lastName:(NSString*)lastName address:(NSString*)address
                                      city:(NSString*)city state:(NSString*)state zipCode:(NSString*)zipCode
                                     email:(NSString*)email homePhone:(NSString*)homePhone
                                 cellNumber:(NSString*)cellNumber birthDate:(NSString*)birthDate
                                  password:(NSString*)password martialStatus:(SynergyMartialStatus)martialStatus
                                    gender:(SynergyGender)gender country:(NSString*)country
                                occupation:(NSString*)occupation receiveEmailFlags:(BOOL)receiveEmailFlags
                      receiveThankYouFlags:(BOOL)receiveThankYouFlags textMessageFlag:(BOOL)textMessageFlag
                         receiveCouponFlag:(BOOL)receiveCouponFlag merchantId:(NSString*)merchantId
                                refferalId:(NSString*)refferalId groupNumber:(NSString*)groupNumber
                                terminalId:(NSString*)terminalId serverId:(NSString*)serverId
                         primaryCardNumber:(NSString*)primaryCardNumber primaryPhoneNumber:(NSString*)primaryPhoneNumber
                                    cardType:(NSString*)cardType streetSavingFlag:(BOOL)streetSavingFlag
                           anniversaryDate:(NSString*)anniversaryDate youGotCashFlag:(BOOL)youGotCashFlag
                               companyName:(NSString*)companyName uniqueId:(int)uniqueId
                               extraFields:(NSArray*)extraFields extraValues:(NSArray*)extraValues;

- (RSSynergyRequest*)postRegistrationSpecial:(NSString*)cardNumber firstName:(NSString*)firstName
                                    lastName:(NSString*)lastName address:(NSString*)address
                                        city:(NSString*)city state:(NSString*)state
                                     zipCode:(NSString*)zipCode email:(NSString*)email
                                   homePhone:(NSString*)homePhone cellNumber:(NSString*)cellNumber
                                   birthDate:(NSString*)birthDate password:(NSString*)password
                               martialStatus:(SynergyMartialStatus)martialStatus gender:(SynergyGender)gender
                                     country:(NSString*)country occupation:(NSString*)occupation
                           receiveEmailFlags:(BOOL)receiveEmailFlags receiveThankYouFlags:(BOOL)receiveThankYouFlags
                             textMessageFlag:(BOOL)textMessageFlag receiveCouponFlag:(BOOL)receiveCouponFlag
                                  merchantId:(NSString*)merchantId refferalId:(NSString*)refferalId
                                 groupNumber:(NSString*)groupNumber terminalId:(NSString*)terminalId
                                    serverId:(NSString*)serverId primaryCardNumber:(NSString*)primaryCardNumber
                          primaryPhoneNumber:(NSString*)primaryPhoneNumber cardType:(NSString*)cardType
                            streetSavingFlag:(BOOL)streetSavingFlag anniversaryDate:(NSString*)anniversaryDate
                              youGotCashFlag:(BOOL)youGotCashFlag companyName:(NSString*)companyName
                                    uniqueId:(int)uniqueId extraFields:(NSArray*)extraFields
                                 extraValues:(NSArray*)extraValues;

- (RSSynergyRequest*)updateRegistrationLong:(NSString*)cardNumber firstName:(NSString*)firstName
                                   lastName:(NSString*)lastName address:(NSString*)address
                                       city:(NSString*)city state:(NSString*)state
                                    zipCode:(NSString*)zipCode email:(NSString*)email
                                  homePhone:(NSString*)homePhone cellNumber:(NSString*)cellNumber
                                  birthDate:(NSString*)birthDate password:(NSString*)password
                              martialStatus:(SynergyMartialStatus)martialStatus
                                     gender:(SynergyGender)gender country:(NSString*)country
                                 occupation:(NSString*)occupation receiveEmailFlags:(BOOL)receiveEmailFlags
                       receiveThankYouFlags:(BOOL)receiveThankYouFlags textMessageFlag:(BOOL)textMessageFlag
                          receiveCouponFlag:(BOOL)receiveCouponFlag merchantId:(NSString*)merchantId
                                 refferalId:(NSString*)refferalId groupNumber:(NSString*)groupNumber
                                 terminalId:(NSString*)terminalId serverId:(NSString*)serverId
                          primaryCardNumber:(NSString*)primaryCardNumber primaryPhoneNumber:(NSString*)primaryPhoneNumber
                                   cardType:(NSString*)cardType streetSavingFlag:(BOOL)streetSavingFlag
                            anniversaryDate:(NSString*)anniversaryDate youGotCashFlag:(BOOL)youGotCashFlag
                        cardHolderSurrogate:(int)cardHolderSurrogate toSynergyServer:(NSString*)toSynergyServer;

- (RSSynergyRequest*)skoopUpdateRegistration:(NSString*)cardNumber firstName:(NSString*)firstName
                                    lastName:(NSString*)lastName address:(NSString*)address
                                        city:(NSString*)city state:(NSString*)state
                                     zipCode:(NSString*)zipCode email:(NSString*)email
                                   homePhone:(NSString*)homePhone cellNumber:(NSString*)cellNumber
                                   birthDate:(NSString*)birthDate password:(NSString*)password
                               martialStatus:(SynergyMartialStatus)martialStatus gender:(SynergyGender)gender
                                     country:(NSString*)country occupation:(NSString*)occupation
                           receiveEmailFlags:(BOOL)receiveEmailFlags receiveThankYouFlags:(BOOL)receiveThankYouFlags
                             textMessageFlag:(BOOL)textMessageFlag receiveCouponFlag:(BOOL)receiveCouponFlag
                                  merchantId:(NSString*)merchantId refferalId:(NSString*)refferalId
                                 groupNumber:(NSString*)groupNumber terminalId:(NSString*)terminalId
                                    serverId:(NSString*)serverId primaryCardNumber:(NSString*)primaryCardNumber
                          primaryPhoneNumber:(NSString*)primaryPhoneNumber cardType:(NSString*)cardType
                            streetSavingFlag:(BOOL)streetSavingFlag anniversaryDate:(NSString*)anniversaryDate
                              youGotCashFlag:(BOOL)youGotCashFlag cardHolderSurrogate:(int)cardHolderSurrogate
                            originalPassword:(NSString*)originalPassword companyName:(NSString*)companyName
                                    uniqueId:(int)uniqueId extraFields:(NSArray*)extraFields
                                 extraValues:(NSArray*)extraValues;

- (RSSynergyRequest*)updateSkoopRegistration:(NSString*)cardNumber firstName:(NSString*)firstName
                                    lastName:(NSString*)lastName address:(NSString*)address
                                        city:(NSString*)city state:(NSString*)state zipCode:(NSString*)zipCode
                                       email:(NSString*)email homePhone:(NSString*)homePhone
                                  cellNumber:(NSString*)cellNumber birthDate:(NSString*)birthDate
                                    password:(NSString*)password martialStatus:(SynergyMartialStatus)martialStatus
                                      gender:(SynergyGender)gender country:(NSString*)country
                                  occupation:(NSString*)occupation receiveEmailFlags:(BOOL)receiveEmailFlags
                        receiveThankYouFlags:(BOOL)receiveThankYouFlags textMessageFlag:(BOOL)textMessageFlag
                           receiveCouponFlag:(BOOL)receiveCouponFlag
                                  merchantId:(NSString*)merchantId refferalId:(NSString*)refferalId
                                 groupNumber:(NSString*)groupNumber terminalId:(NSString*)terminalId
                                    serverId:(NSString*)serverId primaryCardNumber:(NSString*)primaryCardNumber
                          primaryPhoneNumber:(NSString*)primaryPhoneNumber cardType:(NSString*)cardType
                            streetSavingFlag:(BOOL)streetSavingFlag anniversaryDate:(NSString*)anniversaryDate
                              youGotCashFlag:(BOOL)youGotCashFlag cardHolderSurrogate:(NSString*)cardHolderSurrogate
                            originalPassword:(NSString*)originalPassword;

- (RSSynergyRequest*)updateRegistrationSpecial:(NSString*)cardNumber firstName:(NSString*)firstName
                                      lastName:(NSString*)lastName address:(NSString*)address
                                          city:(NSString*)city state:(NSString*)state
                                       zipCode:(NSString*)zipCode email:(NSString*)email
                                     homePhone:(NSString*)homePhone cellNumber:(NSString*)cellNumber
                                     birthDate:(NSString*)birthDate password:(NSString*)password
                                 martialStatus:(SynergyMartialStatus)martialStatus
                                        gender:(SynergyGender)gender country:(NSString*)country
                                    occupation:(NSString*)occupation receiveEmailFlags:(BOOL)receiveEmailFlags
                          receiveThankYouFlags:(BOOL)receiveThankYouFlags textMessageFlag:(BOOL)textMessageFlag
                             receiveCouponFlag:(BOOL)receiveCouponFlag merchantId:(NSString*)merchantId
                                    refferalId:(NSString*)refferalId groupNumber:(NSString*)groupNumber
                                    terminalId:(NSString*)terminalId serverId:(NSString*)serverId
                             primaryCardNumber:(NSString*)primaryCardNumber primaryPhoneNumber:(NSString*)primaryPhoneNumber
                                      cardType:(NSString*)cardType streetSavingFlag:(BOOL)streetSavingFlag
                               anniversaryDate:(NSString*)anniversaryDate youGotCashFlag:(BOOL)youGotCashFlag
                                   companyName:(NSString*)companyName uniqueId:(int)uniqueId
                                   extraFields:(NSArray*)extraFields extraValues:(NSArray*)extraValues
                           cardHolderSurrogate:(NSString*)cardHolderSurrogate toSynergyServer:(NSString*)toSynergyServer;

- (RSSynergyRequest*)addPoints:(NSString*)merchantRockCommID customerCardNumber:(NSString*)customerCardNumber numPoints:(int)numPoints
                    cardAction:(SynergyCardAction)cardActionc clerkID:(NSString*)clerkID checkNumber:(NSString*)checkNumber accountType:(SynergyAccountType)accountType
                    surveyFlag:(BOOL)surveyFlag toSynergyServer:(NSString*)toSynergyServer;

- (RSSynergyRequest*)balanceInquiry:(NSString*)merchantRockCommID customerCardNumber:(NSString*)customerCardNumber
                          numPoints:(int)numPoints cardAction:(SynergyCardAction)cardAction
                            clerkID:(NSString*)clerkID checkNumber:(NSString*)checkNumber
                        accountType:(SynergyAccountType)accountType;

- (RSSynergyRequest*)balanceInquiryWithNetwork:(NSString*)cardNumber networkId:(NSString*)networkId
                         synergyServerLocation:(NSString*)synergyServerLocation;

- (RSSynergyRequest*)balanceInquiryWithoutMerchant:(NSString*)cardNumber synergyServerLocation:(NSString*)synergyServerLocation;

- (RSSynergyRequest*)deductPoints:(NSString*)merchantRockCommID customerCardNumber:(NSString*)customerCardNumber numPoints:(int)numPoints
                       cardAction:(SynergyCardAction)cardAction clerkID:(NSString*)clerkID checkNumber:(NSString*)checkNumber accountType:(SynergyAccountType)accountType;

- (RSSynergyRequest*)loadActivateGiftCard:(NSString*)merchantRockCommID customerCardNumber:(NSString*)customerCardNumber
                                numPoints:(int)numPoints cardAction:(SynergyCardAction)cardAction
                                  clerkID:(NSString*)clerkID checkNumber:(NSString*)checkNumber
                              accountType:(SynergyAccountType)accountType;

- (RSSynergyRequest*)loadRewardCardMoney:(NSString*)merchantRockCommID customerCardNumber:(NSString*)customerCardNumber
                               numPoints:(int)numPoints cardAction:(SynergyCardAction)cardAction
                                 clerkID:(NSString*)clerkID checkNumber:(NSString*)checkNumber
                             accountType:(SynergyAccountType)accountType;


- (RSSynergyRequest*)redeemGiftCardOnly:(NSString*)merchantRockCommID customerCardNumber:(NSString*)customerCardNumber
                              numPoints:(int)numPoints cardAction:(SynergyCardAction)cardAction
                                clerkID:(NSString*)clerkID checkNumber:(NSString*)checkNumber
                            accountType:(SynergyAccountType)accountType;

- (RSSynergyRequest*)redeemGiftCardOrReward:(NSString*)merchantRockCommID customerCardNumber:(NSString*)customerCardNumber
                                  numPoints:(int)numPoints cardAction:(SynergyCardAction)cardAction
                                    clerkID:(NSString*)clerkID checkNumber:(NSString*)checkNumber
                                accountType:(SynergyAccountType)accountType;

- (RSSynergyRequest*)voidTransaction:(NSString*)merchantRockCommID customerCardNumber:(NSString*)customerCardNumber
                             authNum:(int)authNum cardAction:(SynergyCardAction)cardAction
                             clerkID:(NSString*)clerkID checkNumber:(NSString*)checkNumber
                         accountType:(SynergyAccountType)accountType;

- (RSSynergyRequest*)getMerchantRecords:(NSArray*)cards;

- (RSSynergyRequest*)getMerchantLogos:(NSString*)merchantDbaName merchantLogoSize:(SynergyMerchantLogoSize)merchantLogoSize
                          maxNumLogos:(int)maxNumLogos;

- (RSSynergyRequest*)getProgramFAQToSynergyServer:(NSString*)programName synergyServerLocation:(NSString*)synergyServerLocation;

- (RSSynergyRequest*)getTotalSavingsToSynergyServer:(NSString*)customerCardNumber cardAction:(SynergyCardAction)cardAction
                              synergyServerLocation:(NSString*)synergyServerLocation;

- (RSSynergyRequest*)validateCardNumberToSynergyServer:(NSString*)customerCardNumber synergyServerLocation:(NSString*)synergyServerLocation;

- (RSSynergyRequest*)getMerchantRecordsInPage:(NSArray*)cards pageNumbers:(NSArray*)pageNumbers;

- (RSSynergyRequest*)pushServiceToSynergyServer:(NSString*)deviceToken pushNewMerchant:(int)pushNewMerchant
                                    pushSynergy:(int)pushSynergy programName:(NSString*)programName
                                   customerName:(NSString*)customerName zipCode:(NSString*)zipCode
                          synergyServerLocation:(NSString*)synergyServerLocation;

- (RSSynergyRequest*)getiPhoneDeviceMessages:(NSString*)programName deviceToken:(NSString*)deviceToken
                       synergyServerLocation:(NSString*)synergyServerLocation;

- (RSSynergyRequest*)deactivateiPhoneMessage:(NSString*)deviceToken iPhoneMessageId:(int)iPhoneMessageId
                       synergyServerLocation:(NSString*)synergyServerLocation;

- (RSSynergyRequest*)getRegistrationInfo:(NSString*)groupNumber searchBy:(SynergySearchType)searchBy
                             searchValue:(NSString*)searchValue password:(NSString*)password
                   synergyServerLocation:(NSString*)synergyServerLocation;

- (RSSynergyRequest*)checkRegistrationAccount:(NSString*)groupNumber email:(NSString*)email
                                   cellNumber:(NSString*)cellNumber cardNumber:(NSString*)cardNumber
                        synergyServerLocation:(NSString*)synergyServerLocation;


@end

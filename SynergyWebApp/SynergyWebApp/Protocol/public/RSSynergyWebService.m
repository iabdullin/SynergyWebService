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
#import "RSSynergyRequest.h"

#define ServiceUrl     @"http://www.synergywebservice.com/SynergyWebX.asmx"
#define SynergyXmlns   @"http://tempuri.org/"
#define ResponseFormat @"Xml"
#define LoggingEnabled YES

#define SoapMethodPostRegistration                          @"PostRegistration"
#define SoapMethodPostRegistrationToSynergyServer           @"PostRegistrationToSynergyServer"
#define SoapMethodPostRegistrationLong                      @"PostRegistrationLong"
#define SoapMethodPostRegistrationLongToSynergyServer       @"PostRegistrationLongToSynergyServer"
#define SoapMethodPostSkoopRegistrationLong                 @"PostSkoopRegistrationLong"
#define SoapMethodPostSkoopRegistrationLongToSynergyServer  @"PostSkoopRegistrationLongToSynergyServer"
#define SoapMethodSkoopPostRegistration                     @"SkoopPostRegistration"
#define SoapMethodPostRegistrationSpecial                   @"PostRegistrationSpecial"
#define SoapMethodUpdateRegistrationLongToSynergyServer     @"UpdateRegistrationLongToSynergyServer"
#define SoapMethodUpdateSkoopRegistration                   @"UpdateSkoopRegistration"
#define SoapMethodUpdateRegistrationSpecial                 @"UpdateRegistrationSpecial"
#define SoapMethodSkoopUpdateRegistration                   @"SkoopUpdateRegistration"
#define SoapMethodAddPoints                                 @"AddPoints"
#define SoapMethodAddPointsToSynergyServer                  @"AddPointsToSynergyServer"
#define SoapMethodBalanceInquiry                            @"BalanceInquiry"
#define SoapMethodBalanceInquiryWithNetwork                 @"BalanceInquiryWithNetwork"
#define SoapMethodBalanceInquiryWithoutMerchant             @"BalanceInquiryWithoutMerchant"
#define SoapMethodDeductPoints                              @"DeductPoints"
#define SoapMethodLoadActivateGiftCard                      @"LoadActivateGiftCard"
#define SoapMethodLoadRewardCardMoney                       @"LoadRewardCardMoney"
#define SoapMethodRedeemGiftCardOnly                        @"RedeemGiftCardOnly"
#define SoapMethodRedeemGiftCardOrReward                    @"RedeemGiftCardOrReward"
#define SoapMethodVoid                                      @"Void"
#define SoapMethodGetMerchantRecords                        @"GetMerchantRecords"
#define SoapMethodGetMerchantLogos                          @"GetMerchantLogos"
#define SoapMethodGetProgramFAQToSynergyServer              @"GetProgramFAQToSynergyServer"
#define SoapMethodGetTotalSavingsToSynergyServer            @"GetTotalSavingsToSynergyServer"
#define SoapMethodValidateCardNumberToSynergyServer         @"ValidateCardNumberToSynergyServer"
#define SoapMethodPushServiceToSynergyServer                @"PushServiceToSynergyServer"
#define SoapMethodGetMerchantRecordsInPage                  @"GetMerchantRecordsInPage"
#define SoapMethodGetIPhoneDeviceMessages                   @"GetIPhoneDevicesMessages"
#define SoapMethodDeactivateIPhoneMessage                   @"DeactivateIPhoneMessage"
#define SoapMethodGetRegistrationInfo                       @"GetRegistrationInfo"
#define SoapMethodCheckRegistrationAccount                  @"CheckRegistrationAccount"

@interface Soap(Custom)

+ (NSString*)createCustomEnvelope:(NSString*)method forNamespace:(NSString*)ns containing:(NSArray*)containing withHeaders:(NSDictionary*)headers;

@end

@implementation Soap(Custom)

+ (NSString*)createCustomEnvelope:(NSString*)method forNamespace:(NSString*) ns containing:(NSArray*)containing withHeaders: (NSDictionary*)headers
{
	NSMutableString* s = [[[NSMutableString alloc] initWithString: @""] autorelease];
	for(int i = 0; i < [containing count] - 1; i+=2)
    {
        [s appendFormat: @"<%@>%@</%@>", [containing objectAtIndex:i], [Soap serialize:[containing objectAtIndex:i+1]], [containing objectAtIndex:i]];
	}

	NSString* envelope = [Soap createEnvelope: method forNamespace: ns forParameters: s withHeaders: headers];
	return envelope;
}

@end

@interface RSSynergyRequest(Init)

- (id)initWithHandler:(RSWebServiceHandler*)handler;

@end

@implementation RSSynergyRequest(Init)

- (id)initWithHandler:(RSWebServiceHandler*)handler
{
    self = [super init];
    if (self != nil)
    {
        _internal = [handler retain];
    }

    return self;
}

@end

@interface RSSynergyWebService()

@property(nonatomic, assign) SoapService *soapService;

- (void)generateHeader;

- (NSMutableArray*)generateRegistrationCommonData:(BOOL)isLongRequest
                                       cardNumber:(NSString*)cardNumber
                                        firstName:(NSString*)firstName
                                         lastName:(NSString*)lastName
                                          address:(NSString*)address city:(NSString*)city
                                            state:(NSString*)state
                                          zipCode:(NSString*)zipCode
                                            email:(NSString*)email homePhone:(NSString*)homePhone
                                       cellNumber:(NSString*)cellNumber birthDate:(NSString*)birthDate
                                         password:(NSString*)password
                                    martialStatus:(SynergyMartialStatus)martialStatus
                                           gender:(SynergyGender)gender country:(NSString*)country
                                       occupation:(NSString*)occupation
                                receiveEmailFlags:(BOOL)receiveEmailFlags
                             receiveThankYouFlags:(BOOL)receiveThankYouFlags textMessageFlag:(BOOL)textMessageFlag
                                receiveCouponFlag:(BOOL)receiveCouponFlag
                                       merchantId:(NSString*)merchantId refferalId:(NSString*)refferalId
                                      groupNumber:(NSString*)groupNumber
                                       terminalId:(NSString*)terminalId
                                         serverId:(NSString*)serverId primaryCardNumber:(NSString*)primaryCardNumber
                               primaryPhoneNumber:(NSString*)primaryPhoneNumber
                                         cardType:(NSString*)cardType streetSavingFlag:(BOOL)streetSavingFlag
                                  anniversaryDate:(NSString*)anniversaryDate
                                   youGotCashFlag:(BOOL)youGotCashFlag;

- (NSMutableArray*)generateCardManagementCommonData:(NSString*)merchantRockCommID customerCardNumber:(NSString*)customerCardNumber
                                          numPoints:(int)numPoints
                                         cardAction:(SynergyCardAction)cardAction clerkID:(NSString*)clerkID
                                        checkNumber:(NSString*)checkNumber
                                        accountType:(SynergyAccountType)accountType;

- (RSSynergyRequest*)generateRequestWithSoapMethod:(NSString*)soapMethod body:(NSArray*)body andReplyType:(SynergyReplyType)replyType;

- (NSString*)convertCardAction:(SynergyCardAction)action;

- (NSString*)convertAccontType:(SynergyAccountType)type;

- (NSString*)convertSearchBy:(SynergySearchType)type;

- (NSString*)convertLogoSize:(SynergyMerchantLogoSize)size;

- (NSString*)convertMartialStatus:(SynergyMartialStatus)status;

- (NSString*)convertGender:(SynergyGender)gender;

- (RSSynergyRequest*)generateRequestWithSoapMethod:(NSString*)soapMethod body:(NSArray*)body andReplyType:(SynergyReplyType)replyType;

@end

@implementation RSSynergyWebService

@synthesize userName, userPassword, soapService;

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
    [super dealloc];
}

- (void)setUserName:(NSString*)_userName
{
    [userName release];
    userName = [_userName retain];
    [self generateHeader];
}

- (void)setPassword:(NSString*)_password
{
    [userPassword release];
    userPassword = [_password retain];
    [self generateHeader];
}

- (void)generateHeader
{
    NSDictionary *credentialNodes = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"userName", userPassword, @"password",nil];
    self.soapService.headers = [NSDictionary dictionaryWithObjectsAndKeys:credentialNodes, @"UserCredentials", nil];
}

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
                      toSynergyServer:(NSString*)toSynergyServer
{
    NSMutableArray *bodyEnvelope = [self generateRegistrationCommonData:NO cardNumber:cardNumber
                                                              firstName:firstName lastName:lastName
                                                                address:address city:city
                                                                  state:state zipCode:zipCode
                                                                  email:email homePhone:homePhone
                                                             cellNumber:cellNumber birthDate:birthDate password:password
                                                          martialStatus:msUnknown gender:sgUnknown
                                                                country:nil occupation:nil
                                                      receiveEmailFlags:receiveEmailFlags receiveThankYouFlags:receiveThankYouFlags
                                                        textMessageFlag:NO receiveCouponFlag:NO merchantId:merchantId
                                                             refferalId:refferalId groupNumber:groupNumber terminalId:terminalId
                                                               serverId:nil primaryCardNumber:nil primaryPhoneNumber:nil
                                                               cardType:nil streetSavingFlag:streetSavingFlag
                                                        anniversaryDate:anniversaryDate youGotCashFlag:youGotCashFlag];
    if (bodyEnvelope == nil)
    {
        return nil;
    }

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];

    NSString *soapMethod = nil;
    if (toSynergyServer != nil)
    {
        [bodyEnvelope addObject:@"SynergyServerLocation"];
        [bodyEnvelope addObject:toSynergyServer];
        soapMethod = SoapMethodPostRegistrationToSynergyServer;
    }
    else
    {
        soapMethod = SoapMethodPostRegistration;
    }

    return [self generateRequestWithSoapMethod:soapMethod body:bodyEnvelope andReplyType:rtPostRegistrationReply];
}

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
                           youGotCashFlag:(BOOL)youGotCashFlag toSynergyServer:(NSString*)toSynergyServer
{
    NSMutableArray *bodyEnvelope = [self generateRegistrationCommonData:YES cardNumber:cardNumber
                                                              firstName:firstName lastName:lastName
                                                                address:address city:city
                                                                  state:state zipCode:zipCode
                                                                  email:email homePhone:homePhone
                                                             cellNumber:cellNumber birthDate:birthDate password:password
                                                          martialStatus:martialStatus gender:gender
                                                                country:country occupation:occupation
                                                      receiveEmailFlags:receiveEmailFlags receiveThankYouFlags:receiveThankYouFlags
                                                        textMessageFlag:textMessageFlag receiveCouponFlag:receiveCouponFlag
                                                             merchantId:merchantId refferalId:refferalId
                                                            groupNumber:groupNumber terminalId:terminalId
                                                               serverId:serverId primaryCardNumber:primaryCardNumber
                                                     primaryPhoneNumber:primaryPhoneNumber cardType:cardType
                                                       streetSavingFlag:streetSavingFlag anniversaryDate:anniversaryDate
                                                         youGotCashFlag:youGotCashFlag];
    if (bodyEnvelope == nil)
    {
        return nil;
    }

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];

    NSString *soapMethod = nil;
    if (toSynergyServer != nil)
    {
        [bodyEnvelope addObject:@"SynergyServerLocation"];
        [bodyEnvelope addObject:toSynergyServer];
        soapMethod = SoapMethodPostRegistrationLongToSynergyServer;
    }
    else
    {
        soapMethod = SoapMethodPostRegistrationLong;
    }

    return [self generateRequestWithSoapMethod:soapMethod body:bodyEnvelope andReplyType:rtPostRegistrationLongReply];
}

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
                                youGotCashFlag:(BOOL)youGotCashFlag toSynergyServer:(NSString*)toSynergyServer
{
    NSMutableArray *bodyEnvelope = [self generateRegistrationCommonData:YES cardNumber:cardNumber
                                                              firstName:firstName lastName:lastName
                                                                address:address city:city
                                                                  state:state zipCode:zipCode
                                                                  email:email homePhone:homePhone
                                                             cellNumber:cellNumber birthDate:birthDate password:password
                                                          martialStatus:martialStatus gender:gender
                                                                country:country occupation:occupation
                                                      receiveEmailFlags:receiveEmailFlags receiveThankYouFlags:receiveThankYouFlags
                                                        textMessageFlag:textMessageFlag receiveCouponFlag:receiveCouponFlag
                                                             merchantId:merchantId refferalId:refferalId
                                                            groupNumber:groupNumber terminalId:terminalId
                                                               serverId:serverId primaryCardNumber:primaryCardNumber
                                                     primaryPhoneNumber:primaryPhoneNumber cardType:cardType
                                                       streetSavingFlag:streetSavingFlag anniversaryDate:anniversaryDate
                                                         youGotCashFlag:youGotCashFlag];
    if (bodyEnvelope == nil)
    {
        return nil;
    }

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];
    
    NSString *soapMethod = nil;
    if (toSynergyServer != nil)
    {
        [bodyEnvelope addObject:@"SynergyServerLocation"];
        [bodyEnvelope addObject:toSynergyServer];
        soapMethod = SoapMethodPostSkoopRegistrationLongToSynergyServer;
    }
    else
    {
        soapMethod = SoapMethodPostSkoopRegistrationLong;
    }
    
    return [self generateRequestWithSoapMethod:soapMethod body:bodyEnvelope andReplyType:rtPostSkoopRegistrationLongReply];
}

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
                               extraFields:(NSArray*)extraFields extraValues:(NSArray*)extraValues
{
    NSMutableArray *bodyEnvelope = [self generateRegistrationCommonData:YES cardNumber:cardNumber
                                                              firstName:firstName lastName:lastName
                                                                address:address city:city
                                                                  state:state zipCode:zipCode
                                                                  email:email homePhone:homePhone
                                                             cellNumber:cellNumber birthDate:birthDate password:password
                                                          martialStatus:martialStatus gender:gender
                                                                country:country occupation:occupation
                                                      receiveEmailFlags:receiveEmailFlags receiveThankYouFlags:receiveThankYouFlags
                                                        textMessageFlag:textMessageFlag receiveCouponFlag:receiveCouponFlag
                                                             merchantId:merchantId refferalId:refferalId
                                                            groupNumber:groupNumber terminalId:terminalId
                                                               serverId:serverId primaryCardNumber:primaryCardNumber
                                                     primaryPhoneNumber:primaryPhoneNumber cardType:cardType
                                                       streetSavingFlag:streetSavingFlag anniversaryDate:anniversaryDate
                                                         youGotCashFlag:youGotCashFlag];
    if (bodyEnvelope == nil)
    {
        return nil;
    }

    if (companyName)
    {
        [bodyEnvelope addObject:@"CompanyName"];
        [bodyEnvelope addObject:companyName];
    }

    NSString *uniqueIdStr = [NSString stringWithFormat:@"%d", uniqueId];
    if (uniqueIdStr && [uniqueIdStr length] > 5)
    {
        return nil;
    }
    [bodyEnvelope addObject:@"UniqueID"];
    [bodyEnvelope addObject:uniqueIdStr];

    if (extraFields && [extraFields count] > 0)
    {
        NSMutableString *result = [[NSMutableString alloc] initWithString:[extraFields objectAtIndex:0]];
        if ([extraFields count] > 1)
        {
            for (int i = 1; i < [extraFields count]; ++i)
            {
                [result appendFormat:@"^%@", [extraFields objectAtIndex:i]];
            }
        }
        [bodyEnvelope addObject:@"CaretSeparatedExtraFields"];
        [bodyEnvelope addObject:result];
        [result release];
    }

    if (extraValues && [extraValues count] > 0)
    {
        NSMutableString *result = [[NSMutableString alloc] initWithString:[extraValues objectAtIndex:0]];
        if ([extraValues count] > 1)
        {
            for (int i = 1; i < [extraValues count]; ++i)
            {
                [result appendFormat:@"^%@", [extraValues objectAtIndex:i]];
            }
        }
        [bodyEnvelope addObject:@"CaretSeparatedExtraValues"];
        [bodyEnvelope addObject:result];
        [result release];
    }

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];

    return [self generateRequestWithSoapMethod:SoapMethodSkoopPostRegistration body:bodyEnvelope andReplyType:rtSkoopPostRegistrationReply];
}

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
                                 extraValues:(NSArray*)extraValues
{
    NSMutableArray *bodyEnvelope = [self generateRegistrationCommonData:YES cardNumber:cardNumber
                                                              firstName:firstName lastName:lastName
                                                                address:address city:city
                                                                  state:state zipCode:zipCode
                                                                  email:email homePhone:homePhone
                                                             cellNumber:cellNumber birthDate:birthDate password:password
                                                          martialStatus:martialStatus gender:gender
                                                                country:country occupation:occupation
                                                      receiveEmailFlags:receiveEmailFlags receiveThankYouFlags:receiveThankYouFlags
                                                        textMessageFlag:textMessageFlag receiveCouponFlag:receiveCouponFlag
                                                             merchantId:merchantId refferalId:refferalId
                                                            groupNumber:groupNumber terminalId:terminalId
                                                               serverId:serverId primaryCardNumber:primaryCardNumber
                                                     primaryPhoneNumber:primaryPhoneNumber cardType:cardType
                                                       streetSavingFlag:streetSavingFlag anniversaryDate:anniversaryDate
                                                         youGotCashFlag:youGotCashFlag];
    if (bodyEnvelope == nil)
    {
        return nil;
    }

    if (companyName)
    {
        [bodyEnvelope addObject:@"CompanyName"];
        [bodyEnvelope addObject:companyName];
    }
    
    NSString *uniqueIdStr = [NSString stringWithFormat:@"%d", uniqueId];
    if (uniqueIdStr && [uniqueIdStr length] > 5)
    {
        return nil;
    }
    [bodyEnvelope addObject:@"UniqueID"];
    [bodyEnvelope addObject:uniqueIdStr];
    
    if (extraFields && [extraFields count] > 0)
    {
        NSMutableString *result = [[NSMutableString alloc] initWithString:[extraFields objectAtIndex:0]];
        if ([extraFields count] > 1)
        {
            for (int i = 1; i < [extraFields count]; ++i)
            {
                [result appendFormat:@"^%@", [extraFields objectAtIndex:i]];
            }
        }
        [bodyEnvelope addObject:@"CaretSeparatedExtraFields"];
        [bodyEnvelope addObject:result];
        [result release];
    }
    
    if (extraValues && [extraValues count] > 0)
    {
        NSMutableString *result = [[NSMutableString alloc] initWithString:[extraValues objectAtIndex:0]];
        if ([extraValues count] > 1)
        {
            for (int i = 1; i < [extraValues count]; ++i)
            {
                [result appendFormat:@"^%@", [extraValues objectAtIndex:i]];
            }
        }
        [bodyEnvelope addObject:@"CaretSeparatedExtraValues"];
        [bodyEnvelope addObject:result];
        [result release];
    }

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];

    return [self generateRequestWithSoapMethod:SoapMethodPostRegistrationSpecial body:bodyEnvelope andReplyType:rtPostRegistrationSpecialReply];
}

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
                        cardHolderSurrogate:(int)cardHolderSurrogate toSynergyServer:(NSString*)toSynergyServer
{
    NSMutableArray *bodyEnvelope = [self generateRegistrationCommonData:YES cardNumber:cardNumber
                                                              firstName:firstName lastName:lastName
                                                                address:address city:city
                                                                  state:state zipCode:zipCode
                                                                  email:email homePhone:homePhone
                                                             cellNumber:cellNumber birthDate:birthDate password:password
                                                          martialStatus:martialStatus gender:gender
                                                                country:country occupation:occupation
                                                      receiveEmailFlags:receiveEmailFlags receiveThankYouFlags:receiveThankYouFlags
                                                        textMessageFlag:textMessageFlag receiveCouponFlag:receiveCouponFlag
                                                             merchantId:merchantId refferalId:refferalId
                                                            groupNumber:groupNumber terminalId:terminalId
                                                               serverId:serverId primaryCardNumber:primaryCardNumber
                                                     primaryPhoneNumber:primaryPhoneNumber cardType:cardType
                                                       streetSavingFlag:streetSavingFlag anniversaryDate:anniversaryDate
                                                         youGotCashFlag:youGotCashFlag];
    if (bodyEnvelope == nil)
    {
        return nil;
    }

    NSString *cardHolderSurrogateStr = [NSString stringWithFormat:@"%d", cardHolderSurrogate];
    if (cardHolderSurrogateStr && [cardHolderSurrogateStr length] > 20)
    {
        return nil;
    }
    [bodyEnvelope addObject:@"CardholderSurrogate"];
    [bodyEnvelope addObject:cardHolderSurrogateStr];

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];

    if (toSynergyServer != nil)
    {
        [bodyEnvelope addObject:@"SynergyServerLocation"];
        [bodyEnvelope addObject:toSynergyServer];
    }

    return [self generateRequestWithSoapMethod:SoapMethodUpdateRegistrationLongToSynergyServer body:bodyEnvelope andReplyType:rtUpdateRegistrationLongReply];
}

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
                                 extraValues:(NSArray*)extraValues
{
    NSMutableArray *bodyEnvelope = [self generateRegistrationCommonData:YES cardNumber:cardNumber
                                                              firstName:firstName lastName:lastName
                                                                address:address city:city
                                                                  state:state zipCode:zipCode
                                                                  email:email homePhone:homePhone
                                                             cellNumber:cellNumber birthDate:birthDate password:password
                                                          martialStatus:martialStatus gender:gender
                                                                country:country occupation:occupation
                                                      receiveEmailFlags:receiveEmailFlags receiveThankYouFlags:receiveThankYouFlags
                                                        textMessageFlag:textMessageFlag receiveCouponFlag:receiveCouponFlag
                                                             merchantId:merchantId refferalId:refferalId
                                                            groupNumber:groupNumber terminalId:terminalId
                                                               serverId:serverId primaryCardNumber:primaryCardNumber
                                                     primaryPhoneNumber:primaryPhoneNumber cardType:cardType
                                                       streetSavingFlag:streetSavingFlag anniversaryDate:anniversaryDate
                                                         youGotCashFlag:youGotCashFlag];
    if (bodyEnvelope == nil)
    {
        return nil;
    }

    NSString *cardHolderSurrogateStr = [NSString stringWithFormat:@"%d", cardHolderSurrogate];
    if (cardHolderSurrogateStr && [cardHolderSurrogateStr length] > 20)
    {
        return nil;
    }
    [bodyEnvelope addObject:@"CardholderSurrogate"];
    [bodyEnvelope addObject:cardHolderSurrogateStr];

    if (originalPassword)
    {
        [bodyEnvelope addObject:@"OriginalPassword"];
        [bodyEnvelope addObject:originalPassword];
    }

    if (companyName)
    {
        [bodyEnvelope addObject:@"CompanyName"];
        [bodyEnvelope addObject:companyName];
    }
    
    NSString *uniqueIdStr = [NSString stringWithFormat:@"%d", uniqueId];
    if (uniqueIdStr && [uniqueIdStr length] > 5)
    {
        return nil;
    }
    [bodyEnvelope addObject:@"UniqueID"];
    [bodyEnvelope addObject:uniqueIdStr];
    
    if (extraFields && [extraFields count] > 0)
    {
        NSMutableString *result = [[NSMutableString alloc] initWithString:[extraFields objectAtIndex:0]];
        if ([extraFields count] > 1)
        {
            for (int i = 1; i < [extraFields count]; ++i)
            {
                [result appendFormat:@"^%@", [extraFields objectAtIndex:i]];
            }
        }
        [bodyEnvelope addObject:@"CaretSeparatedExtraFields"];
        [bodyEnvelope addObject:result];
        [result release];
    }

    if (extraValues && [extraValues count] > 0)
    {
        NSMutableString *result = [[NSMutableString alloc] initWithString:[extraValues objectAtIndex:0]];
        if ([extraValues count] > 1)
        {
            for (int i = 1; i < [extraValues count]; ++i)
            {
                [result appendFormat:@"^%@", [extraValues objectAtIndex:i]];
            }
        }
        [bodyEnvelope addObject:@"CaretSeparatedExtraValues"];
        [bodyEnvelope addObject:result];
        [result release];
    }

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];

    return [self generateRequestWithSoapMethod:SoapMethodSkoopUpdateRegistration body:bodyEnvelope andReplyType:rtSkoopUpdateRegistrationReply];
}

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
                              youGotCashFlag:(BOOL)youGotCashFlag cardHolderSurrogate:(int)cardHolderSurrogate
                            originalPassword:(NSString*)originalPassword
{
    NSMutableArray *bodyEnvelope = [self generateRegistrationCommonData:YES cardNumber:cardNumber
                                                              firstName:firstName lastName:lastName
                                                                address:address city:city
                                                                  state:state zipCode:zipCode
                                                                  email:email homePhone:homePhone
                                                             cellNumber:cellNumber birthDate:birthDate password:password
                                                          martialStatus:martialStatus gender:gender
                                                                country:country occupation:occupation
                                                      receiveEmailFlags:receiveEmailFlags receiveThankYouFlags:receiveThankYouFlags
                                                        textMessageFlag:textMessageFlag receiveCouponFlag:receiveCouponFlag
                                                             merchantId:merchantId refferalId:refferalId
                                                            groupNumber:groupNumber terminalId:terminalId
                                                               serverId:serverId primaryCardNumber:primaryCardNumber
                                                     primaryPhoneNumber:primaryPhoneNumber cardType:cardType
                                                       streetSavingFlag:streetSavingFlag anniversaryDate:anniversaryDate
                                                         youGotCashFlag:youGotCashFlag];
    if (bodyEnvelope == nil)
    {
        return nil;
    }

    NSString *cardHolderSurrogateStr = [NSString stringWithFormat:@"%d", cardHolderSurrogate];
    if (cardHolderSurrogateStr && [cardHolderSurrogateStr length] > 20)
    {
        return nil;
    }
    [bodyEnvelope addObject:@"CardholderSurrogate"];
    [bodyEnvelope addObject:cardHolderSurrogateStr];
    
    if (originalPassword)
    {
        [bodyEnvelope addObject:@"OriginalPassword"];
        [bodyEnvelope addObject:originalPassword];
    }

    return [self generateRequestWithSoapMethod:SoapMethodUpdateSkoopRegistration body:bodyEnvelope andReplyType:rtUpdateSkoopRegistrationReply];
}

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
                           cardHolderSurrogate:(int)cardHolderSurrogate toSynergyServer:(NSString*)toSynergyServer
{
    NSMutableArray *bodyEnvelope = [self generateRegistrationCommonData:YES cardNumber:cardNumber
                                                              firstName:firstName lastName:lastName
                                                                address:address city:city
                                                                  state:state zipCode:zipCode
                                                                  email:email homePhone:homePhone
                                                             cellNumber:cellNumber birthDate:birthDate password:password
                                                          martialStatus:martialStatus gender:gender
                                                                country:country occupation:occupation
                                                      receiveEmailFlags:receiveEmailFlags receiveThankYouFlags:receiveThankYouFlags
                                                        textMessageFlag:textMessageFlag receiveCouponFlag:receiveCouponFlag
                                                             merchantId:merchantId refferalId:refferalId
                                                            groupNumber:groupNumber terminalId:terminalId
                                                               serverId:serverId primaryCardNumber:primaryCardNumber
                                                     primaryPhoneNumber:primaryPhoneNumber cardType:cardType
                                                       streetSavingFlag:streetSavingFlag anniversaryDate:anniversaryDate
                                                         youGotCashFlag:youGotCashFlag];
    if (bodyEnvelope == nil)
    {
        return nil;
    }
    
    if (companyName)
    {
        [bodyEnvelope addObject:@"CompanyName"];
        [bodyEnvelope addObject:companyName];
    }
    
    NSString *uniqueIdStr = [NSString stringWithFormat:@"%d", uniqueId];
    if (uniqueIdStr && [uniqueIdStr length] > 5)
    {
        return nil;
    }
    [bodyEnvelope addObject:@"UniqueID"];
    [bodyEnvelope addObject:uniqueIdStr];
    
    if (extraFields && [extraFields count] > 0)
    {
        NSMutableString *result = [[NSMutableString alloc] initWithString:[extraFields objectAtIndex:0]];
        if ([extraFields count] > 1)
        {
            for (int i = 1; i < [extraFields count]; ++i)
            {
                [result appendFormat:@"^%@", [extraFields objectAtIndex:i]];
            }
        }
        [bodyEnvelope addObject:@"CaretSeparatedExtraFields"];
        [bodyEnvelope addObject:result];
        [result release];
    }
    
    if (extraValues && [extraValues count] > 0)
    {
        NSMutableString *result = [[NSMutableString alloc] initWithString:[extraValues objectAtIndex:0]];
        if ([extraValues count] > 1)
        {
            for (int i = 1; i < [extraValues count]; ++i)
            {
                [result appendFormat:@"^%@", [extraValues objectAtIndex:i]];
            }
        }
        [bodyEnvelope addObject:@"CaretSeparatedExtraValues"];
        [bodyEnvelope addObject:result];
        [result release];
    }

    NSString *cardHolderSurrogateStr = [NSString stringWithFormat:@"%d", cardHolderSurrogate];
    if (cardHolderSurrogateStr && [cardHolderSurrogateStr length] > 20)
    {
        return nil;
    }
    [bodyEnvelope addObject:@"CardholderSurrogate"];
    [bodyEnvelope addObject:cardHolderSurrogateStr];
    
    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];

    if (toSynergyServer != nil)
    {
        [bodyEnvelope addObject:@"SynergyServerLocation"];
        [bodyEnvelope addObject:toSynergyServer];
    }

    return [self generateRequestWithSoapMethod:SoapMethodUpdateRegistrationSpecial body:bodyEnvelope andReplyType:rtUpdateUpdateRegistrationSpecialReply];
}

- (RSSynergyRequest*)addPoints:(NSString*)merchantRockCommID customerCardNumber:(NSString*)customerCardNumber numPoints:(int)numPoints
                    cardAction:(SynergyCardAction)cardAction clerkID:(NSString*)clerkID checkNumber:(NSString*)checkNumber accountType:(SynergyAccountType)accountType
                    surveyFlag:(BOOL)surveyFlag toSynergyServer:(NSString*)toSynergyServer
{
    NSMutableArray *bodyEnvelope = [self generateCardManagementCommonData:merchantRockCommID customerCardNumber:customerCardNumber numPoints:numPoints
                                                               cardAction:cardAction clerkID:clerkID checkNumber:checkNumber accountType:accountType];
    if (bodyEnvelope == nil)
    {
        return nil;
    }

    NSString *surveyFlagStr = surveyFlag ? @"true" : @"false";
    [bodyEnvelope addObject:@"SurveyFlag"];
    [bodyEnvelope addObject:surveyFlagStr];

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];

    NSString *soapMethod = nil;
    if (toSynergyServer != nil)
    {
        [bodyEnvelope addObject:@"SynergyServerLocation"];
        [bodyEnvelope addObject:toSynergyServer];
        soapMethod = SoapMethodAddPointsToSynergyServer;
    }
    else
    {
        soapMethod = SoapMethodAddPoints;
    }

    return [self generateRequestWithSoapMethod:soapMethod body:bodyEnvelope andReplyType:rtAddPointsReply];
}

- (RSSynergyRequest*)balanceInquiry:(NSString*)merchantRockCommID customerCardNumber:(NSString*)customerCardNumber
                          numPoints:(int)numPoints cardAction:(SynergyCardAction)cardAction
                            clerkID:(NSString*)clerkID checkNumber:(NSString*)checkNumber
                        accountType:(SynergyAccountType)accountType
{
    NSMutableArray *bodyEnvelope = [self generateCardManagementCommonData:merchantRockCommID customerCardNumber:customerCardNumber numPoints:numPoints
                                                               cardAction:cardAction clerkID:clerkID checkNumber:checkNumber accountType:accountType];
    if (bodyEnvelope == nil)
    {
        return nil;
    }
    
    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];

    return [self generateRequestWithSoapMethod:SoapMethodBalanceInquiry body:bodyEnvelope andReplyType:rtAddPointsReply];
}

- (RSSynergyRequest*)balanceInquiryWithNetwork:(NSString*)cardNumber networkId:(NSString*)networkId
                                    synergyServerLocation:(NSString*)synergyServerLocation
{
    NSMutableArray *bodyEnvelope = [[[NSMutableArray alloc] init] autorelease];
    
    if (cardNumber)
    {
        if ([cardNumber length] != 12 && [cardNumber length] != 16)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"CardNumber"];
        [bodyEnvelope addObject:cardNumber];
    }

    if (networkId)
    {
        [bodyEnvelope addObject:@"NetworkID"];
        [bodyEnvelope addObject:networkId];
    }

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];

    if (synergyServerLocation)
    {
        [bodyEnvelope addObject:@"SynergyServerLocation"];
        [bodyEnvelope addObject:synergyServerLocation];
    }

    return [self generateRequestWithSoapMethod:SoapMethodBalanceInquiryWithNetwork body:bodyEnvelope andReplyType:rtAddPointsReply];
}

- (RSSynergyRequest*)balanceInquiryWithoutMerchant:(NSString*)cardNumber synergyServerLocation:(NSString*)synergyServerLocation
{
    NSMutableArray *bodyEnvelope = [[[NSMutableArray alloc] init] autorelease];
    
    if (cardNumber)
    {
        if ([cardNumber length] != 12 && [cardNumber length] != 16)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"CardNumber"];
        [bodyEnvelope addObject:cardNumber];
    }

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];
    
    if (synergyServerLocation)
    {
        [bodyEnvelope addObject:@"SynergyServerLocation"];
        [bodyEnvelope addObject:synergyServerLocation];
    }
    
    return [self generateRequestWithSoapMethod:SoapMethodBalanceInquiryWithoutMerchant body:bodyEnvelope andReplyType:rtBalanceInquiryWithoutMerchantReply];
}

- (RSSynergyRequest*)deductPoints:(NSString*)merchantRockCommID customerCardNumber:(NSString*)customerCardNumber
                        numPoints:(int)numPoints cardAction:(SynergyCardAction)cardAction
                          clerkID:(NSString*)clerkID checkNumber:(NSString*)checkNumber
                      accountType:(SynergyAccountType)accountType
{
    NSMutableArray *bodyEnvelope = [self generateCardManagementCommonData:merchantRockCommID customerCardNumber:customerCardNumber numPoints:numPoints
                                                               cardAction:cardAction clerkID:clerkID checkNumber:checkNumber accountType:accountType];
    if (bodyEnvelope == nil)
    {
        return nil;
    }

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];
    
    return [self generateRequestWithSoapMethod:SoapMethodDeductPoints body:bodyEnvelope andReplyType:rtAddPointsReply];
}

- (RSSynergyRequest*)loadActivateGiftCard:(NSString*)merchantRockCommID customerCardNumber:(NSString*)customerCardNumber
                                numPoints:(int)numPoints cardAction:(SynergyCardAction)cardAction
                                  clerkID:(NSString*)clerkID checkNumber:(NSString*)checkNumber
                              accountType:(SynergyAccountType)accountType
{
    NSMutableArray *bodyEnvelope = [self generateCardManagementCommonData:merchantRockCommID customerCardNumber:customerCardNumber numPoints:numPoints
                                                            cardAction:cardAction clerkID:clerkID checkNumber:checkNumber accountType:accountType];
    if (bodyEnvelope == nil)
    {
        return nil;
    }

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];
    
    return [self generateRequestWithSoapMethod:SoapMethodLoadActivateGiftCard body:bodyEnvelope andReplyType:rtAddPointsReply];
}

- (RSSynergyRequest*)loadRewardCardMoney:(NSString*)merchantRockCommID customerCardNumber:(NSString*)customerCardNumber
                               numPoints:(int)numPoints cardAction:(SynergyCardAction)cardAction
                                 clerkID:(NSString*)clerkID checkNumber:(NSString*)checkNumber
                             accountType:(SynergyAccountType)accountType
{
    NSMutableArray *bodyEnvelope = [self generateCardManagementCommonData:merchantRockCommID customerCardNumber:customerCardNumber numPoints:numPoints
                                                               cardAction:cardAction clerkID:clerkID checkNumber:checkNumber accountType:accountType];
    if (bodyEnvelope == nil)
    {
        return nil;
    }
    
    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];
    
    return [self generateRequestWithSoapMethod:SoapMethodLoadRewardCardMoney body:bodyEnvelope andReplyType:rtLoadRewardCardMoneyReply];
}

- (RSSynergyRequest*)redeemGiftCardOnly:(NSString*)merchantRockCommID customerCardNumber:(NSString*)customerCardNumber
                              numPoints:(int)numPoints cardAction:(SynergyCardAction)cardAction
                                clerkID:(NSString*)clerkID checkNumber:(NSString*)checkNumber
                            accountType:(SynergyAccountType)accountType
{
    NSMutableArray *bodyEnvelope = [self generateCardManagementCommonData:merchantRockCommID customerCardNumber:customerCardNumber
                                                                numPoints:numPoints cardAction:cardAction clerkID:clerkID
                                                              checkNumber:checkNumber accountType:accountType];
    if (bodyEnvelope == nil)
    {
        return nil;
    }

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];

    return [self generateRequestWithSoapMethod:SoapMethodRedeemGiftCardOnly body:bodyEnvelope andReplyType:rtRedeemGiftCardOnlyReply];
}

- (RSSynergyRequest*)redeemGiftCardOrReward:(NSString*)merchantRockCommID customerCardNumber:(NSString*)customerCardNumber
                                  numPoints:(int)numPoints cardAction:(SynergyCardAction)cardAction
                                    clerkID:(NSString*)clerkID checkNumber:(NSString*)checkNumber
                                accountType:(SynergyAccountType)accountType
{
    NSMutableArray *bodyEnvelope = [self generateCardManagementCommonData:merchantRockCommID customerCardNumber:customerCardNumber
                                                                numPoints:numPoints cardAction:cardAction clerkID:clerkID
                                                              checkNumber:checkNumber accountType:accountType];
    if (bodyEnvelope == nil)
    {
        return nil;
    }

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];

    return [self generateRequestWithSoapMethod:SoapMethodRedeemGiftCardOrReward body:bodyEnvelope andReplyType:rtRedeemGiftCardOrRewardReply];
}

- (RSSynergyRequest*)voidTransaction:(NSString*)merchantRockCommID customerCardNumber:(NSString*)customerCardNumber
                             authNum:(int)authNum cardAction:(SynergyCardAction)cardAction
                             clerkID:(NSString*)clerkID checkNumber:(NSString*)checkNumber
                         accountType:(SynergyAccountType)accountType
{
    if (authNum <= 0)
    {
        return nil;
    }

    NSString *authNumStr = [NSString stringWithFormat:@"%d", authNum];
    if (authNumStr && [authNumStr length] > 10)
    {
        return nil;
    }

    NSMutableArray *bodyEnvelope = [self generateCardManagementCommonData:merchantRockCommID customerCardNumber:customerCardNumber
                                                                numPoints:authNum cardAction:cardAction clerkID:clerkID
                                                              checkNumber:checkNumber accountType:accountType];
    if (bodyEnvelope == nil)
    {
        return nil;
    }

    //replace NumPoints with AuthNum
    [bodyEnvelope replaceObjectAtIndex:4 withObject:@"AuthNum"];

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];

    return [self generateRequestWithSoapMethod:SoapMethodVoid body:bodyEnvelope andReplyType:rtVoidReply];
}

- (RSSynergyRequest*)pushServiceToSynergyServer:(NSString*)deviceToken pushNewMerchant:(int)pushNewMerchant
                                    pushSynergy:(int)pushSynergy programName:(NSString*)programName
                                   customerName:(NSString*)customerName zipCode:(NSString*)zipCode
                          synergyServerLocation:(NSString*)synergyServerLocation
{
    NSMutableArray *bodyEnvelope = [[[NSMutableArray alloc] init] autorelease];
    
    if (deviceToken)
    {
        if ([deviceToken length] > 4000)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"DeviceID"];
        [bodyEnvelope addObject:deviceToken];
    }

    NSString *pushNewMerchantStr = [NSString stringWithFormat:@"%d", pushNewMerchant];
    if (pushNewMerchantStr)
    {
        [bodyEnvelope addObject:@"push_new_merchant"];
        [bodyEnvelope addObject:pushNewMerchantStr];
    }

    NSString *pushSynergyStr = [NSString stringWithFormat:@"%d", pushSynergy];
    if (pushSynergyStr)
    {
        [bodyEnvelope addObject:@"push_synergy"];
        [bodyEnvelope addObject:pushSynergyStr];
    }

    if (programName)
    {
        if ([programName length] > 255)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"ProgramName"];
        [bodyEnvelope addObject:programName];
    }

    if (customerName)
    {
        if ([customerName length] > 500)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"CustomerName"];
        [bodyEnvelope addObject:customerName];
    }

    if (zipCode)
    {
        if ([zipCode length] > 30)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"ZipCode"];
        [bodyEnvelope addObject:zipCode];
    }

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];
    
    if (synergyServerLocation)
    {
        [bodyEnvelope addObject:@"SynergyServerLocation"];
        [bodyEnvelope addObject:synergyServerLocation];
    }
    
    return [self generateRequestWithSoapMethod:SoapMethodPushServiceToSynergyServer body:bodyEnvelope andReplyType:rtPushServiceToSynergyServerReply];
}

- (RSSynergyRequest*)getMerchantRecords:(NSArray*)cards
{
    NSMutableArray *bodyEnvelope = [[[NSMutableArray alloc] init] autorelease];

    if (cards && [cards count] > 0)
    {
        NSMutableString *result = [[NSMutableString alloc] initWithString:[cards objectAtIndex:0]];
        if ([cards count] > 1)
        {
            for (int i = 1; i < [cards count]; ++i)
            {
                [result appendFormat:@",%@", [cards objectAtIndex:i]];
            }
        }
        if ([result length] > 255)
        {
            [result release];
            return nil;
        }
        [bodyEnvelope addObject:@"Cards"];
        [bodyEnvelope addObject:result];
        [result release];
    }

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];

    return [self generateRequestWithSoapMethod:SoapMethodGetMerchantRecords body:bodyEnvelope andReplyType:rtGetMerchantRecordsReply];
}

- (RSSynergyRequest*)getMerchantLogos:(NSString*)merchantDbaName merchantLogoSize:(SynergyMerchantLogoSize)merchantLogoSize
                          maxNumLogos:(int)maxNumLogos
{
    if (maxNumLogos <= 0)
    {
        return nil;
    }

    NSMutableArray *bodyEnvelope = [[[NSMutableArray alloc] init] autorelease];

    if (merchantDbaName)
    {
        [bodyEnvelope addObject:@"MerchantDbaName"];
        [bodyEnvelope addObject:merchantDbaName];
    }

    [bodyEnvelope addObject:@"MerchantLogoSize"];
    [bodyEnvelope addObject:[self convertLogoSize:merchantLogoSize]];

    NSString *maxNumLogosStr = [NSString stringWithFormat:@"%d", maxNumLogos];
    if (maxNumLogosStr && [maxNumLogosStr length] > 2)
    {
        return nil;
    }
    [bodyEnvelope addObject:@"MaxNumLogos"];
    [bodyEnvelope addObject:maxNumLogosStr];

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];

    return [self generateRequestWithSoapMethod:SoapMethodGetMerchantLogos body:bodyEnvelope andReplyType:rtGetMerchantLogosReply];
}

- (RSSynergyRequest*)getProgramFAQToSynergyServer:(NSString*)programName synergyServerLocation:(NSString*)synergyServerLocation
{
    NSMutableArray *bodyEnvelope = [[[NSMutableArray alloc] init] autorelease];
    
    if (programName)
    {
        if ([programName length] > 255)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"ProgramName"];
        [bodyEnvelope addObject:programName];
    }

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];

    if (synergyServerLocation)
    {
        [bodyEnvelope addObject:@"SynergyServerLocation"];
        [bodyEnvelope addObject:synergyServerLocation];
    }
    
    return [self generateRequestWithSoapMethod:SoapMethodGetProgramFAQToSynergyServer body:bodyEnvelope andReplyType:rtGetProgramFAQToSynergyServerReply];
}

- (RSSynergyRequest*)getTotalSavingsToSynergyServer:(NSString*)customerCardNumber cardAction:(SynergyCardAction)cardAction
                              synergyServerLocation:(NSString*)synergyServerLocation
{
    NSMutableArray *bodyEnvelope = [[[NSMutableArray alloc] init] autorelease];
    
    if (customerCardNumber)
    {
        if ([customerCardNumber length] != 12 && [customerCardNumber length] != 16)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"CustomerCardNumber"];
        [bodyEnvelope addObject:customerCardNumber];
    }

    [bodyEnvelope addObject:@"CardAction"];
    [bodyEnvelope addObject:[self convertCardAction:cardAction]];

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];
    
    if (synergyServerLocation)
    {
        [bodyEnvelope addObject:@"SynergyServerLocation"];
        [bodyEnvelope addObject:synergyServerLocation];
    }
    
    return [self generateRequestWithSoapMethod:SoapMethodGetTotalSavingsToSynergyServer body:bodyEnvelope andReplyType:rtGetTotalSavingsToSynergyServerReply];
}

- (RSSynergyRequest*)validateCardNumberToSynergyServer:(NSString*)customerCardNumber synergyServerLocation:(NSString*)synergyServerLocation
{
    NSMutableArray *bodyEnvelope = [[[NSMutableArray alloc] init] autorelease];

    if (customerCardNumber)
    {
        if ([customerCardNumber length] != 12 && [customerCardNumber length] != 16)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"CustomerCardNumber"];
        [bodyEnvelope addObject:customerCardNumber];
    }

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];
    
    if (synergyServerLocation)
    {
        [bodyEnvelope addObject:@"SynergyServerLocation"];
        [bodyEnvelope addObject:synergyServerLocation];
    }
    
    return [self generateRequestWithSoapMethod:SoapMethodValidateCardNumberToSynergyServer body:bodyEnvelope andReplyType:rtValidateCardNumberToSynergyServerReply];
}

- (RSSynergyRequest*)getMerchantRecordsInPage:(NSArray*)cards pageNumbers:(NSArray*)pageNumbers
{
    NSMutableArray *bodyEnvelope = [[[NSMutableArray alloc] init] autorelease];

    if (cards && [cards count] > 0)
    {
        NSMutableString *result = [[NSMutableString alloc] initWithString:[cards objectAtIndex:0]];
        if ([cards count] > 1)
        {
            for (int i = 1; i < [cards count]; ++i)
            {
                [result appendFormat:@",%@", [cards objectAtIndex:i]];
            }
        }
        if ([result length] > 255)
        {
            [result release];
            return nil;
        }
        [bodyEnvelope addObject:@"Cards"];
        [bodyEnvelope addObject:result];
        [result release];
    }

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];

    if (pageNumbers && [pageNumbers count] > 0)
    {
        NSMutableString *result = [[NSMutableString alloc] initWithString:[pageNumbers objectAtIndex:0]];
        if ([cards count] > 1)
        {
            for (int i = 1; i < [cards count]; ++i)
            {
                [result appendFormat:@",%@", [pageNumbers objectAtIndex:i]];
            }
        }
        [bodyEnvelope addObject:@"PageNumbersCommaSeparated"];
        [bodyEnvelope addObject:result];
        [result release];
    }

    return [self generateRequestWithSoapMethod:SoapMethodGetMerchantRecordsInPage body:bodyEnvelope andReplyType:rtGetMerchantRecordsInPageReply];
}

- (RSSynergyRequest*)getiPhoneDeviceMessages:(NSString*)programName deviceToken:(NSString*)deviceToken
                       synergyServerLocation:(NSString*)synergyServerLocation
{
    NSMutableArray *bodyEnvelope = [[[NSMutableArray alloc] init] autorelease];
    
    if (programName)
    {
        if ([programName length] > 255)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"ProgramName"];
        [bodyEnvelope addObject:programName];
    }

    if (deviceToken)
    {
        if ([deviceToken length] > 4000)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"ProgramName"];
        [bodyEnvelope addObject:programName];
    }

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];
    
    if (synergyServerLocation)
    {
        [bodyEnvelope addObject:@"SynergyServerLocation"];
        [bodyEnvelope addObject:synergyServerLocation];
    }
    
    return [self generateRequestWithSoapMethod:SoapMethodGetIPhoneDeviceMessages body:bodyEnvelope andReplyType:rtGetIPhoneDeviceMessagesReply];
}

- (RSSynergyRequest*)deactivateiPhoneMessage:(NSString*)deviceToken iPhoneMessageId:(int)iPhoneMessageId
                       synergyServerLocation:(NSString*)synergyServerLocation
{
    NSMutableArray *bodyEnvelope = [[[NSMutableArray alloc] init] autorelease];
    
    if (deviceToken)
    {
        if ([deviceToken length] > 4000)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"DeviceID"];
        [bodyEnvelope addObject:deviceToken];
    }

    NSString *iPhoneMessageIdStr = [NSString stringWithFormat:@"%d", iPhoneMessageId];
    if (iPhoneMessageIdStr)
    {
        [bodyEnvelope addObject:@"IPhoneMessageID"];
        [bodyEnvelope addObject:iPhoneMessageIdStr];
    }

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];

    if (synergyServerLocation)
    {
        [bodyEnvelope addObject:@"SynergyServerLocation"];
        [bodyEnvelope addObject:synergyServerLocation];
    }
    
    return [self generateRequestWithSoapMethod:SoapMethodDeactivateIPhoneMessage body:bodyEnvelope andReplyType:rtDeactivateIPhoneMessageReply];
}

- (RSSynergyRequest*)getRegistrationInfo:(NSString*)groupNumber searchBy:(SynergySearchType)searchBy
                             searchValue:(NSString*)searchValue password:(NSString*)password
                   synergyServerLocation:(NSString*)synergyServerLocation
{
    NSMutableArray *bodyEnvelope = [[[NSMutableArray alloc] init] autorelease];

    if (groupNumber)
    {
        if ([groupNumber length] > 50)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"GroupNumber"];
        [bodyEnvelope addObject:groupNumber];
    }

    [bodyEnvelope addObject:@"SearchBy"];
    [bodyEnvelope addObject:[self convertSearchBy:searchBy]];

    if (searchValue)
    {
        if ([searchValue length] > 50)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"SearchValue"];
        [bodyEnvelope addObject:searchValue];
    }

    if (password)
    {
        if ([password length] > 50)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"Password"];
        [bodyEnvelope addObject:password];
    }

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];

    if (synergyServerLocation)
    {
        [bodyEnvelope addObject:@"SynergyServerLocation"];
        [bodyEnvelope addObject:synergyServerLocation];
    }
    
    return [self generateRequestWithSoapMethod:SoapMethodGetRegistrationInfo body:bodyEnvelope andReplyType:rtGetRegistrationInfoReply];
}

- (RSSynergyRequest*)checkRegistrationAccount:(NSString*)groupNumber email:(NSString*)email
                                   cellNumber:(NSString*)cellNumber cardNumber:(NSString*)cardNumber
                        synergyServerLocation:(NSString*)synergyServerLocation
{
    NSMutableArray *bodyEnvelope = [[[NSMutableArray alloc] init] autorelease];

    if (groupNumber)
    {
        if ([groupNumber length] > 50)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"GroupNumber"];
        [bodyEnvelope addObject:groupNumber];
    }

    if (email)
    {
        if ([email length] > 50)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"Email"];
        [bodyEnvelope addObject:email];
    }

    if (cellNumber)
    {
        if ([cellNumber length] > 50)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"CellNumber"];
        [bodyEnvelope addObject:cellNumber];
    }

    if (cardNumber)
    {
        if ([cardNumber length] > 50)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"CardNumber"];
        [bodyEnvelope addObject:cardNumber];
    }

    [bodyEnvelope addObject:@"ResponseFormat"];
    [bodyEnvelope addObject:ResponseFormat];

    if (synergyServerLocation)
    {
        [bodyEnvelope addObject:@"SynergyServerLocation"];
        [bodyEnvelope addObject:synergyServerLocation];
    }

    return [self generateRequestWithSoapMethod:SoapMethodCheckRegistrationAccount body:bodyEnvelope andReplyType:rtCheckRegistrationAccountReply];
}

#pragma mark Private
- (NSMutableArray*)generateRegistrationCommonData:(BOOL)isLongRequest
                                       cardNumber:(NSString*)cardNumber
                                        firstName:(NSString*)firstName
                                         lastName:(NSString*)lastName
                                          address:(NSString*)address city:(NSString*)city
                                            state:(NSString*)state
                                          zipCode:(NSString*)zipCode
                                            email:(NSString*)email homePhone:(NSString*)homePhone
                                       cellNumber:(NSString*)cellNumber birthDate:(NSString*)birthDate
                                         password:(NSString*)password
                                    martialStatus:(SynergyMartialStatus)martialStatus
                                           gender:(SynergyGender)gender country:(NSString*)country
                                       occupation:(NSString*)occupation
                                receiveEmailFlags:(BOOL)receiveEmailFlags
                             receiveThankYouFlags:(BOOL)receiveThankYouFlags textMessageFlag:(BOOL)textMessageFlag
                                receiveCouponFlag:(BOOL)receiveCouponFlag
                                       merchantId:(NSString*)merchantId refferalId:(NSString*)refferalId
                                      groupNumber:(NSString*)groupNumber
                                       terminalId:(NSString*)terminalId
                                         serverId:(NSString*)serverId primaryCardNumber:(NSString*)primaryCardNumber
                               primaryPhoneNumber:(NSString*)primaryPhoneNumber
                                         cardType:(NSString*)cardType streetSavingFlag:(BOOL)streetSavingFlag
                                  anniversaryDate:(NSString*)anniversaryDate
                                   youGotCashFlag:(BOOL)youGotCashFlag
{
    NSMutableArray *bodyEnvelope = [[[NSMutableArray alloc] init] autorelease];
    
    if (cardNumber)
    {
        if ([cardNumber length] != 12 && [cardNumber length] != 16)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"CardNumber"];
        [bodyEnvelope addObject:cardNumber];
    }
    
    if (firstName)
    {
        if ([firstName length] > 50)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"FisrtName"];
        [bodyEnvelope addObject:firstName];
    }
    
    if (lastName)
    {
        if ([lastName length] > 50)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"LastName"];
        [bodyEnvelope addObject:lastName];
    }
    
    if (address)
    {
        if ([address length] > 255)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"Address"];
        [bodyEnvelope addObject:address];
    }
    
    if (city)
    {
        if ([city length] > 50)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"City"];
        [bodyEnvelope addObject:city];
    }
    
    if (state)
    {
        if ([state length] > 50)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"State"];
        [bodyEnvelope addObject:state];
    }
    
    if (zipCode)
    {
        if ([zipCode length] > 10)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"ZipCode"];
        [bodyEnvelope addObject:zipCode];
    }
    
    if (email)
    {
        if ([email length] > 255)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"Email"];
        [bodyEnvelope addObject:email];
    }
    
    if (homePhone)
    {
        if ([homePhone length] > 20)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"HomePhone"];
        [bodyEnvelope addObject:homePhone];
    }
    
    if (cellNumber)
    {
        if ([cellNumber length] > 20)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"CellNumber"];
        [bodyEnvelope addObject:cellNumber];
    }
    
    if (birthDate)
    {
        if ([birthDate length] > 10)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"BirthDate"];
        [bodyEnvelope addObject:birthDate];
    }
    
    if (password)
    {
        if ([password length] > 50)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"Password"];
        [bodyEnvelope addObject:password];
    }

    if (isLongRequest)
    {
        if (martialStatus != msUnknown)
        {
            NSString *martialStatusStr = martialStatus == msSingle ? @"S" : @"M";
            [bodyEnvelope addObject:@"MartialStatus"];
            [bodyEnvelope addObject:martialStatusStr];
        }
        if (gender != sgUnknown)
        {
            NSString *genderStr = gender == sgMale ? @"M" : @"F";
            [bodyEnvelope addObject:@"Gender"];
            [bodyEnvelope addObject:genderStr];
        }
        if (country)
        {
            if ([country length] > 50)
            {
                return nil;
            }
            [bodyEnvelope addObject:@"Country"];
            [bodyEnvelope addObject:country];
        }
        if (occupation)
        {
            if ([occupation length] > 50)
            {
                return nil;
            }
            [bodyEnvelope addObject:@"Occupation"];
            [bodyEnvelope addObject:occupation];
        }
    }

    NSString *receiveEmailFlagsStr = receiveEmailFlags ? @"true" : @"false";
    [bodyEnvelope addObject:@"ReceiveEmailFlags"];
    [bodyEnvelope addObject:receiveEmailFlagsStr];
    
    NSString *receiveThankYouFlagsStr = receiveThankYouFlags ? @"true" : @"false";
    [bodyEnvelope addObject:@"ReceiveThankYouFlags"];
    [bodyEnvelope addObject:receiveThankYouFlagsStr];

    if (isLongRequest)
    {
        NSString *textMessageFlagStr = textMessageFlag ? @"true" : @"false";
        [bodyEnvelope addObject:@"TextMessageFlag"];
        [bodyEnvelope addObject:textMessageFlagStr];

        NSString *receiveCouponFlagStr = receiveCouponFlag ? @"true" : @"false";
        [bodyEnvelope addObject:@"ReceiveCouponFlag"];
        [bodyEnvelope addObject:receiveCouponFlagStr];
    }
    
    if (merchantId)
    {
        if ([merchantId length] > 50)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"MerchantID"];
        [bodyEnvelope addObject:merchantId];
    }
    
    if (refferalId)
    {
        if ([refferalId length] > 50)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"RefferalID"];
        [bodyEnvelope addObject:refferalId];
    }
    
    if (groupNumber)
    {
        if ([groupNumber length] > 50)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"GroupNumber"];
        [bodyEnvelope addObject:groupNumber];
    }
    
    if (terminalId)
    {
        if ([groupNumber length] > 50)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"TerminalID"];
        [bodyEnvelope addObject:terminalId];
    }

    if (isLongRequest)
    {
        if (serverId)
        {
            if ([serverId length] > 50)
            {
                return nil;
            }
            [bodyEnvelope addObject:@"ServerID"];
            [bodyEnvelope addObject:serverId];
        }
        if (primaryCardNumber)
        {
            if ([primaryCardNumber length] != 12 && [primaryCardNumber length] != 16)
            {
                return nil;
            }
            [bodyEnvelope addObject:@"PrimaryCardNumber"];
            [bodyEnvelope addObject:primaryCardNumber];
        }
        if (primaryPhoneNumber)
        {
            if ([primaryPhoneNumber length] > 20)
            {
                return nil;
            }
            [bodyEnvelope addObject:@"PrimaryPhoneNumber"];
            [bodyEnvelope addObject:primaryPhoneNumber];
        }
        if (cardType)
        {
            if ([cardType length] > 10)
            {
                return nil;
            }
            [bodyEnvelope addObject:@"CardType"];
            [bodyEnvelope addObject:cardType];
        }
    }
    
    NSString *streetSavingFlagStr = streetSavingFlag ? @"true" : @"false";
    [bodyEnvelope addObject:@"StreetSavingFlag"];
    [bodyEnvelope addObject:streetSavingFlagStr];
    
    if (anniversaryDate)
    {
        if ([anniversaryDate length] > 10)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"AnniversaryDate"];
        [bodyEnvelope addObject:anniversaryDate];
    }
    
    NSString *youGotCashFlagStr = youGotCashFlag ? @"true" : @"false";
    [bodyEnvelope addObject:@"YouGotCashFlag"];
    [bodyEnvelope addObject:youGotCashFlagStr];

    return bodyEnvelope;
}

- (NSMutableArray*)generateCardManagementCommonData:(NSString*)merchantRockCommID customerCardNumber:(NSString*)customerCardNumber numPoints:(int)numPoints
                                         cardAction:(SynergyCardAction)cardAction clerkID:(NSString*)clerkID checkNumber:(NSString*)checkNumber
                                        accountType:(SynergyAccountType)accountType
{
    if (numPoints <= 0)
    {
        return nil;
    }
    
    NSString *numPointStr = [NSString stringWithFormat:@"%d", numPoints];
    if (numPointStr && [numPointStr length] > 12)
    {
        return nil;
    }
    
    NSMutableArray *bodyEnvelope = [[[NSMutableArray alloc] init] autorelease];
    
    if (merchantRockCommID)
    {
        if ([merchantRockCommID length] > 12)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"MerchantRockCommID"];
        [bodyEnvelope addObject:merchantRockCommID];
    }
    
    if (customerCardNumber)
    {
        if ([customerCardNumber length] != 12 && [customerCardNumber length] != 16)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"CustomerCardNumber"];
        [bodyEnvelope addObject:customerCardNumber];
    }
    
    [bodyEnvelope addObject:@"NumPoints"];
    [bodyEnvelope addObject:numPointStr];
    
    [bodyEnvelope addObject:@"CardAction"];
    [bodyEnvelope addObject:[self convertCardAction:cardAction]];
    
    if (clerkID)
    {
        if ([clerkID length] > 50)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"ClerkID"];
        [bodyEnvelope addObject:clerkID];
    }
    
    if (checkNumber)
    {
        if ([checkNumber length] > 50)
        {
            return nil;
        }
        [bodyEnvelope addObject:@"CheckNumber"];
        [bodyEnvelope addObject:checkNumber];
    }
    
    [bodyEnvelope addObject:@"AccountType"];
    [bodyEnvelope addObject:[self convertAccontType:accountType]];

    return bodyEnvelope;
}

- (RSSynergyRequest*)generateRequestWithSoapMethod:(NSString*)soapMethod body:(NSArray*)body andReplyType:(SynergyReplyType)replyType
{
    NSString *soapAction = [SynergyXmlns stringByAppendingString:soapMethod];
    NSString *soapXml = [Soap createCustomEnvelope:soapMethod forNamespace:SynergyXmlns containing:body withHeaders:self.soapService.headers];
    RSWebServiceHandler *serviceHandler = [[RSWebServiceHandler alloc] initWithType:replyType];
    RSSynergyRequest *synergyRequest = [[[RSSynergyRequest alloc] initWithHandler:serviceHandler] autorelease];
    serviceHandler.soapRequest = [SoapRequest create:serviceHandler action:nil service:self.soapService soapAction:soapAction postData:soapXml deserializeTo:nil];
    serviceHandler.soapRequest.logging = LoggingEnabled;
    [serviceHandler release];
    
    return synergyRequest;
}

- (NSString*)convertCardAction:(SynergyCardAction)action
{
    return action == caCardSwiped ? @"CardSwiped" : @"CardKeyed";
}

- (NSString*)convertAccontType:(SynergyAccountType)type
{
    NSString *accoutTypeStr = nil;
    if (type == atCardNumber)
    {
        accoutTypeStr = @"CardNumber";
    }
    else if (type == atPhoneNumber)
    {
        accoutTypeStr = @"PhoneNumber";
    }
    else
    {
        accoutTypeStr = @"ReferralNumber";
    }

    return accoutTypeStr;
}

- (NSString*)convertSearchBy:(SynergySearchType)type
{
    NSString *searchByStr = nil;
    if (type == stCardNumber)
    {
        searchByStr = @"CardNumber";
    }
    else if (type == stCellPhone)
    {
        searchByStr = @"CellPhone";
    }
    else if (type == stHomePhone)
    {
        searchByStr = @"HomePhone";
    }
    else if (type == stEmail)
    {
        searchByStr = @"Email";
    }
    else
    {
        searchByStr = @"ClientSurrogate";
    }

    return searchByStr;
}

- (NSString*)convertLogoSize:(SynergyMerchantLogoSize)size
{
    NSString *sizeStr = nil;
    if (size == lsOriginalSize)
    {
        sizeStr = @"OriginalSize";
    }
    else
    {
        sizeStr = @"Small";
    }
    
    return sizeStr;
}

- (NSString*)convertMartialStatus:(SynergyMartialStatus)status
{
    NSString *statusStr = nil;
    if (status == msSingle)
    {
        statusStr = @"S";
    }
    else
    {
        statusStr = @"M";
    }
    
    return statusStr;
}

- (NSString*)convertGender:(SynergyGender)gender
{
    NSString *genderStr = nil;
    if (gender == sgMale)
    {
        genderStr = @"M";
    }
    else
    {
        genderStr = @"F";
    }
    
    return genderStr;
}

@end

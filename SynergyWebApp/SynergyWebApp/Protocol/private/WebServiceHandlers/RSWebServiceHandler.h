//
//  RSWebServiceHandler.h
//  SynergyWebApp
//
//  Created by Ildar on 2/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoapHandler.h"
#import "RSSynergyReply.h"
#import "RSSynergyRequest.h"

@class SoapRequest;

@interface RSWebServiceHandler : SoapHandler
{
@private
    SEL resultSelector;
    id  context;
}

@property(nonatomic, retain)             SoapRequest          *soapRequest;
@property(nonatomic, readwrite)          SynergyReplyType     replyType;
@property(nonatomic, readonly)           SynergyRequestStatus status;
@property(nonatomic, assign, readonly)   RSSynergyReply       *replyObject;

- (id)initWithType:(SynergyReplyType)_replyType;
- (BOOL)handleAndPerformSelector:(SEL)_resultSelector onContext:(id)_context;

@end

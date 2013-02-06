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

@interface RSWebServiceHandler : SoapHandler

@property(nonatomic, readwrite)SynergyReplyType replyType;

- (id)initWithType:(SynergyReplyType)_replyType;

@end

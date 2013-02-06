//
//  RSWebServiceHandler.m
//  SynergyWebApp
//
//  Created by Ildar on 2/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "RSWebServiceHandler.h"

@implementation RSWebServiceHandler

@synthesize replyType;

- (id)initWithType:(SynergyReplyType)_replyType
{
    self = [super init];
    if (self != nil)
    {
        replyType = _replyType;
    }

    return self;
}

- (void) onload: (id) value
{
    return;
}

- (void) onerror: (NSError*) error
{
    return;
}

- (void) onfault: (SoapFault*) fault
{
    return;
}

@end

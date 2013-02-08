//
//  RSSynergyRequest.m
//  SynergyWebApp
//
//  Created by Ildar on 2/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "RSSynergyRequest.h"
#import "RSWebServiceHandler.h"
#import "SoapRequest.h"

@interface RSSynergyRequest()

- (void)handlerFinished;

@end

@implementation RSSynergyRequest

@synthesize delegate;

- (void)dealloc
{
    [_internal release];
    self.delegate = nil;
    [super dealloc];
}

- (BOOL)startRequest
{
    if (_internal == nil)
    {
        return NO;
    }

    RSWebServiceHandler *handler = (RSWebServiceHandler *)_internal;
    return [handler handleAndPerformSelector:@selector(handlerFinished) onContext:self];
}

- (void)cancelRequest
{
    if (_internal == nil)
    {
        return;
    }
    
    RSWebServiceHandler *handler = (RSWebServiceHandler *)_internal;
    [handler.soapRequest cancel];
}

- (void)handlerFinished
{
    RSWebServiceHandler *handler = (RSWebServiceHandler *)_internal;
    [delegate gotReply:handler.replyObject forRequest:self withStatus:handler.status];
}

@end

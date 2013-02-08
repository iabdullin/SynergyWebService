//
//  RSSynergyRequest.h
//  SynergyWebApp
//
//  Created by Ildar on 2/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum SynergyRequestStatus
{
    RequestStatusSuccess = 0,
    RequestStatusInternalError,
    RequestStatusConnectionFailed
    
} SynergyRequestStatus;

@class RSSynergyReply;
@class RSSynergyRequest;

@protocol RSSynergyRequestDelegate <NSObject>

- (void)gotReply:(RSSynergyReply*)reply forRequest:(RSSynergyRequest*)request withStatus:(SynergyRequestStatus)status;

@end

@interface RSSynergyRequest : NSObject
{
@private
    id _internal;
}

@property(nonatomic, assign) id<RSSynergyRequestDelegate> delegate;

- (BOOL)startRequest;
- (void)cancelRequest;

@end

//
//  RSSynergyReply.h
//  SynergyWebApp
//
//  Created by Ildar on 2/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum SynergyReplyType
{
    UnknownReply = 0,     
    PostRegistrationReply

} SynergyReplyType;




@interface RSSynergyReply : NSObject
{
@protected
    SynergyReplyType type;
}

@property(nonatomic, readonly) SynergyReplyType replyType;

@end

@interface RSPostRegistrationReply : RSSynergyReply

@end
//
//  EventBuilder.m
//  ThirdLib
//
//  Created by 王博 on 2018/6/11.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "EventBuilder.h"
@interface EventBuilder ()
@property (nonatomic, strong) Event *event;
@end


@interface Event ()

@property (nonatomic, copy, readwrite) NSString *eventName;
@property (nonatomic, assign, readwrite) BOOL needDispatch;
@property (nonatomic, copy, readwrite, nullable) dispatch_block_t completionBlock;

@end
@implementation Event

+ (EventBuilder * _Nonnull(^)(NSString * _Nonnull))eventBuilder
{
    return ^EventBuilder *(NSString *eventName) {
        EventBuilder *eB = [[EventBuilder alloc] init];
        eB.event.eventName = eventName;
        return eB;
    };
}

@end


@implementation EventBuilder

- (instancetype)init
{
    if (self = [super init]) {
        self.event = [[Event alloc] init];
    }
    return self;
}

- (EventBuilder *(^)(BOOL))needDispatch
{
    return ^EventBuilder *(BOOL needD){
        self.event.needDispatch = needD;
        return self;
    };
}

- (EventBuilder *(^)(dispatch_block_t))completionBlock
{
    return ^EventBuilder *(dispatch_block_t disT) {
        self.event.completionBlock = disT;
        return self;
    };
}

- (Event *(^)(void))build
{
    return ^Event * (void) {
        return self.event;
    };
}

@end



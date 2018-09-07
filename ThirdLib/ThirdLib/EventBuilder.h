//
//  EventBuilder.h
//  ThirdLib
//
//  Created by 王博 on 2018/6/11.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

@import Foundation;
@class Event;
@interface EventBuilder : NSObject
- (EventBuilder *(^)(BOOL))needDispatch;
- (EventBuilder *(^)(dispatch_block_t))completionBlock;
- (Event *(^)(void))build;
@end


@interface Event : NSObject

@property (nonatomic, copy, readonly) NSString *eventName;
@property (nonatomic, assign, readonly) BOOL needDispatch;
@property (nonatomic, copy, readonly, nullable) dispatch_block_t completionBlock;

+ (EventBuilder *(^)(NSString *))eventBuilder;

@end


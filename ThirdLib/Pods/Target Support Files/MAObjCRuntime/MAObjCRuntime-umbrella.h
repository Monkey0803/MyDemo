#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MARTNSObject.h"
#import "RTIvar.h"
#import "RTMethod.h"
#import "RTProperty.h"
#import "RTProtocol.h"
#import "RTUnregisteredClass.h"

FOUNDATION_EXPORT double MAObjCRuntimeVersionNumber;
FOUNDATION_EXPORT const unsigned char MAObjCRuntimeVersionString[];


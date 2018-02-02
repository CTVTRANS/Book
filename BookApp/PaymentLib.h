//
//  paymentLib.h
//  FQTest
//
//  Created by le kien on 1/23/18.
//  Copyright © 2018 zzf073. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FuqianlaPay.h"
#import <CommonCrypto/CommonDigest.h>

@interface PaymentLib : NSObject

@property (strong, nonatomic) NSString *appID;
@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSString *notifyUrl;
@property (strong, nonatomic) NSString *siginRsa;
@property (strong, nonatomic) NSString *orderId;
@property (strong, nonatomic) NSString *chargeID;
@property (strong, nonatomic) NSString *optional;

-(FuqianlaPay *)createPaymemtObject;

@end

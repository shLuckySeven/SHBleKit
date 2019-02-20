//
//  TGCharacteristic.m
//  TOGOBlutoothDemo
//
//  Created by ShuHuan on 2017/4/6.
//  Copyright © 2017年 shuhuan. All rights reserved.
//

#import "TGCharacteristic.h"
#import "TGPeripheral.h"
#import "TGService.h"

@interface TGCharacteristic()
{
    TGService *_service;
}

@property (nonatomic, strong) CBCharacteristic *characteristic;
@property (nonatomic, weak, readwrite) TGPeripheral *ownPeripheral;


@end
@implementation TGCharacteristic
- (instancetype)initWithCharacteristic:(CBCharacteristic *)characteristic andOwnPeripheral:(TGPeripheral *)peripheral
{
    self = [super init];
    if(self){
        _characteristic = characteristic;
        _ownPeripheral = peripheral;
    }
    return self;
}

- (CBUUID *)UUID
{
    return _characteristic.UUID;
}

- (TGService *)service
{
    if(!_service){
        _service = [[TGService alloc] initWithService:_characteristic.service andOwnPeripheral:_ownPeripheral];
    };
    return _service;
}

- (CBCharacteristicProperties)properties
{
    return _characteristic.properties;
}

- (NSData *)value
{
    return _characteristic.value;
}

- (NSArray<TGDescriptor *> *)descriptors
{
    return nil;
}

- (BOOL)isBroadcasted
{
    return _characteristic.isBroadcasted;
}

- (BOOL)isNotifying
{
    return _characteristic.isNotifying;
}

- (void)readValueWithBlock:(TGPeripheralReadValueForCharacteristicBlock)block
{
    if(_ownPeripheral){
        [_ownPeripheral readValueForCharacteristic:self withBlock:[block copy]];
    }
}

- (void)writeValue:(NSData *)data type:(CBCharacteristicWriteType)type withBlock:(TGPeripheralWriteValueForCharacteristicsBlock)block withTypeBlock:(TGBleInstructType)instructType
{
    if(_ownPeripheral){
//        [_ownPeripheral writeValue:data forCharacteristic:self type:type withBlock:[block copy]];
        [_ownPeripheral writeValue:data forCharacteristic:self type:type withBlock:instructType withBlock:[block copy]];
    }
}


- (void)setNotifyValue:(BOOL)enabled withBlock:(TGPeripheralNotifyValueForCharacteristicsBlock)block
{
    if(_ownPeripheral){
        [_ownPeripheral setNotifyValue:enabled forCharacteristic:self withBlock:[block copy]];
    }
}

- (void)discoverDescriptorsWithBlock:(TGPeripheralDiscoverDescriptorsForCharacteristicBlock)block
{
    if(_ownPeripheral){
        [_ownPeripheral discoverDescriptorsForCharacteristic:self withBlock:[block copy]];
    }
}
- (void)dealloc{
    DLog(@"-------dealloc---------Characteristic");
}
@end

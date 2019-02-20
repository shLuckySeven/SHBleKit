//
//  TGDescriptor.m
//  TOGOBlutoothDemo
//
//  Created by ShuHuan on 2017/4/6.
//  Copyright © 2017年 shuhuan. All rights reserved.
//

#import "TGDescriptor.h"
#import "TGPeripheral.h"
#import "TGCharacteristic.h"

@interface TGDescriptor()
{
    TGCharacteristic *_ownCharactreistic;
}

@property (nonatomic, strong) CBDescriptor *descriptor;
@property (nonatomic, weak) TGPeripheral *ownPeripheral;

@end
@implementation TGDescriptor
- (instancetype)initWithDescriptor:(CBDescriptor *)descriptor andOwnPeripheral:(TGPeripheral *)peripheral
{
    self = [super init];
    if (self) {
        _descriptor = descriptor;
        _ownPeripheral = peripheral;
    }
    return self;
}

- (CBUUID *)UUID
{
    return _descriptor.UUID;
}

- (TGCharacteristic *)characteristic
{
    if(!_ownCharactreistic){
        _ownCharactreistic = [[TGCharacteristic alloc] initWithCharacteristic:_descriptor.characteristic andOwnPeripheral:_ownPeripheral];
    }
    return _ownCharactreistic;
}

- (id)value
{
    return _descriptor.value;
}

- (void)readValueWithBlock:(TGPeripheralReadValueForDescriptorsBlock)block
{
    if(_ownPeripheral){
        [_ownPeripheral readValueForDescriptor:self withBlock:[block copy]];
    }
}

- (void)writeValue:(NSData *)data withBlock:(TGPeripheralWriteValueForDescriptorsBlock)block
{
    if(_ownPeripheral){
        [_ownPeripheral writeValue:data forDescriptor:self withBlock:[block copy]];
    }
}@end

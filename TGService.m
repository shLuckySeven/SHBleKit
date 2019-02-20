//
//  TGService.m
//  TOGOBlutoothDemo
//
//  Created by ShuHuan on 2017/4/6.
//  Copyright © 2017年 shuhuan. All rights reserved.
//

#import "TGService.h"
#import "TGPeripheral.h"
#import "TGCharacteristic.h"
@interface TGService()

@property (nonatomic, strong) CBService *service;
@property (nonatomic, weak) TGPeripheral *ownPeipheral;

@end
@implementation TGService
-(instancetype)initWithService:(CBService *)service andOwnPeripheral:(TGPeripheral *)peripheral
{
    self = [super init];
    if (self) {
        _service = service;
        _ownPeipheral = peripheral;
    }
    return self;
}

- (CBUUID *)UUID
{
    return _service.UUID;
}

- (TGPeripheral *)peripheral
{
    return _ownPeipheral;
}

- (BOOL)isPrimary
{
    return _service.isPrimary;
}

- (NSArray<TGService *> *)includedServices
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(CBService *service in _service.includedServices){
        [array addObject:[[TGService alloc] initWithService:service andOwnPeripheral:_ownPeipheral]];
    }
    return array;
}

- (NSArray<TGCharacteristic *> *)characteristics
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(CBCharacteristic *characteristic in _service.characteristics){
        [array addObject:[[TGCharacteristic alloc] initWithCharacteristic:characteristic andOwnPeripheral:_ownPeipheral]];
    }
    return array;
}

- (void)discoverCharacteristics:(NSArray<CBUUID *> *)characteristicUUIDs withBlock:(TGPeripheralDiscoverCharacteristicsBlock)block
{
    if(_ownPeipheral){
        [_ownPeipheral discoverCharacteristics:characteristicUUIDs forService:self withBlock:[block copy]];
    }
}

- (void)discoverIncludedServices:(NSArray<CBUUID *> *)includedServiceUUIDs withBlock:(TGPeripheralDiscoverIncludedServicesBlock)block
{
    if(_ownPeipheral){
        [_ownPeipheral discoverIncludedServices:includedServiceUUIDs forService:self withBlock:[block copy]];
    }
}
@end

//
//  TGPeripheral.m
//  TOGOBlutoothDemo
//
//  Created by ShuHuan on 2017/4/6.
//  Copyright © 2017年 shuhuan. All rights reserved.
//

#import "TGPeripheral.h"
#import "TGCharacteristic.h"
#import "TGService.h"
#import "TGDescriptor.h"

#define TGPeripheralIsSelf(peripheral) [peripheral.identifier.UUIDString isEqualToString:_peripheral.identifier.UUIDString]

@interface TGCharacteristic()
@property (nonatomic, strong) CBCharacteristic *characteristic;
@end

@interface TGService()
@property (nonatomic, strong) CBService *service;
@end

@interface TGDescriptor()
@property (nonatomic, strong) CBDescriptor *descriptor;
@end

@interface TGPeripheral() <CBPeripheralDelegate>
{
    TGPeripheralRedRSSIBlock            _readRSSIBlock;
    TGPeripheralDiscoverServicesBlock   _discoverServicesBlock;
    
    NSMutableDictionary *_readValueForCharacteristicsBlocks;
    NSMutableDictionary *_writeValueForCharacteristicsBlocks;
    NSMutableDictionary *_notifyValyeForCharacteristicsBlocks;
    NSMutableDictionary *_readValueForDescriptorsBlock;
    NSMutableDictionary *_writeValueForDescriptorsBlock;
    
    NSMutableDictionary *_discoverCharacteristicsBlocks;
    NSMutableDictionary *_discoverIncludedServicesBlocks;
    NSMutableDictionary *_discoverDescriptorsForCharacteristicBlocks;
    NSNumber *_RSSI;
}

@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, retain, readwrite) NSNumber *RSSI;

@end
@implementation TGPeripheral
- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral
{
    NSAssert(peripheral, @"MPPeripheral cannot init with a nullable peripheral");
    self = [super init];
    if (self) {
        self.peripheral = peripheral;
        self.peripheral.delegate = self;
        
        _readValueForCharacteristicsBlocks = [[NSMutableDictionary alloc] init];
        _writeValueForCharacteristicsBlocks = [[NSMutableDictionary alloc] init];
        _notifyValyeForCharacteristicsBlocks = [[NSMutableDictionary alloc] init];
        _readValueForDescriptorsBlock = [[NSMutableDictionary alloc] init];
        _writeValueForDescriptorsBlock = [[NSMutableDictionary alloc] init];
        _discoverCharacteristicsBlocks = [[NSMutableDictionary alloc] init];
        _discoverIncludedServicesBlocks = [[NSMutableDictionary alloc] init];
        _discoverDescriptorsForCharacteristicBlocks = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSUUID *)identifier
{
    return _peripheral.identifier;
}

- (NSString *)name
{
    return _peripheral.name;
}

- (CBPeripheralState)state
{
    return _peripheral.state;
}

- (NSArray<TGService *> *)services
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(CBService *service in _peripheral.services){
        [array addObject:[[TGService alloc] initWithService:service andOwnPeripheral:self]];
    }
    return array;
}

- (void)setRSSI:(NSNumber *)RSSI
{
    _RSSI = RSSI;
}

- (NSNumber *)RSSI
{
    return _RSSI;
}
- (TGBleInstructType)instructType{
    return _instructType;
}
- (void)readRSSI:(TGPeripheralRedRSSIBlock)block
{
    NSAssert(block, @"readRSSI: block cannot be nil");
    _readRSSIBlock = block;
    [self.peripheral readRSSI];
}

- (void)discoverServices:(NSArray<CBUUID *> *)serviceUUIDs withBlock:(TGPeripheralDiscoverServicesBlock)block
{
    NSAssert(block, @"discoverServices:withBlock: block cannot be nil");
    _discoverServicesBlock = block;
    //    self.peripheral.delegate =self;
    [self.peripheral discoverServices:serviceUUIDs];
}

- (void)discoverIncludedServices:(NSArray<CBUUID *> *)includedServiceUUIDs
                      forService:(TGService *)service
                       withBlock:(TGPeripheralDiscoverIncludedServicesBlock)block
{
    NSAssert(block, @"discoverIncludedServices:forService:withBlock: block cannot be nil");
    [_discoverIncludedServicesBlocks setObject:block forKey:service.UUID.UUIDString];
    [self.peripheral discoverIncludedServices:includedServiceUUIDs forService:service.service];
}
//扫描service
- (void)discoverCharacteristics:(NSArray<CBUUID *> *)characteristicUUIDs
                     forService:(TGService *)service
                      withBlock:(TGPeripheralDiscoverCharacteristicsBlock)block
{
    NSAssert(block, @"discoverCharacteristics:forService:withBlock: block cannot be nil");
    [_discoverCharacteristicsBlocks setObject:block forKey:service.UUID.UUIDString];
    [self.peripheral discoverCharacteristics:characteristicUUIDs forService:service.service];
}

- (void)readValueForCharacteristic:(TGCharacteristic *)characteristic withBlock:(TGPeripheralReadValueForCharacteristicBlock)block
{
    NSAssert(block, @"readValueForCharacteristic:withBlock: block cannot be nil");
    [_readValueForCharacteristicsBlocks setValue:block forKey:characteristic.UUID.UUIDString];
    [self.peripheral readValueForCharacteristic:characteristic.characteristic];
}

- (void)writeValue:(NSData *)data
 forCharacteristic:(TGCharacteristic *)characteristic
              type:(CBCharacteristicWriteType)type
         withBlock:(TGBleInstructType)instructType
         withBlock:(TGPeripheralWriteValueForCharacteristicsBlock)block
{
    NSAssert(block, @"writeValue:forCharacteristic:type:withBlock: block cannot be nil");
    _instructType =instructType;
    [_writeValueForCharacteristicsBlocks setValue:block forKey:characteristic.UUID.UUIDString];
    [self.peripheral writeValue:data forCharacteristic:characteristic.characteristic type:type];
}

- (void)setNotifyValue:(BOOL)enabled forCharacteristic:(TGCharacteristic *)characteristic withBlock:(TGPeripheralNotifyValueForCharacteristicsBlock)block
{
    NSAssert(block, @"setNotifyValue:forCharacteristic:withBlock: block cannot be nil");
    if(enabled){
        [_notifyValyeForCharacteristicsBlocks setValue:block forKey:characteristic.UUID.UUIDString];
    }else{
        [_notifyValyeForCharacteristicsBlocks removeObjectForKey:characteristic.UUID.UUIDString];
    }
    [self.peripheral setNotifyValue:enabled forCharacteristic:characteristic.characteristic];
}

-(void)discoverDescriptorsForCharacteristic:(TGCharacteristic *)characteristic withBlock:(TGPeripheralDiscoverDescriptorsForCharacteristicBlock)block
{
    NSAssert(block, @"discoverDescriptorsForCharacteristic:withBlcok: block cannot be nil");
    [_discoverDescriptorsForCharacteristicBlocks setObject:block forKey:characteristic.UUID.UUIDString];
    [self.peripheral discoverDescriptorsForCharacteristic:characteristic.characteristic];
}

- (void)readValueForDescriptor:(TGDescriptor *)descriptor withBlock:(TGPeripheralReadValueForDescriptorsBlock)block
{
    NSAssert(block, @"readValueForDescriptor:withBlock: block cannot be nil");
    [_readValueForDescriptorsBlock setValue:block forKey:descriptor.UUID.UUIDString];
    [self.peripheral readValueForDescriptor:descriptor.descriptor];
}

- (void)writeValue:(NSData *)data forDescriptor:(TGDescriptor *)descriptor withBlock:(TGPeripheralWriteValueForDescriptorsBlock)block
{
    NSAssert(block, @"writeValue:forDescriptor:withBlock: block cannot be nil");
    [_writeValueForDescriptorsBlock setValue:block forKey:descriptor.UUID.UUIDString];
    [self.peripheral writeValue:data forDescriptor:descriptor.descriptor];
}

#pragma mark - CBPeripheralDelegate

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    if(TGPeripheralIsSelf(peripheral) && _readRSSIBlock){
        self.RSSI = peripheral.RSSI;
        _readRSSIBlock(self,self.RSSI,error);
        _readRSSIBlock = nil;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
    if(TGPeripheralIsSelf(peripheral) && _readRSSIBlock){
        self.RSSI = RSSI;
        _readRSSIBlock(self,self.RSSI,error);
        _readRSSIBlock = nil;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if(TGPeripheralIsSelf(peripheral) && _discoverServicesBlock){
        _discoverServicesBlock(self,error);
        _discoverServicesBlock = nil;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error
{
    TGPeripheralDiscoverIncludedServicesBlock block = [_discoverIncludedServicesBlocks objectForKey:service.UUID.UUIDString];
    if(TGPeripheralIsSelf(peripheral) && block){
        TGService *mService = [[TGService alloc] initWithService:service andOwnPeripheral:self];
        block(self,mService,error);
        [_discoverIncludedServicesBlocks removeObjectForKey:service.UUID.UUIDString];
    }
}
//特征值
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    TGPeripheralDiscoverCharacteristicsBlock block = [_discoverCharacteristicsBlocks objectForKey:service.UUID.UUIDString];
    if(TGPeripheralIsSelf(peripheral) && block){
        TGService *mService = [[TGService alloc] initWithService:service andOwnPeripheral:self];
        block(self, mService, error);
        [_discoverCharacteristicsBlocks removeObjectForKey:service.UUID.UUIDString];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if(TGPeripheralIsSelf(peripheral)){
        TGPeripheralReadValueForCharacteristicBlock readBlock = [_readValueForCharacteristicsBlocks objectForKey:characteristic.UUID.UUIDString];
        TGCharacteristic *mCharacteristic = [[TGCharacteristic alloc] initWithCharacteristic:characteristic andOwnPeripheral:self];
        if(readBlock){
            readBlock(self, mCharacteristic, error);
            [_readValueForCharacteristicsBlocks removeObjectForKey:characteristic.UUID.UUIDString];
        }
        TGPeripheralNotifyValueForCharacteristicsBlock notifyBlock = [_notifyValyeForCharacteristicsBlocks objectForKey:characteristic.UUID.UUIDString];
        if(notifyBlock){
            notifyBlock(self, mCharacteristic, error,_instructType);
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    TGPeripheralWriteValueForCharacteristicsBlock block = [_writeValueForCharacteristicsBlocks objectForKey:characteristic.UUID.UUIDString];
    if(TGPeripheralIsSelf(peripheral) && block){
        TGCharacteristic *mCharacteristic = [[TGCharacteristic alloc] initWithCharacteristic:characteristic andOwnPeripheral:self];
        block(self,mCharacteristic, error);
        [_writeValueForCharacteristicsBlocks removeObjectForKey:characteristic.UUID.UUIDString];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    TGPeripheralNotifyValueForCharacteristicsBlock block = [_notifyValyeForCharacteristicsBlocks objectForKey:characteristic.UUID.UUIDString];
    if(TGPeripheralIsSelf(peripheral) && block){
        TGCharacteristic *mCharacteristic = [[TGCharacteristic alloc] initWithCharacteristic:characteristic andOwnPeripheral:self];
        block(self, mCharacteristic, error,_instructType);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    TGPeripheralDiscoverDescriptorsForCharacteristicBlock block = [_discoverDescriptorsForCharacteristicBlocks objectForKey:characteristic.UUID.UUIDString];
    if(TGPeripheralIsSelf(peripheral) && block){
        TGCharacteristic *mCharacteristic = [[TGCharacteristic alloc] initWithCharacteristic:characteristic andOwnPeripheral:self];
        block(self, mCharacteristic, error);
        [_discoverDescriptorsForCharacteristicBlocks removeObjectForKey:characteristic.UUID.UUIDString];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    TGPeripheralReadValueForDescriptorsBlock block = [_readValueForDescriptorsBlock objectForKey:descriptor.UUID.UUIDString];
    if(TGPeripheralIsSelf(peripheral) && block){
        TGDescriptor *mDescriptor = [[TGDescriptor alloc] initWithDescriptor:descriptor andOwnPeripheral:self];
        block(self, mDescriptor, error);
        [_readValueForDescriptorsBlock removeObjectForKey:descriptor.UUID.UUIDString];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    TGPeripheralWriteValueForDescriptorsBlock block = [_writeValueForDescriptorsBlock objectForKey:descriptor.UUID.UUIDString];
    if(TGPeripheralIsSelf(peripheral) && block){
        TGDescriptor *mDescriptor = [[TGDescriptor alloc] initWithDescriptor:descriptor andOwnPeripheral:self];
        block(self, mDescriptor, error);
        [_writeValueForDescriptorsBlock removeObjectForKey:descriptor.UUID.UUIDString];
    }
}
- (void)dealloc{
//    DLog(@"--------dealloc--------peripheral");
}
@end

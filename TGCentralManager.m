//
//  TGCentralManager.m
//  TOGOBlutoothDemo
//
//  Created by ShuHuan on 2017/4/6.
//  Copyright © 2017年 shuhuan. All rights reserved.
//

#import "TGCentralManager.h"

@interface TGPeripheral()

@property (nonatomic, strong) CBPeripheral *peripheral;

@end

@interface TGCentralManager()<CBCentralManagerDelegate>
{
    /* didDiscoverPeripheralBlock */
    TGCentralDidDiscoverPeripheralBlock _didDiscoverPeripheralBlock;
    
     /* didConnectPeripheralBlock */
    TGCentralDidConnectPeripheralBlock _didConnectPeripheralBlock;
    
     /* didFailToConnectPeripheralBlock */
    TGCentralDidFailToConnectPeripheralBlock _didFailToConnectPeripheralBlock;
    
     /* didDisconnectPeripheralBlock */
    TGCentralDidDisconnectPeripheralBlock _didDisconnectPeripheralBlock;
}
@property (nonatomic, strong) CBCentralManager * centralManager;
@end

@implementation  TGCentralManager
- (instancetype)initWithQueue:(dispatch_queue_t)queue withMac:(nonnull NSString *)macName
{
    return [self initWithQueue:queue options:nil withMac:macName];
}

- (instancetype)initWithQueue:(dispatch_queue_t)queue options:(NSDictionary<NSString *,id> *)options withMac:(NSString *)mac
{
    self = [super init];
    if (self) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:queue options:options];
//        _discoveredPeripherals = [[NSMutableArray alloc] init];
        _macString =mac;
    }
    return self;
}
//状态
- (CBManagerState)state
{
    return _centralManager.state;
}
//搜索
- (void)scanForPeripheralsWithServices:(NSArray<CBUUID *> *)serviceUUIDs
                               options:(NSDictionary<NSString *,id> *)options
                             withBlock:(TGCentralDidDiscoverPeripheralBlock)block
{
    _didDiscoverPeripheralBlock = block;
    if (_centralManager) {
        [_centralManager scanForPeripheralsWithServices:serviceUUIDs options:options];
    }
}
//停止搜索
- (void)stopScan
{
//    [_discoveredPeripherals removeAllObjects];
    [_centralManager stopScan];
}
//连接
- (void)connectPeripheral:(TGPeripheral *)peripheral
                  options:(NSDictionary<NSString *,id> *)options
         withSuccessBlock:(TGCentralDidConnectPeripheralBlock)successBlock
      withDisConnectBlock:(nullable TGCentralDidDisconnectPeripheralBlock)disconnectBlock withDidFailToConnect:(nullable TGCentralDidFailToConnectPeripheralBlock)didFailToConnectBlock
{
    _didConnectPeripheralBlock = successBlock;
    _didDisconnectPeripheralBlock = disconnectBlock;
    _didFailToConnectPeripheralBlock =didFailToConnectBlock;
    [_centralManager connectPeripheral:peripheral.peripheral options:options];
}
//断开
- (void)cancelPeripheralConnection:(TGPeripheral *)peripheral withBlock:(TGCentralDidDisconnectPeripheralBlock)block
{
    _didDisconnectPeripheralBlock = block;
    if (peripheral) {
        [_centralManager cancelPeripheralConnection:peripheral.peripheral];
    }
}

#pragma mark - CBCentralManagerDelegate
//获取蓝牙状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    _centralManager = central;
//    [_discoveredPeripherals removeAllObjects];
    if(_updateStateBlock){
        _updateStateBlock(self,self.state);
    }
}
//成功连接
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if(_didConnectPeripheralBlock){
        _connectedPeripheral = [[TGPeripheral alloc] initWithPeripheral:peripheral];
        _didConnectPeripheralBlock(self,[[TGPeripheral alloc] initWithPeripheral:peripheral]);
    }
}
//断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if(_didDisconnectPeripheralBlock){
        _didDisconnectPeripheralBlock(self,[[TGPeripheral alloc] initWithPeripheral:peripheral],error);
    }
}
//搜索到设备
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary<NSString *,id> *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    TGPeripheral *TGeripheral = [[TGPeripheral alloc] initWithPeripheral:peripheral];
    if(_didDiscoverPeripheralBlock){
        _didDiscoverPeripheralBlock(self,TGeripheral,advertisementData,RSSI);
    }
    
    
//    if (_macString) {
//        if ([peripheral.name isEqualToString:_macString]) {// || [peripheral.name isEqualToString:@"EC72FD3C4D6E"]
//            TGPeripheral *TGeripheral = [[TGPeripheral alloc] initWithPeripheral:peripheral];
//            if(_didDiscoverPeripheralBlock){
//                _didDiscoverPeripheralBlock(self,TGeripheral,advertisementData,RSSI);
//            }
//        }
//    }
    
}
//连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if(_didFailToConnectPeripheralBlock){
        _didFailToConnectPeripheralBlock(self,[[TGPeripheral alloc] initWithPeripheral:peripheral],error);
    }
}
- (void)emptyBleAndStopWork{
    if (_centralManager) {
        _centralManager.delegate =nil;
        _centralManager =nil;
    }
}
- (void)dealloc{
    DLog(@"-------dealloc---------TGCentralManager");
}
@end

//
//  TGCentralManager.h
//  TOGOBlutoothDemo
//
//  Created by ShuHuan on 2017/4/6.
//  Copyright © 2017年 shuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "TGBluetoothBlocks.h"
#import "TGPeripheral.h"
@class TGCentralManager;

@protocol TGCentralManagerPeripheralFilter <NSObject>

- (BOOL)centralManager:(nullable TGCentralManager *)centralManager
  shouldShowPeripheral:(nullable TGPeripheral *)peripheral
     advertisementData:(nullable NSDictionary<NSString *,id> *)advertisementData;

@end

@interface TGCentralManager : NSObject
/*!
 *  @@property state
 *
 */
@property(readonly) CBManagerState state;
/*!
 *  @property updateStateBlock
 *
 *  @discussion updata the Central status
 */
@property (nonatomic, copy, nullable) TGCentralDidUpdateStateBlock updateStateBlock;
/*!
 *  @property connectedPeripheral
 *
 *  @discussion connected of Peripheral
 */
@property (nonatomic, strong, readonly, nullable) TGPeripheral *connectedPeripheral;
/*!
 *  @property discoveredPeripherals
 *
 *  @discussion discovered of Peripherals (NSMutableArray)
 */
//@property (nonatomic, strong, readonly, nullable) NSMutableArray<TGPeripheral *> *discoveredPeripherals;
/*!
 *  @property filter
 *
 *  @discussion TGCentralManagerPeripheralFilter delegate
 */
@property (nonatomic, weak, nullable) id<TGCentralManagerPeripheralFilter> filter;

@property (nonatomic, strong, nullable) NSString * macString;


/** -- Methods -- **/

/*!
 *  @Method init
 *
 *  @discussion init NS_UNAVAILABLE
 */
- (nullable instancetype)init NS_UNAVAILABLE;
/*!
 *  @Method initWithQueue
 *  @param queue init queue
 *  @discussion This method is init Central use a Queue
 */
- (nullable instancetype)initWithQueue:(nullable dispatch_queue_t)queue withMac:(nonnull NSString *)macName;
/*!
 *
 * @Method 搜索外设
 *
 */
- (void)scanForPeripheralsWithServices:(nullable NSArray<CBUUID *> *)serviceUUIDs
                               options:(nullable NSDictionary<NSString *, id> *)options
                             withBlock:(nullable TGCentralDidDiscoverPeripheralBlock)block;
/*!
 *
 * @Method 停止搜索
 *
 */
- (void)stopScan;
/*!
 *
 * @Method 蓝牙停止工作
 *
 */
- (void)emptyBleAndStopWork;
/*!
 *
 * @Method 连接外设
 *
 */
- (void)connectPeripheral:(nullable TGPeripheral *)peripheral
                  options:(nullable NSDictionary<NSString *, id> *)options
         withSuccessBlock:(nullable TGCentralDidConnectPeripheralBlock)successBlock
      withDisConnectBlock:(nullable TGCentralDidDisconnectPeripheralBlock)disconnectBlock
     withDidFailToConnect:(nullable TGCentralDidFailToConnectPeripheralBlock)didFailToConnectBlock;
/*!
 *
 * @Method 断开外设
 *
 */
- (void)cancelPeripheralConnection:(nullable TGPeripheral *)peripheral withBlock:(nullable TGCentralDidDisconnectPeripheralBlock)block;

@end

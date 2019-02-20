//
//  TGBluetoothBlocks.h
//  TOGOBlutoothDemo
//
//  Created by ShuHuan on 2017/4/6.
//  Copyright © 2017年 shuhuan. All rights reserved.
//
#import <CoreBluetooth/CoreBluetooth.h>
@class TGCentralManager;
@class TGPeripheral;
@class TGCharacteristic;
@class TGService;
@class TGDescriptor;
@class BlueToothManager;


#ifndef TGBluetoothBlocks_h
#define TGBluetoothBlocks_h

#pragma mark - about central ENUMS
/**
 * @brief 蓝牙指令
 */
typedef NS_ENUM(NSInteger, TGBleInstructType){
    TGBleNone,//无指令
    TGBleLogin,//登录
    TGBleOpenDoor, //开门
    TGBleLockDoor, //锁门
    TGBleFlash,//闪灯
    TGBlePowerStatus,//电源状态
    TGBleLightStatus,//大灯状态
    TGBleOilOn,//给油
    TGBleOilOff,//断油
    TGBleReset,//重置
    TGBleModifiPassword,//修改密码
//    TGBleAuthFail,//鉴权失效
};
/**
 * @brief 蓝牙版本
 */
typedef NS_ENUM(NSInteger, TGBleVersion){
    TGBleNewVersion,//新版本
    TGBleOldVersion, //就版本
};
#pragma mark - about central blocks
/**
 ---------------------------------------------------------------------------------------------
 about central blocks
 ---------------------------------------------------------------------------------------------
 */

/** Central manager did discover Peripheral Block */
typedef void (^TGCentralDidDiscoverPeripheralBlock)(TGCentralManager *centralManager,TGPeripheral *peripheral,NSDictionary *advertisementData,NSNumber *RSSI);

/** Central did connect peripheral block */
typedef void (^TGCentralDidConnectPeripheralBlock)(TGCentralManager *centralManager,TGPeripheral *peripheral);

/** central did disconnect peripheral block */
typedef void (^TGCentralDidDisconnectPeripheralBlock)(TGCentralManager *centralManager,TGPeripheral *peripheral,NSError *error);

/** central did update state block */
typedef void (^TGCentralDidUpdateStateBlock)(TGCentralManager *centralManager,CBManagerState state);

/** central did fail to connect peripheral block */
typedef void (^TGCentralDidFailToConnectPeripheralBlock)(TGCentralManager *centralManager,TGPeripheral *peripheral,NSError *error);



#pragma mark - about peripheral blocks

/**
 ---------------------------------------------------------------------------------------------
 about peripheral blocks
 ---------------------------------------------------------------------------------------------
 */

/** Discovered Services Block */
typedef void (^TGPeripheralDiscoverServicesBlock)(TGPeripheral *peripheral, NSError *error);

/** Discovered Included Services Block */
typedef void (^TGPeripheralDiscoverIncludedServicesBlock)(TGPeripheral *peripheral,TGService *service, NSError *error);

/** Discovered Characteristics Block */
typedef void (^TGPeripheralDiscoverCharacteristicsBlock)(TGPeripheral *peripheral,TGService *service,NSError *error);

/** Read Value For Characteristic Block */
typedef void (^TGPeripheralReadValueForCharacteristicBlock)(TGPeripheral *peripheral,TGCharacteristic *characteristic,NSError *error);

/** Writed Value For Characteristics Block */
typedef void (^TGPeripheralWriteValueForCharacteristicsBlock)(TGPeripheral *peripheral,TGCharacteristic *characteristic,NSError *error);

/** Notified Value For Characteristics Block */
typedef void (^TGPeripheralNotifyValueForCharacteristicsBlock)(TGPeripheral *peripheral,TGCharacteristic *characteristic,NSError *error,TGBleInstructType type);
///** Notified Value For Characteristics Block */
//typedef void (^TGPeripheralNotifyValueForCharacteristicsBlock)( TGPeripheral * __nonnull  peripheral,TGCharacteristic * __nonnull characteristic,NSError * _Nullable error,TGBleInstructType type);

/** Discovered Descriptors For Characteristic Block */
typedef void (^TGPeripheralDiscoverDescriptorsForCharacteristicBlock)(TGPeripheral *peripheral,TGCharacteristic *service,NSError *error);

/** Read Value For DescriptorsBlock */
typedef void (^TGPeripheralReadValueForDescriptorsBlock)(TGPeripheral *peripheral,TGDescriptor *descriptor,NSError *error);

/** Writed Value For Descriptors Block */
typedef void (^TGPeripheralWriteValueForDescriptorsBlock)(TGPeripheral *peripheral,TGDescriptor *descriptor,NSError *error);

/** Red RSSI Block */
typedef void (^TGPeripheralRedRSSIBlock)(TGPeripheral *peripheral,NSNumber *RSSI, NSError *error);
#endif /* TGBluetoothBlocks_h */

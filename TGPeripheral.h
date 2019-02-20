//
//  TGPeripheral.h
//  TOGOBlutoothDemo
//
//  Created by ShuHuan on 2017/4/6.
//  Copyright © 2017年 shuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "TGBluetoothBlocks.h"

@class TGPeripheral;
@class TGCharacteristic;
@class TGDescriptor;
@class TGService;
/*!
 *  @class MPPeripheral
 *
 *  @discussion Represents a peripheral.
 */
NS_CLASS_AVAILABLE(NA, 7_0)
@interface TGPeripheral : NSObject

/*!
 *  @property identifier
 *
 *  @discussion The unique, persistent identifier associated with the peripheral.
 */
@property(readonly, nonatomic, nullable) NSUUID *identifier NS_AVAILABLE(NA, 7_0);

/*!
 *  @property name
 *
 *  @discussion The name of the peripheral.
 */
@property(retain, readonly, nullable) NSString *name;

/*!
 *  @property state
 *
 *  @discussion The current connection state of the peripheral.
 */
@property(readonly) CBPeripheralState state;

/*!
 *  @property services
 *
 *  @discussion A list of <code>CBService</code> objects that have been discovered on the peripheral.
 */
@property(retain, readonly, nullable) NSArray<TGService *> *services;

/*!
 *  @property RSSI
 *
 *  @discussion The most recently read RSSI, in decibels.
 */
@property(retain, readonly, nullable) NSNumber *RSSI;
/*!
 *  @property instructType
 *
 *  @discussion Bluetooth instruction enum.
 */
@property(nonatomic,assign)TGBleInstructType instructType;
/*!
 *  @property versionType
 *
 *  @discussion Bluetooth version enum.
 */
@property(nonatomic, assign)TGBleVersion versionType;
/*!
 *  @property versionNo
 *
 *  @discussion Bluetooth version.
 */
@property(retain, readonly, nullable)NSNumber *versionNo;

- (nullable instancetype)init NS_UNAVAILABLE;

/*!
 *  @method initWithPeripheral:
 *
 *  @discussion Create a perpheral with CBPeripheral. and this is the only way to initial a perpheral.
 */
- (nullable instancetype)initWithPeripheral:(nullable CBPeripheral *)peripheral;

/*!
 *  @method readRSSI:
 *
 *	@discussion While connected, retrieves the current RSSI of the link.
 *
 *  @see		MPPeripheralRedRSSIBlock
 */
- (void)readRSSI:(nullable TGPeripheralRedRSSIBlock)block;

/*!
 *  @method discoverServices:withBlock:
 *
 *  @param serviceUUIDs A list of <code>CBUUID</code> objects representing the service types to be discovered. If <i>nil</i>,
 *						all services will be discovered, which is considerably slower and not recommended.
 *  @param block        callback with this block,(MPPeripheral *peripheral, NSError *error)
 *
 *  @discussion			Discovers available service(s) on the peripheral.
 *
 *  @see						MPPeripheralDiscoverServicesBlock
 */
- (void)discoverServices:(nullable NSArray<CBUUID *> *)serviceUUIDs withBlock:(nullable TGPeripheralDiscoverServicesBlock)block;

/*!
 *  @method discoverIncludedServices:forService:withBlock:
 *
 *  @param includedServiceUUIDs A list of <code>CBUUID</code> objects representing the included service types to be discovered. If <i>nil</i>,
 *								all of <i>service</i>s included services will be discovered, which is considerably slower and not recommended.
 *  @param service				A GATT service.
 *  @param block                callback with this block,(MPPeripheral *peripheral,CBService *service, NSError *error)
 *
 *  @discussion					Discovers the specified included service(s) of <i>service</i>.
 *
 *  @see						MPPeripheralDiscoverIncludedServicesBlock
 */
- (void)discoverIncludedServices:(nullable NSArray<CBUUID *> *)includedServiceUUIDs
                      forService:(nullable TGService *)service
                       withBlock:(nullable TGPeripheralDiscoverIncludedServicesBlock)block;

/*!
 *  @method discoverCharacteristics:forService:withBlock:
 *
 *  @param characteristicUUIDs	A list of <code>CBUUID</code> objects representing the characteristic types to be discovered. If <i>nil</i>,
 *								all characteristics of <i>service</i> will be discovered, which is considerably slower and not recommended.
 *  @param service				A GATT service.
 *  @param block                callback with this block,(MPPeripheral *peripheral,CBService *service,NSError *error)
 *
 *  @discussion					Discovers the specified characteristic(s) of <i>service</i>.
 *
 *  @see						MPPeripheralDiscoverCharacteristicsBlock
 */
- (void)discoverCharacteristics:(nullable NSArray<CBUUID *> *)characteristicUUIDs
                     forService:(nullable TGService *)service
                      withBlock:(nullable TGPeripheralDiscoverCharacteristicsBlock)block;

/*!
 *  @method readValueForCharacteristic:withBlock:
 *
 *  @param characteristic	A GATT characteristic.
 *  @param block            callback with this block,(MPPeripheral *peripheral,MPharacteristic *characteristic,NSError *error)
 *
 *  @discussion				Reads the characteristic value for <i>characteristic</i>.
 *
 *  @see					MPPeripheralReadValueForCharacteristicBlock
 */
- (void)readValueForCharacteristic:(nullable TGCharacteristic *)characteristic withBlock:(nullable TGPeripheralReadValueForCharacteristicBlock)block;

/*!
 *  @method writeValue:forCharacteristic:type:withBlock:
 *
 *  @param data				The value to write.
 *  @param characteristic	The characteristic whose characteristic value will be written.
 *  @param type				The type of write to be executed.
 *  @param block            callback with this block;
 *
 *  @discussion				Writes <i>value</i> to <i>characteristic</i>'s characteristic value.
 *							If the <code>CBCharacteristicWriteWithResponse</code> type is specified, {@link peripheral:didWriteValueForCharacteristic:error:}
 *							is called with the result of the write request.
 *							If the <code>CBCharacteristicWriteWithoutResponse</code> type is specified, the delivery of the data is best-effort and not
 *							guaranteed.
 *
 *	@see					CBCharacteristicWriteType
 */
- (void)writeValue:(nullable NSData *)data
 forCharacteristic:(nullable TGCharacteristic *)characteristic
              type:(CBCharacteristicWriteType)type  withBlock:(TGBleInstructType)instructType
         withBlock:(nullable TGPeripheralWriteValueForCharacteristicsBlock)block;

/*!
 *  @method setNotifyValue:forCharacteristic:withBlock:
 *
 *  @param enabled			Whether or not notifications/indications should be enabled.
 *  @param characteristic	The characteristic containing the client characteristic configuration descriptor.
 *  @param block            callback with this block
 *
 *  @discussion				Enables or disables notifications/indications for the characteristic value of <i>characteristic</i>. If <i>characteristic</i>
 *							allows both, notifications will be used.
 *                          When notifications/indications are enabled, updates to the characteristic value will be received via block.
 *                          Since it is the peripheral that chooses when to send an update,
 *                          the application should be prepared to handle them as long as notifications/indications remain enabled.
 *
 *  @see					MPPeripheralNotifyValueForCharacteristicsBlock
 *  @seealso                CBConnectPeripheralOptionNotifyOnNotificationKey
 */
- (void)setNotifyValue:(BOOL)enabled
     forCharacteristic:(nullable TGCharacteristic *)characteristic
             withBlock:(nullable TGPeripheralNotifyValueForCharacteristicsBlock)block;// withBlock:(TGBleInstructType)instructType

/*!
 *  @method discoverDescriptorsForCharacteristic:withBlcok:
 *
 *  @param characteristic	A GATT characteristic.
 *  @param block            callback with this block;
 *
 *  @discussion				Discovers the characteristic descriptor(s) of <i>characteristic</i>.
 *
 *  @see                    MPPeripheralDiscoverDescriptorsForCharacteristicBlock
 */
- (void)discoverDescriptorsForCharacteristic:(nullable TGCharacteristic *)characteristic
                                   withBlock:(nullable TGPeripheralDiscoverDescriptorsForCharacteristicBlock)block;

/*!
 *  @method readValueForDescriptor:withBlock:
 *
 *  @param descriptor	A GATT characteristic descriptor.
 *  @param block        callback with this block.
 *
 *  @discussion			Reads the value of <i>descriptor</i>.
 *
 *  @see                MPPeripheralReadValueForDescriptorsBlock
 */
- (void)readValueForDescriptor:(nullable TGDescriptor *)descriptor withBlock:(nullable TGPeripheralReadValueForDescriptorsBlock)block;

/*!
 *  @method writeValue:forDescriptor:withBlock:
 *
 *  @param data			The value to write.
 *  @param descriptor	A GATT characteristic descriptor.
 *  @param block        callback with this block.
 *
 *  @discussion			Writes <i>data</i> to <i>descriptor</i>'s value. Client characteristic configuration descriptors cannot be written using
 *						this method, and should instead use @link setNotifyValue:forCharacteristic: @/link.
 *
 *  @see                MPPeripheralReadValueForDescriptorsBlock
 */
- (void)writeValue:(nullable NSData *)data
     forDescriptor:(nullable TGDescriptor *)descriptor
         withBlock:(nullable TGPeripheralWriteValueForDescriptorsBlock)block;
@end

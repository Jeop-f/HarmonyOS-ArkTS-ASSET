import { asset } from '@kit.AssetStoreKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { LogUtil } from 'zcommon';
import { util } from '@kit.ArkTS';


function stringToArray(str: string): Uint8Array {
  let textEncoder = new util.TextEncoder();
  return textEncoder.encodeInto(str);
}

function arrayToString(arr: Uint8Array): string {
  let textDecoder = util.TextDecoder.create("utf-8", { ignoreBOM: true });
  let str = textDecoder.decodeToString(arr, { stream: false })
  return str;
}


export class AssetUtil {
  /**
   * 检查当前设备是否支持该模块
   * @returns 是否支持
   */
  static canIUse(): boolean {
    return canIUse('SystemCapability.Security.Asset');
  }

  /**
   * 创建通用的资产属性映射
   * @param key 资产别名
   * @param value 资产明文
   * @param e10 是否持久化
   * @returns 资产属性映射
   */
  private static createAssetMap(key: string, value: string, e10: boolean = true): asset.AssetMap {
    const attr = new Map<asset.Tag, Uint8Array | asset.SyncType | asset.ConflictResolution | boolean>();
    attr.set(asset.Tag.ALIAS, stringToArray(key));
    attr.set(asset.Tag.SECRET, stringToArray(value));
    attr.set(asset.Tag.SYNC_TYPE, asset.SyncType.THIS_DEVICE);
    attr.set(asset.Tag.CONFLICT_RESOLUTION, asset.ConflictResolution.OVERWRITE); // 冲突时覆盖原有资产
    /*
     *元服务不支持此API
     */

    /*if (e10) {
      attr.set(asset.Tag.IS_PERSISTENT, e10); // 应用卸载时是否保留资产
    }*/
    return attr;
  }

  /**
   * 创建查询条件
   * @param key 资产别名
   * @returns 查询条件映射
   */
  private static createQuery(key: string, isRemove: boolean = false): asset.AssetMap {
    const query = new Map<asset.Tag, Uint8Array | asset.ReturnType>();
    query.set(asset.Tag.ALIAS, stringToArray(key));
    if (!isRemove) {
      query.set(asset.Tag.RETURN_TYPE, asset.ReturnType.ALL);
    }
    return query;
  }

  /**
   * 提取资产密文
   * @param result 查询结果
   * @returns 资产明文
   */
  private static extractSecret(result: asset.AssetMap[]): string {
    if (!result || result.length < 1) {
      return '';
    }
    const map = result[0];
    const secret = map.get(asset.Tag.SECRET) as Uint8Array;
    return secret ? arrayToString(secret) : '';
  }

  /**
   * 新增一条关键资产（异步）
   * @param key 资产别名
   * @param value 资产明文
   * @param e10 是否持久化
   * @returns 操作结果
   */
  static async add(key: string, value: string, e10: boolean = true): Promise<boolean> {
    try {
      if (!AssetUtil.canIUse()) {
        LogUtil.e('AssetStore-当前设备不支持该模块');
        return false;
      }
      const attr = AssetUtil.createAssetMap(key, value, e10);
      await asset.add(attr);
      return true;
    } catch (err) {
      const error = err as BusinessError;
      LogUtil.e(`AssetStore-add-异常 ~ code: ${error.code} -·- message: ${error.message}`);
      return false;
    }
  }

  /**
   * 新增一条关键资产（同步）
   * @param key 资产别名
   * @param value 资产明文
   * @param e10 是否持久化
   * @returns 操作结果
   */
  static addSync(key: string, value: string, e10: boolean = true): boolean {
    try {
      if (!AssetUtil.canIUse()) {
        LogUtil.e('AssetStore-当前设备不支持该模块');
        return false;
      }
      const attr = AssetUtil.createAssetMap(key, value, e10);
      asset.addSync(attr);
      return true;
    } catch (err) {
      const error = err as BusinessError;
      LogUtil.e(`AssetStore-addSync-异常 ~ code: ${error.code} -·- message: ${error.message}`);
      return false;
    }
  }

  /**
   * 查询关键资产（异步）
   * @param key 资产别名
   * @returns 查询结果
   */
  static async get(key: string): Promise<string> {
    try {
      if (!AssetUtil.canIUse()) {
        LogUtil.e('AssetStore-当前设备不支持该模块');
        return '';
      }
      const query = AssetUtil.createQuery(key);
      const result = await asset.query(query);
      return AssetUtil.extractSecret(result);
    } catch (err) {
      const error = err as BusinessError;
      LogUtil.e(`AssetStore-get-异常 ~ code: ${error.code} -·- message: ${error.message}`);
      return '';
    }
  }

  /**
   * 查询关键资产（同步）
   * @param key 资产别名
   * @returns 查询结果
   */
  static getSync(key: string): string {
    try {
      if (!AssetUtil.canIUse()) {
        LogUtil.e('AssetStore-当前设备不支持该模块');
        return '';
      }
      const query = AssetUtil.createQuery(key);
      const result = asset.querySync(query);
      return AssetUtil.extractSecret(result);
    } catch (err) {
      const error = err as BusinessError;
      LogUtil.e(`AssetStore-getSync-异常 ~ code: ${error.code} -·- message: ${error.message}`);
      return '';
    }
  }

  /**
   * 删除关键资产（异步）
   * @param key 资产别名
   * @returns 操作结果
   */
  static async remove(key: string): Promise<boolean> {
    try {
      if (!AssetUtil.canIUse()) {
        LogUtil.e('AssetStore-当前设备不支持该模块');
        return false;
      }
      const query = AssetUtil.createQuery(key, true);
      await asset.remove(query);
      return true;
    } catch (err) {
      const error = err as BusinessError;
      LogUtil.e(`AssetStore-remove-异常 ~ code: ${error.code} -·- message: ${error.message}`);
      return false;
    }
  }

  /**
   * 删除关键资产（同步）
   * @param key 资产别名
   * @returns 操作结果
   */
  static removeSync(key: string): boolean {
    try {
      if (!AssetUtil.canIUse()) {
        LogUtil.e('AssetStore-当前设备不支持该模块');
        return false;
      }
      const query = AssetUtil.createQuery(key, true);
      asset.removeSync(query);
      return true;
    } catch (err) {
      const error = err as BusinessError;
      LogUtil.e(`AssetStore-removeSync-异常 ~ code: ${error.code} -·- message: ${error.message}`);
      return false;
    }
  }
}
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

  static canIUse(): boolean {
    return canIUse('SystemCapability.Security.Asset');
  }

  private static createAssetMap(key: string, value: string, e10: boolean = true): asset.AssetMap {
    const attr = new Map<asset.Tag, Uint8Array | asset.SyncType | asset.ConflictResolution | boolean>();
    attr.set(asset.Tag.ALIAS, stringToArray(key));
    attr.set(asset.Tag.SECRET, stringToArray(value));
    attr.set(asset.Tag.SYNC_TYPE, asset.SyncType.THIS_DEVICE);
    attr.set(asset.Tag.CONFLICT_RESOLUTION, asset.ConflictResolution.OVERWRITE); // 冲突时覆盖原有资产
    /*
     *The meta-service does not support this API.
     */

    /*if (e10) {
      attr.set(asset.Tag.IS_PERSISTENT, e10); // Whether to keep assets when uninstalling the app
    }*/
    return attr;
  }


  private static createQuery(key: string, isRemove: boolean = false): asset.AssetMap {
    const query = new Map<asset.Tag, Uint8Array | asset.ReturnType>();
    query.set(asset.Tag.ALIAS, stringToArray(key));
    if (!isRemove) {
      query.set(asset.Tag.RETURN_TYPE, asset.ReturnType.ALL);
    }
    return query;
  }


  private static extractSecret(result: asset.AssetMap[]): string {
    if (!result || result.length < 1) {
      return '';
    }
    const map = result[0];
    const secret = map.get(asset.Tag.SECRET) as Uint8Array;
    return secret ? arrayToString(secret) : '';
  }

  static async add(key: string, value: string, e10: boolean = true): Promise<boolean> {
    try {
      if (!AssetUtil.canIUse()) {
        LogUtil.e('AssetStore-The current device does not support this module');
        return false;
      }
      const attr = AssetUtil.createAssetMap(key, value, e10);
      await asset.add(attr);
      return true;
    } catch (err) {
      const error = err as BusinessError;
      LogUtil.e(`AssetStore-add-error~ code: ${error.code} -·- message: ${error.message}`);
      return false;
    }
  }


  static addSync(key: string, value: string, e10: boolean = true): boolean {
    try {
      if (!AssetUtil.canIUse()) {
        LogUtil.e('AssetStore-The current device does not support this module');
        return false;
      }
      const attr = AssetUtil.createAssetMap(key, value, e10);
      asset.addSync(attr);
      return true;
    } catch (err) {
      const error = err as BusinessError;
      LogUtil.e(`AssetStore-addSync-error ~ code: ${error.code} -·- message: ${error.message}`);
      return false;
    }
  }


  static async get(key: string): Promise<string> {
    try {
      if (!AssetUtil.canIUse()) {
        LogUtil.e('AssetStore-The current device does not support this module');
        return '';
      }
      const query = AssetUtil.createQuery(key);
      const result = await asset.query(query);
      return AssetUtil.extractSecret(result);
    } catch (err) {
      const error = err as BusinessError;
      LogUtil.e(`AssetStore-get-error~ code: ${error.code} -·- message: ${error.message}`);
      return '';
    }
  }

  static getSync(key: string): string {
    try {
      if (!AssetUtil.canIUse()) {
        LogUtil.e('AssetStore-The current device does not support this module.');
        return '';
      }
      const query = AssetUtil.createQuery(key);
      const result = asset.querySync(query);
      return AssetUtil.extractSecret(result);
    } catch (err) {
      const error = err as BusinessError;
      LogUtil.e(`AssetStore-getSync-error ~ code: ${error.code} -·- message: ${error.message}`);
      return '';
    }
  }

  static async remove(key: string): Promise<boolean> {
    try {
      if (!AssetUtil.canIUse()) {
        LogUtil.e('AssetStore-The current device does not support this module.');
        return false;
      }
      const query = AssetUtil.createQuery(key, true);
      await asset.remove(query);
      return true;
    } catch (err) {
      const error = err as BusinessError;
      LogUtil.e(`AssetStore-remove-error~ code: ${error.code} -·- message: ${error.message}`);
      return false;
    }
  }



  static removeSync(key: string): boolean {
    try {
      if (!AssetUtil.canIUse()) {
        LogUtil.e('AssetStore-The current device does not support this module.');
        return false;
      }
      const query = AssetUtil.createQuery(key, true);
      asset.removeSync(query);
      return true;
    } catch (err) {
      const error = err as BusinessError;
      LogUtil.e(`AssetStore-removeSync-error~ code: ${error.code} -·- message: ${error.message}`);
      return false;
    }
  }
}

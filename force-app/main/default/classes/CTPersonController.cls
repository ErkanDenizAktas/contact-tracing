public with sharing class CTPersonController {
  public static string getToken(String mobileNumber){
    Blob value = Blob.valueOf(mobileNumber);
    Blob hash = Crypto.generateDigest('MD5', value);

    //string sonuc
    return EncodingUtil.base64encode(hash);
  }
}
enum BaseUrl { local, staging, live }

extension BaseUrlExtention on BaseUrl {
  String get url {
    switch (this) {
      case BaseUrl.local:
        return 'http://192.168.29.223:8080/';
      case BaseUrl.staging:
        return 'https://staging-advisorykp.amnex.co.in/';
      case BaseUrl.live:
        return 'https://advisory.krushipragati.co.in/';
    }
  }
}

enum UrlEndPoint {
  login,
  register,
  saveInventoryItem,
  inventoryItemList,
  addCustomerDetailsOrCheck,
  saveBill,
}

extension UrlEndPointExtention on UrlEndPoint {
  String get stringValue {
    switch (this) {
      // Auth
      case UrlEndPoint.login:
        return "auth/login";
      case UrlEndPoint.register:
        return "auth/register";
      case UrlEndPoint.saveInventoryItem:
        return "api/products/save";
      case UrlEndPoint.inventoryItemList:
        return "api/products/user/";
      case UrlEndPoint.addCustomerDetailsOrCheck:
        return "api/customers/save";
      case UrlEndPoint.saveBill:
        return "api/bills/save";
    }
  }
}

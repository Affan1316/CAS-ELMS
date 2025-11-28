enum WebViewPageType { privacyPolicy, termsAndConditions }

extension WebViewPageTypeUrl on WebViewPageType {
  String get url {
    switch (this) {
      case WebViewPageType.privacyPolicy:
        return "https://sites.google.com/view/cas-privacy-policy-page/home";
      case WebViewPageType.termsAndConditions:
        return "https://sites.google.com/view/cas-term-of-use/home";
    }
  }

  String get title {
    switch (this) {
      case WebViewPageType.privacyPolicy:
        return "Privacy Policy";
      case WebViewPageType.termsAndConditions:
        return "Terms & Conditions";
    }
  }
}

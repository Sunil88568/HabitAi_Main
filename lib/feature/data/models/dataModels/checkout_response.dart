

class CheckoutResponse {
  int? statusCode;
  String? message;
  Data? data;

  CheckoutResponse({this.statusCode, this.message, this.data});

  CheckoutResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? object;
  AdaptivePricing? adaptivePricing;
  Null? afterExpiration;
  Null? allowPromotionCodes;
  int? amountSubtotal;
  int? amountTotal;
  AutomaticTax? automaticTax;
  Null? billingAddressCollection;
  String? cancelUrl;
  Null? clientReferenceId;
  Null? clientSecret;
  Null? collectedInformation;
  Null? consent;
  Null? consentCollection;
  int? created;
  String? currency;
  Null? currencyConversion;
  CustomText? customText;
  Null? customer;
  String? customerCreation;
  Null? customerDetails;
  Null? customerEmail;
  int? expiresAt;
  Null? invoice;
  InvoiceCreation? invoiceCreation;
  bool? livemode;
  Null? locale;
  Metadata? metadata;
  String? mode;
  Null? paymentIntent;
  Null? paymentLink;
  String? paymentMethodCollection;
  Null? paymentMethodConfigurationDetails;
  PaymentMethodOptions? paymentMethodOptions;
  List<String>? paymentMethodTypes;
  String? paymentStatus;
  Null? permissions;
  AdaptivePricing? phoneNumberCollection;
  Null? recoveredFrom;
  Null? savedPaymentMethodOptions;
  Null? setupIntent;
  Null? shippingAddressCollection;
  Null? shippingCost;
  Null? shippingDetails;
  String? status;
  Null? submitType;
  Null? subscription;
  String? successUrl;
  TotalDetails? totalDetails;
  String? uiMode;
  String? url;
  Null? walletOptions;

  Data(
      {this.id,
        this.object,
        this.adaptivePricing,
        this.afterExpiration,
        this.allowPromotionCodes,
        this.amountSubtotal,
        this.amountTotal,
        this.automaticTax,
        this.billingAddressCollection,
        this.cancelUrl,
        this.clientReferenceId,
        this.clientSecret,
        this.collectedInformation,
        this.consent,
        this.consentCollection,
        this.created,
        this.currency,
        this.currencyConversion,
        this.customText,
        this.customer,
        this.customerCreation,
        this.customerDetails,
        this.customerEmail,
        this.expiresAt,
        this.invoice,
        this.invoiceCreation,
        this.livemode,
        this.locale,
        this.metadata,
        this.mode,
        this.paymentIntent,
        this.paymentLink,
        this.paymentMethodCollection,
        this.paymentMethodConfigurationDetails,
        this.paymentMethodOptions,
        this.paymentMethodTypes,
        this.paymentStatus,
        this.permissions,
        this.phoneNumberCollection,
        this.recoveredFrom,
        this.savedPaymentMethodOptions,
        this.setupIntent,
        this.shippingAddressCollection,
        this.shippingCost,
        this.shippingDetails,
        this.status,
        this.submitType,
        this.subscription,
        this.successUrl,
        this.totalDetails,
        this.uiMode,
        this.url,
        this.walletOptions});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    object = json['object'];
    adaptivePricing = json['adaptive_pricing'] != null
        ? new AdaptivePricing.fromJson(json['adaptive_pricing'])
        : null;
    afterExpiration = json['after_expiration'];
    allowPromotionCodes = json['allow_promotion_codes'];
    amountSubtotal = json['amount_subtotal'];
    amountTotal = json['amount_total'];
    automaticTax = json['automatic_tax'] != null
        ? new AutomaticTax.fromJson(json['automatic_tax'])
        : null;
    billingAddressCollection = json['billing_address_collection'];
    cancelUrl = json['cancel_url'];
    clientReferenceId = json['client_reference_id'];
    clientSecret = json['client_secret'];
    collectedInformation = json['collected_information'];
    consent = json['consent'];
    consentCollection = json['consent_collection'];
    created = json['created'];
    currency = json['currency'];
    currencyConversion = json['currency_conversion'];
    customText = json['custom_text'] != null
        ? new CustomText.fromJson(json['custom_text'])
        : null;
    customer = json['customer'];
    customerCreation = json['customer_creation'];
    customerDetails = json['customer_details'];
    customerEmail = json['customer_email'];
    expiresAt = json['expires_at'];
    invoice = json['invoice'];
    invoiceCreation = json['invoice_creation'] != null
        ? new InvoiceCreation.fromJson(json['invoice_creation'])
        : null;
    livemode = json['livemode'];
    locale = json['locale'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
    mode = json['mode'];
    paymentIntent = json['payment_intent'];
    paymentLink = json['payment_link'];
    paymentMethodCollection = json['payment_method_collection'];
    paymentMethodConfigurationDetails =
    json['payment_method_configuration_details'];
    paymentMethodOptions = json['payment_method_options'] != null
        ? new PaymentMethodOptions.fromJson(json['payment_method_options'])
        : null;
    paymentMethodTypes = json['payment_method_types'].cast<String>();
    paymentStatus = json['payment_status'];
    permissions = json['permissions'];
    phoneNumberCollection = json['phone_number_collection'] != null
        ? new AdaptivePricing.fromJson(json['phone_number_collection'])
        : null;
    recoveredFrom = json['recovered_from'];
    savedPaymentMethodOptions = json['saved_payment_method_options'];
    setupIntent = json['setup_intent'];
    shippingAddressCollection = json['shipping_address_collection'];
    shippingCost = json['shipping_cost'];
    shippingDetails = json['shipping_details'];
    status = json['status'];
    submitType = json['submit_type'];
    subscription = json['subscription'];
    successUrl = json['success_url'];
    totalDetails = json['total_details'] != null
        ? new TotalDetails.fromJson(json['total_details'])
        : null;
    uiMode = json['ui_mode'];
    url = json['url'];
    walletOptions = json['wallet_options'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['object'] = this.object;
    if (this.adaptivePricing != null) {
      data['adaptive_pricing'] = this.adaptivePricing!.toJson();
    }
    data['after_expiration'] = this.afterExpiration;
    data['allow_promotion_codes'] = this.allowPromotionCodes;
    data['amount_subtotal'] = this.amountSubtotal;
    data['amount_total'] = this.amountTotal;
    if (this.automaticTax != null) {
      data['automatic_tax'] = this.automaticTax!.toJson();
    }
    data['billing_address_collection'] = this.billingAddressCollection;
    data['cancel_url'] = this.cancelUrl;
    data['client_reference_id'] = this.clientReferenceId;
    data['client_secret'] = this.clientSecret;
    data['collected_information'] = this.collectedInformation;
    data['consent'] = this.consent;
    data['consent_collection'] = this.consentCollection;
    data['created'] = this.created;
    data['currency'] = this.currency;
    data['currency_conversion'] = this.currencyConversion;
    if (this.customText != null) {
      data['custom_text'] = this.customText!.toJson();
    }
    data['customer'] = this.customer;
    data['customer_creation'] = this.customerCreation;
    data['customer_details'] = this.customerDetails;
    data['customer_email'] = this.customerEmail;
    data['expires_at'] = this.expiresAt;
    data['invoice'] = this.invoice;
    if (this.invoiceCreation != null) {
      data['invoice_creation'] = this.invoiceCreation!.toJson();
    }
    data['livemode'] = this.livemode;
    data['locale'] = this.locale;
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    data['mode'] = this.mode;
    data['payment_intent'] = this.paymentIntent;
    data['payment_link'] = this.paymentLink;
    data['payment_method_collection'] = this.paymentMethodCollection;
    data['payment_method_configuration_details'] =
        this.paymentMethodConfigurationDetails;
    if (this.paymentMethodOptions != null) {
      data['payment_method_options'] = this.paymentMethodOptions!.toJson();
    }
    data['payment_method_types'] = this.paymentMethodTypes;
    data['payment_status'] = this.paymentStatus;
    data['permissions'] = this.permissions;
    if (this.phoneNumberCollection != null) {
      data['phone_number_collection'] = this.phoneNumberCollection!.toJson();
    }
    data['recovered_from'] = this.recoveredFrom;
    data['saved_payment_method_options'] = this.savedPaymentMethodOptions;
    data['setup_intent'] = this.setupIntent;
    data['shipping_address_collection'] = this.shippingAddressCollection;
    data['shipping_cost'] = this.shippingCost;
    data['shipping_details'] = this.shippingDetails;
    data['status'] = this.status;
    data['submit_type'] = this.submitType;
    data['subscription'] = this.subscription;
    data['success_url'] = this.successUrl;
    if (this.totalDetails != null) {
      data['total_details'] = this.totalDetails!.toJson();
    }
    data['ui_mode'] = this.uiMode;
    data['url'] = this.url;
    data['wallet_options'] = this.walletOptions;
    return data;
  }
}

class AdaptivePricing {
  bool? enabled;

  AdaptivePricing({this.enabled});

  AdaptivePricing.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['enabled'] = this.enabled;
    return data;
  }
}

class AutomaticTax {
  bool? enabled;
  Null? liability;
  Null? provider;
  Null? status;

  AutomaticTax({this.enabled, this.liability, this.provider, this.status});

  AutomaticTax.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
    liability = json['liability'];
    provider = json['provider'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['enabled'] = this.enabled;
    data['liability'] = this.liability;
    data['provider'] = this.provider;
    data['status'] = this.status;
    return data;
  }
}

class CustomText {
  Null? afterSubmit;
  Null? shippingAddress;
  Null? submit;
  Null? termsOfServiceAcceptance;

  CustomText(
      {this.afterSubmit,
        this.shippingAddress,
        this.submit,
        this.termsOfServiceAcceptance});

  CustomText.fromJson(Map<String, dynamic> json) {
    afterSubmit = json['after_submit'];
    shippingAddress = json['shipping_address'];
    submit = json['submit'];
    termsOfServiceAcceptance = json['terms_of_service_acceptance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['after_submit'] = this.afterSubmit;
    data['shipping_address'] = this.shippingAddress;
    data['submit'] = this.submit;
    data['terms_of_service_acceptance'] = this.termsOfServiceAcceptance;
    return data;
  }
}

class InvoiceCreation {
  bool? enabled;
  InvoiceData? invoiceData;

  InvoiceCreation({this.enabled, this.invoiceData});

  InvoiceCreation.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
    invoiceData = json['invoice_data'] != null
        ? new InvoiceData.fromJson(json['invoice_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['enabled'] = this.enabled;
    if (this.invoiceData != null) {
      data['invoice_data'] = this.invoiceData!.toJson();
    }
    return data;
  }
}

class InvoiceData {
  Null? accountTaxIds;
  Null? customFields;
  Null? description;
  Null? footer;
  Null? issuer;
  Null? renderingOptions;

  InvoiceData(
      {this.accountTaxIds,
        this.customFields,
        this.description,
        this.footer,
        this.issuer,
        this.renderingOptions});

  InvoiceData.fromJson(Map<String, dynamic> json) {
    accountTaxIds = json['account_tax_ids'];
    customFields = json['custom_fields'];
    description = json['description'];
    footer = json['footer'];
    issuer = json['issuer'];
    renderingOptions = json['rendering_options'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account_tax_ids'] = this.accountTaxIds;
    data['custom_fields'] = this.customFields;
    data['description'] = this.description;
    data['footer'] = this.footer;
    data['issuer'] = this.issuer;
    data['rendering_options'] = this.renderingOptions;
    return data;
  }
}

class Metadata {
  String? userId;

  Metadata({this.userId});

  Metadata.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    return data;
  }
}

class PaymentMethodOptions {
  Card? card;

  PaymentMethodOptions({this.card});

  PaymentMethodOptions.fromJson(Map<String, dynamic> json) {
    card = json['card'] != null ? new Card.fromJson(json['card']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.card != null) {
      data['card'] = this.card!.toJson();
    }
    return data;
  }
}

class Card {
  String? requestThreeDSecure;

  Card({this.requestThreeDSecure});

  Card.fromJson(Map<String, dynamic> json) {
    requestThreeDSecure = json['request_three_d_secure'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request_three_d_secure'] = this.requestThreeDSecure;
    return data;
  }
}

class TotalDetails {
  int? amountDiscount;
  int? amountShipping;
  int? amountTax;

  TotalDetails({this.amountDiscount, this.amountShipping, this.amountTax});

  TotalDetails.fromJson(Map<String, dynamic> json) {
    amountDiscount = json['amount_discount'];
    amountShipping = json['amount_shipping'];
    amountTax = json['amount_tax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount_discount'] = this.amountDiscount;
    data['amount_shipping'] = this.amountShipping;
    data['amount_tax'] = this.amountTax;
    return data;
  }
}

class RestaurantDetails {
  final int employeeId;
  final String firstName;
  final String lastName;
  final String emailAddress;
  final String mobileNumber;
  final String dateOfBirth;
  final int restaurantId;
  final String restaurantName;
  final String restaurantLegalName;
  final String slugName;
  final String restaurantImage;
  final String restaurantImageFull;
  final String street1;
  final String street2;
  final String landmark;
  final String zipcode;
  final int city;
  final String cityName;
  final int state;
  final String stateName;
  final int country;
  final String countryName;
  final String establishedSince;
  final String gstNo;
  final String serviceTaxNumber;
  final String vatTinNumber;
  final double vatPercent;
  final String website;
  final String facebookId;
  final String twitterId;
  final String isActive;
  final String isDelete;
  final String isDisplayRestaurantLogo;
  final String isMenuManagementApplicable;
  final String isOnlineOrderApplicable;
  final String isPrepaymentApplicable;
  final String isPrepaymentTable;
  final String isPrepaymentToken;
  final String isUserSmsApplicable;
  final int suspendReasonId;
  final String reasonName;
  final String otherReason;
  final int timeZoneId;
  final String timeZone;
  final int currencyId;
  final int createdBy;
  final int createdId;
  final String createdOn;
  final int modifiedBy;
  final String modifiedOn;
  final int modifierId;

  RestaurantDetails({
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    required this.mobileNumber,
    required this.dateOfBirth,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantLegalName,
    required this.slugName,
    required this.restaurantImage,
    required this.restaurantImageFull,
    required this.street1,
    required this.street2,
    required this.landmark,
    required this.zipcode,
    required this.city,
    required this.cityName,
    required this.state,
    required this.stateName,
    required this.country,
    required this.countryName,
    required this.establishedSince,
    required this.gstNo,
    required this.serviceTaxNumber,
    required this.vatTinNumber,
    required this.vatPercent,
    required this.website,
    required this.facebookId,
    required this.twitterId,
    required this.isActive,
    required this.isDelete,
    required this.isDisplayRestaurantLogo,
    required this.isMenuManagementApplicable,
    required this.isOnlineOrderApplicable,
    required this.isPrepaymentApplicable,
    required this.isPrepaymentTable,
    required this.isPrepaymentToken,
    required this.isUserSmsApplicable,
    required this.suspendReasonId,
    required this.reasonName,
    required this.otherReason,
    required this.timeZoneId,
    required this.timeZone,
    required this.currencyId,
    required this.createdBy,
    required this.createdId,
    required this.createdOn,
    required this.modifiedBy,
    required this.modifiedOn,
    required this.modifierId,
  });

  factory RestaurantDetails.fromJson(Map<String, dynamic> json) {
    return RestaurantDetails(
      employeeId: json['employee_id'] ?? 0,
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      emailAddress: json['email_address'] ?? "",
      mobileNumber: json['mobile_number'] ?? "",
      dateOfBirth: json['date_of_birth'] ?? "",
      restaurantId: json['restaurant_id'] ?? 0,
      restaurantName: json['restaurant_name'] ?? "",
      restaurantLegalName: json['restaurant_legal_name'] ?? "",
      slugName: json['slug_name'] ?? "",
      restaurantImage: json['restaurant_image'] ?? "",
      restaurantImageFull: json['restaurant_image_full'] ?? "",
      street1: json['street1'] ?? "",
      street2: json['street2'] ?? "",
      landmark: json['landmark'] ?? "",
      zipcode: json['zipcode'] ?? "",
      city: json['city'] ?? 0,
      cityName: json['city_name'] ?? "",
      state: json['state'] ?? 0,
      stateName: json['state_name'] ?? "",
      country: json['country'] ?? 0,
      countryName: json['country_name'] ?? "",
      establishedSince: json['established_since'] ?? "",
      gstNo: json['gst_no'] ?? "",
      serviceTaxNumber: json['service_tax_number'] ?? "",
      vatTinNumber: json['vat_tin_number'] ?? "",
      vatPercent: (json['vat_percent'] ?? 0).toDouble(),
      website: json['website'] ?? "",
      facebookId: json['facebook_id'] ?? "",
      twitterId: json['twitter_id'] ?? "",
      isActive: json['is_active'] ?? "",
      isDelete: json['is_delete'] ?? "",
      isDisplayRestaurantLogo: json['is_display_restaurant_logo'] ?? "",
      isMenuManagementApplicable: json['is_menu_management_applicable'] ?? "",
      isOnlineOrderApplicable: json['is_online_order_applicable'] ?? "",
      isPrepaymentApplicable: json['is_prepayment_applicable'] ?? "",
      isPrepaymentTable: json['is_prepayment_table'] ?? "",
      isPrepaymentToken: json['is_prepayment_token'] ?? "",
      isUserSmsApplicable: json['is_user_sms_applicable'] ?? "",
      suspendReasonId: json['suspend_reason_id'] ?? 0,
      reasonName: json['reason_name'] ?? "",
      otherReason: json['other_reason'] ?? "",
      timeZoneId: json['time_zone_id'] ?? 0,
      timeZone: json['time_zone'] ?? "",
      currencyId: json['currency_id'] ?? 0,
      createdBy: json['created_by'] ?? 0,
      createdId: json['created_id'] ?? 0,
      createdOn: json['created_on'] ?? "",
      modifiedBy: json['modified_by'] ?? 0,
      modifiedOn: json['modified_on'] ?? "",
      modifierId: json['modifier_id'] ?? 0,
    );
  }
}

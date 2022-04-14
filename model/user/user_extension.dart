enum UserDBKey {
  name,
  profileImage,
  transactionSummary,
  email,
  phone,
  sex,
  myRestro,
  stripeAccountId,
  paymentMethods,
  lastName,
  firstName,
  emailOptin
}

extension UserDBKeyMethod on UserDBKey {
  static UserDBKey typeOf(String type) {
    switch (type) {
      case "email_opt_in":
        return UserDBKey.email;
      case "my_restro":
        return UserDBKey.myRestro;
      case "last_name":
        return UserDBKey.lastName;
      case "first_name":
        return UserDBKey.firstName;
      case "stripe_account_id":
        return UserDBKey.stripeAccountId;
      case "payment_methods":
        return UserDBKey.paymentMethods;
      case "name":
        return UserDBKey.name;
      case "profile_image":
        return UserDBKey.profileImage;
      case "transaction_summary":
        return UserDBKey.transactionSummary;
      case "email":
        return UserDBKey.email;
      case "phone":
        return UserDBKey.phone;
      case "sex":
        return UserDBKey.sex;
      default:
        throw ArgumentError.value(type);
    }
  }

  String get dbKey {
    switch (this) {
      case UserDBKey.emailOptin:
        return "email_opt_in";
      case UserDBKey.lastName:
        return "last_name";
      case UserDBKey.firstName:
        return "first_name";
      case UserDBKey.paymentMethods:
        return "payment_methods";
      case UserDBKey.stripeAccountId:
        return "stripe_account_id";
      case UserDBKey.myRestro:
        return "my_restro";
      case UserDBKey.name:
        return "name";
      case UserDBKey.profileImage:
        return "profile_image";
      case UserDBKey.transactionSummary:
        return "transaction_summary";
      case UserDBKey.email:
        return "email";
      case UserDBKey.phone:
        return "phone";
      case UserDBKey.sex:
        return "sex";
      default:
        throw ArgumentError.value(this);
    }
  }
}

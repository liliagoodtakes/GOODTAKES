import 'package:com_goodtakes/model/base/base_method.dart';
import 'package:com_goodtakes/model/base/base_model.dart';
import 'package:com_goodtakes/model/base/transaction_summary/transaction_summary.dart';
import 'package:com_goodtakes/model/payment_method.dart';
import 'package:com_goodtakes/model/user/user_extension.dart';

class UsrProfile extends BaseModel with BaseMethod {
  final String firstName;
  final String lastName;
  final String? profileImage;
  final TransactionSummary summary;
  final String email;
  final String phone;
  final int sex;
  final String stripeAccountId;
  final Map<String, bool>? myRestro;
  final List<PaymentMethod> paymentMethods;
  bool emailOptin;

  UsrProfile._(
      {required this.emailOptin,
      required this.paymentMethods,
      required this.firstName,
      required this.lastName,
      required this.myRestro,
      this.profileImage,
      required this.email,
      required this.phone,
      required this.sex,
      required this.summary,
      required this.stripeAccountId,
      required Map<String, dynamic> meta,
      required String uid})
      : super(meta, uid);

  factory UsrProfile.build(Map profile, String uid) {
    return UsrProfile._(
        emailOptin: profile[UserDBKey.emailOptin.dbKey] as bool? ?? false,
        stripeAccountId: profile[UserDBKey.stripeAccountId.dbKey] as String,
        profileImage: profile[UserDBKey.profileImage.dbKey] as String?,
        // profileImage: null,
        myRestro:
            (profile[UserDBKey.myRestro.dbKey] as Map?)?.cast<String, bool>(),
        uid: uid,
        meta: (profile[baseModelDBKeyMeta] as Map).cast<String, dynamic>(),
        lastName: (profile[UserDBKey.name.dbKey]?[UserDBKey.lastName.dbKey]
            ?['zh'] as String),
        firstName: (profile[UserDBKey.name.dbKey]?[UserDBKey.firstName.dbKey]
            ?['zh'] as String),
        email: profile[UserDBKey.email.dbKey] as String,
        phone: profile[UserDBKey.phone.dbKey] as String,
        sex: profile[UserDBKey.sex.dbKey] as int,
        paymentMethods: ((profile[UserDBKey.paymentMethods.dbKey] as Map? ?? {})
                .cast<String, dynamic>())
            .entries
            .map((e) => PaymentMethod.build(e.value, e.key))
            .toList(),
        summary:
            TransactionSummary.build(profile['transaction_summary'] as Map));
  }

  @override
  Map<String, dynamic> get dbStructure {
    return {
      UserDBKey.email.dbKey: email,
      UserDBKey.name.name: {
        UserDBKey.lastName.dbKey: {"zh": lastName},
        UserDBKey.firstName.dbKey: {"zh": firstName}
      },
      UserDBKey.phone.dbKey: phone,
      UserDBKey.profileImage.dbKey: profileImage,
      UserDBKey.sex.dbKey: sex
    };
  }

  String get name => lastName + " " + firstName;

  UsrProfile copyWith(Map update) {
    return UsrProfile._(
        emailOptin: (update[UserDBKey.emailOptin.dbKey] as bool?) ?? emailOptin,
        paymentMethods: (update[UserDBKey.paymentMethods.dbKey] as Map?)
                ?.cast<String, dynamic>()
                .entries
                .map((e) => PaymentMethod.build(e.value, e.key))
                .toList() ??
            paymentMethods,
        lastName: (update[UserDBKey.name.dbKey]?[UserDBKey.lastName.dbKey]
                ?['zh'] as String?) ??
            lastName,
        firstName: (update[UserDBKey.name.dbKey]?[UserDBKey.firstName.dbKey]
                ?['zh'] as String?) ??
            firstName,
        myRestro:
            ((update[UserDBKey.myRestro.dbKey] as Map?)?.cast<String, bool>()) ??
                myRestro,
        email: (update[UserDBKey.email.dbKey] as String?) ?? email,
        phone: (update[UserDBKey.phone.dbKey] as String?) ?? phone,
        sex: (update[UserDBKey.sex.dbKey] as int?) ?? sex,
        summary: update['transaction_summary'] != null
            ? TransactionSummary.build(update['transaction_summary'] as Map)
            : summary,
        stripeAccountId: (update[UserDBKey.stripeAccountId.dbKey] as String?) ??
            stripeAccountId,
        meta: (update[baseModelDBKeyMeta] as Map?)?.cast<String, dynamic>() ?? meta,
        profileImage: (update[UserDBKey.profileImage.dbKey] as String?) ?? profileImage,
        uid: id);
  }
}

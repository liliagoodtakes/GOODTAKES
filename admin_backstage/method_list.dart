import 'package:com_goodtakes/admin_backstage/web_form_view.dart';
import 'package:com_goodtakes/static/standard_styling/standard_button_style.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

Future<AccessCredentials> obtainCredentials() async {
  var accountCredentials = ServiceAccountCredentials.fromJson({
    "private_key_id": "<please fill in>",
    "private_key": "<please fill in>",
    "client_email": "<please fill in>@developer.gserviceaccount.com",
    "client_id": "<please fill in>.apps.googleusercontent.com",
    "type": "service_account"
  });
  var scopes = [];

  var client = http.Client();
  AccessCredentials credentials =
      await obtainAccessCredentialsViaServiceAccount(
          accountCredentials, [], client);

  client.close();
  return credentials;
}

class MethodList extends StatelessWidget {
  const MethodList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(PageTransition(
                  child: WebFormView(), type: PageTransitionType.fade));
            },
            child: Text("Add new restro"),
            style: StandardButtonStyle.regularYellowButtonStyle,
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {},
              child: Text("data"),
              style: StandardButtonStyle.regularYellowButtonStyle)
        ],
      ),
    ));
  }
}

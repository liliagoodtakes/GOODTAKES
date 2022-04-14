import 'dart:convert';

import 'package:com_goodtakes/admin_backstage/main_state.dart';
import 'package:com_goodtakes/model/config_model/config_mode.dart';
import 'package:com_goodtakes/service/routing/paths.dart';
import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/content/standard_regex.dart';
import 'package:com_goodtakes/static/standard_styling/standard_button_style.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/widgets/display/gt_chip.dart';
import 'package:com_goodtakes/widgets/interaction/loading_button_builder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class WebFormView extends StatefulWidget {
  // final Restro restro;
  const WebFormView({Key? key}) : super(key: key);

  @override
  State<WebFormView> createState() => _WebFormViewState();
}

class _WebFormViewState extends State<WebFormView> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final descriptionController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();
  final imageUrlController = TextEditingController();
  final ownerController = TextEditingController();
  final GlobalKey<FormState> formstate = GlobalKey();
  final List<ConfigModel> types = [];
  ConfigModel district = RM.get<MainState>().state.district.first;
  Widget get inlineSeperator => const SizedBox(width: 20);
  Widget get colSeperator => const SizedBox(height: 20);

  String? emptyAlert(String? value) {
    if ((value ?? "").isNotEmpty) {
      return null;
    } else {
      return "必填";
    }
  }

  void selectType() {
    showDialog(
        context: context,
        builder: (_) {
          final datas = RM.get<MainState>().state.l1TypeSelector;

          return AlertDialog(
              content: SizedBox(
                  width: 400,
                  child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                          datas.length,
                          (index) => GTChip(
                              backgroundColor: StandardColor.darkyellow,
                              onTap: () {
                                final d2 = RM
                                    .get<MainState>()
                                    .state
                                    .l2TypeSelector(datas.elementAt(index));

                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                          content: SizedBox(
                                              width: 400,
                                              child: Wrap(
                                                  spacing: 10,
                                                  runSpacing: 10,
                                                  children: List.generate(
                                                      d2.length,
                                                      (index) => GTChip(
                                                          backgroundColor:
                                                              StandardColor
                                                                  .darkyellow,
                                                          message: d2
                                                              .elementAt(index)
                                                              .displayName,
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            types.add(
                                                                d2.elementAt(
                                                                    index));
                                                            setState(() {});
                                                          })))));
                                    });
                              },
                              message: datas.elementAt(index))))));
        });
  }

  void selectDistrict() {
    _showL3(String key) {
      final d3 = RM.get<MainState>().state.l3DistrictSelector(key);
      debugPrint("d3 length: ${d3.length}");
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
                content: SizedBox(
                    width: 400,
                    child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(
                            d3.length,
                            (index) => GTChip(
                                backgroundColor: StandardColor.darkyellow,
                                message: d3.elementAt(index).displayName,
                                onTap: () {
                                  Navigator.of(context).pop();
                                  district = d3.elementAt(index);
                                  setState(() {});
                                })))));
          });
    }

    _showL2(String key) {
      final d2 = RM.get<MainState>().state.l2DistrictSelector(key);

      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
                content: SizedBox(
                    width: 400,
                    child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(
                            d2.length,
                            (index) => GTChip(
                                backgroundColor: StandardColor.darkyellow,
                                message: d2.elementAt(index),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  _showL3(d2.elementAt(index));
                                })))));
          });
    }

    showDialog(
        context: context,
        builder: (_) {
          final datas = RM.get<MainState>().state.l1DistrictSelector;

          return AlertDialog(
              content: SizedBox(
                  width: 400,
                  child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                          datas.length,
                          (index) => GTChip(
                              backgroundColor: StandardColor.darkyellow,
                              onTap: () {
                                Navigator.of(context).pop();
                                _showL2(datas.elementAt(index));
                              },
                              message: datas.elementAt(index))))));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.fromLTRB(80, 50, 80, 50),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: StandardColor.white),
                child: Form(
                    key: formstate,
                    child: Column(children: [
                      Image(
                        image: AssetImage(StandardAssetImage.logoYellow),
                        height: 100,
                      ),
                      Row(children: [
                        Text(
                          "餐廳名稱 (zh) : ",
                          style: StandardTextStyle.black18B,
                        ),
                        inlineSeperator,
                        Expanded(
                            child: TextFormField(
                                validator: emptyAlert,
                                controller: nameController,
                                style: StandardTextStyle.black18R))
                      ]),
                      colSeperator,
                      Row(children: [
                        Text("餐廳電話 : ", style: StandardTextStyle.black18B),
                        inlineSeperator,
                        Expanded(
                            child: TextFormField(
                          validator: emptyAlert,
                          controller: phoneController,
                          maxLength: 8,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              counterText: "", prefixText: "+852 "),
                          style: StandardTextStyle.black18R,
                        ))
                      ]),
                      colSeperator,
                      Row(children: [
                        Text(
                          "餐廳圖片 : ",
                          style: StandardTextStyle.black18B,
                        ),
                        inlineSeperator,
                        Expanded(
                            child: TextFormField(
                                decoration: InputDecoration(hintText: "有效的URL"),
                                validator: emptyAlert,
                                controller: imageUrlController,
                                style: StandardTextStyle.black18R))
                      ]),
                      colSeperator,
                      Row(children: [
                        Text(
                          "餐廳地址 : ",
                          style: StandardTextStyle.black18B,
                        ),
                        inlineSeperator,
                        Expanded(
                            child: TextFormField(
                          validator: emptyAlert,
                          controller: addressController,
                          style: StandardTextStyle.black18R,
                        ))
                      ]),
                      colSeperator,
                      Row(children: [
                        Text(
                          "餐廳Email : ",
                          style: StandardTextStyle.black18B,
                        ),
                        inlineSeperator,
                        Expanded(
                            child: TextFormField(
                          validator: (value) {
                            final bool match =
                                RegExp(StandardRegExp.emailVailidator)
                                    .hasMatch(value ?? "");
                            debugPrint("email have matched $match");
                            if (match) {
                              return null;
                            } else {
                              return "請輸入有效的EMAIL";
                            }
                          },
                          style: StandardTextStyle.black18R,
                          controller: emailController,
                        ))
                      ]),
                      colSeperator,
                      Row(children: [
                        Text(
                          "擁有人 : ",
                          style: StandardTextStyle.black18B,
                        ),
                        inlineSeperator,
                        Expanded(
                            child: TextFormField(
                          validator: emptyAlert,
                          style: StandardTextStyle.black18R,
                          controller: ownerController,
                        ))
                      ]),
                      colSeperator,
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "餐廳描述 : ",
                              style: StandardTextStyle.black18B,
                            ),
                            inlineSeperator,
                            Expanded(
                                child: TextFormField(
                              validator: emptyAlert,
                              controller: descriptionController,
                              minLines: 3,
                              maxLines: 5,
                              style: StandardTextStyle.black18R,
                            )),
                          ]),
                      colSeperator,
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "餐廳位置 : ",
                              style: StandardTextStyle.black18B,
                            ),
                            inlineSeperator,
                            Expanded(
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                  Expanded(
                                      child: TextFormField(
                                    validator: emptyAlert,
                                    controller: latController,
                                    decoration: InputDecoration(
                                        hintText: "Latitude, eg: 22.12345"),
                                  )),
                                  inlineSeperator,
                                  Expanded(
                                      child: TextFormField(
                                    controller: lngController,
                                    validator: emptyAlert,
                                    decoration: InputDecoration(
                                        hintText: "Longitude, eg: 122.12345"),
                                  )),
                                ]))
                          ]),
                      colSeperator,
                      Row(children: [
                        Text(
                          "餐廳區域 : ",
                          style: StandardTextStyle.black18B,
                        ),
                        inlineSeperator,
                        Expanded(
                            child: Text(
                          district.displayName,
                          style: TextStyle(fontSize: 14),
                        )),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: StandardColor.yellow),
                            onPressed: selectDistrict,
                            child: Text("選擇"))
                      ]),
                      colSeperator,
                      Row(children: [
                        Text(
                          "餐廳類別 : ",
                          style: StandardTextStyle.black18B,
                        ),
                        inlineSeperator,
                        Expanded(
                            child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(
                              types.length,
                              (index) => GTChip(
                                  onTap: () {
                                    types.remove(types.elementAt(index));
                                    setState(() {});
                                  },
                                  backgroundColor: StandardColor.darkyellow,
                                  message: types.elementAt(index).displayName)),
                        )),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: StandardColor.yellow),
                            onPressed: selectType,
                            child: Text("選擇"))
                      ]),
                      colSeperator,
                      LoadingButtonBuilder(
                          builder: (context, loading, onClick) {
                        return ElevatedButton(
                            onPressed: onClick,
                            style: StandardButtonStyle.regularYellowButtonStyle,
                            child: Text("Add Restro"));
                      }, callback: () async {
                        if (formstate.currentState!.validate()) {
                          final lat = double.tryParse(latController.text);
                          final lng = double.tryParse(lngController.text);
                          final data = {
                            "address": {
                              "zh": addressController.text,
                              "en": null
                            },
                            "description": {"zh": descriptionController.text},
                            "district": district.id,
                            "email": emailController.text,
                            "name": {"zh": nameController.text, "en": null},
                            "image": imageUrlController.text,
                            "location": [lat, lng],
                            "phone": "+852 ${phoneController.text}",
                            "type": Map.fromEntries(
                                types.map((e) => MapEntry(e.id, true))),
                            "owner": ownerController.text
                          };
                          final res = await http.post(
                              Uri.parse(
                                  "https://asia-northeast1-goodtakes-9e17c.cloudfunctions.net/admin_api/create_restro"),
                              headers: <String, String>{
                                'content-type':
                                    'application/json; charset=utf-8'
                              },
                              body: json.encode(data));
                          if (res.statusCode == 200) {
                            await showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                      title: Text("成功"),
                                      actions: [
                                        ElevatedButton(
                                            style: StandardButtonStyle
                                                .regularYellowButtonStyle,
                                            onPressed: () {
                                              Navigator.of(context).pushReplacement(
                                                  CupertinoPageRoute(
                                                      builder: (_) =>
                                                          const WebFormView()));
                                            },
                                            child: Text("Confirm"))
                                      ]);
                                });
                          } else if (res.statusCode == 404) {
                            await showDialog(
                                context: context,
                                builder: (_) {
                                  return ElevatedButton(
                                      style: StandardButtonStyle
                                          .regularYellowButtonStyle,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Confirm"));
                                });
                          }
                        }
                      })
                    ])))));
  }
}

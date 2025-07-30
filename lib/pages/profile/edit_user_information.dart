import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vet/component/header_v2.dart';
import 'package:vet/component/material/inut_with_label.dart';
import 'package:vet/home_v2.dart';
import 'package:vet/pages/blank_page/dialog_fail.dart';
import 'package:vet/shared/api_provider.dart';
import 'package:vet/widget/text_form_field.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dt_picker;

class EditUserInformationPage extends StatefulWidget {
  @override
  _EditUserInformationPageState createState() =>
      _EditUserInformationPageState();
}

class _EditUserInformationPageState extends State<EditUserInformationPage> {
  final storage = new FlutterSecureStorage();

  String _imageUrl = '';
  late String _code;

  final _formKey = GlobalKey<FormState>();

  List<String> _itemPrefixName = ['นาย', 'นาง', 'นางสาว']; // Option 2
  late String _selectedPrefixName;

  List<dynamic> _itemSex = [
    {'title': 'ชาย', 'code': 'ชาย'},
    {'title': 'หญิง', 'code': 'หญิง'},
    {'title': 'ไม่ระบุเพศ', 'code': ''}
  ];

  List<dynamic> _itemProvince = [];
  String _selectedProvince = '';

  List<dynamic> _itemDistrict = [];
  late String _selectedDistrict;

  List<dynamic> _itemSubDistrict = [];
  late String _selectedSubDistrict;

  List<dynamic> _itemPostalCode = [];
  late String _selectedPostalCode;

  List<dynamic> dataPolicy = [];

  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConPassword = TextEditingController();
  final txtPrefixName = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtPhone = TextEditingController();
  final txtUsername = TextEditingController();
  final txtIdCard = TextEditingController();
  final txtLineID = TextEditingController();
  final txtOfficerCode = TextEditingController();
  final txtAddress = TextEditingController();
  final txtMoo = TextEditingController();
  final txtSoi = TextEditingController();
  final txtRoad = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TextEditingController txtDate = new TextEditingController();

  late Future<dynamic> futureModel;

  ScrollController scrollController = new ScrollController();

  late XFile _image;

  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;

  String _categorySocial = '';
  String _imageUrlSocial = '';

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtEmail.dispose();
    txtPassword.dispose();
    txtConPassword.dispose();
    txtFirstName.dispose();
    txtLastName.dispose();
    txtPhone.dispose();
    txtDate.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getProvince();
    _callRead();

    scrollController = ScrollController();
    var now = new DateTime.now();
    setState(() {
      year = now.year;
      month = now.month;
      day = now.day;
      _selectedYear = now.year;
      _selectedMonth = now.month;
      _selectedDay = now.day;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        } else if (details.delta.dx < -0) {
          //Left Swipe
        }
      },
      child: Scaffold(
        appBar: header(context, goBack, title: 'ข้อมูลผู้ใช้งาน'),
        backgroundColor: Color(0xFFFFFFFF),
        body: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: FutureBuilder<dynamic>(
              future: futureModel,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  _setData(snapshot.data);
                  print('--------------------');
                  return Container(
                    child: ListView(
                      controller: scrollController,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      children: [
                        _buildImage(snapshot.data),
                        contentCard(snapshot.data),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                      child: Container(
                    color: Colors.white,
                    child: dialogFail(context),
                  ));
                } else {
                  return Container();
                }
              },
            )),
      ),
    );
  }

  _buildImage(dynamic model) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                'assets/background/backgroundUserInfo.png',
              ),
            ),
          ),
          height: 150.0,
        ),
        Container(
          height: 150.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                'assets/background/backgroundUserInfoColor.png',
              ),
            ),
          ),
        ),
        Center(
          child: Container(
            width: 90.0,
            height: 90.0,
            margin: EdgeInsets.only(top: 30.0),
            padding: EdgeInsets.all(
                _imageUrl != null && _imageUrl != '' ? 0.0 : 5.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45), color: Colors.white70),
            child: GestureDetector(
              onTap: () {
                _showPickerImage(context);
              },
              child: _imageUrl != null && _imageUrl != ''
                  ? CircleAvatar(
                      backgroundColor: Colors.black,
                      backgroundImage: _imageUrl != null && _imageUrl != ''
                          ? NetworkImage(_imageUrl)
                          : null,
                    )
                  : Container(
                      padding: EdgeInsets.all(10.0),
                      child: Image.asset(
                        'assets/images/user_not_found.png',
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
            ),
          ),
        ),
        Center(
          child: Container(
            width: 25.0,
            height: 25.0,
            margin: EdgeInsets.only(top: 90.0, left: 70.0),
            child: Padding(
              padding: EdgeInsets.all(0.0),
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    image: AssetImage("assets/logo/icons/Group37.png"),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  contentCard(dynamic model) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          controller: scrollController,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5.0),
            ),
            // Text(
            //   'บัญชีผู้ใช้',
            //   style: TextStyle(
            //     fontSize: 18.00,
            //     fontFamily: 'Kanit',
            //     fontWeight: FontWeight.w500,
            //     // color: Color(0xFFBC0611),
            //   ),
            // ),
            // inputCus(
            //   enabled: false,
            //   context: context,
            //   title: '',
            //   controller: txtUsername,
            //   validator: (String value) {
            //     // if (value.isEmpty) return '';
            //   },
            // ),
            // Padding(
            //   padding: EdgeInsets.only(top: 5.0),
            // ),
            // SizedBox(height: 40),
            // Text(
            //   'รายละเอียดผู้ใช้งาน',
            //   style: TextStyle(
            //     fontSize: 18.00,
            //     fontFamily: 'Kanit',
            //     fontWeight: FontWeight.w500,
            //     // color: Color(0xFFBC0611),
            //   ),
            // ),
            labelTextFormFieldRequired('* ', 'คำนำหน้า'),
            textFormFieldEdit(
              txtPrefixName,
              '',
              'คำนำหน้า',
              'คำนำหน้า',
              true,
              false,
              false,
              false,
              onChanged: (value) {
                setState(() {
                  txtPrefixName.text = value;
                });
              },
            ),
            labelTextFormFieldRequired('* ', 'ชื่อ'),
            textFormFieldEdit(
              txtFirstName,
              '',
              'ชื่อ',
              'ชื่อ',
              true,
              false,
              false,
              false,
              onChanged: (value) {
                setState(() {
                  txtFirstName.text = value;
                });
              },
            ),
            labelTextFormFieldRequired('* ', 'นามสกุล'),
            textFormFieldEdit(
              txtLastName,
              '',
              'นามสกุล',
              'นามสกุล',
              true,
              false,
              false,
              false,
              onChanged: (value) {
                setState(() {
                  txtLastName.text = value;
                });
              },
            ),
            labelTextFormFieldRequired('* ', 'เบอร์โทรศัพท์ (10 หลัก'),
            textFormPhoneFieldEdit(
              txtPhone,
              'เบอร์โทรศัพท์ (10 หลัก)',
              'เบอร์โทรศัพท์ (10 หลัก)',
              true,
              true,
              onChanged: (value) {
                setState(() {
                  txtPhone.text = value;
                });
              },
            ),
            labelTextFormField('อีเมล'),
            textFormFieldNoValidator(
              txtEmail,
              'อีเมล',
              false,
              false,
            ),
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: Container(
                // width: MediaQuery.of(context).size.width * 0.7,
                // margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xFF99722F),
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    height: 40,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        // print(model['birthDay']);
                        if (txtDate.text != '') {
                          List<String> date = txtDate.text.split('-');
                          setState(() {
                            model['birthDay'] = date[0] + date[1] + date[2];
                          });
                        }
                        // print(model['birthDay']);
                        setState(() {
                          model['prefixName'] = txtPrefixName.text;
                          model['firstName'] = txtFirstName.text;
                          model['lastName'] = txtLastName.text;
                          model['phone'] = txtPhone.text;
                          model['email'] = txtEmail.text;
                          model['imageUrl'] = _imageUrl;
                          model['idcard'] = txtIdCard.text;
                          model['provinceCode'] = _selectedProvince;
                        });
                        if (_selectedProvince != '') {
                          getPolicy();
                          getProvince();
                          getDistrict();
                          getSubDistrict();
                          setState(() {
                            futureModel = getPostalCode();
                          });
                        } else {
                          getPolicy();
                          setState(() {
                            futureModel = getProvince();
                          });
                        }
                        _callUpdate(model);
                      }
                    },
                    child: new Text(
                      'บันทึกข้อมูล',
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _contentCard(dynamic model) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          controller: scrollController,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5.0),
            ),
            // Text(
            //   'บัญชีผู้ใช้',
            //   style: TextStyle(
            //     fontSize: 18.00,
            //     fontFamily: 'Kanit',
            //     fontWeight: FontWeight.w500,
            //     // color: Color(0xFFBC0611),
            //   ),
            // ),
            // inputCus(
            //   enabled: false,
            //   context: context,
            //   title: '',
            //   controller: txtUsername,
            //   validator: (String value) {
            //     // if (value.isEmpty) return '';
            //   },
            // ),
            // Padding(
            //   padding: EdgeInsets.only(top: 5.0),
            // ),
            // SizedBox(height: 40),
            // Text(
            //   'รายละเอียดผู้ใช้งาน',
            //   style: TextStyle(
            //     fontSize: 18.00,
            //     fontFamily: 'Kanit',
            //     fontWeight: FontWeight.w500,
            //     // color: Color(0xFFBC0611),
            //   ),
            // ),

            inputCus(
              context: context,
              hintText: 'คำนำหน้า',
              // title: 'คำนำหน้า',
              controller: txtPrefixName,
              onChanged: (value) {
                setState(() {
                  model['prefixName'] = value;
                });
              },
              validator: (String value) {
                // if (value.isEmpty) return '';
              },
            ),
            inputCus(
              context: context,
              hintText: 'ชื่อ',
              // title: 'ชื่อ',
              controller: txtFirstName,
              onChanged: (value) {
                setState(() {
                  model['firstName'] = value;
                });
              },
              validator: (String value) {
                // if (value.isEmpty) return '';
              },
            ),
            inputCus(
              context: context,
              hintText: 'นามสกุล',
              // title: 'นามสกุล',
              controller: txtLastName,
              onChanged: (value) {
                setState(() {
                  model['lastName'] = value;
                });
              },
              validator: (String value) {
                // if (value.isEmpty) return 'oooo';
              },
            ),
            Container(
              child: GestureDetector(
                onTap: () => {
                  FocusScope.of(context).unfocus(),
                  dialogOpenPickerDate(model)
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: txtDate,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Kanit',
                      fontSize: 15.0,
                    ),
                    decoration: InputDecoration(
                      // filled: true,
                      hintText: "วันเดือนปีเกิด",
                      errorStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Kanit',
                        fontSize: 10.0,
                      ),
                      fillColor: Colors.transparent,
                      contentPadding:
                          EdgeInsets.only(left: 5.0, right: 5.0, top: 15.0),
                    ),
                    // validator: (model) {
                    //   if (model.isEmpty) {
                    //     return 'กรุณากรอกวันเดือนปีเกิด.';
                    //   }
                    // },
                  ),
                ),
              ),
            ),
            inputCus(
              textInputType: TextInputType.numberWithOptions(signed: true),
              context: context,
              hintText: 'เบอร์โทรศัพท์',
              // title: 'เบอร์โทรศัพท์',
              controller: txtPhone,
              onChanged: (value) {
                setState(() {
                  model['phone'] = value;
                });
              },
              validator: (String value) {
                // if (value.length > 10)
                //   return 'เบอร์โทรศัพท์ต้องไม่่เกิน 10 ตัว';
              },
            ),
            inputCus(
              enabled: false,
              context: context,
              hintText: 'อีเมล',
              // title: 'อีเมล',
              controller: txtEmail,
              onChanged: (value) {
                setState(() {
                  model['email'] = value;
                });
              },
              validator: (String value) {
                // if (value.isEmpty) return 'oooo';
              },
            ),
            // labelTextFormField('เพศ'),
            // new Container(
            //   width: double.infinity,
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 5,
            //     vertical: 0,
            //   ),
            //   decoration: BoxDecoration(
            //     color: Color(0xFFEEBA33),
            //     borderRadius: BorderRadius.circular(
            //       10,
            //     ),
            //   ),
            //   child: DropdownButtonFormField(
            //     decoration: InputDecoration(
            //       errorStyle: TextStyle(
            //         fontWeight: FontWeight.normal,
            //         fontFamily: 'Kanit',
            //         fontSize: 10.0,
            //       ),
            //       enabledBorder: UnderlineInputBorder(
            //         borderSide: BorderSide(
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //     validator: (value) =>
            //         // value == '' ||
            //         value == null ? 'กรุณาเลือกเพศ' : null,
            //     hint: Text(
            //       'เพศ',
            //       style: TextStyle(
            //         fontSize: 15.00,
            //         fontFamily: 'Kanit',
            //       ),
            //     ),
            //     value: _selectedSex,
            //     onChanged: (newValue) {
            //       setState(() {
            //         _selectedSex = newValue;
            //       });
            //     },
            //     items: _itemSex.map((item) {
            //       return DropdownMenuItem(
            //         child: new Text(
            //           item['title'],
            //           style: TextStyle(
            //             fontSize: 15.00,
            //             fontFamily: 'Kanit',
            //             color: Color(
            //               0xFF9A1120,
            //             ),
            //           ),
            //         ),
            //         value: item['code'],
            //       );
            //     }).toList(),
            //   ),
            // ),

            Padding(
              padding: EdgeInsets.only(top: 50),
              child: Container(
                // width: MediaQuery.of(context).size.width * 0.7,
                // margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xFF1B6CA8),
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    height: 40,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        // print(model['birthDay']);
                        if (txtDate.text != '') {
                          List<String> date = txtDate.text.split('-');
                          setState(() {
                            model['birthDay'] = date[0] + date[1] + date[2];
                          });
                        }
                        // print(model['birthDay']);
                        setState(() {
                          model['imageUrl'] = _imageUrl;
                        });
                        _callUpdate(model);
                      }
                    },
                    child: new Text(
                      'บันทึกข้อมูล',
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  dialogOpenPickerDate(dynamic model) {
    dt_picker.DatePicker.showDatePicker(context,
        theme: const dt_picker.DatePickerTheme(
          containerHeight: 210.0,
          itemStyle: TextStyle(
            fontSize: 16.0,
            color: Color(0xFF9A1120),
            fontWeight: FontWeight.normal,
            fontFamily: 'Kanit',
          ),
          doneStyle: TextStyle(
            fontSize: 16.0,
            color: Color(0xFF9A1120),
            fontWeight: FontWeight.normal,
            fontFamily: 'Kanit',
          ),
          cancelStyle: TextStyle(
            fontSize: 16.0,
            color: Color(0xFF9A1120),
            fontWeight: FontWeight.normal,
            fontFamily: 'Kanit',
          ),
        ),
        showTitleActions: true,
        minTime: DateTime(1800, 1, 1),
        maxTime: DateTime(year, month, day), onConfirm: (date) {
      txtDate.text = DateFormat("dd-MM-yyyy").format(date);
      // setState(
      //   () {
      //     _selectedYear = date.year;
      //     _selectedMonth = date.month;
      //     _selectedDay = date.day;
      //     // txtDate.value = TextEditingValue(
      //     //   text: DateFormat("dd-MM-yyyy").format(date),
      //     // );
      //   },
      // );
    },
        currentTime: DateTime(
          _selectedYear,
          _selectedMonth,
          _selectedDay,
        ),
        locale: dt_picker.LocaleType.th);
  }

  _imgFromCamera() async {
    // File image = await ImagePicker.pickImage(
    //   source: ImageSource.camera,
    //   imageQuality: 100,
    // );

    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image!;
    });
    _upload();
  }

  _imgFromGallery() async {
    // File image = await ImagePicker.pickImage(
    //   source: ImageSource.gallery,
    //   imageQuality: 100,
    // );

//  maxHeight: 240.0,
//     maxWidth: 240.0,

    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image!;
    });
    _upload();
  }

  void _upload() async {
    if (_image == null) return;

    uploadImage(_image).then((res) {
      setState(() {
        _imageUrl = res;
      });
    }).catchError((err) {
      print(err);
    });
  }

  void _showPickerImage(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text(
                      'อัลบั้มรูปภาพ',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text(
                    'กล้องถ่ายรูป',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
                if (_categorySocial != '')
                  new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text(
                      ' ใช้รูปโปรไฟล์จาก ' + _categorySocial,
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      _imgFromNow();
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  _imgFromNow() async {
    setState(() {
      _imageUrl = _imageUrlSocial;
    });
  }

  void _setData(dynamic model) {
    print('============================$_imageUrl======================');
    _imageUrl = _imageUrl != '' ? _imageUrl : model['imageUrl'];
    if (txtPhone.text == '') txtPhone.text = model['phone'];
    if (txtFirstName.text == '') txtFirstName.text = model['firstName'];
    if (txtLastName.text == '') txtLastName.text = model['lastName'];
    if (txtUsername.text == '') txtUsername.text = model['username'];
    if (txtPrefixName.text == '') txtPrefixName.text = model['prefixName'];
    if (txtIdCard.text == '') txtIdCard.text = model['idcard'];
    if (_selectedProvince == '') _selectedProvince = model['provinceCode'];
    if (txtEmail.text == '') txtEmail.text = model['email'];
    if (txtDate.text == '') txtDate.text = model['birthDay'];
    if (model['birthDay'] != '' && model['birthDay'] != null) {
      var date = model['birthDay'];
      var day = date.substring(0, 2);
      var month = date.substring(2, 4);
      var year = date.substring(4, 8);
      txtDate.text = day + '-' + month + '-' + year;
    }
  }

  Future<dynamic> _callUpdate(dynamic model) async {
    postDio(server + 'm/v2/Register/update', model).then(
      (value) => {
        if (value != null)
          {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return WillPopScope(
                  onWillPop: () {
                    return Future.value(false);
                  },
                  child: CupertinoAlertDialog(
                    title: new Text(
                      'อัพเดตข้อมูลเรียบร้อยแล้ว',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Kanit',
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    content: Text(" "),
                    actions: [
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        child: new Text(
                          "ตกลง",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Kanit',
                            color: Color(0xFF9A1120),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => HomePageV2(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            )
          }
        else
          {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return WillPopScope(
                  onWillPop: () {
                    return Future.value(false);
                  },
                  child: CupertinoAlertDialog(
                    title: new Text(
                      'อัพเดตข้อมูลไม่สำเร็จ',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Kanit',
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    content: new Text(
                      'error',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Kanit',
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    actions: [
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        child: new Text(
                          "ตกลง",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Kanit',
                            color: Color(0xFF9A1120),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            )
          }
      },
    );
  }

  Future<dynamic> getPolicy() async {
    final result = await postDio("m/policy/read", {
      "category": "application",
    });
    // if (result['status'] == 'S') {
    if (result['objectData'].length > 0) {
      for (var i in result['objectData']) {
        result['objectData'][i].isActive = "";
        result['objectData'][i].agree = false;
        result['objectData'][i].noAgree = false;
      }
      setState(() {
        dataPolicy = result['objectData'];
      });
    }
    // }
  }

  Future<dynamic> getProvince() async {
    final result = await postObjectData("route/province/read", {});
    if (result['status'] == 'S') {
      setState(() {
        _itemProvince = result['objectData'];
      });
    }
  }

  Future<dynamic> getDistrict() async {
    final result = await postObjectData("route/district/read", {
      'province': _selectedProvince,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemDistrict = result['objectData'];
      });
    }
  }

  Future<dynamic> getSubDistrict() async {
    final result = await postObjectData("route/tambon/read", {
      'province': _selectedProvince,
      'district': _selectedDistrict,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemSubDistrict = result['objectData'];
      });
    }
  }

  Future<dynamic> getPostalCode() async {
    final result = await postObjectData("route/postcode/read", {
      'tambon': _selectedSubDistrict,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemPostalCode = result['objectData'];
      });
    }
  }

  _callRead() async {
    futureModel = postDio(server + "m/v2/Register/read", {});

    var categorySocial = await storage.read(key: 'categorySocial');
    if (categorySocial != '' && categorySocial != null)
      setState(() {
        _categorySocial = categorySocial;
      });

    var imageUrlSocial = await storage.read(key: 'imageUrlSocial');
    if (imageUrlSocial != '' && imageUrlSocial != null)
      setState(() {
        _imageUrlSocial = imageUrlSocial;
      });
  }

  void goBack() async {
    Navigator.pop(context, false);
  }
}

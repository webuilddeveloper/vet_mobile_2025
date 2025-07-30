class LoginRegister {
  String? status;
  String? message;
  User? objectData;

  LoginRegister({this.status, this.message, this.objectData});

  static Map<String, dynamic> toMap(LoginRegister loginRegister) {
    var map = Map<String, dynamic>();
    map['status'] = loginRegister.status;
    map['message'] = loginRegister.message;
    map['objectData'] = User.toMap(loginRegister);
    return map;
  }

  LoginRegister.map(dynamic obj) {
    this.status = obj["status"];
    this.message = obj["message"];
    if (obj['objectData'] != null) {
      this.objectData = new User.map(obj['objectData']);
    }
  }

  factory LoginRegister.fromJson(dynamic json) {
    if (json['objectData'] != '') {
      return LoginRegister(
        status: json['status'],
        message: json['message'],
        objectData: new User.fromJson(json['objectData']),
      );
    } else {
      return LoginRegister(status: json['status'], message: json['message']);
    }
  }
}

class User {
  String prefixName = '';
  String firstName = '';
  String lastName = '';
  String email = "";
  String category = "";
  String code = "";
  String username = "";
  String password = "";
  bool isActive = false; // Default value for non-nullable field
  String status = "";
  String createBy = "";
  String createDate = "";
  String imageUrl = "";
  String updateBy = "";
  String updateDate = "";
  String birthDay = "";
  String phone = "";
  String facebookID = "";
  String googleID = "";
  String lineID = "";
  String appleID = "";
  String line = "";
  String sex = "";
  String soi = "";
  String moo = "";
  String road = "";
  String address = "";
  String tambonCode = "";
  String tambon = "";
  String amphoeCode = "";
  String amphoe = "";
  String provinceCode = "";
  String province = "";
  String postnoCode = "";
  String postno = "";
  String job = "";
  String idcard = "";
  String countUnit = "";
  String lv0 = "";
  String lv1 = "";
  String lv2 = "";
  String lv3 = "";
  String lv4 = "";
  String lv5 = "";
  String linkAccount = "";
  String officerCode = "";

  User.map(dynamic json) {
    this.prefixName = json['prefixName'] ?? '';
    this.firstName = json['firstName'] ?? '';
    this.lastName = json['lastName'] ?? '';
    this.email = json['email'] ?? '';
    this.category = json['category'] ?? '';
    this.code = json['code'] ?? '';
    this.username = json['username'] ?? '';
    this.password = json['password'] ?? '';
    this.isActive =
        json['isActive'] ??
        false; // Provide default value for non-nullable field
    this.status = json['status'] ?? '';
    this.createBy = json['createBy'] ?? '';
    this.createDate = json['createDate'] ?? '';
    this.imageUrl = json['imageUrl'] ?? '';
    this.updateBy = json['updateBy'] ?? '';
    this.updateDate = json['updateDate'] ?? '';
    this.birthDay = json['birthDay'] ?? '';
    this.phone = json['phone'] ?? '';
    this.facebookID = json['facebookID'] ?? '';
    this.googleID = json['googleID'] ?? '';
    this.lineID = json['lineID'] ?? '';
    this.appleID = json['appleID'] ?? '';
    this.line = json['line'] ?? '';
    this.sex = json['sex'] ?? '';
    this.soi = json['soi'] ?? '';
    this.moo = json['moo'] ?? '';
    this.road = json['road'] ?? '';
    this.address = json['address'] ?? '';
    this.tambonCode = json['tambonCode'] ?? '';
    this.tambon = json['tambon'] ?? '';
    this.amphoeCode = json['amphoeCode'] ?? '';
    this.amphoe = json['amphoe'] ?? '';
    this.provinceCode = json['provinceCode'] ?? '';
    this.province = json['province'] ?? '';
    this.postnoCode = json['postnoCode'] ?? '';
    this.postno = json['postno'] ?? '';
    this.job = json['job'] ?? '';
    this.idcard = json['idcard'] ?? '';
    this.countUnit = json['countUnit'] ?? '';
    this.lv0 = json['lv0'] ?? '';
    this.lv1 = json['lv1'] ?? '';
    this.lv2 = json['lv2'] ?? '';
    this.lv3 = json['lv3'] ?? '';
    this.lv4 = json['lv4'] ?? '';
    this.lv5 = json['lv5'] ?? '';
    this.linkAccount = json['linkAccount'] ?? '';
    this.officerCode = json['officerCode'] ?? '';
  }

  static Map<String, dynamic> toMap(LoginRegister loginRegister) {
    var map = Map<String, dynamic>();
    map['prefixName'] = loginRegister.objectData?.prefixName;
    map['firstName'] = loginRegister.objectData?.firstName;
    map['lastName'] = loginRegister.objectData?.lastName;
    map['email'] = loginRegister.objectData?.email;
    map['category'] = loginRegister.objectData?.category;
    map['code'] = loginRegister.objectData?.code;
    map['username'] = loginRegister.objectData?.username;
    map['password'] = loginRegister.objectData?.password;
    map['isActive'] = loginRegister.objectData?.isActive;
    map['status'] = loginRegister.objectData?.status;
    map['createBy'] = loginRegister.objectData?.createBy;
    map['createDate'] = loginRegister.objectData?.createDate;
    map['imageUrl'] = loginRegister.objectData?.imageUrl;
    map['updateBy'] = loginRegister.objectData?.updateBy;
    map['updateDate'] = loginRegister.objectData?.updateDate;
    map['birthDay'] = loginRegister.objectData?.birthDay;
    map['phone'] = loginRegister.objectData?.phone;
    map['facebookID'] = loginRegister.objectData?.facebookID;
    map['googleID'] = loginRegister.objectData?.googleID;
    map['lineID'] = loginRegister.objectData?.lineID;
    map['appleID'] = loginRegister.objectData?.appleID;
    map['line'] = loginRegister.objectData?.line;
    map['sex'] = loginRegister.objectData?.sex;
    map['soi'] = loginRegister.objectData?.soi;
    map['address'] = loginRegister.objectData?.address;
    map['tambonCode'] = loginRegister.objectData?.tambonCode;
    map['tambon'] = loginRegister.objectData?.tambon;
    map['amphoeCode'] = loginRegister.objectData?.amphoeCode;
    map['amphoe'] = loginRegister.objectData?.amphoe;
    map['provinceCode'] = loginRegister.objectData?.provinceCode;
    map['province'] = loginRegister.objectData?.province;
    map['postnoCode'] = loginRegister.objectData?.postnoCode;
    map['postno'] = loginRegister.objectData?.postno;
    map['job'] = loginRegister.objectData?.job;
    map['idcard'] = loginRegister.objectData?.idcard;
    map['countUnit'] = loginRegister.objectData?.countUnit;
    map['lv0'] = loginRegister.objectData?.lv0;
    map['lv1'] = loginRegister.objectData?.lv1;
    map['lv2'] = loginRegister.objectData?.lv2;
    map['lv3'] = loginRegister.objectData?.lv3;
    map['lv4'] = loginRegister.objectData?.lv4;
    map['lv5'] = loginRegister.objectData?.lv5;
    map['linkAccount'] = loginRegister.objectData?.linkAccount;
    map['officerCode'] = loginRegister.objectData?.officerCode;
    return map;
  }

  factory User.fromJson(dynamic json) {
    return User(
      prefixName: json['prefixName'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      category: json['category'] ?? '',
      code: json['code'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      isActive: json['isActive'] ?? '',
      status: json['status'] ?? '',
      createBy: json['createBy'] ?? '',
      createDate: json['createDate'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      updateBy: json['updateBy'] ?? '',
      updateDate: json['updateDate'] ?? '',
      birthDay: json['birthDay'] ?? '',
      phone: json['phone'] ?? '',
      facebookID: json['facebookID'] ?? '',
      googleID: json['googleID'] ?? '',
      lineID: json['lineID'] ?? '',
      appleID: json['appleID'] ?? '',
      line: json['line'] ?? '',
      sex: json['sex'] ?? '',
      soi: json['soi'] ?? '',
      address: json['address'] ?? '',
      tambonCode: json['tambonCode'] ?? '',
      tambon: json['tambon'] ?? '',
      amphoeCode: json['amphoeCode'] ?? '',
      amphoe: json['amphoe'] ?? '',
      provinceCode: json['provinceCode'] ?? '',
      province: json['province'] ?? '',
      postnoCode: json['postnoCode'] ?? '',
      postno: json['postno'] ?? '',
      job: json['job'] ?? '',
      idcard: json['idcard'] ?? '',
      countUnit: json['countUnit'] ?? '',
      lv0: json['lv0'] ?? '',
      lv1: json['lv1'] ?? '',
      lv2: json['lv2'] ?? '',
      lv3: json['lv3'] ?? '',
      lv4: json['lv4'] ?? '',
      lv5: json['lv5'] ?? '',
      linkAccount: json['linkAccount'] ?? '',
      officerCode: json['officerCode'] ?? '',
    );
  }

 User({
    this.prefixName = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.category = '',
    this.code = '',
    this.username = '',
    this.password = '',
    required this.isActive, // Make isActive required, no default
    this.status = '',
    this.createBy = '',
    this.createDate = '',
    this.imageUrl = '',
    this.updateBy = '',
    this.updateDate = '',
    this.birthDay = '',
    this.phone = '',
    this.facebookID = '',
    this.googleID = '',
    this.lineID = '',
    this.appleID = '',
    this.line = '',
    this.sex = '',
    this.soi = '',
    this.moo = '',
    this.address = '',
    this.tambonCode = '',
    this.tambon = '',
    this.amphoeCode = '',
    this.amphoe = '',
    this.provinceCode = '',
    this.province = '',
    this.postnoCode = '',
    this.postno = '',
    this.job = '',
    this.idcard = '',
    this.countUnit = '',
    this.lv0 = '',
    this.lv1 = '',
    this.lv2 = '',
    this.lv3 = '',
    this.lv4 = '',
    this.lv5 = '',
    this.linkAccount = '',
    this.officerCode = '',
  });

  Map<String, dynamic> toJson() => {
    'prefixName': prefixName,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'category': category,
    'code': code,
    'username': username,
    'password': password,
    'isActive': isActive,
    'status': status,
    'createBy': createBy,
    'createDate': createDate,
    'imageUrl': imageUrl,
    'updateBy': updateBy,
    'updateDate': updateDate,
    'birthDay': birthDay,
    'phone': phone,
    'facebookID': facebookID,
    'googleID': googleID,
    'lineID': lineID,
    'appleID': appleID,
    'line': line,
    'sex': sex,
    'soi': soi,
    'moo': moo,
    'address': address,
    'tambonCode': tambonCode,
    'tambon': tambon,
    'amphoeCode': amphoeCode,
    'amphoe': amphoe,
    'provinceCode': provinceCode,
    'province': province,
    'postnoCode': postnoCode,
    'postno': postno,
    'job': job,
    'idcard': idcard,
    'countUnit': countUnit,
    'lv0': lv0,
    'lv1': lv1,
    'lv2': lv2,
    'lv3': lv3,
    'lv4': lv4,
    'lv5': lv5,
    'linkAccount': linkAccount,
    'officerCode': officerCode,
  };

  save() {
    print('saving user using a web service');
  }
}

class DataUser {
  String facebookID = "";
  String appleID = "";
  String googleID = "";
  String lineID = "";
  String email = "";
  String imageUrl = "";
  String category = "";
  String username = "";
  String password = "";
  String prefixName = "";
  String firstName = "";
  String lastName = "";
}

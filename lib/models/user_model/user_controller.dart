import 'package:election/models/main_model.dart';
import 'package:election/models/user_model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

mixin UserController on Model {
  bool _isJudgeLoginLoading = false;
  bool get isJudgeLogingLoading => _isJudgeLoginLoading;

  bool _isApproveUserLoading = false;
  bool get isApproveUsergLoading => _isApproveUserLoading;

  List<CandidatesUser> _allCandidates = [];
  List<CandidatesUser> get allCandidates => _allCandidates;

  Future<bool> judgeLogin(String ssn, String password) async {
    _isJudgeLoginLoading = true;
    notifyListeners();
    Map<String, dynamic> _bodyData = {'SSN': ssn, 'password': password};

    http.Response _res = await http.post(
        Uri.parse('${MainData.url}judge/login'),
        headers: MainData.defaultHeader,
        body: json.encode(_bodyData));

    var _data = json.decode(_res.body);

    if (_res.statusCode != 200) {
      _isJudgeLoginLoading = false;
      notifyListeners();
      return false;
    } else {
      MainData.saveToLocalStorage('token', _data['access_token']);
      await _getJudgeProfile(_data['access_token']);
      await _getJudgeCandidates(_data['access_token']);
      _isJudgeLoginLoading = false;
      notifyListeners();
      return true;
    }
  }

  _getJudgeProfile(String token) async {
    http.Response _res = await http.get(
      Uri.parse('${MainData.url}judge/me'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
  }

  _getJudgeCandidates(String token) async {
    http.Response _res =
        await http.get(Uri.parse('${MainData.url}judge/candidates'), headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    var _data = json.decode(_res.body);

    _data['data'].forEach((i) {
      CandidatesUser _newCan = CandidatesUser.fromJson(i);
      _allCandidates.add(_newCan);
    });
  }

  selectCandidates(CandidatesUser user) {
    user.isSelected = !user.isSelected;
    notifyListeners();
  }

  Future<String> approveCan() async {
    _isApproveUserLoading = true;
    notifyListeners();
    Map<String, List<int>> _approvedUsers = {'candidates': []};

    for (CandidatesUser user in _allCandidates) {
      if (user.isSelected) {
        _approvedUsers['candidates']!.add(user.id!);
      }
    }

    if (_approvedUsers.isEmpty) {
      _isApproveUserLoading = false;
      notifyListeners();
      return 'Please Select at Least one user to approve';
    }

    String _token = await MainData.getFromLocalStorage('token');

    http.Response _res =
        await http.post(Uri.parse('${MainData.url}judge/approve'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
            },
            body: json.encode(_approvedUsers));

    if (_res.statusCode != 200) {
      _isApproveUserLoading = false;
      notifyListeners();
      return 'some thing went wrong try again';
    } else {
      _isApproveUserLoading = false;
      _allCandidates.clear();
      notifyListeners();
      return 'approved successfuly';
    }
  }
}

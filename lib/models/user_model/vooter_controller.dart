import 'package:election/models/main_model.dart';
import 'package:election/models/user_model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

mixin VooterController on Model {
  bool _isVooterLoginLoading = false;
  bool get isVooterLogingLoading => _isVooterLoginLoading;

  bool _isVootingLoading = false;
  bool get isVootinggLoading => _isVootingLoading;

  bool _sureVoting = false;

  List<CandidatesUser> _allVooterCandidates = [];
  List<CandidatesUser> get allVooterCandidates => _allVooterCandidates;

  VooterUser? vooterProfile;

  Future<bool> vooterLogin(String ssn) async {
    _isVooterLoginLoading = true;
    notifyListeners();
    Map<String, dynamic> _bodyData = {'SSN': ssn, 'password': '', 'comm_id': 4};

    http.Response _res = await http.post(
        Uri.parse('${MainData.url}voter/login'),
        headers: MainData.defaultHeader,
        body: json.encode(_bodyData));

    var _data = json.decode(_res.body);

    if (_res.statusCode != 200) {
      _isVooterLoginLoading = false;
      notifyListeners();
      return false;
    } else {
      MainData.saveToLocalStorage('vooter_token', _data['access_token']);
      vooterProfile = await _getVooterProfile(_data['access_token']);
      await _getVooterCandidates(_data['access_token']);
      await _getElecDetails(_data['access_token']);
      _isVooterLoginLoading = false;
      notifyListeners();
      return true;
    }
  }

  _getVooterProfile(String token) async {
    http.Response _res = await http.get(
      Uri.parse('${MainData.url}voter/me'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    var _data = json.decode(_res.body);

    return VooterUser.fromJson(_data['data']);
  }

  _getVooterCandidates(String token) async {
    http.Response _res =
        await http.get(Uri.parse('${MainData.url}voter/candidates'), headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    var _data = json.decode(_res.body);

    _data.forEach((i) {
      CandidatesUser _newCan = CandidatesUser.fromJson(i);
      _allVooterCandidates.add(_newCan);
    });
  }

  Future<int> _getElecDetails(String token) async {
    http.Response _res =
        await http.get(Uri.parse('${MainData.url}voter/election'), headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    var _data = json.decode(_res.body);

    return _data[0]['id'];
  }

  setVootingAcceptance(bool value, CandidatesUser user) {
    _sureVoting = value;
    user.isSelected = value;
    notifyListeners();
  }

  Future<String> vooteCan(CandidatesUser user) async {
    _isVootingLoading = true;
    notifyListeners();

    if (!_sureVoting) {
      _isVootingLoading = false;
      notifyListeners();
      return 'Vooting Canceled';
    }

    String _token = await MainData.getFromLocalStorage('vooter_token');

    int _elecId = await _getElecDetails(_token);
    Map<String, dynamic> _vootingData = {
      'can_id': user.id,
      'elec_id': _elecId,
      'comm_id': 4
    };

    int _vooterCounter = 0;

    for (CandidatesUser user in _allVooterCandidates) {
      if (user.isSelected) {
        _vooterCounter++;
      }
    }

    if (_vooterCounter > 1) {
      _isVootingLoading = false;
      notifyListeners();
      return 'Please Select Just one Candidates to voote';
    }

    http.Response _res = await http.post(Uri.parse('${MainData.url}voter/vote'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: json.encode(_vootingData));

    print(_res.statusCode);
    print(_res.body);

    if (_res.statusCode != 200) {
      _isVootingLoading = false;
      notifyListeners();
      return 'some thing went wrong try again';
    } else {
      _isVootingLoading = false;
      _allVooterCandidates.clear();
      notifyListeners();
      return 'Vooted successfuly';
    }
  }
}

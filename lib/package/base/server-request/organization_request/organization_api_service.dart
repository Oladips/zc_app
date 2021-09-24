import 'package:hng/app/app.logger.dart';
import 'package:hng/services/user_service.dart';
import 'package:hng/ui/shared/shared.dart';

import '../../../../app/app.locator.dart';
import '../../../../models/organization_model.dart';
import '../../../../services/local_storage_services.dart';
import '../../../../utilities/storage_keys.dart';
import '../api/http_api.dart';

class OrganizationApiService {
  final log = getLogger('OrganizationApiService');
  final _api = HttpApiService(coreBaseUrl);
  final storageService = locator<SharedPreferenceLocalStorage>();
  final _userService = locator<UserService>();

  /// Fetches a list of organizations that exist in the zuri database
  /// This does not fetch the Organization the user belongs to
  /// To implement that use `getJoinedOrganizations()`
  Future<List<OrganizationModel>> fetchListOfOrganizations() async {
    final res = await _api.get(
      '/organizations',
      headers: {'Authorization': 'Bearer $token'},
    );
    log.i(res?.data?['data'].length);
    return (res?.data?['data'] as List)
        .map((e) => OrganizationModel.fromJson(e))
        .toList();
  }

  ///Get the list of Organization the user has joined
  Future<List<OrganizationModel>> getJoinedOrganizations() async {
    String email = _userService.userEmail;

    final res = await _api.get(
      '/users/$email/organizations',
      headers: {'Authorization': 'Bearer $token'},
    );
    log.i(res?.data?['data']);
    print(res?.data);
    if (res?.data['data'] == null) {
      return [];
    }
    return (res?.data?['data'] as List)
        .map((e) => OrganizationModel.fromJson(e))
        .toList();
  }

  /// Fetches information on a particular Organization. It takes a parameter
  /// `id` which is the id of the organization
  Future<OrganizationModel> fetchOrganizationInfo(String id) async {
    final res = await _api.get(
      '/organizations/$id',
      headers: {'Authorization': 'Bearer $token'},
    );
    return OrganizationModel.fromJson(res?.data?['data']);
  }

  /// takes in a `url` and returns a Organization that matches the url
  /// use this url for testing `zurichat-fsp1856.zurichat.com`
  Future<OrganizationModel> fetchOrganizationByUrl(String url) async {
    final res = await _api.get(
      '/organizations/url/$url',
      headers: {'Authorization': 'Bearer $token'},
    );
    log.i(res?.data);
    print(res?.data);

    res?.data?['data']['id'] = res.data['data']['_id'];
    return OrganizationModel.fromJson(res?.data?['data']);
  }

  ///Limited to the admin who created the org
  ///
  ///This should be used to add users to an organization by the admin user alone
  /// takes in a `Organization id` and joins the Organization
  Future<bool> joinOrganization(String orgId) async {
    String email = _userService.userEmail;

    final res = await _api.post(
      '/organizations/$orgId/members',
      data: {"user_email": email},
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res?.statusCode == 200) {
      return true;
    }

    return false;
  }

  /// This method creates an organization. Creator email `email` must be present
  ///
  Future<String> createOrganization(String email) async {
    final res = await _api.post(
      '/organizations',
      headers: {'Authorization': 'Bearer $token'},
      data: {"creator_email": email},
    );
    return res?.data?['data']['InsertedID'];
  }

  /// Updates an organization's URL. The organization's id `orgId` must not be
  /// null or empty. Url must not begin with `https` or `http`
  Future<void> updateOrgUrl(String orgId, String url) async {
    final res = await _api.patch(
      '/organizations/$orgId/url',
      headers: {'Authorization': 'Bearer $token'},
      data: {"url": url},
    );
    return res?.data?['message'];
  }

  /// Updates an organization's name. The organization's id `orgId` must not be
  /// null or empty
  Future<void> updateOrgName(String orgId, String name) async {
    final res = await _api.patch(
      '/organizations/$orgId/name',
      headers: {'Authorization': 'Bearer $token'},
      data: {"organization_name": name},
    );
    return res?.data?['message'];
  }

  /// Updates an organization's logo. The organization's id `orgId` must not be
  /// null or empty
  Future<void> updateOrgLogo(String orgId, String url) async {
    final res = await _api.patch(
      '/organizations/$orgId/logo',
      headers: {'Authorization': 'Bearer $token'},
      data: {"url": url},
    );
    return res?.data?['message'];
  }

  Future<void> addMemberToOrganization(String orgId, String email) async {
    final res = await _api.post(
      '/organizations/$orgId/members',
      headers: {'Authorization': 'Bearer $token'},
      data: {"user_email": email},
    );
    return res?.data?['message'];
  }

  String? get token =>
      storageService.getString(StorageKeys.currentSessionToken);
}
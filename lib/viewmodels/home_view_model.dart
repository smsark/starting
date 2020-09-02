import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/post.dart';
import 'package:compound/models/user.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/cloud_storage_service.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/viewmodels/base_model.dart';

class HomeViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();
  final AuthenticationService _authenticationService =
  locator<AuthenticationService>();

  List<Post> _posts;
  User _user;
  List<Post> get posts => _posts;
  User get user => _user;

  void listenToPosts() {
    setBusy(true);

    _firestoreService.listenToPostsRealTime().listen((postsData) {
      List<Post> updatedPosts = postsData;
      if (updatedPosts != null && updatedPosts.length > 0) {
        _posts = updatedPosts;
        notifyListeners();
      }

      setBusy(false);
    });
  }

  void listenToUser() {
    setBusy(true);

    _user = User(
      fullName: _authenticationService.currentUser.fullName,
      email: _authenticationService.currentUser.email,
    );

    _authenticationService.isUserLoggedIn().then((value) {
      if (value == true) {
        _user = User(
          fullName: _authenticationService.currentUser.fullName,
          email: _authenticationService.currentUser.email,
        );
        setBusy(false);
      }else{
        _user = User(
          fullName: "Ahmed A",
          email: "ahmed@gmail.com",
        );
        setBusy(false);
      }

    });

  }

  Future deletePost(int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete the post?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed) {
      var postToDelete = _posts[index];
      setBusy(true);
      await _firestoreService.deletePost(postToDelete.documentId);
      // Delete the image after the post is deleted
      await _cloudStorageService.deleteImage(postToDelete.imageFileName);
      setBusy(false);
    }
  }

  Future navigateToCreateView() async {
    await _navigationService.navigateTo(CreatePostViewRoute);
  }

  Future navigateTo(r) async {
    await _navigationService.navigateTo(r);
  }

  void editPost(int index) {
    _navigationService.navigateTo(CreatePostViewRoute,
        arguments: _posts[index]);
  }

  void requestMoreData() => _firestoreService.requestMoreData();
}

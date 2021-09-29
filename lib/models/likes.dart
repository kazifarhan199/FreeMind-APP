class LikesModel {
  String userName = '', userImage = '';

  get userImageURL => this.userImage;

  LikesModel(Map data) {
    userName = data['username'];
    userImage = data['userimage'];
  }
}

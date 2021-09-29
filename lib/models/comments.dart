class CommentsModel {
  String userName = '', userImage = '';

  get userImageURL => this.userImage;

  CommentsModel(Map data) {
    userName = data['username'];
    userImage = data['userimage'];
  }
}

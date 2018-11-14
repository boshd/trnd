import Foundation

// MARK: - NSUserDefaults Keys
let DEFAULTS_USERNAME = "username"
let DEFAULTS_EMAIL = "email"
let DEFAULTS_USERNAME_ = "username_"
let DEFAULTS_FULLNAME = "fullname"

// MARK: - Reuse Identifiers
enum Reuse {
    static let ProfileNavigationController = "ProfileNavigationController"
    static let ImageCell = "ImageCell"
    static let FollowCell = "FollowCell"
    static let ProfileHeader = "ProfileHeader"
    static let PostCell = "PostCell"
    static let PostImageCell = "PostImageCell"
    static let PostInfoCell = "PostInfoCell"
    static let CommentCell = "CommentCell"
    static let NotificationCell = "NotificationCell"
}

// MARK: - Parse Class Names
enum ParseClass {
    static let User = "_User"
    static let Post = "Post"
    static let Follow = "Follow"
    static let Like = "Like"
    static let Comment = "Comment"
    static let Complaint = "Complaint"
    static let Hashtag = "Hashtag"
    static let Notification = "Notification"
    static let Event = "Event"
}

// MARK: - Parse Query Keys
enum QueryKey {
    static let Username = "username"
    static let Username_ = "username_"
    static let Email = "email"
    static let Url = "url"
    static let Avatar = "avatar"
    static let FullName = "fullName"
    static let Website = "website"
    static let Bio = "bio"
    static let Telephone = "telephone"
    static let Gender = "gender"
    static let Follower = "follower"
    static let Following = "following"
    static let CreatedAt = "createdAt"
    static let UniqueID = "uuid"
    static let Picture = "picture"
    static let Video = "video"
    static let Title = "title"
    static let Location = "location"
    static let Latitude = "latitude"
    static let Longitude = "longitude"
    static let To = "to"
    static let By = "by"
    static let Comment = "comment"
    static let Post = "post"
    static let ReportedUser = "reportedUser"
    static let Hashtag = "hashtag"
    static let Owner = "owner"
    static let NotifType = "type"
    static let Checked = "checked"
    
    // Event QueryKey
    static let EventTitle = "eventTitle"
    static let EventLatitude = "eventLatitude"
    static let EventLongitude = "eventLongitude"
    
}

// MARK: - Notifications
enum Notification {
    static let PostUploaded = "PostUploaded"
    static let ImageSelected = "ImageSelectedFromPicker"
}

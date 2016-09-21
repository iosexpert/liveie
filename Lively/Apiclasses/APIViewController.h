
//  Created by AppHub on 2/28/14.
//  Copyright (c) 2014 AppHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIViewController : NSObject{
    
    
    NSURLConnection *l_theConnection;
	NSMutableData *m_mutResponseData;
	int m_intResponseCode;
    
   // id              callBackTarget;
	//SEL				callBackSelector;
    
}

@property (assign) SEL callBackSelector;
@property (assign) id callBackTarget;
-(void)GetSearchNearby:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)searchdata;

-(void)ApproveFollowRequest:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) frdid;

-(void)RecentSearch:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)searchdata;
/*
 This method called to edit comment on feed
 */
-(void)editCommetOnFeed:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString *)comment :(NSString*)feeedid;
/*
 This method called to follow post
 */
-(void)followUser:(SEL)tempSelector tempTarget:(id)tempTarget   :(NSString *)urlll :(NSString *)status;
/*
 This method called to report user
 */
-(void)reportUser:(SEL)tempSelector tempTarget:(id)tempTarget   :(NSString *)urlll;
/*
 This method called to block user
 */
-(void)blockUser:(SEL)tempSelector tempTarget:(id)tempTarget   :(NSString *)urlll;
/*
 This method called to Get Details Of application
 */
-(void)GetAppSettings:(SEL)tempSelector tempTarget:(id)tempTarget;
/*
 This method called to get nearByPost
 */
-(void)getNearByPost:(SEL)tempSelector tempTarget:(id)tempTarget   :(NSString *)urlll;
/*
 This method called to change profile private
 */
-(void)makeProfilePrivate:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString *)value;
/*
 This method called to get people
 */
-(void)getPeople:(SEL)tempSelector tempTarget:(id)tempTarget   :(NSString *)urlll;
/*
 This method called to get trending post
 */
-(void)getTrendingPost:(SEL)tempSelector tempTarget:(id)tempTarget   :(NSString *)urlll;
/*
 This method called to ClearBadgeCount
 */
-(void)ClearBadgeCount:(id)tempTarget;

-(void)SyncPhoneBook:(SEL)tempSelector tempTarget:(id)tempTarget :(NSMutableArray *)contacts :(NSMutableArray*)workContacts;
-(void)FollowingSearch:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)OtherID :(NSString*)searchdata;
-(void)FollowerSearch:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)OtherID :(NSString*)searchdata;
/*
 This method called to get recent post
 */
-(void)getRecentPost:(SEL)tempSelector tempTarget:(id)tempTarget   :(NSString *)urlll;
/*
 This method called to directShareThePost
 */
-(void)directShareThePost:(SEL)tempSelector tempTarget:(id)tempTarget   :(NSString *)urlll;
/*
 This method called get notification count
 */
-(void)getNotificationCount:(SEL)tempSelector tempTarget:(id)tempTarget;

/*
 This method called to read notification
 */
-(void)readNotification:(SEL)tempSelector tempTarget:(id)tempTarget  :(NSString *)value;
/*
 This method called to check notification get or not
 */
-(void)getNotificationStatus:(SEL)tempSelector tempTarget:(id)tempTarget;
/*
 This method called to get notification
 */
-(void)getNotification:(SEL)tempSelector tempTarget:(id)tempTarget;
/*
 This method called to change notification
 */
-(void)changeNotification:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString *)value;
/*
 This method called to un hide posts
 */
-(void)unhidepost:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString *)postiddd;
/*
 This method called to un block user
 */
-(void)unblockuser:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString *)unblockid;
/*
 This method called to get hide posts
 */
-(void)gethidepost:(SEL)tempSelector tempTarget:(id)tempTarget;
/*
 This method called to get blocked users
 */
-(void)getBlockedUser:(SEL)tempSelector tempTarget:(id)tempTarget;
/*
 This method called to save user profile detail
 */
-(void)updateDetailUserProfile:(SEL)tempSelector tempTarget:(id)tempTarget :(NSDictionary*) params ;
/*
 This method called to get user profile detail
 */
-(void)getDetailUserProfile:(SEL)tempSelector tempTarget:(id)tempTarget;
/*
 This method called to like user profile
 */
-(void)likeUserProfile:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) frdid :(NSString*) value;
/*
 This method called to mark post view
 */
-(void)markviewresd:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) postid;
/*
 This method called to get following list
 */
-(void)getFollowingList:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) frdid;
/*
 This method called to get follower list
 */
-(void)getFollowerList:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) frdid;

/*
 This method called to follow the user
 */
-(void)follow_user:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) frdid :(NSString*) value;
/*
 This method called to  get data for search screen
 */
-(void)searchScreenData:(SEL)tempSelector tempTarget:(id)tempTarget ;
/*
 This method called to upload the video
 */
-(void)changeprofile_pic:(SEL)tempSelector tempTarget:(id)tempTarget :(NSData*) img;
/*
 This method called to upload the video
 */
-(void)chnage_cover_pic:(SEL)tempSelector tempTarget:(id)tempTarget :(NSData*) img;
/*
 This method called to get profile info
 */
-(void)getProfileInfo:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)otherUserid;
/*
 This method called to get post of hashtag
 */
-(void)postOfHashTags:(SEL)tempSelector tempTarget:(id)tempTarget :(NSDictionary*) urls;

/*
 This method called to With&agaist
 */
-(void)getWithAndagaist:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) urls;
/*
 This method called to get nearest text
 */
-(void)searchNearesttext:(SEL)tempSelector tempTarget:(id)tempTarget :(float)lati :(float)longi :(NSString *)searchText;
/*
 This method called to get nearest places
 */
-(void)searchNearestPlaces:(SEL)tempSelector tempTarget:(id)tempTarget :(float)lati :(float)longi;
/*
 This method called to get feed msg list
 */
-(void)getFeedmessage:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)feed_id;
/*
 This method called to uploadVideoUrlOnServer
 */
-(void)uploadVideoUrlOnServer:(SEL)tempSelector tempTarget:(id)tempTarget :(NSDictionary *)params;
/*
 This method called to uploadVideoDirectOnServer
 */
-(void)uploadVideoDirectOnServer:(SEL)tempSelector tempTarget:(id)tempTarget :(NSDictionary *)params;
/*
 This method called to upload video as reply
 */
-(void)uploadVideoasReply:(SEL)tempSelector tempTarget:(id)tempTarget :(NSDictionary *)params;
/*
 This method called to comment on feed
 */
-(void)commetOnFeed:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString *)comment :(NSString*)feeedid;
/*
 This method called to like on feed
 */
-(void)likeOnFeed:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString* )feeedid :(NSString* )value;
/*
 This method called to upload the video
 */
-(void)getAllVideos:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) urls ;
/*
 This method called to upload the video
 */
-(void)uploadVideo:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) urls :(NSData*) video;
/*
 This method called to Register new user
 */
-(void)registerNewUser:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) urls :(NSData*) image;

/*
 This method called to login user
 */
-(void)loginuser:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) email :(NSString *)pass ;
/*
 This method called to forgot pass user
 */
-(void)forgotpass:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) email  ;
/*
 This method called to Check User Name
 */
-(void)CheckUserName:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)UserName;

/*
 This method called to Check EmailID
 */
-(void)CheckEmailID:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)emailID;

/*
 This method called to Get Post Likes
 */
-(void)getPostLikes:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)postId;
-(void)getDirectUsers:(SEL)tempSelector tempTarget:(id)tempTarget;

-(void)getDirectPost:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString *)otherUserId;
-(void)SearchUser:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString *)SEARCHDATA;
-(void)ReportSpamPost:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)postId;
-(void)ReShare:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)postId;
-(void)HidePost:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)postId;

-(void)Search:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)searchdata;


@end


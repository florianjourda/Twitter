# Twitter Week 4

This is an more rich version of the week 3 iOS application to show Twitter tweets.

Time spent: 11 hours spent in total (5 hours on adding Mantle and addressing comments of last week, 6 hours on doing the required tasks)

# Project Requirements

## Hamburger menu
* [x] Dragging anywhere in the view should reveal the menu.
* [x] The menu should include links to your profile, the home timeline, and the mentions view.
* [x] The menu can look similar to the LinkedIn menu below or feel free to take liberty with the UI.

## Profile page
* [x] Contains the user header view
* [x] Contains a section with the users basic stats: # tweets, # following, # followers
* [ ] Optional: Implement the paging view for the user description.
* [ ] Optional: As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
* [ ] Optional: Pulling down the profile page should blur and resize the header image.

## Home Timeline
* [x] Tapping on a user image should bring up that user's profile page

## Optional: Account switching
* [ ] Long press on tab bar to bring up Account view with animation
* [ ] Tap account to switch to
* [ ] Include a plus button to Add an Account
* [ ]  Swipe to delete an account

Walkthrough of all user stories:

![Video Walkthrough](twitter2.gif)

# Twitter Week 3

This is an iOS application to show Twitter tweets.

Time spent: 16 hours spent in total

# Project Requirements
* [x] User can sign in using OAuth login flow
* [x] User can view last 20 tweets from their home timeline
* [x] The current signed in user will be persisted across restarts
* [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp. In other words, design the custom cell with the proper Auto Layout settings. You will also need to augment the model classes.
* [x] User can pull to refresh
* [x] User can compose a new tweet by tapping on a compose button.
* [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
* [x] Optional: When composing, you should have a countdown in the upper right for the tweet limit.
* [x] Optional: After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
* [x] Optional: Retweeting and favoriting should increment the retweet and favorite count.
* [x] Optional: User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
* [x] Optional: Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
* [x] Optional: User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

# Notes
* I have a weird bug where selected TweetCells will have their UILable with the tweet text move to the left. I was not able to understand why.

Walkthrough of all user stories:

![Video Walkthrough](twitter.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).
Timestamp convertion from http://stackoverflow.com/questions/902950/iphone-convert-date-string-to-a-relative-time-stamp

module Stream
  require 'stream/activity'
  require 'stream/aspect'
  require 'stream/comments'
  require 'stream/followed_tag'
  require 'stream/likes'
  require 'stream/mention'
  require 'stream/multi'
  require 'stream/person'
  require 'stream/public'
  require 'stream/tag'

	include Stream::Activity
	include Stream::Aspect
	include Stream::Base
	include Stream::Comments
	include Stream::FollowedTag
	include Stream::Likes
	include Stream::Mention
	include Stream::Multi
	include Stream::Person
	include Stream::Public
	include Stream::Tag
end

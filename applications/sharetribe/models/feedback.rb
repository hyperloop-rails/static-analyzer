# == Schema Information
#
# Table name: feedbacks
#
#  id           :integer          not null, primary key
#  content      :text
#  author_id    :string(255)
#  url          :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  is_handled   :integer          default(0)
#  email        :string(255)
#  community_id :integer
#

class Feedback < ActiveRecord::Base

  belongs_to :author, :class_name => "Person"

  validates_presence_of :content, :author_id, :url

  attr_accessor :title

end

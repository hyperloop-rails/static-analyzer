# encoding: utf-8
# == Schema Information
#
# Table name: taggings
#
#  id         :integer          not null, primary key
#  tag_id     :integer
#  node_id    :integer
#  user_id    :integer
#  created_at :datetime
#

class Tagging < ActiveRecord::Base
  belongs_to :tag, counter_cache: true
  belongs_to :node
  belongs_to :user

  scope :owned_by, ->(user_id) { where(user_id: user_id).order(created_at: :desc) }

  # FIXME Elasticsearch
  # after_commit :reindex_content
  # def reindex_content
  #   node.content.update_index
  # end
end

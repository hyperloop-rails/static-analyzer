class DeployKeysProject < ActiveRecord::Base
  belongs_to :project
  belongs_to :deploy_key

  validates :deploy_key_id, presence: true
  validates :deploy_key_id, uniqueness: { scope: [:project_id], message: "already exists in project" }
  validates :project_id, presence: true

  after_destroy :destroy_orphaned_deploy_key

  private

  def destroy_orphaned_deploy_key
    return unless self.deploy_key.destroyed_when_orphaned? && self.deploy_key.orphaned?
    
    self.deploy_key.destroy
  end
end

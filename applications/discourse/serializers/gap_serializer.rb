class GapSerializer < ApplicationSerializer
  attributes :before, :after

  def before
    @object.before
  end

  def after
    @object.after
  end
end

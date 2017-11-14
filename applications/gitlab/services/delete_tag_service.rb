require_relative 'base_service'

class DeleteTagService < BaseService
  def execute(tag_name)
    repository = project.repository
    tag = repository.find_tag(tag_name)

    # No such tag
    unless tag
      return error('No such tag', 404)
    end

    if repository.rm_tag(tag_name)
      release = project.releases.find_by(tag: tag_name)
      release.destroy if release

      push_data = build_push_data(tag)
      EventCreateService.new.push(project, current_user, push_data)
      project.execute_hooks(push_data.dup, :tag_push_hooks)
      project.execute_services(push_data.dup, :tag_push_hooks)

      success('Tag was removed')
    else
      error('Failed to remove tag')
    end
  end

  def error(message, return_code = 400)
    out = super(message)
    out[:return_code] = return_code
    out
  end

  def success(message)
    out = super()
    out[:message] = message
    out
  end

  def build_push_data(tag)
    Gitlab::PushDataBuilder
      .build(project, current_user, tag.target, Gitlab::Git::BLANK_SHA, "#{Gitlab::Git::TAG_REF_PREFIX}#{tag.name}", [])
  end
end

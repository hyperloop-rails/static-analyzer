module SelectsHelper
  def users_select_tag(id, opts = {})
    css_class = "ajax-users-select "
    css_class << "multiselect " if opts[:multiple]
    css_class << "skip_ldap " if opts[:skip_ldap]
    css_class << (opts[:class] || '')
    value = opts[:selected] || ''

    first_user = opts[:first_user] && current_user ? current_user.username : false

    html = {
      class: css_class,
      data: {
        placeholder: opts[:placeholder]   || 'Search for a user',
        null_user: opts[:null_user]       || false,
        any_user: opts[:any_user]         || false,
        email_user: opts[:email_user]     || false,
        first_user: first_user,
        current_user: opts[:current_user] || false,
        "push-code-to-protected-branches" => opts[:push_code_to_protected_branches],
        author_id: opts[:author_id] || ''
      }
    }

    unless opts[:scope] == :all
      project = opts[:project] || @project

      if project
        html['data-project-id'] = project.id
      elsif @group
        html['data-group-id'] = @group.id
      end
    end

    hidden_field_tag(id, value, html)
  end

  def groups_select_tag(id, opts = {})
    opts[:class] ||= ''
    opts[:class] << ' ajax-groups-select'
    select2_tag(id, opts)
  end

  def namespace_select_tag(id, opts = {})
    opts[:class] ||= ''
    opts[:class] << ' ajax-namespace-select'
    select2_tag(id, opts)
  end

  def project_select_tag(id, opts = {})
    opts[:class] ||= ''
    opts[:class] << ' ajax-project-select'

    unless opts.delete(:scope) == :all
      if @group
        opts['data-group-id'] = @group.id
      end
    end

    hidden_field_tag(id, opts[:selected], opts)
  end

  def select2_tag(id, opts = {})
    css_class = ''
    css_class << 'multiselect ' if opts[:multiple]
    css_class << (opts[:class] || '')
    value = opts[:selected] || ''

    hidden_field_tag(id, value, class: css_class)
  end
end

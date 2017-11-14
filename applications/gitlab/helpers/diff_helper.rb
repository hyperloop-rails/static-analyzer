module DiffHelper
  def mark_inline_diffs(old_line, new_line)
    old_diffs, new_diffs = Gitlab::Diff::InlineDiff.new(old_line, new_line).inline_diffs

    marked_old_line = Gitlab::Diff::InlineDiffMarker.new(old_line).mark(old_diffs)
    marked_new_line = Gitlab::Diff::InlineDiffMarker.new(new_line).mark(new_diffs)

    [marked_old_line, marked_new_line]
  end

  def diff_view
    diff_views = %w(inline parallel)

    if diff_views.include?(cookies[:diff_view])
      cookies[:diff_view]
    else
      diff_views.first
    end
  end

  def diff_hard_limit_enabled?
    params[:force_show_diff].present?
  end

  def diff_options
    options = { ignore_whitespace_change: hide_whitespace? }
    if diff_hard_limit_enabled?
      options.merge!(Commit.max_diff_options)
    end
    options
  end

  def safe_diff_files(diffs, diff_refs)
    diffs.decorate! { |diff| Gitlab::Diff::File.new(diff, diff_refs) }
  end

  def generate_line_code(file_path, line)
    Gitlab::Diff::LineCode.generate(file_path, line.new_pos, line.old_pos)
  end

  def unfold_bottom_class(bottom)
    (bottom) ? 'js-unfold-bottom' : ''
  end

  def unfold_class(unfold)
    (unfold) ? 'unfold js-unfold' : ''
  end

  def diff_line_content(line, line_type = nil)
    if line.blank?
      " &nbsp;".html_safe
    else
      line[0] = ' ' if %w[new old].include?(line_type)
      line
    end
  end

  def organize_comments(left, right)
    notes_left = notes_right = nil

    unless left[:type].nil? && right[:type] == 'new'
      notes_left = @grouped_diff_notes[left[:line_code]]
    end

    unless left[:type].nil? && right[:type].nil?
      notes_right = @grouped_diff_notes[right[:line_code]]
    end

    [notes_left, notes_right]
  end

  def inline_diff_btn
    diff_btn('Inline', 'inline', diff_view == 'inline')
  end

  def parallel_diff_btn
    diff_btn('Side-by-side', 'parallel', diff_view == 'parallel')
  end

  def submodule_link(blob, ref, repository = @repository)
    tree, commit = submodule_links(blob, ref, repository)
    commit_id = if commit.nil?
                  Commit.truncate_sha(blob.id)
                else
                  link_to Commit.truncate_sha(blob.id), commit
                end

    [
      content_tag(:span, link_to(truncate(blob.name, length: 40), tree)),
      '@',
      content_tag(:span, commit_id, class: 'monospace'),
    ].join(' ').html_safe
  end

  def commit_for_diff(diff_file)
    if diff_file.deleted_file
      @base_commit || @commit.parent || @commit
    else
      @commit
    end
  end

  def diff_file_html_data(project, diff_commit, diff_file)
    {
      blob_diff_path: namespace_project_blob_diff_path(project.namespace, project,
                                                       tree_join(diff_commit.id, diff_file.file_path))
    }
  end

  def editable_diff?(diff)
    !diff.deleted_file && @merge_request && @merge_request.source_project
  end

  private

  def diff_btn(title, name, selected)
    params_copy = params.dup
    params_copy[:view] = name

    # Always use HTML to handle case where JSON diff rendered this button
    params_copy.delete(:format)

    link_to url_for(params_copy), id: "#{name}-diff-btn", class: (selected ? 'btn active' : 'btn'), data: { view_type: name } do
      title
    end
  end

  def commit_diff_whitespace_link(project, commit, options)
    url = namespace_project_commit_path(project.namespace, project, commit.id, params_with_whitespace)
    toggle_whitespace_link(url, options)
  end

  def diff_merge_request_whitespace_link(project, merge_request, options)
    url = diffs_namespace_project_merge_request_path(project.namespace, project, merge_request, params_with_whitespace)
    toggle_whitespace_link(url, options)
  end

  private

  def hide_whitespace?
    params[:w] == '1'
  end

  def params_with_whitespace
    hide_whitespace? ? request.query_parameters.except(:w) : request.query_parameters.merge(w: 1)
  end

  def toggle_whitespace_link(url, options)
    options[:class] ||= ''
    options[:class] << ' btn btn-default'

    link_to "#{hide_whitespace? ? 'Show' : 'Hide'} whitespace changes", url, class: options[:class]
  end
end

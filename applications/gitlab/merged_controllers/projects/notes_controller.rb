class Projects::NotesController < Projects::ApplicationController
  # Authorize
  before_action :authorize_read_note!
  before_action :authorize_create_note!, only: [:create]
  before_action :authorize_admin_note!, only: [:update, :destroy]
  before_action :find_current_user_notes, except: [:destroy, :delete_attachment, :award_toggle]

  def index
    current_fetched_at = Time.now.to_i

    notes_json = { notes: [], last_fetched_at: current_fetched_at }

    @notes.each do |note|
      next if note.cross_reference_not_visible_for?(current_user)

      notes_json[:notes] << note_json(note)
    end

    render json: notes_json
  end

  def create
    @note = Notes::CreateService.new(project, current_user, note_params).execute

    respond_to do |format|
      format.json { render json: note_json(@note) }
      format.html { redirect_back_or_default }
    end
  end

  def update
    @note = Notes::UpdateService.new(project, current_user, note_params).execute(note)

    respond_to do |format|
      format.json { render json: note_json(@note) }
      format.html { redirect_back_or_default }
    end
  end

  def destroy
    if note.editable?
      Notes::DeleteService.new(project, current_user).execute(note)
    end

    respond_to do |format|
      format.js { render nothing: true }
    end
  end

  def delete_attachment
    note.remove_attachment!
    note.update_attribute(:attachment, nil)

    respond_to do |format|
      format.js { render nothing: true }
    end
  end

  def award_toggle
    noteable = if note_params[:noteable_type] == "issue"
                 project.issues.find(note_params[:noteable_id])
               else
                 project.merge_requests.find(note_params[:noteable_id])
               end

    data = {
      author: current_user,
      is_award: true,
      note: note_params[:note].delete(":")
    }

    note = noteable.notes.find_by(data)

    if note
      note.destroy
    else
      Notes::CreateService.new(project, current_user, note_params).execute
    end

    render json: { ok: true }
  end

  private

  def note
    @note ||= @project.notes.find(params[:id])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 page_title       @project.name_with_namespace 
 page_description @project.description    unless page_description 
 header_title     project_title(@project) unless header_title 
 sidebar          "project"               unless sidebar 
 content_for :scripts_body_top do 
 project = @target_project || @project 
 if @project_wiki 
 markdown_preview_path = namespace_project_wikis_markdown_preview_path(project.namespace, project) 
 else 
 markdown_preview_path = markdown_preview_namespace_project_path(project.namespace, project) 
 end 
 if current_user 
 end 
 end 
 content_for :scripts_body do 
  project = @target_project || @project 
 if @noteable 
 end 
 
 end 
 content_for :header_content do 
 dropdown_title("Go to a project") 
 dropdown_filter("Search your projects") 
 dropdown_content 
 dropdown_loading 
 end 
   page_description brand_title unless page_description 
 site_name = "GitLab" 
 # Open Graph - http://ogp.me/ 
 site_name 
 page_title 
 page_description 
 page_image 
 request.base_url 
 # Twitter Card - https://dev.twitter.com/cards/types/summary 
 page_title 
 page_description 
 page_image 
 page_card_meta_tags 
 page_title(site_name) 
 page_description 
 favicon_link_tag 'favicon.ico' 
 stylesheet_link_tag "application", media: "all" 
 stylesheet_link_tag "print",       media: "print" 
 javascript_include_tag "application" 
 csrf_meta_tags 
 include_gon 
 unless browser.safari? 
 end 
 # Apple Safari/iOS home screen icons 
 favicon_link_tag 'touch-icon-iphone.png',        rel: 'apple-touch-icon' 
 favicon_link_tag 'touch-icon-ipad.png',          rel: 'apple-touch-icon', sizes: '76x76' 
 favicon_link_tag 'touch-icon-iphone-retina.png', rel: 'apple-touch-icon', sizes: '120x120' 
 favicon_link_tag 'touch-icon-ipad-retina.png',   rel: 'apple-touch-icon', sizes: '152x152' 
 image_path('logo.svg') 
 # Windows 8 pinned site tile 
 image_path('msapplication-tile.png') 
 yield :meta_tags 
  
  
  
  
 
 # Ideally this would be inside the head, but turbolinks only evaluates page-specific JS in the body. 
 yield :scripts_body_top 
  nav_header_class 
 icon('bars') 
 icon('angle-left') 
  page_title    "Search" 
 header_title  "Search", search_path 
 render template: "layouts/application" 
 
 link_to search_path, title: 'Search', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('search') 
 end 
 if current_user 
 if session[:impersonator_id] 
 link_to admin_impersonation_path, method: :delete, title: 'Stop Impersonation', data: { toggle: 'tooltip', placement: 'bottom', container: 'body' } do 
 icon('user-secret fw') 
 end 
 end 
 if current_user.is_admin? 
 link_to admin_root_path, title: 'Admin Area', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('wrench fw') 
 end 
 end 
 link_to dashboard_todos_path, title: 'Todos', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('bell fw') 
 unless todos_pending_count == 0 
 todos_pending_count 
 end 
 end 
 if current_user.can_create_project? 
 link_to new_project_path, title: 'New project', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('plus fw') 
 end 
 end 
 if Gitlab::Sherlock.enabled? 
 link_to sherlock_transactions_path, title: 'Sherlock Transactions',                  data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('tachometer fw') 
 end 
 end 
 link_to destroy_user_session_path, class: 'logout', method: :delete, title: 'Sign out', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('sign-out') 
 end 
 else 
 link_to "Sign in", new_session_path(:user, redirect_to_referer: 'yes'), class: 'btn btn-sign-in btn-success' 
 end 
 title 
 yield :header_content 
  if outdated_browser? 
 link = "https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/install/requirements.md#supported-web-browsers" 
 link_to 'supported web browser', link 
 end 
 
 if @project && !@project.empty_repo? 
 if ref = @ref || @project.repository.root_ref 
 end 
 end 
 
   broadcast_message 
 
 nav_sidebar_class 
 brand_header_logo 
 link_to root_path, class: 'gitlab-text-container-link', title: 'Dashboard', id: 'js-shortcuts-home' do 
 end 
 if defined?(sidebar) && sidebar 
 render "layouts/nav/" 
 elsif current_user 
  nav_link(path: ['root#index', 'projects#trending', 'projects#starred', 'dashboard/projects#index'], html_options: {class: 'home'}) do 
 link_to dashboard_projects_path, title: 'Projects' do 
 icon('bookmark fw') 
 end 
 end 
 nav_link(controller: :todos) do 
 link_to dashboard_todos_path, title: 'Todos' do 
 icon('bell fw') 
 number_with_delimiter(todos_pending_count) 
 end 
 end 
 nav_link(path: 'dashboard#activity') do 
 link_to activity_dashboard_path, class: 'shortcuts-activity', title: 'Activity' do 
 icon('dashboard fw') 
 end 
 end 
 nav_link(controller: [:groups, 'groups/milestones', 'groups/group_members']) do 
 link_to dashboard_groups_path, title: 'Groups' do 
 icon('group fw') 
 end 
 end 
 nav_link(controller: 'dashboard/milestones') do 
 link_to dashboard_milestones_path, title: 'Milestones' do 
 icon('clock-o fw') 
 end 
 end 
 nav_link(path: 'dashboard#issues') do 
 link_to assigned_issues_dashboard_path, title: 'Issues', class: 'shortcuts-issues' do 
 icon('exclamation-circle fw') 
 number_with_delimiter(current_user.assigned_issues.opened.count) 
 end 
 end 
 nav_link(path: 'dashboard#merge_requests') do 
 link_to assigned_mrs_dashboard_path, title: 'Merge Requests', class: 'shortcuts-merge_requests' do 
 icon('tasks fw') 
 number_with_delimiter(current_user.assigned_merge_requests.opened.count) 
 end 
 end 
 nav_link(controller: :snippets) do 
 link_to dashboard_snippets_path, title: 'Snippets' do 
 icon('clipboard fw') 
 end 
 end 
 nav_link(controller: :help) do 
 link_to help_path, title: 'Help' do 
 icon('question-circle fw') 
 end 
 end 
 nav_link(html_options: {class: profile_tab_class}) do 
 link_to profile_path, title: 'Profile Settings', data: {placement: 'bottom'} do 
 icon('user fw') 
 end 
 end 
 
 else 
  nav_link(path: ['dashboard#show', 'root#show', 'projects#trending', 'projects#starred', 'projects#index'], html_options: {class: 'home'}) do 
 link_to explore_root_path, title: 'Projects' do 
 icon('bookmark fw') 
 end 
 end 
 nav_link(controller: [:groups, 'groups/milestones', 'groups/group_members']) do 
 link_to explore_groups_path, title: 'Groups' do 
 icon('group fw') 
 end 
 end 
 nav_link(controller: :snippets) do 
 link_to explore_snippets_path, title: 'Snippets' do 
 icon('clipboard fw') 
 end 
 end 
 nav_link(controller: :help) do 
 link_to help_path, title: 'Help' do 
 icon('question-circle fw') 
 end 
 end 
 
 end 
  if nav_menu_collapsed? 
 link_to icon('angle-right'), '#', class: 'toggle-nav-collapse', title: "Open/Close" 
 else 
 link_to icon('angle-left'), '#', class: 'toggle-nav-collapse', title: "Open/Close" 
 end 
 
 if current_user 
 link_to current_user, class: 'sidebar-user', title: "Profile" do 
 image_tag avatar_icon(current_user, 60), alt: 'Profile', class: 'avatar avatar s36' 
 current_user.username 
 end 
 end 
 if defined?(nav) && nav 
 render "layouts/nav/" 
 end 
  if alert 
 alert 
 elsif notice 
 notice 
 end 
 
 yield :flash_message 
 (container_class unless @no_container) 
 note_editable = note_editable?(note) 
 user_path(note.author) 
 image_tag avatar_icon(note.author), alt: '', class: 'avatar s40' 
 link_to_member(note.project, note.author, avatar: false) 
 "" 
 if !note.system 
 end 
 time_ago_with_tooltip(note.created_at, placement: 'bottom', html_class: 'note-created-ago') 
 access = note.project.team.human_max_access(note.author.id) 
 if access 
 access 
 end 
 if note_editable 
 link_to '#', title: 'Edit comment', class: 'note-action-button js-note-edit' do 
 icon('pencil') 
 end 
 link_to namespace_project_note_path(note.project.namespace, note.project, note), title: 'Remove comment', method: :delete, data: { confirm: 'Are you sure you want to remove this comment?' }, remote: true, class: 'note-action-button js-note-delete danger' do 
 icon('trash-o') 
 end 
 end 
 preserve do 
 markdown(note.note, pipeline: :note, cache_key: [note, "note"]) 
 end 
 if note_editable 
  form_for note, url: namespace_project_note_path(@project.namespace, @project, note), method: :put, remote: true, authenticity_token: true, html: { class: 'edit-note common-note-form js-quick-submit' } do |f| 
 note_target_fields(note) 
 render layout: 'projects/md_preview', locals: { preview_class: 'md-preview' } do 
 render 'projects/zen', f: f, attr: :note, classes: 'note-textarea js-note-text js-task-list-field', placeholder: "Write a comment or drag your files here..." 
 render 'projects/notes/hints' 
 end 
 f.submit 'Save Comment', class: 'btn btn-nr btn-save btn-grouped js-comment-button' 
 end 
 
 end 
 edited_time_ago_with_tooltip(note, placement: 'bottom', html_class: 'note_edited_ago', include_author: true) 
 if note.attachment.url 
 if note.attachment.image? 
 link_to note.attachment.url, target: '_blank' do 
 image_tag note.attachment.url, class: 'note-image-attach' 
 end 
 end 
 link_to note.attachment.url, target: '_blank' do 
 icon('paperclip') 
 note.attachment_identifier 
 link_to delete_attachment_namespace_project_note_path(note.project.namespace, note.project, note),                title: 'Delete this attachment', method: :delete, remote: true, data: { confirm: 'Are you sure you want to remove the attachment?' }, class: 'danger js-note-attachment-delete' do 
 icon('trash-o', class: 'cred') 
 end 
 end 
 end 
 
 yield :scripts_body 
 

end

  end

  def note_to_html(note)
    render_to_string(
      "projects/notes/_note",
      layout: false,
      formats: [:html],
      locals: { note: note }
    )
  end

  def note_to_discussion_html(note)
    return unless note.for_diff_line?

    if params[:view] == 'parallel'
      template = "projects/notes/_diff_notes_with_reply_parallel"
      locals =
        if params[:line_type] == 'old'
          { notes_left: [note], notes_right: [] }
        else
          { notes_left: [], notes_right: [note] }
        end
    else
      template = "projects/notes/_diff_notes_with_reply"
      locals = { notes: [note] }
    end

    render_to_string(
      template,
      layout: false,
      formats: [:html],
      locals: locals
    )
  end

  def note_to_discussion_with_diff_html(note)
    return unless note.for_diff_line?

    render_to_string(
      "projects/notes/_discussion",
      layout: false,
      formats: [:html],
      locals: { discussion_notes: [note] }
    )
  end

  def note_json(note)
    if note.valid?
      {
        valid: true,
        id: note.id,
        discussion_id: note.discussion_id,
        html: note_to_html(note),
        award: note.is_award,
        note: note.note,
        discussion_html: note_to_discussion_html(note),
        discussion_with_diff_html: note_to_discussion_with_diff_html(note)
      }
    else
      {
        valid: false,
        award: note.is_award,
        errors: note.errors
      }
    end
  end

  def authorize_admin_note!
    return access_denied! unless can?(current_user, :admin_note, note)
  end

  def note_params
    params.require(:note).permit(
      :note, :noteable, :noteable_id, :noteable_type, :project_id,
      :attachment, :line_code, :commit_id
    )
  end

  def find_current_user_notes
    @notes = NotesFinder.new.execute(project, current_user, params)
  end
end

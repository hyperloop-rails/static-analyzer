# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160509201028) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"

  create_table "abuse_reports", force: :cascade do |t|
    t.integer  "reporter_id"
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "appearances", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "header_logo"
    t.string   "logo"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "application_settings", force: :cascade do |t|
    t.integer  "default_projects_limit"
    t.boolean  "signup_enabled"
    t.boolean  "signin_enabled"
    t.boolean  "gravatar_enabled"
    t.text     "sign_in_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "home_page_url"
    t.integer  "default_branch_protection",         default: 2
    t.text     "restricted_visibility_levels"
    t.boolean  "version_check_enabled",             default: true
    t.integer  "max_attachment_size",               default: 10,          null: false
    t.integer  "default_project_visibility"
    t.integer  "default_snippet_visibility"
    t.text     "restricted_signup_domains"
    t.boolean  "user_oauth_applications",           default: true
    t.string   "after_sign_out_path"
    t.integer  "session_expire_delay",              default: 10080,       null: false
    t.text     "import_sources"
    t.text     "help_page_text"
    t.string   "admin_notification_email"
    t.boolean  "shared_runners_enabled",            default: true,        null: false
    t.integer  "max_artifacts_size",                default: 100,         null: false
    t.string   "runners_registration_token"
    t.boolean  "require_two_factor_authentication", default: false
    t.integer  "two_factor_grace_period",           default: 48
    t.boolean  "metrics_enabled",                   default: false
    t.string   "metrics_host",                      default: "localhost"
    t.integer  "metrics_pool_size",                 default: 16
    t.integer  "metrics_timeout",                   default: 10
    t.integer  "metrics_method_call_threshold",     default: 10
    t.boolean  "recaptcha_enabled",                 default: false
    t.string   "recaptcha_site_key"
    t.string   "recaptcha_private_key"
    t.integer  "metrics_port",                      default: 8089
    t.boolean  "akismet_enabled",                   default: false
    t.string   "akismet_api_key"
    t.integer  "metrics_sample_interval",           default: 15
    t.boolean  "sentry_enabled",                    default: false
    t.string   "sentry_dsn"
    t.boolean  "email_author_in_body",              default: false
    t.integer  "default_group_visibility"
    t.boolean  "repository_checks_enabled",         default: false
    t.text     "shared_runners_text"
    t.integer  "metrics_packet_size",               default: 1
    t.text     "disabled_oauth_sign_in_sources"
    t.string   "health_check_access_token"
  end

  create_table "audit_events", force: :cascade do |t|
    t.integer  "author_id",   null: false
    t.string   "type",        null: false
    t.integer  "entity_id",   null: false
    t.string   "entity_type", null: false
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "audit_events", ["author_id"], name: "index_audit_events_on_author_id", using: :btree
  add_index "audit_events", ["entity_id", "entity_type"], name: "index_audit_events_on_entity_id_and_entity_type", using: :btree
  add_index "audit_events", ["type"], name: "index_audit_events_on_type", using: :btree

  create_table "broadcast_messages", force: :cascade do |t|
    t.text     "message",    null: false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "color"
    t.string   "font"
  end

  create_table "application_settings", force: :cascade do |t|
    t.boolean  "all_broken_builds"
    t.boolean  "add_pusher"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ci_builds", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "status"
    t.datetime "finished_at"
    t.text     "trace"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "started_at"
    t.integer  "runner_id"
    t.float    "coverage"
    t.integer  "commit_id"
    t.text     "commands"
    t.integer  "job_id"
    t.string   "name"
    t.boolean  "deploy",             default: false
    t.text     "options"
    t.boolean  "allow_failure",      default: false, null: false
    t.string   "stage"
    t.integer  "trigger_request_id"
    t.integer  "stage_idx"
    t.boolean  "tag"
    t.string   "ref"
    t.integer  "user_id"
    t.string   "type"
    t.string   "target_url"
    t.string   "description"
    t.text     "artifacts_file"
    t.integer  "gl_project_id"
    t.text     "artifacts_metadata"
    t.integer  "erased_by_id"
    t.datetime "erased_at"
  end

  add_index "ci_builds", ["commit_id", "stage_idx", "created_at"], name: "index_ci_builds_on_commit_id_and_stage_idx_and_created_at", using: :btree
  add_index "ci_builds", ["commit_id", "status", "type"], name: "index_ci_builds_on_commit_id_and_status_and_type", using: :btree
  add_index "ci_builds", ["commit_id", "type", "name", "ref"], name: "index_ci_builds_on_commit_id_and_type_and_name_and_ref", using: :btree
  add_index "ci_builds", ["commit_id", "type", "ref"], name: "index_ci_builds_on_commit_id_and_type_and_ref", using: :btree
  add_index "ci_builds", ["commit_id"], name: "index_ci_builds_on_commit_id", using: :btree
  add_index "ci_builds", ["erased_by_id"], name: "index_ci_builds_on_erased_by_id", using: :btree
  add_index "ci_builds", ["gl_project_id"], name: "index_ci_builds_on_gl_project_id", using: :btree
  add_index "ci_builds", ["project_id", "commit_id"], name: "index_ci_builds_on_project_id_and_commit_id", using: :btree
  add_index "ci_builds", ["project_id"], name: "index_ci_builds_on_project_id", using: :btree
  add_index "ci_builds", ["runner_id"], name: "index_ci_builds_on_runner_id", using: :btree
  add_index "ci_builds", ["status"], name: "index_ci_builds_on_status", using: :btree
  add_index "ci_builds", ["type"], name: "index_ci_builds_on_type", using: :btree

  create_table "ci_commits", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "ref"
    t.string   "sha"
    t.string   "before_sha"
    t.text     "push_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "tag",           default: false
    t.text     "yaml_errors"
    t.datetime "committed_at"
    t.integer  "gl_project_id"
    t.string   "status"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.integer  "duration"
  end

  add_index "ci_commits", ["gl_project_id", "sha"], name: "index_ci_commits_on_gl_project_id_and_sha", using: :btree
  add_index "ci_commits", ["gl_project_id", "status"], name: "index_ci_commits_on_gl_project_id_and_status", using: :btree
  add_index "ci_commits", ["gl_project_id"], name: "index_ci_commits_on_gl_project_id", using: :btree
  add_index "ci_commits", ["project_id", "committed_at", "id"], name: "index_ci_commits_on_project_id_and_committed_at_and_id", using: :btree
  add_index "ci_commits", ["project_id", "committed_at"], name: "index_ci_commits_on_project_id_and_committed_at", using: :btree
  add_index "ci_commits", ["project_id", "sha"], name: "index_ci_commits_on_project_id_and_sha", using: :btree
  add_index "ci_commits", ["project_id"], name: "index_ci_commits_on_project_id", using: :btree
  add_index "ci_commits", ["sha"], name: "index_ci_commits_on_sha", using: :btree
  add_index "ci_commits", ["status"], name: "index_ci_commits_on_status", using: :btree

  create_table "events", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.integer  "is_admin"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ci_events", ["created_at"], name: "index_ci_events_on_created_at", using: :btree
  add_index "ci_events", ["is_admin"], name: "index_ci_events_on_is_admin", using: :btree
  add_index "ci_events", ["project_id"], name: "index_ci_events_on_project_id", using: :btree

  create_table "ci_jobs", force: :cascade do |t|
    t.integer  "project_id",                          null: false
    t.text     "commands"
    t.boolean  "active",         default: true,       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "build_branches", default: true,       null: false
    t.boolean  "build_tags",     default: false,      null: false
    t.string   "job_type",       default: "parallel"
    t.string   "refs"
    t.datetime "deleted_at"
  end

  add_index "ci_jobs", ["deleted_at"], name: "index_ci_jobs_on_deleted_at", using: :btree
  add_index "ci_jobs", ["project_id"], name: "index_ci_jobs_on_project_id", using: :btree

  create_table "ci_projects", force: :cascade do |t|
    t.string   "name"
    t.integer  "timeout",                  default: 3600,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.string   "default_ref"
    t.string   "path"
    t.boolean  "always_build",             default: false, null: false
    t.integer  "polling_interval"
    t.boolean  "public",                   default: false, null: false
    t.string   "ssh_url_to_repo"
    t.integer  "gitlab_id"
    t.boolean  "allow_git_fetch",          default: true,  null: false
    t.string   "email_recipients",         default: "",    null: false
    t.boolean  "email_add_pusher",         default: true,  null: false
    t.boolean  "email_only_broken_builds", default: true,  null: false
    t.string   "skip_refs"
    t.string   "coverage_regex"
    t.boolean  "shared_runners_enabled",   default: false
    t.text     "generated_yaml_config"
  end

  add_index "ci_projects", ["gitlab_id"], name: "index_ci_projects_on_gitlab_id", using: :btree
  add_index "ci_projects", ["shared_runners_enabled"], name: "index_ci_projects_on_shared_runners_enabled", using: :btree

  create_table "ci_runner_projects", force: :cascade do |t|
    t.integer  "runner_id",     null: false
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gl_project_id"
  end

  add_index "ci_runner_projects", ["gl_project_id"], name: "index_ci_runner_projects_on_gl_project_id", using: :btree
  add_index "ci_runner_projects", ["runner_id"], name: "index_ci_runner_projects_on_runner_id", using: :btree

  create_table "ci_runners", force: :cascade do |t|
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.datetime "contacted_at"
    t.boolean  "active",       default: true,  null: false
    t.boolean  "is_shared",    default: false
    t.string   "name"
    t.string   "version"
    t.string   "revision"
    t.string   "platform"
    t.string   "architecture"
  end

  add_index "ci_runners", ["description"], name: "index_ci_runners_on_description_trigram", using: :gin, opclasses: {"description"=>"gin_trgm_ops"}
  add_index "ci_runners", ["token"], name: "index_ci_runners_on_token", using: :btree
  add_index "ci_runners", ["token"], name: "index_ci_runners_on_token_trigram", using: :gin, opclasses: {"token"=>"gin_trgm_ops"}

  create_table "ci_services", force: :cascade do |t|
    t.string   "type"
    t.string   "title"
    t.integer  "project_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     default: false, null: false
    t.text     "properties"
  end

  add_index "ci_services", ["project_id"], name: "index_ci_services_on_project_id", using: :btree

  create_table "ci_sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ci_sessions", ["session_id"], name: "index_ci_sessions_on_session_id", using: :btree
  add_index "ci_sessions", ["updated_at"], name: "index_ci_sessions_on_updated_at", using: :btree

  create_table "ci_taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "ci_taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "ci_taggings_idx", unique: true, using: :btree
  add_index "ci_taggings", ["taggable_id", "taggable_type", "context"], name: "index_ci_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "ci_tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "ci_tags", ["name"], name: "index_ci_tags_on_name", unique: true, using: :btree

  create_table "ci_trigger_requests", force: :cascade do |t|
    t.integer  "trigger_id", null: false
    t.text     "variables"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "commit_id"
  end

  create_table "ci_triggers", force: :cascade do |t|
    t.string   "token"
    t.integer  "project_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gl_project_id"
  end

  add_index "ci_triggers", ["deleted_at"], name: "index_ci_triggers_on_deleted_at", using: :btree
  add_index "ci_triggers", ["gl_project_id"], name: "index_ci_triggers_on_gl_project_id", using: :btree

  create_table "ci_variables", force: :cascade do |t|
    t.integer "project_id"
    t.string  "key"
    t.text    "value"
    t.text    "encrypted_value"
    t.string  "encrypted_value_salt"
    t.string  "encrypted_value_iv"
    t.integer "gl_project_id"
  end

  add_index "ci_variables", ["gl_project_id"], name: "index_ci_variables_on_gl_project_id", using: :btree

  create_table "ci_web_hooks", force: :cascade do |t|
    t.string   "url",        null: false
    t.integer  "project_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deploy_keys_projects", force: :cascade do |t|
    t.integer  "deploy_key_id", null: false
    t.integer  "project_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deploy_keys_projects", ["project_id"], name: "index_deploy_keys_projects_on_project_id", using: :btree

  create_table "emails", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "email",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "emails", ["email"], name: "index_emails_on_email", unique: true, using: :btree
  add_index "emails", ["user_id"], name: "index_emails_on_user_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "target_type"
    t.integer  "target_id"
    t.string   "title"
    t.text     "data"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "action"
    t.integer  "author_id"
  end

  add_index "events", ["action"], name: "index_events_on_action", using: :btree
  add_index "events", ["author_id"], name: "index_events_on_author_id", using: :btree
  add_index "events", ["created_at"], name: "index_events_on_created_at", using: :btree
  add_index "events", ["project_id"], name: "index_events_on_project_id", using: :btree
  add_index "events", ["target_id"], name: "index_events_on_target_id", using: :btree
  add_index "events", ["target_type"], name: "index_events_on_target_type", using: :btree

  create_table "forked_project_links", force: :cascade do |t|
    t.integer  "forked_to_project_id",   null: false
    t.integer  "forked_from_project_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forked_project_links", ["forked_to_project_id"], name: "index_forked_project_links_on_forked_to_project_id", unique: true, using: :btree

  create_table "identities", force: :cascade do |t|
    t.string   "extern_uid"
    t.string   "provider"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["created_at", "id"], name: "index_identities_on_created_at_and_id", using: :btree
  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "issues", force: :cascade do |t|
    t.string   "title"
    t.integer  "assignee_id"
    t.integer  "author_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",      default: 0
    t.string   "branch_name"
    t.text     "description"
    t.integer  "milestone_id"
    t.string   "state"
    t.integer  "iid"
    t.integer  "updated_by_id"
    t.boolean  "confidential",  default: false
    t.datetime "deleted_at"
    t.date     "due_date"
    t.integer  "moved_to_id"
  end

  add_index "issues", ["assignee_id"], name: "index_issues_on_assignee_id", using: :btree
  add_index "issues", ["author_id"], name: "index_issues_on_author_id", using: :btree
  add_index "issues", ["confidential"], name: "index_issues_on_confidential", using: :btree
  add_index "issues", ["created_at", "id"], name: "index_issues_on_created_at_and_id", using: :btree
  add_index "issues", ["created_at"], name: "index_issues_on_created_at", using: :btree
  add_index "issues", ["deleted_at"], name: "index_issues_on_deleted_at", using: :btree
  add_index "issues", ["description"], name: "index_issues_on_description_trigram", using: :gin, opclasses: {"description"=>"gin_trgm_ops"}
  add_index "issues", ["due_date"], name: "index_issues_on_due_date", using: :btree
  add_index "issues", ["milestone_id"], name: "index_issues_on_milestone_id", using: :btree
  add_index "issues", ["project_id", "iid"], name: "index_issues_on_project_id_and_iid", unique: true, using: :btree
  add_index "issues", ["project_id"], name: "index_issues_on_project_id", using: :btree
  add_index "issues", ["state"], name: "index_issues_on_state", using: :btree
  add_index "issues", ["title"], name: "index_issues_on_title", using: :btree
  add_index "issues", ["title"], name: "index_issues_on_title_trigram", using: :gin, opclasses: {"title"=>"gin_trgm_ops"}

  create_table "keys", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "key"
    t.string   "title"
    t.string   "type"
    t.string   "fingerprint"
    t.boolean  "public",      default: false, null: false
  end

  add_index "keys", ["created_at", "id"], name: "index_keys_on_created_at_and_id", using: :btree
  add_index "keys", ["user_id"], name: "index_keys_on_user_id", using: :btree

  create_table "label_links", force: :cascade do |t|
    t.integer  "label_id"
    t.integer  "target_id"
    t.string   "target_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "label_links", ["label_id"], name: "index_label_links_on_label_id", using: :btree
  add_index "label_links", ["target_id", "target_type"], name: "index_label_links_on_target_id_and_target_type", using: :btree

  create_table "labels", force: :cascade do |t|
    t.string   "title"
    t.string   "color"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "template",    default: false
    t.string   "description"
  end

  add_index "labels", ["project_id"], name: "index_labels_on_project_id", using: :btree

  create_table "lfs_objects", force: :cascade do |t|
    t.string   "oid",                  null: false
    t.integer  "size",       limit: 8, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file"
  end

  add_index "lfs_objects", ["oid"], name: "index_lfs_objects_on_oid", unique: true, using: :btree

  create_table "lfs_objects_projects", force: :cascade do |t|
    t.integer  "lfs_object_id", null: false
    t.integer  "project_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lfs_objects_projects", ["project_id"], name: "index_lfs_objects_projects_on_project_id", using: :btree

  create_table "members", force: :cascade do |t|
    t.integer  "access_level",       null: false
    t.integer  "source_id",          null: false
    t.string   "source_type",        null: false
    t.integer  "user_id"
    t.integer  "notification_level", null: false
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.string   "invite_email"
    t.string   "invite_token"
    t.datetime "invite_accepted_at"
  end

  add_index "members", ["access_level"], name: "index_members_on_access_level", using: :btree
  add_index "members", ["created_at", "id"], name: "index_members_on_created_at_and_id", using: :btree
  add_index "members", ["invite_token"], name: "index_members_on_invite_token", unique: true, using: :btree
  add_index "members", ["source_id", "source_type"], name: "index_members_on_source_id_and_source_type", using: :btree
  add_index "members", ["type"], name: "index_members_on_type", using: :btree
  add_index "members", ["user_id"], name: "index_members_on_user_id", using: :btree

  create_table "merge_request_diffs", force: :cascade do |t|
    t.string   "state"
    t.text     "st_commits"
    t.text     "st_diffs"
    t.integer  "merge_request_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "base_commit_sha"
    t.string   "real_size"
  end

  add_index "merge_request_diffs", ["merge_request_id"], name: "index_merge_request_diffs_on_merge_request_id", unique: true, using: :btree

  create_table "merge_requests", force: :cascade do |t|
    t.string   "target_branch",                             null: false
    t.string   "source_branch",                             null: false
    t.integer  "source_project_id",                         null: false
    t.integer  "author_id"
    t.integer  "assignee_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "milestone_id"
    t.string   "state"
    t.string   "merge_status"
    t.integer  "target_project_id",                         null: false
    t.integer  "iid"
    t.text     "description"
    t.integer  "position",                  default: 0
    t.datetime "locked_at"
    t.integer  "updated_by_id"
    t.string   "merge_error"
    t.text     "merge_params"
    t.boolean  "merge_when_build_succeeds", default: false, null: false
    t.integer  "merge_user_id"
    t.string   "merge_commit_sha"
    t.datetime "deleted_at"
  end

  add_index "merge_requests", ["assignee_id"], name: "index_merge_requests_on_assignee_id", using: :btree
  add_index "merge_requests", ["author_id"], name: "index_merge_requests_on_author_id", using: :btree
  add_index "merge_requests", ["created_at", "id"], name: "index_merge_requests_on_created_at_and_id", using: :btree
  add_index "merge_requests", ["created_at"], name: "index_merge_requests_on_created_at", using: :btree
  add_index "merge_requests", ["deleted_at"], name: "index_merge_requests_on_deleted_at", using: :btree
  add_index "merge_requests", ["description"], name: "index_merge_requests_on_description_trigram", using: :gin, opclasses: {"description"=>"gin_trgm_ops"}
  add_index "merge_requests", ["milestone_id"], name: "index_merge_requests_on_milestone_id", using: :btree
  add_index "merge_requests", ["source_branch"], name: "index_merge_requests_on_source_branch", using: :btree
  add_index "merge_requests", ["source_project_id"], name: "index_merge_requests_on_source_project_id", using: :btree
  add_index "merge_requests", ["target_branch"], name: "index_merge_requests_on_target_branch", using: :btree
  add_index "merge_requests", ["target_project_id", "iid"], name: "index_merge_requests_on_target_project_id_and_iid", unique: true, using: :btree
  add_index "merge_requests", ["title"], name: "index_merge_requests_on_title", using: :btree
  add_index "merge_requests", ["title"], name: "index_merge_requests_on_title_trigram", using: :gin, opclasses: {"title"=>"gin_trgm_ops"}

  create_table "milestones", force: :cascade do |t|
    t.string   "title",       null: false
    t.integer  "project_id",  null: false
    t.text     "description"
    t.date     "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.integer  "iid"
  end

  add_index "milestones", ["created_at", "id"], name: "index_milestones_on_created_at_and_id", using: :btree
  add_index "milestones", ["description"], name: "index_milestones_on_description_trigram", using: :gin, opclasses: {"description"=>"gin_trgm_ops"}
  add_index "milestones", ["due_date"], name: "index_milestones_on_due_date", using: :btree
  add_index "milestones", ["project_id", "iid"], name: "index_milestones_on_project_id_and_iid", unique: true, using: :btree
  add_index "milestones", ["project_id"], name: "index_milestones_on_project_id", using: :btree
  add_index "milestones", ["title"], name: "index_milestones_on_title", using: :btree
  add_index "milestones", ["title"], name: "index_milestones_on_title_trigram", using: :gin, opclasses: {"title"=>"gin_trgm_ops"}

  create_table "namespaces", force: :cascade do |t|
    t.string   "name",                                  null: false
    t.string   "path",                                  null: false
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "description",           default: "",    null: false
    t.string   "avatar"
    t.boolean  "share_with_group_lock", default: false
    t.integer  "visibility_level",      default: 20,    null: false
  end

  add_index "namespaces", ["created_at", "id"], name: "index_namespaces_on_created_at_and_id", using: :btree
  add_index "namespaces", ["name"], name: "index_namespaces_on_name", unique: true, using: :btree
  add_index "namespaces", ["name"], name: "index_namespaces_on_name_trigram", using: :gin, opclasses: {"name"=>"gin_trgm_ops"}
  add_index "namespaces", ["owner_id"], name: "index_namespaces_on_owner_id", using: :btree
  add_index "namespaces", ["path"], name: "index_namespaces_on_path", unique: true, using: :btree
  add_index "namespaces", ["path"], name: "index_namespaces_on_path_trigram", using: :gin, opclasses: {"path"=>"gin_trgm_ops"}
  add_index "namespaces", ["type"], name: "index_namespaces_on_type", using: :btree
  add_index "namespaces", ["visibility_level"], name: "index_namespaces_on_visibility_level", using: :btree

  create_table "notes", force: :cascade do |t|
    t.text     "note"
    t.string   "noteable_type"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.string   "attachment"
    t.string   "line_code"
    t.string   "commit_id"
    t.integer  "noteable_id"
    t.boolean  "system",            default: false, null: false
    t.text     "st_diff"
    t.integer  "updated_by_id"
    t.boolean  "is_award",          default: false, null: false
    t.string   "type"
  end

  add_index "notes", ["author_id"], name: "index_notes_on_author_id", using: :btree
  add_index "notes", ["commit_id"], name: "index_notes_on_commit_id", using: :btree
  add_index "notes", ["created_at", "id"], name: "index_notes_on_created_at_and_id", using: :btree
  add_index "notes", ["created_at"], name: "index_notes_on_created_at", using: :btree
  add_index "notes", ["is_award"], name: "index_notes_on_is_award", using: :btree
  add_index "notes", ["line_code"], name: "index_notes_on_line_code", using: :btree
  add_index "notes", ["note"], name: "index_notes_on_note_trigram", using: :gin, opclasses: {"note"=>"gin_trgm_ops"}
  add_index "notes", ["noteable_id", "noteable_type"], name: "index_notes_on_noteable_id_and_noteable_type", using: :btree
  add_index "notes", ["noteable_type"], name: "index_notes_on_noteable_type", using: :btree
  add_index "notes", ["project_id", "noteable_type"], name: "index_notes_on_project_id_and_noteable_type", using: :btree
  add_index "notes", ["project_id"], name: "index_notes_on_project_id", using: :btree
  add_index "notes", ["updated_at"], name: "index_notes_on_updated_at", using: :btree

  create_table "notification_settings", force: :cascade do |t|
    t.integer  "user_id",                 null: false
    t.integer  "source_id",               null: false
    t.string   "source_type",             null: false
    t.integer  "level",       default: 0, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "notification_settings", ["source_id", "source_type"], name: "index_notification_settings_on_source_id_and_source_type", using: :btree
  add_index "notification_settings", ["user_id"], name: "index_notification_settings_on_user_id", using: :btree

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  add_index "oauth_applications", ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type", using: :btree
  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "project_group_links", force: :cascade do |t|
    t.integer  "project_id",                null: false
    t.integer  "group_id",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_access", default: 30, null: false
  end

  create_table "project_import_data", force: :cascade do |t|
    t.integer "project_id"
    t.text    "data"
    t.text    "encrypted_credentials"
    t.string  "encrypted_credentials_iv"
    t.string  "encrypted_credentials_salt"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.string   "path"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.boolean  "issues_enabled",               default: true,     null: false
    t.boolean  "merge_requests_enabled",       default: true,     null: false
    t.boolean  "wiki_enabled",                 default: true,     null: false
    t.integer  "namespace_id"
    t.string   "issues_tracker",               default: "gitlab", null: false
    t.string   "issues_tracker_id"
    t.boolean  "snippets_enabled",             default: true,     null: false
    t.datetime "last_activity_at"
    t.string   "import_url"
    t.integer  "visibility_level",             default: 0,        null: false
    t.boolean  "archived",                     default: false,    null: false
    t.string   "avatar"
    t.string   "import_status"
    t.float    "repository_size",              default: 0.0
    t.integer  "star_count",                   default: 0,        null: false
    t.string   "import_type"
    t.string   "import_source"
    t.integer  "commit_count",                 default: 0
    t.text     "import_error"
    t.integer  "ci_id"
    t.boolean  "builds_enabled",               default: true,     null: false
    t.boolean  "shared_runners_enabled",       default: true,     null: false
    t.string   "runners_token"
    t.string   "build_coverage_regex"
    t.boolean  "build_allow_git_fetch",        default: true,     null: false
    t.integer  "build_timeout",                default: 3600,     null: false
    t.boolean  "pending_delete",               default: false
    t.boolean  "public_builds",                default: true,     null: false
    t.string   "main_language"
    t.integer  "pushes_since_gc",              default: 0
    t.boolean  "last_repository_check_failed"
    t.datetime "last_repository_check_at"
    t.boolean  "container_registry_enabled"
  end

  add_index "projects", ["builds_enabled", "shared_runners_enabled"], name: "index_projects_on_builds_enabled_and_shared_runners_enabled", using: :btree
  add_index "projects", ["builds_enabled"], name: "index_projects_on_builds_enabled", using: :btree
  add_index "projects", ["ci_id"], name: "index_projects_on_ci_id", using: :btree
  add_index "projects", ["created_at", "id"], name: "index_projects_on_created_at_and_id", using: :btree
  add_index "projects", ["creator_id"], name: "index_projects_on_creator_id", using: :btree
  add_index "projects", ["description"], name: "index_projects_on_description_trigram", using: :gin, opclasses: {"description"=>"gin_trgm_ops"}
  add_index "projects", ["last_activity_at"], name: "index_projects_on_last_activity_at", using: :btree
  add_index "projects", ["last_repository_check_failed"], name: "index_projects_on_last_repository_check_failed", using: :btree
  add_index "projects", ["name"], name: "index_projects_on_name_trigram", using: :gin, opclasses: {"name"=>"gin_trgm_ops"}
  add_index "projects", ["namespace_id"], name: "index_projects_on_namespace_id", using: :btree
  add_index "projects", ["path"], name: "index_projects_on_path", using: :btree
  add_index "projects", ["path"], name: "index_projects_on_path_trigram", using: :gin, opclasses: {"path"=>"gin_trgm_ops"}
  add_index "projects", ["pending_delete"], name: "index_projects_on_pending_delete", using: :btree
  add_index "projects", ["runners_token"], name: "index_projects_on_runners_token", using: :btree
  add_index "projects", ["star_count"], name: "index_projects_on_star_count", using: :btree
  add_index "projects", ["visibility_level"], name: "index_projects_on_visibility_level", using: :btree

  create_table "protected_branches", force: :cascade do |t|
    t.integer  "project_id",                          null: false
    t.string   "name",                                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "developers_can_push", default: false, null: false
  end

  add_index "protected_branches", ["project_id"], name: "index_protected_branches_on_project_id", using: :btree

  create_table "releases", force: :cascade do |t|
    t.string   "tag"
    t.text     "description"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "releases", ["project_id", "tag"], name: "index_releases_on_project_id_and_tag", using: :btree
  add_index "releases", ["project_id"], name: "index_releases_on_project_id", using: :btree

  create_table "sent_notifications", force: :cascade do |t|
    t.integer "project_id"
    t.integer "noteable_id"
    t.string  "noteable_type"
    t.integer "recipient_id"
    t.string  "commit_id"
    t.string  "reply_key",     null: false
    t.string  "line_code"
  end

  add_index "sent_notifications", ["reply_key"], name: "index_sent_notifications_on_reply_key", unique: true, using: :btree

  create_table "services", force: :cascade do |t|
    t.string   "type"
    t.string   "title"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                default: false,    null: false
    t.text     "properties"
    t.boolean  "template",              default: false
    t.boolean  "push_events",           default: true
    t.boolean  "issues_events",         default: true
    t.boolean  "merge_requests_events", default: true
    t.boolean  "tag_push_events",       default: true
    t.boolean  "note_events",           default: true,     null: false
    t.boolean  "build_events",          default: false,    null: false
    t.string   "category",              default: "common", null: false
    t.boolean  "default",               default: false
    t.boolean  "wiki_page_events",      default: true
  end

  add_index "services", ["category"], name: "index_services_on_category", using: :btree
  add_index "services", ["created_at", "id"], name: "index_services_on_created_at_and_id", using: :btree
  add_index "services", ["default"], name: "index_services_on_default", using: :btree
  add_index "services", ["project_id"], name: "index_services_on_project_id", using: :btree
  add_index "services", ["template"], name: "index_services_on_template", using: :btree

  create_table "snippets", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "author_id",                    null: false
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_name"
    t.string   "type"
    t.integer  "visibility_level", default: 0, null: false
  end

  add_index "snippets", ["author_id"], name: "index_snippets_on_author_id", using: :btree
  add_index "snippets", ["created_at", "id"], name: "index_snippets_on_created_at_and_id", using: :btree
  add_index "snippets", ["created_at"], name: "index_snippets_on_created_at", using: :btree
  add_index "snippets", ["file_name"], name: "index_snippets_on_file_name_trigram", using: :gin, opclasses: {"file_name"=>"gin_trgm_ops"}
  add_index "snippets", ["project_id"], name: "index_snippets_on_project_id", using: :btree
  add_index "snippets", ["title"], name: "index_snippets_on_title_trigram", using: :gin, opclasses: {"title"=>"gin_trgm_ops"}
  add_index "snippets", ["updated_at"], name: "index_snippets_on_updated_at", using: :btree
  add_index "snippets", ["visibility_level"], name: "index_snippets_on_visibility_level", using: :btree

  create_table "spam_logs", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "source_ip"
    t.string   "user_agent"
    t.boolean  "via_api"
    t.integer  "project_id"
    t.string   "noteable_type"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "subscribable_id"
    t.string   "subscribable_type"
    t.boolean  "subscribed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["subscribable_id", "subscribable_type", "user_id"], name: "subscriptions_user_id_and_ref_fields", unique: true, using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "todos", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.integer  "project_id",  null: false
    t.integer  "target_id"
    t.string   "target_type", null: false
    t.integer  "author_id"
    t.integer  "action",      null: false
    t.string   "state",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "note_id"
    t.string   "commit_id"
  end

  add_index "todos", ["author_id"], name: "index_todos_on_author_id", using: :btree
  add_index "todos", ["commit_id"], name: "index_todos_on_commit_id", using: :btree
  add_index "todos", ["note_id"], name: "index_todos_on_note_id", using: :btree
  add_index "todos", ["project_id"], name: "index_todos_on_project_id", using: :btree
  add_index "todos", ["state"], name: "index_todos_on_state", using: :btree
  add_index "todos", ["target_type", "target_id"], name: "index_todos_on_target_type_and_target_id", using: :btree
  add_index "todos", ["user_id"], name: "index_todos_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                       default: "",    null: false
    t.string   "encrypted_password",          default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",               default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "admin",                       default: false, null: false
    t.integer  "projects_limit",              default: 10
    t.string   "skype",                       default: "",    null: false
    t.string   "linkedin",                    default: "",    null: false
    t.string   "twitter",                     default: "",    null: false
    t.string   "authentication_token"
    t.integer  "theme_id",                    default: 1,     null: false
    t.string   "bio"
    t.integer  "failed_attempts",             default: 0
    t.datetime "locked_at"
    t.string   "username"
    t.boolean  "can_create_group",            default: true,  null: false
    t.boolean  "can_create_team",             default: true,  null: false
    t.string   "state"
    t.integer  "color_scheme_id",             default: 1,     null: false
    t.integer  "notification_level",          default: 1,     null: false
    t.datetime "password_expires_at"
    t.integer  "created_by_id"
    t.datetime "last_credential_check_at"
    t.string   "avatar"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "hide_no_ssh_key",             default: false
    t.string   "website_url",                 default: "",    null: false
    t.string   "notification_email"
    t.boolean  "hide_no_password",            default: false
    t.boolean  "password_automatically_set",  default: false
    t.string   "location"
    t.string   "encrypted_otp_secret"
    t.string   "encrypted_otp_secret_iv"
    t.string   "encrypted_otp_secret_salt"
    t.boolean  "otp_required_for_login",      default: false, null: false
    t.text     "otp_backup_codes"
    t.string   "public_email",                default: "",    null: false
    t.integer  "dashboard",                   default: 0
    t.integer  "project_view",                default: 0
    t.integer  "consumed_timestep"
    t.integer  "layout",                      default: 0
    t.boolean  "hide_project_limit",          default: false
    t.string   "unlock_token"
    t.datetime "otp_grace_period_started_at"
    t.boolean  "ldap_email",                  default: false, null: false
    t.boolean  "external",                    default: false
  end

  add_index "users", ["admin"], name: "index_users_on_admin", using: :btree
  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["created_at", "id"], name: "index_users_on_created_at_and_id", using: :btree
  add_index "users", ["current_sign_in_at"], name: "index_users_on_current_sign_in_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email_trigram", using: :gin, opclasses: {"email"=>"gin_trgm_ops"}
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["name"], name: "index_users_on_name_trigram", using: :gin, opclasses: {"name"=>"gin_trgm_ops"}
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree
  add_index "users", ["username"], name: "index_users_on_username_trigram", using: :gin, opclasses: {"username"=>"gin_trgm_ops"}

  create_table "users_star_projects", force: :cascade do |t|
    t.integer  "project_id", null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_star_projects", ["project_id"], name: "index_users_star_projects_on_project_id", using: :btree
  add_index "users_star_projects", ["user_id", "project_id"], name: "index_users_star_projects_on_user_id_and_project_id", unique: true, using: :btree
  add_index "users_star_projects", ["user_id"], name: "index_users_star_projects_on_user_id", using: :btree

  create_table "web_hooks", force: :cascade do |t|
    t.string   "url",                     limit: 2000
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                                 default: "ProjectHook"
    t.integer  "service_id"
    t.boolean  "push_events",                          default: true,          null: false
    t.boolean  "issues_events",                        default: false,         null: false
    t.boolean  "merge_requests_events",                default: false,         null: false
    t.boolean  "tag_push_events",                      default: false
    t.boolean  "note_events",                          default: false,         null: false
    t.boolean  "enable_ssl_verification",              default: true
    t.boolean  "build_events",                         default: false,         null: false
    t.boolean  "wiki_page_events",                     default: false,         null: false
    t.string   "token"
  end

  add_index "web_hooks", ["created_at", "id"], name: "index_web_hooks_on_created_at_and_id", using: :btree
  add_index "web_hooks", ["project_id"], name: "index_web_hooks_on_project_id", using: :btree

end

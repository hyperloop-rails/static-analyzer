
 form_tag({}, :multipart => true, :action => 'post') do 
 hidden_field_tag 'key', params[:key] 
 text_area_tag 'email', '', :style => 'width:95%; height:400px;' 
 select_tag 'unknown_user', options_for_select(['', 'ignore', 'accept', 'create']) 
 text_field_tag 'default_group' 
 check_box_tag 'no_account_notice', 1 
 check_box_tag 'no_notification', 1 
 check_box_tag 'no_permission_check', 1 
 text_field_tag 'issue[project]' 
 text_field_tag 'issue[status]' 
 text_field_tag 'issue[tracker]' 
 text_field_tag 'issue[category]' 
 text_field_tag 'issue[priority]' 
 text_field_tag 'issue[assigned_to]' 
 text_field_tag 'issue[fixed_version]' 
 check_box_tag 'issue[private]', 1 
 text_field_tag 'allow_override' 
 submit_tag 'Submit Email' 
 end 

# Redmine - project management software
# Copyright (C) 2006-2016  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class MailHandlerController < ActionController::Base
  before_action :check_credential

  # Displays the email submission form
  def new
  end

  # Submits an incoming email to MailHandler
  def index
    options = params.dup
    email = options.delete(:email)
    if MailHandler.receive(email, options)
      head :created
    else
      head :unprocessable_entity
    end
  end

  private

  def check_credential
    User.current = nil
    unless Setting.mail_handler_api_enabled? && params[:key].to_s == Setting.mail_handler_api_key
      render :plain => 'Access denied. Incoming emails WS is disabled or key is invalid.', :status => 403
    end
  end
end

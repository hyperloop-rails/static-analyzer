# Amahi Home Server
# Copyright (C) 2007-2013 Amahi
#

require 'leases'

class NetworkController < ApplicationController
  KIND = Setting::NETWORK
  before_filter :admin_required
  before_filter :set_page_title
  IP_RANGE = 10

  def index
    @leases = use_sample_data? ? SampleData.load('leases') : Leases.all
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 ::Temple::Utils.escape_html((t 'expiration')) 
 ::Temple::Utils.escape_html((t 'mac')) 
 ::Temple::Utils.escape_html((t 'ip')) 
 ::Temple::Utils.escape_html((t 'name')) 
 @leases.each do |lease|
 
 _temple_html_attributeremover1 = ''; _slim_codeattributes1 = cycle("odd", "even"); if Array === _slim_codeattributes1; _slim_codeattributes1 = _slim_codeattributes1.flatten; _slim_codeattributes1.map!(&:to_s); _slim_codeattributes1.reject!(&:empty?); _temple_html_attributeremover1 << ((::Temple::Utils.escape_html((_slim_codeattributes1.join(" ")))).to_s); else; _temple_html_attributeremover1 << ((::Temple::Utils.escape_html((_slim_codeattributes1))).to_s); end; _temple_html_attributeremover1 
 if !_temple_html_attributeremover1.empty? 
 _temple_html_attributeremover1 
 end 
 ::Temple::Utils.escape_html((time_ago_in_words(Time.at(lease[:expiration])))) 
 ::Temple::Utils.escape_html((lease[:mac])) 
 ::Temple::Utils.escape_html((lease[:ip])) 
 ::Temple::Utils.escape_html((lease[:name])) 
 end 

end

  end

  def hosts
    get_hosts
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @hosts.any?
 
 ::Temple::Utils.escape_html((t 'host')) 
 ::Temple::Utils.escape_html((t 'ip_address')) 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((link_to host.name, '#')) 
 ::Temple::Utils.escape_html((@net + '.' + host.address)) 
 ::Temple::Utils.escape_html((host.name)) 
 ::Temple::Utils.escape_html((spinner)) 
 ::Temple::Utils.escape_html((link_to t('delete') + ' ' + host.name,
network_engine.destroy_host_path(host),
:method => :delete,
:data => {:confirm => confirm_host_destroy_message(host.name)},
:remote => true,
:class => 'btn-delete remote-btn btn btn-primary btn-sm pull-right')) 
 ::Temple::Utils.escape_html((t('host'))) 
 ::Temple::Utils.escape_html((host.name)) 
 ::Temple::Utils.escape_html((t('mac'))) 
 ::Temple::Utils.escape_html((host.mac)) 
 ::Temple::Utils.escape_html((t('ip'))) 
 ::Temple::Utils.escape_html((@net + '.' + host.address)) 
)) 
 end 
 ::Temple::Utils.escape_html((t('there_are_no_hosts'))) 
 ::Temple::Utils.escape_html((button_tag t('new_host'), type: 'button', class: 'open-area btnn btn-create btn btn-info btn-sm', id: 'new-host-to-step1', data: { related: '#new-host-step1' })) 
 ::Temple::Utils.escape_html(( @host = @host || Host.new

_slim_controls1 = form_for @host, url: network_engine.hosts_path, remote: true, html: { class: 'host create-form form-horizontal col-md-6', id: 'new-host-form' } do |f|
 
 ::Temple::Utils.escape_html((t('create_a_new_host'))) 
 ::Temple::Utils.escape_html((f.text_field :name, size: 16, maxlength: 20, placeholder: t('name'),:class=>'form-control input-sm top-margin-10')) 
 ::Temple::Utils.escape_html((f.text_field :mac, size: 16, maxlength: 20, placeholder: t('mac_address') ,:class=>'form-control input-sm top-margin-10')) 
 ::Temple::Utils.escape_html((t('host_mac_hint'))) 
 ::Temple::Utils.escape_html((f.text_field :address, size: 16, maxlength: 20, placeholder: t('ip_address') ,:class=>'form-control input-sm top-margin-10')) 
 ::Temple::Utils.escape_html((@net + '.')) 
 ::Temple::Utils.escape_html(('X')) 
 ::Temple::Utils.escape_html((spinner)) 
 ::Temple::Utils.escape_html((button_tag t('create'), type: 'submit', id: 'host_create_button', class: 'btnn btn-create btn btn-info btn-sm ')) 
 ::Temple::Utils.escape_html((link_to t('cancel'), '#', class: 'close-area cancel-link btn btn-primary btn-sm left-margin-10', data: { related: '#new-host-to-step1' })) 
 end 
 ::Temple::Utils.escape_html((_slim_controls1)) 
)) 

end

  end

  def create_host
    sleep 2 if development?
    @host = Host.create params[:host]
    get_hosts
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
self.formats = [:html]

if @host.errors.any?
  json.status :not_accepted
  json.content render(:partial => 'network/host_form', :object => @host)
else
  @host = nil
  json.status :ok
  json.content render(:template => 'network/hosts')
end

end

  end

  def destroy_host
    sleep 2 if development?
    @host = Host.find params[:id]
    @host.destroy
    render json: {:status=>:ok,id: @host.id }
  end

  def dns_aliases
    unless @advanced
      redirect_to network_engine_path
    else
      get_dns_aliases
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @dns_aliases.any?
 
 ::Temple::Utils.escape_html((t 'name')) 
 ::Temple::Utils.escape_html((t 'ip_address')) 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((link_to dns_alias.name, '#')) 
 ::Temple::Utils.escape_html((alias_ip(dns_alias))) 
 ::Temple::Utils.escape_html((dns_alias.name)) 
 ::Temple::Utils.escape_html((spinner)) 
 ::Temple::Utils.escape_html((link_to t('delete') + ' ' + dns_alias.name,
network_engine.destroy_dns_alias_path(dns_alias),
:method => :delete,
:data => {:confirm => confirm_dns_alias_destroy_message(dns_alias.name)},
:remote => true,
:class => 'btn-delete remote-btn btn btn-primary btn-sm pull-right')) 
 ::Temple::Utils.escape_html((t('name'))) 
 ::Temple::Utils.escape_html((link_to "http://#{dns_alias.name}", "http://#{dns_alias.name}")) 
 ::Temple::Utils.escape_html((t('ip_address'))) 
 ::Temple::Utils.escape_html((alias_ip(dns_alias))) 
)) 
 end 
 ::Temple::Utils.escape_html((t('there_are_no_dns_aliases'))) 
 ::Temple::Utils.escape_html((button_tag t('new_dns_alias'), type: 'button', class: 'open-area btnn btn-create btn btn-info btn-sm', id: 'new-dns-alias-to-step1', data: { related: '#new-dns-alias-step1' })) 
 ::Temple::Utils.escape_html(( @dns_alias = @dns_alias || DnsAlias.new

_slim_controls1 = form_for @dns_alias, url: network_engine.dns_aliases_path, remote: true, html: { class: 'dns_alias create-form form-horizontal col-md-6', id: 'new-dns-alias-form' } do |f|
 
 ::Temple::Utils.escape_html((t('create_a_new_dns_alias'))) 
 ::Temple::Utils.escape_html((f.text_field :name, size: 16, maxlength: 20, placeholder: t('name'),:class=>'form-control input-sm top-margin-10')) 
 ::Temple::Utils.escape_html((f.text_field :address, size: 16, maxlength: 20, placeholder: t('ip_address'),:class=>'form-control input-sm top-margin-10')) 
 ::Temple::Utils.escape_html((@net + '.')) 
 ::Temple::Utils.escape_html(('X')) 
 ::Temple::Utils.escape_html((spinner)) 
 ::Temple::Utils.escape_html((button_tag t('create'), type: 'submit', id: 'dns_alias_create_button', class: 'btnn btn-create btn btn-info btn-sm')) 
 ::Temple::Utils.escape_html((link_to t('cancel'), '#', class: 'close-area cancel-link btn btn-primary btn-sm left-margin-10', data: { related: '#new-dns-alias-to-step1' })) 
 end 
 ::Temple::Utils.escape_html((_slim_controls1)) 
)) 

end

  end

  def create_dns_alias
    sleep 2 if development?
    @dns_alias = DnsAlias.create params[:dns_alias]
    get_dns_aliases
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
self.formats = [:html]

if @dns_alias.errors.any?
  json.status :not_accepted
  json.content render(:partial => 'network/dns_alias_form', :object => @dns_alias)
else
  @dns_alias = nil
  json.status :ok
  json.content render(:template => 'network/dns_aliases')
end

end

  end

  def destroy_dns_alias
    sleep 2 if development?
    @dns_alias = DnsAlias.find params[:id]
    @dns_alias.destroy
    render json: { :status=>:ok, id: @dns_alias.id }
  end

  def settings
    unless @advanced
      redirect_to network_engine_path
    else
      @net = Setting.get 'net'
      @dns = Setting.find_or_create_by(KIND, 'dns', 'opendns')
      @dns_ip_1, @dns_ip_2 = DnsIpSetting.custom_dns_ips
      @dnsmasq_dhcp = Setting.find_or_create_by(KIND, 'dnsmasq_dhcp', '1')
      @dnsmasq_dns = Setting.find_or_create_by(KIND, 'dnsmasq_dns', '1')
      @lease_time = Setting.get("lease_time") || "14400"
      @gateway = Setting.find_or_create_by(KIND, 'gateway', '1').value
      @dyn_lo = Setting.find_or_create_by(KIND, 'dyn_lo', '100').value
      @dyn_hi = Setting.find_or_create_by(KIND, 'dyn_hi', '254').value
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 ::Temple::Utils.escape_html((t 'settings')) 
 ::Temple::Utils.escape_html((t 'dhcp_server')) 
 ::Temple::Utils.escape_html((simple_remote_checkbox id: "setting_dnsmasq_dhcp",
url: network_engine.toggle_setting_path(@dnsmasq_dhcp),
checked: @dnsmasq_dhcp.set?)) 
 ::Temple::Utils.escape_html((t 'dns_server')) 
 ::Temple::Utils.escape_html((simple_remote_checkbox id: "setting_dnsmasq_dns",
url: network_engine.toggle_setting_path(@dnsmasq_dns),
checked: @dnsmasq_dns.set?)) 
 ::Temple::Utils.escape_html((t 'lease_time')) 
 ::Temple::Utils.escape_html((@lease_time)) 
 ::Temple::Utils.escape_html((simple_remote_text     :id => "lease_time_area",
:input_id =>"lease_time",
:form_id => "lease_form",
:button_id => "",
:url => network_engine.update_lease_time_path,
:label => t("change"),
:disabled => false,
:value => @lease_time,
:name => :lease_time,
:method => :put,
:remote => true,
:input_css_class=>'form-control input-sm',
:form_css_class => "edit_lease_form form-inline form_hidden",
:cancel_class => "lease-cancel-link btn btn-primary btn-sm left-margin-10")) 
 ::Temple::Utils.escape_html((t 'dns_provider')) 
 ::Temple::Utils.escape_html((simple_remote_select id: "setting_dns",
name: "setting_dns",
collection: dns_select_options,
url: network_engine.update_dns_path,
selected: @dns.value)) 
 _slim_codeattributes1 = (@dns.value == "custom" ? "" : "display: none"); if _slim_codeattributes1; if _slim_codeattributes1 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes1)) 
 end; end 
 _slim_controls1 = form_tag network_engine.update_dns_ips_path, remote: true, method: 'put', id: 'update-dns-ips-form', class: 'update-form form-horizontal' do |f|
 
 ::Temple::Utils.escape_html((text_field_tag "dns_ip_1", @dns_ip_1, placeholder: t('dns_ip_1'))) 
 ::Temple::Utils.escape_html((text_field_tag "dns_ip_2", @dns_ip_2, placeholder: t('dns_ip_2'))) 
 ::Temple::Utils.escape_html((spinner)) 
 ::Temple::Utils.escape_html((submit_tag t('update_dns_ips'), class: 'btnn', disabled: 'disabled')) 
 end 
 ::Temple::Utils.escape_html((_slim_controls1)) 
 ::Temple::Utils.escape_html((t 'gateway')) 
 ::Temple::Utils.escape_html((@net +'.')) 
 ::Temple::Utils.escape_html((@gateway)) 
 ::Temple::Utils.escape_html((simple_remote_text     :id => "gateway_area",
:input_id =>"gateway_input",
:form_id => "gateway_form",
:button_id => "",
:url => network_engine.update_gateway_path,
:label => t("change"),
:disabled => false,
:value => @gateway,
:name => :gateway,
:method => :put,
:remote => true,
:input_css_class=>'form-control input-sm',
:form_css_class => "edit_gateway_form form-inline form_hidden",
:cancel_class => "gateway-cancel-link btn btn-primary btn-sm left-margin-10")) 
 ::Temple::Utils.escape_html((@net +'.')) 
 ::Temple::Utils.escape_html((@gateway)) 
 ::Temple::Utils.escape_html((t 'dynamic_ip_range')) 
 ::Temple::Utils.escape_html((t 'minimum')) 
 ::Temple::Utils.escape_html((@dyn_lo)) 
 ::Temple::Utils.escape_html((simple_remote_text     :id => "dyn_lo_area",
:input_id =>"dyn_lo_input",
:form_id => "dyn_lo_form",
:button_id => "",
:url => network_engine.update_dhcp_range_path("min"),
:label => t("change"),
:disabled => false,
:value => @dyn_lo,
:name => :dyn_lo,
:method => :put,
:remote => true,
:input_css_class=>'form-control input-sm',
:form_css_class => "edit_dyn_lo_form form-inline form_hidden",
:cancel_class => "dyn-lo-cancel-link btn btn-primary btn-sm left-margin-10")) 
 ::Temple::Utils.escape_html((t 'maximum')) 
 ::Temple::Utils.escape_html((@dyn_hi)) 
 ::Temple::Utils.escape_html((simple_remote_text     :id => "dyn_hi_area",
:input_id =>"dyn_hi_input",
:form_id => "dyn_hi_form",
:button_id => "",
:url => network_engine.update_dhcp_range_path("max"),
:label => t("change"),
:disabled => false,
:value => @dyn_hi,
:name => :dyn_hi,
:method => :put,
:remote => true,
:input_css_class=>'form-control input-sm',
:form_css_class => "edit_dyn_hi_form form-inline form_hidden",
:cancel_class => "dyn-hi-cancel-link btn btn-primary btn-sm left-margin-10")) 
 _slim_controls2 = content_for(:js_templates) do
 
 ::Temple::Utils.escape_html((render '/js_templates/shares/lease_time_form')) 
 ::Temple::Utils.escape_html((render '/js_templates/shares/gateway_form')) 
 end 
 ::Temple::Utils.escape_html((_slim_controls2)) 

end

  end

  def update_dns
    sleep 2 if development?
    case params[:setting_dns]
    when 'opendns', 'google', 'opennic'
      @saved = Setting.set("dns", params[:setting_dns], KIND)
      system("hda-ctl-hup")
    else
      @saved = true
    end
    render :json => { :status => @saved ? :ok : :not_acceptable }
  end

  def update_dns_ips
    sleep 2 if development?
    Setting.transaction do
      @ip_1_saved = DnsIpSetting.set("dns_ip_1", params[:dns_ip_1], KIND)
      @ip_2_saved = DnsIpSetting.set("dns_ip_2", params[:dns_ip_2], KIND)
      Setting.set("dns", 'custom', KIND)
      system("hda-ctl-hup")
    end
    if @ip_1_saved && @ip_2_saved
      render json: {status: :ok}
    else
      render json: {status: :not_acceptable, ip_1_saved: @ip_1_saved, ip_2_saved: @ip_2_saved}
    end
  end

  def update_lease_time
    sleep 2 if development?
    @saved = params[:lease_time].present? && params[:lease_time].to_i > 0 ? Setting.set("lease_time", params[:lease_time], KIND) : false
    render :json => { :status => @saved ? :ok : :not_acceptable }
    system("hda-ctl-hup")
  end

  def update_gateway
    sleep 2 if development?
    @saved = params[:gateway].to_i > 0 && params[:gateway].to_i < 255 ? Setting.set("gateway", params[:gateway], KIND) : false
    if @saved
      @net = Setting.get 'net'
      render json: { status: :ok, data: @net + '.' + params[:gateway] }
    else
      render json: { status: :not_acceptable }
    end
  end

  def toggle_setting
		sleep 2 if development?
		id = params[:id]
		s = Setting.find id
		s.value = (1 - s.value.to_i).to_s
		if s.save
			render json: { status: 'ok' }
			system("hda-ctl-hup")
		else
			render json: { status: 'error' }
		end
  end

  def update_dhcp_range
    if(params[:id] == "min")
      dyn_lo = params[:dyn_lo].to_i
      dyn_hi = Setting.find_by_name("dyn_hi").value.to_i
    else
      dyn_lo = Setting.find_by_name("dyn_lo").value.to_i
      dyn_hi = params[:dyn_hi].to_i
    end
    @saved = dyn_lo > 0 && dyn_hi < 255 && dyn_hi - dyn_lo > IP_RANGE
    if @saved
      Setting.set("dyn_lo", dyn_lo, KIND)
      Setting.set("dyn_hi", dyn_hi, KIND)
      system("hda-ctl-hup")
      render json: { status: :ok }
    else
      render json: { status: :not_acceptable }
    end
  end

private
  def set_page_title
    @page_title = t('network')
  end

  def get_hosts
    @hosts = Host.order('name ASC')
    @net = Setting.get 'net'
  end

  def get_dns_aliases
    @dns_aliases = DnsAlias.order('name ASC')
    @net = Setting.get 'net'
  end
end

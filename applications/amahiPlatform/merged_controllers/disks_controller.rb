class DisksController < ApplicationController
	before_filter :admin_required

	def index
		@page_title = t('disks')
		unless use_sample_data?
			@disks = DiskUtils.stats
		else
			# NOTE: this is to get sample fake data in development
			@disks = SampleData.load('disks')
		end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 ::Temple::Utils.escape_html((t 'model')) 
 ::Temple::Utils.escape_html((t 'device')) 
 ::Temple::Utils.escape_html((t 'temperature')) 
 ::Temple::Utils.escape_html((link_to "F", '#', :onclick=> '$("#disks-table .temperature").toggle()', class: 'temperature', style: 'display:none')) 
 ::Temple::Utils.escape_html((link_to "C", '#', :onclick=> '$("#disks-table .temperature").toggle()', class: 'temperature')) 
 @disks.each do | disk |
 
 _temple_html_attributeremover1 = ''; _slim_codeattributes1 = cycle("odd", "even"); if Array === _slim_codeattributes1; _slim_codeattributes1 = _slim_codeattributes1.flatten; _slim_codeattributes1.map!(&:to_s); _slim_codeattributes1.reject!(&:empty?); _temple_html_attributeremover1 << ((::Temple::Utils.escape_html((_slim_codeattributes1.join(" ")))).to_s); else; _temple_html_attributeremover1 << ((::Temple::Utils.escape_html((_slim_codeattributes1))).to_s); end; _temple_html_attributeremover1 
 if !_temple_html_attributeremover1.empty? 
 _temple_html_attributeremover1 
 end 
 ::Temple::Utils.escape_html((disk[:model])) 
 ::Temple::Utils.escape_html((disk[:device])) 
 _temple_html_attributeremover2 = ''; _slim_codeattributes2 = disk[:tempcolor]; if Array === _slim_codeattributes2; _slim_codeattributes2 = _slim_codeattributes2.flatten; _slim_codeattributes2.map!(&:to_s); _slim_codeattributes2.reject!(&:empty?); _temple_html_attributeremover2 << ((::Temple::Utils.escape_html((_slim_codeattributes2.join(" ")))).to_s); else; _temple_html_attributeremover2 << ((::Temple::Utils.escape_html((_slim_codeattributes2))).to_s); end; _temple_html_attributeremover2 
 if !_temple_html_attributeremover2.empty? 
 _temple_html_attributeremover2 
 end 
 ::Temple::Utils.escape_html((disk[:temp_c])) 
 ::Temple::Utils.escape_html((disk[:temp_f])) 
 end 

end

	end

	def mounts
		@page_title =t('disks')
		unless use_sample_data?
			@mounts = DiskUtils.mounts
		else
			# NOTE: this is to get sample fake data in development
			@mounts = SampleData.load('mounts')
		end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 ::Temple::Utils.escape_html((t 'partition')) 
 ::Temple::Utils.escape_html((t 'total_space')) 
 ::Temple::Utils.escape_html((t 'free_space')) 
 ::Temple::Utils.escape_html((t 'used_space')) 
 ::Temple::Utils.escape_html((t 'mount point')) 
 if @mounts.any?
@mounts.each do | mount |
 
 _temple_html_attributeremover1 = ''; _slim_codeattributes1 = cycle("odd", "even"); if Array === _slim_codeattributes1; _slim_codeattributes1 = _slim_codeattributes1.flatten; _slim_codeattributes1.map!(&:to_s); _slim_codeattributes1.reject!(&:empty?); _temple_html_attributeremover1 << ((::Temple::Utils.escape_html((_slim_codeattributes1.join(" ")))).to_s); else; _temple_html_attributeremover1 << ((::Temple::Utils.escape_html((_slim_codeattributes1))).to_s); end; _temple_html_attributeremover1 
 if !_temple_html_attributeremover1.empty? 
 _temple_html_attributeremover1 
 end 
 ::Temple::Utils.escape_html((mount[:filesystem])) 
 ::Temple::Utils.escape_html((number_to_human_size mount[:bytes])) 
 ::Temple::Utils.escape_html((number_to_human_size mount[:available])) 
 ::Temple::Utils.escape_html((number_to_human_size mount[:used])) 
 ::Temple::Utils.escape_html((" (#{mount[:use_percent]})")) 
 ::Temple::Utils.escape_html((mount[:mount])) 
 end; else
 
 end 

end

	end
end

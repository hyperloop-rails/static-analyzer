def solve_all_renders
	$actions.each do |k, a|
		if a.is_entrance or a.has_non_default_or_layout_render
			solve_render_for_action(a)
			if $only_generate_nextcall == false
				puts "Action: #{a.controller.name}.#{a.name} renders:"
				str = ""
				a.render_stack.each do |r|
					puts "\t#{r.render_file}"
					str += "\n"
					str += r.get_content
				end
				str += "\n"
				a.replaced_code = str 
			end
		end
	end
end

def replace_files
	#TODO: mkdir
	$controllers.each do |k, v|
		puts "Rewriting #{v.file_name}"
		fp = File.open("#{v.file_name}","r")
		content = fp.read
		fp.close
		v.actions.each do |a|
			if a.render_stack.length > 0 and  a.replaced_code.length > 0
				puts "Replace #{a.controller.name}.#{a.name}"
				#content = content.gsub(a.astnode.source[0...-1], "#{a.astnode.source[0...-1]}#{a.replaced_code}")
				content[a.astnode.source[0...-1]] = "#{a.astnode.source[0...-1]}#{a.replaced_code}" 
			end
		end
		new_file_name = v.file_name.gsub($controller_folder_name, $new_controller_folder_name)
		File.write("#{new_file_name}", content)
		#make sure the replaced file parses
		ast = YARD::Parser::Ruby::RubyParser.parse(File.open(new_file_name, "r").read)
	end
	if $has_helper
		$helpers.each do |k, v|
			puts "Rewriting #{v.file_name}"
			fp = File.open("#{v.file_name}","r")
			content = fp.read
			fp.close
			v.actions.each do |a|
				if a.render_stack.length > 0 and  a.replaced_code.length > 0
					puts "Replace #{a.controller.name}.#{a.name}"
					#content = content.gsub(a.astnode.source[0...-1], "#{a.astnode.source[0...-1]}#{a.replaced_code}")
					content[a.astnode.source[0...-1]] = "#{a.astnode.source[0...-1]}#{a.replaced_code}" 
				end
			end
			new_file_name = v.file_name.gsub($helper_folder_name, $new_helper_folder_name)
			File.write("#{new_file_name}", content)
			ast = YARD::Parser::Ruby::RubyParser.parse(File.open(new_file_name, "r").read)
		end
	end
end

def solve_render_for_action(action)
	#first, check layout
	if action.use_layout and action.controller.exist_layout
		action.push_to_render_stack(action.controller.get_layout)
	end	
	#then check render stmt
	exist_render = false
	action.render_stmts.each do |r|
		if r.valid_file_path
			action.push_to_render_stack(r)
			exist_render = true
			solve_render_for_view(action, r.render_file)
		end
	end
	#if no exist render, check default render
	if exist_render == false
		if action.exist_template
			action.push_to_render_stack(action.get_template)
		end
	end
end

#recursively...
def solve_render_for_view(action, view_file)
	viewf = find_view_file(view_file)
	if viewf
		viewf.render_stmts.each do |r|
			if r.valid_file_path
				exist = action.push_to_render_stack(r)
				if exist == false
					solve_render_for_view(action, r.render_file)
				end
			end
		end
	end
end

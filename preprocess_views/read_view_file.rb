def read_view_files
	root, files, dirs = os_walk($view_dir)
	for filename in files
		if filename.to_s.end_with?("html.erb")
			new_file_name = filename.to_s.gsub($view_folder_name, $new_view_folder_name)
			#TODO: full path
			view_file = View_file.new(new_file_name)
			$view_files[new_file_name] = view_file
			run_command("#{$extract_ruby_script} #{filename} #{new_file_name}")
			fp = File.open(view_file.file_path, "r")
			contents = fp.read
			ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
			#TODO: This is a bit messy... $cur_action and view_file should be of different types
			$cur_action = view_file
			traverse_ast(ast, 0)	
		end
	end
end

def find_view_file(view_file)
	$view_files.each do |k, v|
		if same_file(k, view_file) 
			return v
		end
	end
	return nil
end

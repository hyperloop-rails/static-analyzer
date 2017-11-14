def compute_redundant_usage
	$graph_file.puts "<redundantData>"
	$node_list.each do |n|
		if n.isReadQuery?
			@qr = trace_query_result(n)
			str = ""
			if @qr and n.getInstr.getTableName and @qr != "int"
				print_single_redundant_usage(n.getInstr.getTableName, @qr, n) 
				if @qr.include?"ALL_FIELDS" and $class_map[n.getInstr.getTableName]
					$class_map[n.getInstr.getTableName].getTableFields.each do |f|
						add_used_field_to_chained_query(n, "#{n.getInstr.getTableName}.#{f.field_name}")
					end
				else
					@qr.each do |f|
						add_used_field_to_chained_query(n, "#{n.getInstr.getTableName}.#{f}")
					end
				end
				@qr.each do |f|
					str += "#{f}, "
				end
				$temp_file.puts "! query #{n.getIndex} uses fields #{str}"
			elsif @qr == "int" and n.getInstr.getTableName
				class_name = n.getInstr.getTableName
				$graph_file.puts("\t<#{class_name} totalFieldSize=\"4\">4<\/#{class_name}>")
			end
		#elsif @qr
		#	puts "Table name empty... #{n.getIndex}"
		end
	end
	$graph_file.puts "<\/redundantData>"
end


def trace_query_result(qnode)
	if cq = is_chained_query(qnode)
		#$temp_file.puts "#{qnode.getIndex} is chained query"
		add_in_chained_query(qnode, cq)
		return nil
	end
	if $query_return_record.include?qnode.getInstr.getFuncname  #TODO: association is not included!!!
	else
		if $key_words.has_key?(qnode.getInstr.getFuncname)
			return "int"
		else
			return nil
		end
	end
	@r = Array.new
	@traversed = Array.new
	@node_list = Array.new
	@node_list.push(qnode)
	@names = Array.new
	if qnode.getInstr.getDefv
		@names.push(qnode.getInstr.getDefv)
	end
	if qnode.getInstr.getBB.getCFG.getMHandler.normal_function == false
		qnode.getDataflowEdges.each do |e|
			@node_list.push(e.getToNode)
		end
	end
	str = ""
	chained_query = false
	stop_chain = false
	into_query = Array.new
	while @node_list.length > 0 do
		temp_node = @node_list.pop
		if @traversed.include?(temp_node)
		else
			@to_add = Array.new
			@traversed.push(temp_node)
			str += "#{temp_node.getIndex}, "
			if temp_node.getInstr.instance_of?Return_instr
				str += " |(jump #{temp_node.getIndex})|, "
				@names.delete_at(@names.index("%self") || @names.length)
				if temp_node.getDataflowEdges[0]
					tonode = temp_node.getDataflowEdges[0].getToNode
					tonode.getDataflowEdges.each do |e1|
						@to_add.push(e1.getToNode)
					end
					if tonode.getInstr.getDefv
						@names.push(tonode.getInstr.getDefv)
					end
				end
			else	
				temp_node.getDataflowEdges.each do |e|
					@to_add.push(e.getToNode)
				end
			end
			@to_add.each do |n|
				if @traversed.include?(n)
				elsif n.getIndex > qnode.getIndex
					if n.isTableField? #or n.getInstr.instance_of?GetField_instr
						if @r.include?(n.getInstr.getFuncname)
						else
							@r.push(n.getInstr.getFuncname)
							stop_chain = true
						end
					elsif n.getInstr.instance_of?GetField_instr
						if @names.include?(n.getInstr.getFuncname)
							@names.push(n.getInstr.getDefv)
							@node_list.push(n)
						end
					elsif n.getInstr.instance_of?AttrAssign_instr
						if isActiveRecord(n.getInstr.getCallerType) #unlikely to happen? assign to a member to another class 
							@r.push("ALL_FIELDS")
							stop_chain = true
						else
							@names.push(n.getInstr.getFuncname)
							@node_list.push(n)
						end 
					elsif n.isQuery?
						into_query.push(n)
						chained_query = true   #There might be branches that chained at one branch but not chained at the other... :(
						#if @names.include?(n.getInstr.getCaller) #It should be chained query!!!
						#	$temp_file.puts "..... q #{qnode.getIndex} #{str}"
						#	return nil
						#end
					elsif n.getInstr.instance_of?Copy_instr and n.getInstr.getDefv
						@names.push(n.getInstr.getDefv)
						@node_list.push(n)
					elsif n.getInstr.is_a?Call_instr
						if @names.include?(n.getInstr.getCaller)
							@node_list.push(n)
							if n.getInstr.getCallCFG == nil and n.getInstr.getDefv
								@names.push(n.getInstr.getDefv)
							else
								@names.push("%self")
							end
							if ["send","send_data"].include?n.getInstr.getFuncname
								@r.push("ALL_FIELDS")
							end
							
						else
							name_in_args = false
							n.getInstr.getArgs.each do |a|
								if @names.include?a
									name_in_args = true
									n.getDataflowEdges.each do |e1|
										if e1.getToNode.getInstr.is_a?ReceiveArg_instr and e1.getVname == a
											if e1.getToNode.getInstr.getDefv
												@names.push(e1.getToNode.getInstr.getDefv)
											end
											@node_list.push(e1.getToNode)
										end
									end
								end
							end
						end 
					else
						@node_list.push(n)
					end
				end
			end
		end
	end
	#$temp_file.puts "chained_query = #{chained_query}, stop_chain = #{stop_chain}"
	if chained_query and stop_chain == false
		c_str = ""
	  into_query.each do |q|
			c_str += "#{q.getIndex},"
		end
		#$temp_file.puts "CHAINED QUERY #{str} || into query [#{c_str}]"
		return nil
	end
	name_str = ""
	@names.each do |n|
		name_str += "[#{n}] "
	end
	#$temp_file.puts "traversed #{str}"
	#$temp_file.puts "\t name = #{name_str}"
	str = ""
	qnode.getShowStack.each do |c|
		str += "#{c.getIndex} "
	end
	puts "Qnode: #{qnode.getIndex}, viewstack = #{str} getViewShow = #{qnode.getViewShowClosure}"
	if qnode.getViewShowClosure or goto_render(qnode)
		@r.push("ALL_FIELDS")
	end
	return @r
end

#t.string  length * 1byte
#t.datetime 8byte
#t.text  ? (L+2) * 1bytes -> L bytes
#t.integer 4byte
#t.boolean 1byte
#t.float 4byte
#t.decimal 3byte
#t.date  3byte
#t.binary 1byte
#t.references 4type (same as integer)
$text_size = 2450
def get_field_size(field)
	#if string has a limit: count use limit
	#if string has no limit: count as 64
	f = field
	field_size = 0	
	if f.type == "string"
		if f.attrs["limit"]
			field_size = f.attrs["limit"].to_i 
		else
			field_size = 64
		end
	elsif f.type == "datetime"
		field_size = 8
	elsif f.type == "integer" or f.type == "references"
		field_size = 4
	elsif f.type == "boolean" or f.type == "binary"
		field_size = 1
	elsif f.type == "date"
		field_size = 3
	elsif f.type == "float"
		field_size = 4
	elsif f.type == "decimal"	
		field_size = 3
	elsif f.type == "text"
		if f.attrs["limit"]
			if f.attrs["limit"].to_i > 2450
				field_size = 2450
			else
				field_size = f.attrs["limit"].to_i 
			end
		else
			if f.field_name.include?("comment") 
				field_size = 177
			elsif ["path","location","gadget_url","public_key","settings","email","name","key","body_html","credentials","country_ids","url","context_id"].include?f.field_name
				field_size = 128
			else
				field_size = 2450
			end
		end
	end
	return field_size
end

def print_single_redundant_usage(class_name, r, query_node)
	if $class_map[class_name] == nil
		return
	end
	total_field_num = $class_map[class_name].getTableFields.length
	total_field_size = 0
	$class_map[class_name].getTableFields.each do |f|
		total_field_size += get_field_size(f)
	end
	actual_used_size = 0
	if r.include?"ALL_FIELDS"
		$graph_file.puts("\t<#{class_name} totalFieldSize=\"#{total_field_size}\">#{total_field_size}<\/#{class_name}>")
		puts("\t<#{class_name} totalFieldSize=\"#{total_field_size}\">#{total_field_size}<\/#{class_name}>")
		$class_map[class_name].getTableFields.each do |f|
			if get_field_size(f) >= 2400
				$temp_file.puts "Large Redundant Field: #{class_name}.#{f.field_name}, in query #{query_node.getInstr.toString}, used = true"
			end
		end	
	else
		@r.each do |inner_r|
			$class_map[class_name].getTableFields.each do |f|
				used = false
				if f.field_name == inner_r
					actual_used_size += get_field_size(f)
					used = true
				end
				if get_field_size(f) >= 2400
					$temp_file.puts "Large Redundant Field: #{class_name}.#{f.field_name}, in query #{query_node.getInstr.toString}, used = #{used}"
				end
			end
		end
		$graph_file.puts("\t<#{class_name} totalFieldSize=\"#{total_field_size}\">#{actual_used_size}<\/#{class_name}>")
	end
end

def compute_kv_store
	$graph_file.puts "<selectAndUse>"
	$query_chain.each do |k,v|
		used_str = ""
		v.used_fields.each do |u|
			used_str += "#{u} "
		end
		select_str = ""
		v.select_conditions.each do |s|
			select_str += "#{s} "
		end
		$graph_file.puts "\t<Qchain used_fields=\"#{used_str}\" select_fields=\"#{select_str}\">#{v.qnodes[0].getInstr.getTableName}<\/Qchain>"
	end
	$graph_file.puts "<\/selectAndUse>"
end

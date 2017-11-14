
def compute_dataflow_stat(output_dir, start_class, start_function, build_node_list_only=false)

	if $root == nil
		$cfg = trace_query_flow(start_class, start_function, "", "", 0)
		addAllControlEdges
		compute_source_sink_for_all_nodes
		if $cfg == nil
			return
		end
		if $cfg.getBB[0] == nil or $cfg.getBB[0].getInstr[0] == nil
			exit
		end
		$root = $cfg.getBB[0].getInstr[0].getINode	
	end
	
	$node_list.each do |n|
		n.setLabel
		$temp_file.puts "#{n.getIndex}:#{n.getInstr.toString}"
		if n.getValidationStack.length > 0
			str = ""
			n.getValidationStack.each do |v|
				str += "#{v.getIndex}, "
			end
			#$temp_file.puts "\t * \t transaction #{str}"
		end
		#if n.getInClosure
		#	if n.getInView and n.getClosureStack.length == 1
		#	else
		#		s = ""
		#		n.getClosureStack.each do |n1|
		#			s += "#{n1.getIndex}," 
		#		end
		#		puts "\t * IN CLOSURE (#{n.isQuery?})  [#{s}]"
		#	end
		#end
		if n.getInstr.is_a?Call_instr
			caller_type = type_valid(n.getInstr, n.getInstr.getCaller)
			returnv = ""
			if n.getInstr.getDefv
				returnv = type_valid(n.getInstr, n.getInstr.getDefv)
			end
			$temp_file.puts "\tcallert #{n.getInstr.getCallerType}; isQuery? #{n.getInstr.isQuery}; isReadQuery? #{n.getInstr.isReadQuery}; QType = #{n.getInstr.getQueryType}; isTableField? #{n.getInstr.isTableField}; isClassField? #{n.getInstr.isClassField} -- (#{returnv})"
			if n.isQuery?
				#puts "\t * table_name = #{n.getInstr.getTableName}"
			end 
		end
		if $tempfile_print_forward_edges
			n.getDataflowEdges.each do |e|
				if e.getToNode != nil 
					$temp_file.puts "\t\t -> [#{e.getVname}] #{e.getToNode.getIndex}: #{e.getToNode.getInstr.toString}"
				end
			end
		end
		if $tempfile_print_backward_edges
			n.getBackwardEdges.each do |e|
				if e.getFromNode != nil 
					$temp_file.puts "\t\t <- [#{e.getVname}] #{e.getFromNode.getIndex}: #{e.getFromNode.getInstr.toString}"
				else
					$temp_file.puts "\t\t <- params"
				end
			end
		end
		if $tempfile_print_control_edges
			n.getControlflowEdges.each do |e|
				$temp_file.puts "\t\t (DF) -> #{e.getToNode.getIndex}: #{e.getToNode.getInstr.toString} (#{e.getToNode.path_length})"
			end
		end
	end

	#@func_dep_file = File.open("#{output_dir}/func_dep.xml", "w")
	#@func_dep_file.puts("<funcDep>")
	#compute_functional_dependency(@func_dep_file)
	#@func_dep_file.puts("<\/funcDep>")
	#@func_dep_file.close
	#@trivial_branches = Array.new
	#@query_to_trivial_branch = Array.new

	if build_node_list_only
				#puts "#{n.getIndex}: Forward ARRAY length: #{@forwardarray.length}  (write: #{temp_to_write}) (stat: #{@read_sink_stat.to_write_query})"
		return
	end


	graph_fname = "#{output_dir}/stats.xml"
	$graph_file = File.open(graph_fname, "w")
	$graph_file.puts("<STATSHEADER>")

	#compute_functional_dependency($graph_file)

	total_query_num = 0
	query_in_closure = 0
	query_in_view = 0
	query_read = 0
	query_write = 0
	branch_dependon_query = 0
	total_branch = 0

	cnt_materialized_query = 0	
	cnt_not_materialized_query = 0

	write_source_total = 0	
	write_from_const = 0
	write_from_user_input = 0
	write_from_query = 0
	#The whoe query
	read_to_read_query = 0
	read_to_write_query = 0
	read_to_view = 0
	read_to_branch = 0

	@general_stat = Temp_Qgeneral_stat.new
	@read_sink_stat = Temp_Qsink_stat.new
	@write_source_stat = Temp_Qsource_stat.new
	@read_source_stat = Temp_Qsource_stat.new
	@singleQ_stat = Temp_singleQ_stat.new
	@view_stat = Temp_view_stat.new
	@const_stat = Temp_const_stat.new

	@table_read_stat = Hash.new
	@table_write_stat = Hash.new
	@table_general_stat = Hash.new

	@validation_stat = Hash.new

	$node_list.each do |n|
		if n.isQuery?
			if test_in_while_loop(n)
				#$temp_file.puts " +++ query #{n.getIndex} in while loop"
			end
			n.getValidationStack.each do |vl|
				if @validation_stat[vl]
				else
					@validation_stat[vl] = Temp_validation_stat.new
					@validation_stat[vl].depth = vl.getValidationStack.length
				end
				@validation_stat[vl].addQuery(n)
				@validation_stat[vl].addQuery(vl)
				if n.isReadQuery?
					@validation_stat[vl].read += 1
				else
					@validation_stat[vl].write += 1
				end
			end
		end
	end
	#add single-write txn
	#$node_list.each do |n|
	#	if n.isWriteQuery?
	#		if @validation_stat.key?(n)
	#		else
	#			@validation_stat[n] = Temp_validation_stat.new
	#			@validation_stat[n].addQuery(n)
	#		end
	#	end
	#end

	@query_length_graph = Hash.new
	$node_list.each do |n|
		if n.isReadQuery?
			@query_length_graph[n] = Array.new
		end
	end

	if $compute_card or $compute_view_stat
		compute_query_card_stat
	end
	compute_loop_carry_dep

	#keep track of query dependency in terms of controlflow
	@query_affect_controlflow = Hash.new

	if $print_querydep_graph
		$vis_file.puts "digraph \"QGraph\" {"
		$vis_file.puts "node [ style = filled ];"

		$node_list.each do |n|
			#for each query node
			if n.isQuery?
				if n.isReadQuery?
					$vis_file.puts "\t\"n#{n.getIndex}\" [color=#{$READQCOLOR}, label=\"#{n.getInstr.getTableName}\"];"
				else
					$vis_file.puts "\t\"n#{n.getIndex}\" [color=#{$WRITEQCOLOR}, label=\"#{n.getInstr.getTableName}\"];"
				end
			#for each user input node
			elsif n.getInstr.getFromUserInput
				$vis_file.puts "\t\"n#{n.getIndex}\" [color=#{$USERINPUTCOLOR}, label=\"instr#{n.getIndex}_user_input\"];"
			end
		end
	end

	if $compute_partial_overlap
		@query_on_variable = Hash.new
		$node_list.each do |n|
			if n.isQuery?
				traceback_data_dep(n).each do |n1|
					if n1.instance_of?Dataflow_edge
					elsif n1.getInstr.instance_of?GetField_instr and n1.getInstr.getBB == n.getInstr.getBB
						#puts "#{n.getIndex}:#{n.getInstr.toString} FROM (#{e.getFromNode.getInstr.field})"
						class_name = n1.getInstr.getBB.getCFG.getMHandler.getCallerClass.getName
						variable_name = n1.getInstr.field
						query = n.getInstr.getFuncname
						hash_key = "#{class_name}.#{variable_name}"
						@query_on_variable[hash_key] = [] unless @query_on_variable.has_key?(hash_key)
						@query_on_variable[hash_key].append(n) unless @query_on_variable[hash_key].include?(n)
					end
				end	
			end
		end
	end

	@temp_use_input = 0
	@temp_use_input_in_loop = 0
	$node_list.each do |n|
		if $print_querydep_graph
			if n.getInstr.getFromUserInput and $graph_print_control_edge
				@forwardarray = traceforward_data_dep(n)
				@forwardarray.each do |n1|
					if n1.isBranch?
						$node_list.each do |n2|
							#user input node n affect a branch n1, and query node n2 is control-dependent on branch n1
							if n2.isQuery? and n2.getIndex > n.getIndex and is_in_controlflow_range(n2, n1)
								$vis_file.puts "\t\"n#{n.getIndex}\" -> \"n#{n2.getIndex}\" [color=#{$CONTROLEDGECOLOR}];"
							end
						end
					end
				end
			end
		end

		if n.isQuery?
			if $class_map[n.getInstr.getClassName]
				if $class_map[n.getInstr.getClassName].class_type == "other"
					@general_stat.issued_by_other += 1
				end
			end
			#always print general status
			@general_stat.total += 1
			@table_name = n.getInstr.getTableName
			if @table_name == nil
				@table_name = "UNKNOWN"
			end
			if @table_read_stat.has_key?(@table_name)
			else
				@table_read_stat[@table_name] = Temp_Qsink_stat.new
			end
			if @table_write_stat.has_key?(@table_name)
			else
				@table_write_stat[@table_name] = Temp_Qsource_stat.new
			end
			if @table_general_stat.has_key?(@table_name)
			else
				@table_general_stat[@table_name] = Temp_Qgeneral_stat.new
			end
			@table_general_stat[@table_name].total += 1

			if n.getInClosure
				if n.getNonViewClosureStack.length > 0
					@general_stat.in_closure += 1
					if n.isReadQuery?
						@general_stat.read_in_closure += 1
					end
				end
			end
			if $compute_loopdetail
				if n.getInClosure
					if n.getNonViewClosureStack.length > 0
						@general_stat.in_closure += 1
						if n.isReadQuery?
							@general_stat.read_in_closure += 1
						end
						@table_general_stat[@table_name].in_closure += 1
						by_db = false
						by_db_scale = false
						has_loop_carrydep = false
						str = ""
						n.getNonViewClosureStack.each do |cl|
							if cl.getInstr.getClosure and cl.getInstr.getClosure.has_loop_carry_dep
								has_loop_carrydep = true
							end
							r = traceback_data_dep(cl, true)
							if r
								by_db = true
								by_db_scale = true unless r.card_limited
								str += "(DB)"
							end
							str += "#{cl.getIndex}, "
						end
						if by_db
							@general_stat.in_closure_by_db += 1
							@table_general_stat[@table_name].in_closure_by_db += 1
						end
						if by_db_scale
							@general_stat.in_closure_by_db_scale += 1
							@table_general_stat[@table_name].in_closure_by_db_scale += 1
						end
						if has_loop_carrydep
							@general_stat.in_loop_has_carrydep += 1
							@table_general_stat[@table_name].in_loop_has_carrydep += 1
						end
						#$temp_file.puts "query #{n.getIndex} in closure : #{str}"
					end
					if n.getInstr.in_view#n.getInView
						#graph_write($graph_file, " (v)")
						@general_stat.in_view += 1
						if $key_words[n.getInstr.getFuncname]
						else
							@general_stat.in_view_assoc += 1
						end 
						@table_general_stat[@table_name].in_view += 1
					end
				elsif n.getInstr.in_while_loop
					@general_stat.in_while += 1
					@table_general_stat[@table_name].in_while += 1
					by_db = false
					str = ""
					if traceback_data_dep(n.getInstr.in_while_loop.getINode, true)
						by_db = true
						str += "(DB)"
					end
					if by_db
							@general_stat.in_while_by_db += 1
							@table_general_stat[@table_name].in_while_by_db += 1
					end
					#$temp_file.puts "query #{n.getIndex} in while loop : #{str}"
				end
			end
			if n.isReadQuery?
				if check_scope_query_string(n)
					@read_source_stat.from_query_string += 1
					@general_stat.use_query_string += 1
					@table_general_stat[@table_name].use_query_string += 1
				else
					check_query_function(n)
				end
				@general_stat.read += 1
				@read_sink_stat.total += 1
				@read_source_stat.total += 1
				@table_read_stat[@table_name].total += 1
				#puts "READ query instr #{n.getIndex}:#{n.getInstr.toString} forward flow:"
				if $compute_materialized_result
					v_node = find_nearest_var(n)
					_key = n.getInstr.getFuncname
					if n.getInstr.getCallHandler
						_key = n.getInstr.getCallHandler.getFuncName
					end
					key = _key.gsub('?','').gsub('!','')
					if _key.include?("find_by")
						key = "find_by"
					elsif $key_words[_key]
						key = _key.gsub('?','').gsub('!','')
					else
						key = "association"
					end
					if $query_return_record.include?(key)
						if v_node
							#AttrAssign or closure
							if v_node.getInstr.getDefv != nil
								#if check_necessary_materialization(v_node, v_node.getInstr.getDefv)
									cnt_materialized_query += 1
							else
								cnt_materialized_query += 1
							end
						elsif is_chained_query(n)==nil
							cnt_not_materialized_query += 1
							#$temp_file.puts("Query #{n.getIndex} result not materialized")
						end
					end
				end
				@used_in_view = false
				@forwardarray = traceforward_data_dep(n)
							
				#Queries in validations need to be executed sequentially	
				#n.getValidationStack.each do |vl|
				#	@validation_stat[vl].queries.each do |q|
				#		if q.getIndex > n.getIndex 
				#			if @query_length_graph[n].include?(q)
				#			else
				#				@query_length_graph[n].push(q)
				#			end
				#		end
				#	end
				#end
				
				@forwardarray.each do |n1|
					#if n1.isTableField?
					#	var_name = n1.getInstr.getCallHandler.getObjName
					#	field_name = n1.getInstr.getCallHandler.getFuncName
					#	if (self_v_name == nil or self_v_name != var_name) and n1.getInstr.instance_of?AttrAssign_instr
					#			read_assign_to_other += 1
					#			single_tbl_assign_to_other += 1
					#			#puts "\t(read_assign_to_other)"
					#	end
					#elsif n1.getInstr.instance_of?AttrAssign_instr and n1.getInstr.getCaller.include?("self")
					#	read_assign_to_self += 1
					#	single_tbl_assign_to_self += 1
					#	#puts "\t(read_assign_to_self)"
					#if n1.getInView
						#puts " * (To view)"
						#@table_read_stat[@table_name].to_view += 1
						#@read_sink_stat.to_view += 1
						#@table_read_stat[@table_name].sink_total += 1
						#@read_sink_stat.sink_total += 1
					if n1.isQuery?

						if $print_querydep_graph
						#dataflow from query node n to query node n1
							$vis_file.puts "\t\"n#{n.getIndex}\" -> \"n#{n1.getIndex}\";"						
						end
	
						if @query_length_graph[n].include?(n1)
						else
							@query_length_graph[n].push(n1)
						end

						@table_read_stat[@table_name].sink_total += 1
						@read_sink_stat.sink_total += 1
						#puts "QUERY: #{n.getIndex}: #{n.getInstr.toString}"
						if n1.isWriteQuery?
								@read_sink_stat.to_write_query += 1
								@table_read_stat[@table_name].to_write_query += 1
								#in txn: read goes to write
								n.getValidationStack.each do |vl|
									if @validation_stat[vl].queries.include?(n1)
										@validation_stat[vl].addReadGoesToWrite(n)
									end
								end
								#puts " * (To write query)"
						else
								@read_sink_stat.to_read_query += 1
								@table_read_stat[@table_name].to_read_query += 1
								#puts " * (To read query)"
						end
					elsif n1.getDataflowEdges.length == 0
						if sinkIgnore(n1) == false
							@table_read_stat[@table_name].sink_total += 1
							@read_sink_stat.sink_total += 1
						end
						if n1.isBranch?
							
							if $compute_querydep_controlflow or ($print_querydep_graph and $graph_print_control_edge)
								@query_affect_controlflow[n] = Array.new unless @query_affect_controlflow[n]
								$node_list.each do |n2|
									if n2.isQuery? and n2.getIndex > n.getIndex and is_in_controlflow_range(n2, n1)
										#@query_length_graph[n].push(n2) unless @query_length_graph[n].include?n2
										if $graph_print_control_edge
											#result of query n affect branch n1, and query n2 is control-dependent on branch n1
											$vis_file.puts "\t\"n#{n.getIndex}\" -> \"n#{n2.getIndex}\" [color=#{$CONTROLEDGECOLOR}];"
										end
										@query_affect_controlflow[n].push(n2) unless @query_affect_controlflow[n].include?(n2)
										#$temp_file.puts "#{n2.getIndex} is in the control flow range of #{n.getIndex} by branch node #{n1.getIndex}"
									end
								end
							end
							#$temp_file.puts "#Q #{n.getIndex} reaches branch #{n1.getIndex}"
							if $compute_querydep_controlflow
								n.getValidationStack.each do |vl|
									@validation_stat[vl].queries.each do |w|
										if w.isWriteQuery?
											#puts "\tREachable? (#{w.getIndex}) <- (#{n1.getIndex}) #{is_controlflow_reachable(w, n1)}"
											if is_in_controlflow_range(w, n1)
												@validation_stat[vl].addReadGoesToBranchOnWrite(n)
												#puts "\t\t* branch affect write #{w.getIndex}"
											end
										end
									end
								end
							end
						end
						if n1.isBranch?
							@read_sink_stat.to_branch += 1
							@table_read_stat[@table_name].to_branch += 1
							#puts " * (To branch) #{n1.getIndex}:#{n1.getInstr.toString}"
						elsif n1.getInView
								@table_read_stat[@table_name].to_view += 1
								@read_sink_stat.to_view += 1
							
						#elsif n1.getDataflowEdges.length == 0
						elsif isValidationSink(n1)
							@table_read_stat[@table_name].to_validation += 1
							@read_sink_stat.to_validation += 1
						elsif isCacheSink(n1)
							@table_read_stat[@table_name].to_browser_cache += 1
							@read_sink_stat.to_browser_cache += 1
						elsif sinkIgnore(n1)==false
								#puts " * (To unknown sink) #{n1.getIndex}: #{n1.getInstr.toString}"
						end
						if n1.getInView
							@used_in_view = true
						end
					end
					#puts "\t--\t#{n1.getIndex}:#{n1.getInstr.toString}"
				end
				
				if @used_in_view
					@singleQ_stat.result_used_in_view += 1
				end
				@only_from_user_input = true
				@used_query_string = false
				@use_user_input = false
				if n.getInstr.args.include?("Fixnum")
					@read_source_stat.from_select_condition += 1
				end 
				traceback_data_dep(n).each do |n1|
					if n1.instance_of?Dataflow_edge
					elsif n1.getInstr.getFromUserInput
						#user input n1 is used as param in query n
						if $print_querydep_graph
							$vis_file.puts "\t\"n#{n1.getIndex}\" -> \"n#{n.getIndex}\";"
						end
					end

					if n1.instance_of?Dataflow_edge
						@read_source_stat.from_user_input += 1
						@read_source_stat.source_total += 1
						@use_user_input = true
					elsif n1.isQuery?
						@read_source_stat.from_query += 1
						@read_source_stat.source_total += 1
						@only_from_user_input = false
					elsif n1.getBackwardEdges.length == 0
						if sourceIgnore(n1)
						else
							@read_source_stat.source_total += 1
						end
						if isConstSource(n1)
							#Test query string
							is_query_string = check_query_string(n, n1)
							if is_query_string
								@used_query_string = true
								@read_source_stat.from_query_string += 1
							elsif isSelectCondition(n1)
								@read_source_stat.from_select_condition += 1
							else
								#$temp_file.puts " x (#{n.getIndex} From copy const #{n1.getIndex}: #{n1.getInstr.toString})"
								@read_source_stat.from_const += 1
								analyzeConstSource(n1, @const_stat)
							end
						elsif isUtilSource(n1)
							#$temp_file.puts " x (#{n.getIndex} From Util #{n1.getIndex}: #{n1.getInstr.toString})" 
							@read_source_stat.from_util += 1
						elsif n1.getInstr.instance_of?GlobalVar_instr
							@read_source_stat.from_global += 1
						elsif sourceIgnore(n1) == false
							#puts " x (Some source) #{n1.getIndex}:#{n1.getInstr.toString}"
						end
					end
				end
				if @only_from_user_input
					@singleQ_stat.only_from_user_input += 1
					#$temp_file.puts "# query #{n.getIndex} only uses user input"
				end
				if @use_user_input
					@temp_use_input += 1
					if n.getNonViewClosureStack.length > 0
						@temp_use_input_in_loop += 1
					end
				end
				if @used_query_string
					@general_stat.use_query_string += 1
					@table_general_stat[@table_name].use_query_string += 1
				end
			end
			if n.isWriteQuery?
				has_source = false
				@general_stat.write += 1
				@write_source_stat.total += 1
				@table_write_stat[@table_name].total += 1
				#puts "READ / DELETE/UPDATE/INSERT instr #{n.getIndex}:#{n.getInstr.toString} backflow:"
				#puts "backward length = #{traceback_data_dep(n).length}"
				@only_from_user_input = true
				traceback_data_dep(n).each do |n1|
					if n1.instance_of?Dataflow_edge
						has_source = true
						#puts " x (From user input)"
						@write_source_stat.from_user_input += 1
						@write_source_stat.source_total += 1
						@table_write_stat[@table_name].from_user_input += 1
						@table_write_stat[@table_name].source_total += 1
					else
						if n1.isQuery? 
							@only_from_user_input = false
							if n1.isReadQuery?
								has_source = true
								@write_source_stat.from_query += 1
								@write_source_stat.source_total += 1
								@table_write_stat[@table_name].from_query += 1
								@table_write_stat[@table_name].source_total += 1
								#puts " x (From query)"
							else
								#puts " (#{n.getInstr.toString}) depend on (#{n1.getInstr.toString})"
							end
						elsif n1.getBackwardEdges.length == 0
							if isSelectCondition(n1)
								has_source = true
								@write_source_stat.from_select_condition += 1
								@table_write_stat[@table_name].from_select_condition += 1
							elsif isConstSource(n1)
								has_source = true
								#$temp_file.puts " x (#{n.getIndex} From copy const #{n1.getIndex}: #{n1.getInstr.toString})"
								@write_source_stat.from_const += 1
								analyzeConstSource(n1, @const_stat)
								@table_write_stat[@table_name].from_const += 1
							elsif isUtilSource(n1)
								has_source = true
								#$temp_file.puts " x (#{n.getIndex} From Util #{n1.getIndex}: #{n1.getInstr.toString})" 
								@write_source_stat.from_util += 1
							elsif n1.getInstr.instance_of?GlobalVar_instr
								@write_source_stat.from_global += 1
							elsif sourceIgnore(n1) == false
								#puts " x (Some source) #{n1.getIndex}:#{n1.getInstr.toString}"
							end
							if sourceIgnore(n1)
							else
								@write_source_stat.source_total += 1
								@table_write_stat[@table_name].source_total += 1
							end
						end
						#puts "\t--\t#{n1.getIndex}:#{n1.getInstr.toString}"
					end
				end
				if has_source == false
					#$temp_file.puts "Write Query #{n.getIndex} has no source"
				end
				if @only_from_user_input
					@singleQ_stat.only_from_user_input += 1
				end
			end
			#graph_write($graph_file, "\n")
	
		elsif n.isBranch?
			@general_stat.total_branch += 1
		 	q = traceback_data_dep(n, true)
			if q != nil
				@general_stat.branch_dependon_query += 1
				#$temp_file.puts "Branch  #{n.getIndex} depend on QUERY #{q.getIndex}"
			else
				#$temp_file.puts "Branch on other #{n.getIndex}"
			end
			if n.getInView
				@general_stat.branch_in_view += 1
			end
		end
	end
	if $print_querydep_graph
		$vis_file.puts "}"
	end

	$node_list.each do |n|
		if n.getInView
			if n.isQuery?
				tbl_name = n.getInstr.getTableName
				@view_stat.addTable(tbl_name)
			elsif n.isTableField?
				tbl_name = type_valid(n.getInstr, n.getInstr.getCaller)
				field_name = n.getInstr.getFuncname
				f = testTableField(tbl_name, field_name)
				if f != nil
					@view_stat.addField("#{tbl_name}.#{field_name}")
				end
			end 
		elsif n.isTableField?
			@used_in_view = false
			tbl_name = type_valid(n.getInstr, n.getInstr.getCaller)
			field_name = n.getInstr.getFuncname
			f = testTableField(tbl_name, field_name)
			if f != nil
				traceforward_data_dep(n).each do |n1|
					if n1.getInView
						@used_in_view = true
						break
					end
				end
				if @used_in_view
					@view_stat.addField("#{tbl_name}.#{field_name}")
					@view_stat.addTable(tbl_name)
				end
			end 
		end
	end

#compute longest query chain length
	@temp_length_graph = Hash.new
	@following_nodes = Hash.new
	@head_node = nil
	@longest_query_len = 0
	@queries_in_loop_has_carrydep = 0
	@queries_in_loop_no_carrydep = 0
	@queries_affected = Array.new
	
	if $compute_querychain_length
		$node_list.reverse_each do |n|
			if @query_length_graph[n]
				@q = @query_length_graph[n]
				@temp_length_graph[n] = 1
				@following_nodes[n] = nil
				if @q.length > 0
					@q.each do |inner_q|
						@queries_affected.push(inner_q) unless @queries_affected.include?(inner_q)			

						if @temp_length_graph[inner_q] == nil
						elsif @temp_length_graph[n] < @temp_length_graph[inner_q]+1
							@temp_length_graph[n] = @temp_length_graph[inner_q]+1
							@following_nodes[n] = inner_q
						end
					end
				end
				if @temp_length_graph[n] > @longest_query_len
					@longest_query_len = @temp_length_graph[n]
					@head_node = n
				end
			end
		end
		cur_node = @head_node
		iter = 0
		while cur_node and iter < 10000
			n = cur_node
			#check if in loop or not
			if n.getInClosure and n.getNonViewClosureStack.length > 0
				loop_has_carrydep = false
				n.getNonViewClosureStack.each do |cl|
					if cl.getInstr.getClosure and cl.getInstr.getClosure.has_loop_carry_dep
						loop_has_carrydep = true
					end
				end

				#calculate only queries on that chain has/has not loop-carry dep
				if loop_has_carrydep
					@queries_in_loop_has_carrydep += 1
				else
					@queries_in_loop_no_carrydep += 1
				end
			end
			cur_node = @following_nodes[cur_node]
			iter += 1
		end 
		if @queries_in_loop_has_carrydep > @longest_query_len
			@queries_in_loop_has_carrydep = 0
		end
		if @queries_in_loop_no_carrydep > @longest_query_len
			@queries_in_loop_no_carrydep = 0
		end
	end

	if $compute_querydep_controlflow
		@query_affected_by_controlflow = Array.new
		@query_affect_controlflow.each do |k, v|
			v.each do |n|
				@query_affected_by_controlflow.push(n) unless @query_affected_by_controlflow.include?(n)
			end 
		end
	end

	$graph_file.puts("<stat>")
	$graph_file.puts("\t<general>")
	helper_print_stat(@general_stat, @read_sink_stat, @read_source_stat, @write_source_stat, "STATS")
	$graph_file.puts("\t\t<queryOnlyFromUser>#{@singleQ_stat.only_from_user_input}<\/queryOnlyFromUser>")
	
	if $compute_querydep_controlflow
		$graph_file.puts("\t\t<queryControlDependent>#{@query_affected_by_controlflow.length}<\/queryControlDependent>")
		$graph_file.puts("\t\t<queryAffectControl>#{@query_affect_controlflow.length}<\/queryAffectControl>")
		$graph_file.puts("\t\t<queryAffectedByBoth>#{@queries_affected.length}<\/queryAffectedByBoth>")
	end

	if $compute_querychain_length
		$graph_file.puts("\t\t<longestQueryPath>#{@longest_query_len}<\/longestQueryPath>")
		$graph_file.puts("\t\t<loopLongestQueryPath>#{@queries_in_loop_no_carrydep}<\/loopLongestQueryPath>")
		$graph_file.puts("\t\t<loopCarryLongestQueryPath>#{@queries_in_loop_has_carrydep}<\/loopCarryLongestQueryPath>")
	end

	$graph_file.puts("\t\t<queryUsedInView>#{@singleQ_stat.result_used_in_view}<\/queryUsedInView>")
	#$graph_file.puts("\t\t<queryToTrivialBranch>#{@query_to_trivial_branch.length}<\/queryToTrivialBranch>")
	#$graph_file.puts("\t\t<trivialBranch>#{@trivial_branches.length}<\/trivialBranch>")

	if $compute_materialized_result
		$graph_file.puts("\t\t<materialized>#{cnt_materialized_query}<\/materialized>")	
		$graph_file.puts("\t\t<notMaterialized>#{cnt_not_materialized_query}<\/notMaterialized>")	
	end

	$graph_file.puts("\t<\/general>")

	if $print_table_detail
		@table_general_stat.each do |k, v|
			$graph_file.puts("\t<#{k}>")
			helper_print_stat(v, @table_read_stat[k], nil, @table_write_stat[k], k, false)
			$graph_file.puts("\t<\/#{k}>")
		end
	end

	$graph_file.puts("<\/stat>")
	$graph_file.puts("")

	if $compute_partial_overlap
		$graph_file.puts("<queryVariable>")
		@query_on_variable.each do |k,v|
			in_loop = 0
			v.each do |n1|
				if n1.getNonViewClosureStack.length > 0
					in_loop += 1
				end
			end
			$graph_file.puts("\t<#{k.gsub("::","")} in_loop=\"#{in_loop}\">#{v.length}<\/#{k.gsub("::","")}>")
		end
		$graph_file.puts("<\/queryVariable>")
	end

	$graph_file.puts("<readFromInput in_loop=\"#{@temp_use_input_in_loop}\">#{@temp_use_input}<\/readFromInput>")


	if $compute_view_stat
		compute_view_stat
	end

	if $compute_loop_stat
		compute_loop_stat
	end
	
	if $compute_input_stat
		compute_input_stat
	end

	if $compute_card
		print_query_card_stat
	end
	
	compute_query_chain
	
	if $compute_select_condition
		compute_select_condition
	end
	
	if $compute_branch_queries
		branch_queries
	end

	if $compute_order_stat
		compute_order_stat
	end

	if $compute_redundant_usage
		compute_redundant_usage
	end

	if $compute_field_order_stat
		if $compute_redundant_usage == false
			compute_redundant_usage
		end
		if $compute_select_condition == false
			compute_select_condition
		end
		compute_field_order_stat
	end

	if $compute_redundant_table_usage
		compute_redundant_table_access
		compute_query_only_used_for_queries
	end

	#compute_kv_store

	$graph_file.puts("<viewStats>")
	@view_stat.table_list.each do |t|
		$graph_file.puts("\t<table>#{t}<\/table>")
	end
	@view_stat.field_list.each do |f|
		$graph_file.puts("\t<field>#{f}<\/field>")
	end
	$graph_file.puts("<\/viewStats>")

	$graph_file.puts("<constStats>")
	@const_stat.getSources.each do |s,v|
		$graph_file.puts("\t<#{s}>#{v}<\/#{s}>")
	end
	$graph_file.puts("<\/constStats>")

	$graph_file.puts("<cliqueStat>")
	@validation_stat.each do |k, vd|
		str = ""
		vd.queries.each do |q|
			str += "#{q.getIndex}, "
		end
		#$temp_file.puts "VALIDATION: #{k.getIndex} -> #{str}"
		vd.queries.each do |q|
			if vd.read_goes_to_write.include?(q)
			elsif vd.read_goes_to_branch_on_write.include?(q)
			elsif q.isReadQuery?
				$temp_file.puts "Read #{q.getIndex} in txn #{k.getIndex} can be kicked out"
			end
		end	
		$graph_file.puts("\t<validation>")
		$graph_file.puts("\t\t<read>#{vd.read}<\/read>")
		$graph_file.puts("\t\t<write>#{vd.write+1}<\/write>")
		$graph_file.puts("\t\t<depth>#{vd.depth}<\/depth>")
		if $compute_querydep_controlflow
			$graph_file.puts("\t\t<readToWrite>#{vd.read_goes_to_write.length}<\/readToWrite>")
			$graph_file.puts("\t\t<readToBranchOnWrite>#{vd.read_goes_to_branch_on_write.length}<\/readToBranchOnWrite>")
		end
		vd.getOtherQueries.each do |q|
			$graph_file.puts("\t\t<validationTable>#{q.getInstr.getTableName}<\/validationTable>")
		end
		$graph_file.puts("\t<\/validation>")
	end
	#@clique_stat.each do |cq|
	#	$graph_file.puts("\t<clique>#{cq}<\/clique>")
	#end
	$graph_file.puts("<\/cliqueStat>")

	if $compute_assignment_source
		compute_assignment_source
	end
			
	if $compute_physical_volatile_store
		$graph_file.puts("<chainStats>")
		compute_chain_stats
		$graph_file.puts("<\/chainStats>")
	end

	if $compute_single_path
		$graph_file.puts("<singlePath>")
		compute_longest_single_path	
		$graph_file.puts("<\/singlePath>")
	end

	#denormalization
	#$graph_file.puts("<schema>")
	#compute_schema_design_stat($graph_file)
	#$graph_file.puts("<\/schema>")

	#$graph_file.puts("<queryString>")
	#printQueryStringFreq
	#$graph_file.puts("<\/queryString>")

	$graph_file.puts("<queryFunction>")
	printQueryFunctionFreq
	$graph_file.puts("<\/queryFunction>")	
	
	
	$graph_file.puts("<\/STATSHEADER>")	
	$graph_file.close
	#number of query functions
	#number of tables  --- Hard to know. If Comment.where(story_id <= 1).first, second "story" table will not be detected
	#number of query functions within loop
	#number of queries in view


end

def helper_print_stat(general, readSink, readSource, write, label, print_branch=true)
	$graph_file.puts("\t\t<queryTotal>#{general.total}<\/queryTotal>")
	$graph_file.puts("\t\t<readTotal>#{general.read}<\/readTotal>")
	$graph_file.puts("\t\t<writeTotal>#{general.write}<\/writeTotal>")
	$graph_file.puts("\t\t<queryInView>#{general.in_view}<\/queryInView>")
	$graph_file.puts("\t\t<queryInViewAssoc>#{general.in_view_assoc}<\/queryInViewAssoc>")
	$graph_file.puts("\t\t<queryIssuedByOther>#{general.issued_by_other}<\/queryIssuedByOther>")
	$graph_file.puts("\t\t<queryInClosure>#{general.in_closure}<\/queryInClosure>")
	$graph_file.puts("\t\t<queryReadInClosure>#{general.read_in_closure}<\/queryReadInClosure>")
	$graph_file.puts("\t\t<queryInClosureByDB>#{general.in_closure_by_db}<\/queryInClosureByDB>")
	$graph_file.puts("\t\t<queryInClosureByDBScale>#{general.in_closure_by_db_scale}<\/queryInClosureByDBScale>")
	$graph_file.puts("\t\t<queryInWhile>#{general.in_while}<\/queryInWhile>")
	$graph_file.puts("\t\t<queryInWhileByDB>#{general.in_while_by_db}<\/queryInWhileByDB>")
	$graph_file.puts("\t\t<queryInClosureWithCarrydep>#{general.in_loop_has_carrydep}<\/queryInClosureWithCarrydep>")


	$graph_file.puts("\t\t<queryUseSQLString>#{general.use_query_string}<\/queryUseSQLString>")

	if print_branch
		$graph_file.puts("\t\t<branchOnQuery>#{general.branch_dependon_query}<\/branchOnQuery>")
		$graph_file.puts("\t\t<branchInView>#{general.branch_in_view}<\/branchInView>")
		$graph_file.puts("\t\t<branchTotal>#{general.total_branch}<\/branchTotal>")
	end

	$graph_file.puts("\t\t<readSink>")
	$graph_file.puts("\t\t\t<total>#{readSink.total}<\/total>")
	$graph_file.puts("\t\t\t<sinkTotal>#{readSink.get_sink_total}<\/sinkTotal>")
	$graph_file.puts("\t\t\t<toReadQuery>#{readSink.get_to_read_query}<\/toReadQuery>")
	$graph_file.puts("\t\t\t<toWriteQuery>#{readSink.get_to_write_query}<\/toWriteQuery>")
	$graph_file.puts("\t\t\t<toView>#{readSink.get_to_view}<\/toView>")
	$graph_file.puts("\t\t\t<toBranch>#{readSink.get_to_branch}<\/toBranch>")
	$graph_file.puts("\t\t<\/readSink>")

	if readSource
		$graph_file.puts("\t\t<readSource>")
		$graph_file.puts("\t\t\t<total>#{readSource.total}<\/total>")
		$graph_file.puts("\t\t\t<sourceTotal>#{readSource.get_source_total}<\/sourceTotal>")
		$graph_file.puts("\t\t\t<fromUserInput>#{readSource.get_from_user_input}<\/fromUserInput>")
		$graph_file.puts("\t\t\t<fromUtil>#{readSource.get_from_util}<\/fromUtil>")
		$graph_file.puts("\t\t\t<fromQuery>#{readSource.get_from_query}<\/fromQuery>")
		$graph_file.puts("\t\t\t<fromQueryString>#{readSource.get_from_query_string}</fromQueryString>")
		$graph_file.puts("\t\t\t<selectCondition>#{readSource.get_from_select_condition}</selectCondition>")
		$graph_file.puts("\t\t\t<fromConst>#{readSource.get_from_const}<\/fromConst>")
		$graph_file.puts("\t\t\t<fromGlobal>#{readSource.get_from_global}<\/fromGlobal>")
		$graph_file.puts("\t\t<\/readSource>")
	end

	$graph_file.puts("\t\t<writeSource>")
	$graph_file.puts("\t\t\t<total>#{write.total}<\/total>")
	$graph_file.puts("\t\t\t<sourceTotal>#{write.get_source_total}<\/sourceTotal>")
	$graph_file.puts("\t\t\t<fromUserInput>#{write.get_from_user_input}<\/fromUserInput>")
	$graph_file.puts("\t\t\t<fromUtil>#{write.get_from_util}<\/fromUtil>")
	$graph_file.puts("\t\t\t<fromQuery>#{write.get_from_query}<\/fromQuery>")
	$graph_file.puts("\t\t\t<selectCondition>#{write.get_from_select_condition}<\/selectCondition>")
	$graph_file.puts("\t\t\t<fromConst>#{write.get_from_const}<\/fromConst>")
	$graph_file.puts("\t\t\t<fromGlobal>#{write.get_from_global}<\/fromGlobal>")
	$graph_file.puts("\t\t<\/writeSource>")
end

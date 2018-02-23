* run extract\_ruby and generate ruby views
'''
$ vi util.rb
'''
modify "run\_command" function to let it actually execute the commands

* replace controller/helper file:

if app has helper folder:

'''
$ ruby main.rb -a #{app\_name} -e
'''

else:

'''
$ ruby main.rb -a #{app\_name}
'''

* generate next actions:

'''
$ ruby main.rb -a #{app\_name} -f
'''

copy the "path\_funcs.sh" to the application directory and run the script

copy the "path\_funcs.txt" from the application directory back to this dir

then generate the next action files:

'''
$ruby main.rb -a #{app\_name} -e -n
'''

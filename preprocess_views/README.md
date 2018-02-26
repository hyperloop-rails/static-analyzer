* install yard
```
$ gem install yard
```

* MAKE A COPY of your application folder:
```
$ cp -r APP_FOLDER NEW_APP_FOLDER
$ cd NEW_APP_FOLDER
```

* make sure the following file exists:
```
$ ls db/schema.rb
$ ls config/routes.rb
```

* run the script to replace view rendering calls in controllers with all ruby code extracted from view files (mainly .erb files), and replace `ANALYZER_APP_PATH` with the path where the analyzer stores the application, e.g., `path_to_static-analyzer/applications/APP_NAME`:
```
$ ./preprocess.sh ANALYZER_APP_PATH
```

If `app/helpers` exists, all view rendering calls in helpers will be replaced too.

* copy other folders to `ANALYZER_APP_PATH`, if ruby file exists in those folders, for example:
```
$ cp app/mailers ANALYZER_APP_PATH/
```


===========OPTIONAL=========
* generate next actions:

```
$ ruby main.rb -a #{app_name} -f
```

copy the "path\_funcs.sh" to the application directory and run the script

copy the "path\_funcs.txt" from the application directory back to this dir

then generate the next action files:

```
$ruby main.rb -a #{app_name} -e -n
```

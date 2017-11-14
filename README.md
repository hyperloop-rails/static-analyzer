This repository hosts the static analyzer. It analyzes the control flow and data flow, and identifies each ORM APIs that issues DB queries. 

This analyzer can help find some anti-patterns mentioned in the paper. For example, by checking how the query result is used in the application, it understands where unnecessary data retrieval happens. 

Here's step of how to run it:

0. Run the static analysis:
```
$cd controller_model_analysis
```
* run
```
$ruby main.rb --help
```
to get the options

* Basically, to get the statistics and program flow of a specific action from an app, you would like to run:

```
$ruby main.rb -d DIR_TO_APP_FILES -s CONTROLLER_NAME,ACTION_NAME
```

For example,
```
$ruby main.rb -s -d ../applications/forem PostsController,index
```

The `instructions` in the form of [JRuby intermediate representation](https://www.infoq.com/news/2009/11/jruby-ir) that will be executed by an action, together with the data dependencies among these instructions,  will be printed to the screen.

* If you wish to run all actions from an application, do:
```
$ruby main.rb -a -d DIR_TO_APP_FILES
```

Results will be saved to the folder under the app directory.
The folder name is defined under global.rb, and by default is `/result/`.

1. Analysis

The data flow information can be used to find anti-patterns. An example is shown
in `compute_redundant_field_access.rb`, which returns the fields retrieved by a query but
not used by the action.

2. Applications:

There are already many applications that are preprocessed and ready to be analyzed by this tool. 
These apps lie under the `applications/` directory.

To analyze your own applications, there are some preprocessing work to do:
(not completed yet...)

* copy the ruby files to some directory APPDIR, under the `applications/` folder:
```
$cd applications/
$mkdir APPNAME/
$cd ..
```

* in your app, run:
```
$rake routes | tail -n +2 | awk '{ for (i=1;i<=NF;i++) if (match($i, /.#./)) print $i}' | sed -e 's/#/,/g' | sort | uniq
```
to get the list of actions that can be invoked by the app, copy it to `APPDIR/calls.txt`

* go to `preprocess\_views/` folder, and check the README.md there to extract the code from view.

If there are only .erb files in views, it is probably fine. But if you are using haml, the convertion from haml to erb may run into some trouble.

* copy schema.rb in your app to `APPDIR/`.

* use JRuby to "compile" your app into JRuby IR. The modified JRuby is also in this repository. Follow the `jruby/README.md` to deploy jruby. 

Then go to the applications folder and run the script:
```
$cd applications/
$python generate_dataflow.py APPNAME
```



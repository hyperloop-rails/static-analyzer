import glob
import os
import sys
apppath = "./%s"%(sys.argv[1])

for root, dirs, files in os.walk(apppath):
	for filename in files:
		if filename.endswith(".rb"):
			print filename
			n_begin = filename.rfind('/')
			n_end = filename.rfind('.')
			class_name = filename[n_begin+1:n_end]
			print class_name
			if class_name == "schema":
				continue
			fname = os.path.join(root, filename)
			k = fname.find("%s"%sys.argv[1])
			#des_file = "%s/%s.log"%(des_controller,class_name)
			l = fname.find(".rb")
			#os.system("ruby convert_scope.rb %s"%fname)
			des_file = fname[:k+len(sys.argv[1])] + "/dataflow" + fname[k+len(sys.argv[1]):l] + ".log"
			d_ind = des_file.rfind('/')
			dir_name = des_file[:d_ind]
			print "dir_name = %s"%dir_name
			if os.path.exists(dir_name) == False:
				os.system("mkdir -p %s"%dir_name)
			print "\tdes_file = %s"%des_file
			os.system("jrubyc %s >> %s"%(fname, des_file))
			os.system("rm %s"%fname.replace(".rb",".class"))

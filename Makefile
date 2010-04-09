#------------------------------------------------------------------------
#        Makefile for project
#        Initial version created by zhangshen 2010/02/25
#------------------------------------------------------------------------

#------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------
project=bidin
topmodulename=bidin
cdc_hier=0
lib=1

tcl_dir=D:\svn\tcl
#------------------------------------------------------------------------
# Make Targets for implementation
#------------------------------------------------------------------------
build_dir:
	mkdir $(project)
	cd $(project)
        $(tcl_dir)\build.bat
	copy $(tcl_dir)\run_deb.bat hdl\rtlsim\debussy
	copy $(tcl_dir)\run_nc.bat hdl\rtlsim\run_dir

build_env:
        $(tcl_dir)/build_env $(lib) $(project)

clean:
	rmdir /S /Q $(project)

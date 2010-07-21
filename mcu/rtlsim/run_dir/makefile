#set VCS_HOME = "/ecad/synopsys/vcs_a200809/linux"

all:    run
run:    
	-vcs +vcs+lic+wait -f run.f \
        ../../../sim_env/tb/tb_fpga_cmmb.v \
        +notimingcheck +delay_mode_unit +nospecify +v2k -l ./../log/compile_rs_cmmb.log -Mdir=./DATA \
        -debug -cm_fsmopt optimist\
	-P /ecad/synopsys/Debussy/share/PLI/vcs/LINUX/debussy.tab /ecad/synopsys/Debussy/share/PLI/vcs/LINUX/pli.a
	./simv -l ./../log/cmmb.vcs.log 
       #  -cm line+cond+fsm+path+branch+assert -cm_name rs

clean_vcs:
	-rm simv 
	-rm -R DATA simv.daidir

clean_modsim:
	-rm *.mti *.mpf *.wlf *.do transcript
	-rm -R work

clean_debussy:
	-rm debussyLog -rf
	-rm debussy.rc
    
clean_dve:
	-rm -R DVEfiles

clean_dc:
	-rm *.mr
	-rm *.syn
	-rm *.pvl
	-rm *.svf
	-rm dwsvf_*/ -rf
	-rm *.log

clean:
	make clean_vcs
	make clean_modsim
	make clean_debussy
	make clean_dve
	-rm .vcsmx_rebuild
#	make clean_dc





clean:
        rm -r csrc simv.daidir simv
sim:
        vcs -f compile.f +notimingcheck +nospecify +v2k -debug_all -l ./log/compile.log -Mdir=./DATA \
        -P /ecad/synopsys/Debussy/share/PLI/vcs/LINUX/debussy.tab /ecad/synopsys/Debussy/share/PLI/vcs/LINUX/pli.a
        ./simv -ucli -l ./log/sim.log

sim_cov:
        vcs -f compile.f +notimingcheck +nospecify +v2k -debug_all -l ./log/compile.log \
        -cm line+cond+fsm+path -lca -cm_dir coverage \
        -P /ecad/synopsys/Debussy/share/PLI/vcs/LINUX/debussy.tab /ecad/synopsys/Debussy/share/PLI/vcs/LINUX/pli.a
        ./simv -ucli -l ./log/sim.log

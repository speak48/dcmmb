


all:
	perl ralgen.pl -csv CHIP2901M4.csv -out CHIP2901M4.ralf   
	ralgen -l sv -t CHIP2901M4 CHIP2901M4.ralf
	cp -f ral_CHIP2901M4.sv ../../tests/ral_CHIP2901M4.sv

all_cov:
	perl ralgen.pl -csv CHIP2901M4.csv -out CHIP2901M4_cov.ralf   
	ralgen -l sv -c a -c b -c f -e -t CHIP2901M4 CHIP2901M4_cov.ralf
      


with_mem:
	perl xls2ral.pl  -input CHIP2901M4_with_mem.xls -output CHIP2901M4_with_mem.ralf
	ralgen -l sv -t CHIP2901M4 CHIP2901M4_with_mem.ralf
	cp -f ral_CHIP2901M4.sv ../../tests/ral_CHIP2901M4.sv
        

with_hdl:
	ralgen -b -l sv -t CHIP2901M4 CHIP2901M4_hdl.ralf
	cp -f ral_CHIP2901M4.sv ../../tests/ral_CHIP2901M4.sv

xls_run:
	perl xls2ral.pl  -input CHIP2901M4.xls -output CHIP2901M4.ralf  
	ralgen -l sv -t CHIP2901M4 CHIP2901M4.ralf
	cp -f ral_CHIP2901M4.sv ../../tests/ral_CHIP2901M4.sv

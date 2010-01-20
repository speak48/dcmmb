`ifndef RAL_CHIP2901M4
`define RAL_CHIP2901M4

`include "vmm_ral.sv"

class ral_reg_WDTCCVR extends vmm_ral_reg;
	rand vmm_ral_field WDT_CCVR;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.WDT_CCVR = new(this, "WDT_CCVR", 32, vmm_ral::RO, 'hffff, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_WDTCCVR


class ral_reg_WDTCRR extends vmm_ral_reg;
	rand vmm_ral_field WDT_CRR;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.WDT_CRR = new(this, "WDT_CRR", 8, vmm_ral::WO, 'h0, 8'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_WDTCRR


class ral_reg_WDTCtrl extends vmm_ral_reg;
	rand vmm_ral_field WDT_EN;
	rand vmm_ral_field RMOD;
	rand vmm_ral_field RPL;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.WDT_EN = new(this, "WDT_EN", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.RMOD = new(this, "RMOD", 1, vmm_ral::RW, 'h1, 1'hx, 1, 0, cvr);
		this.RPL = new(this, "RPL", 3, vmm_ral::RW, 'h0, 3'hx, 2, 0, cvr);
	endfunction: new
endclass : ral_reg_WDTCtrl


class ral_reg_WDTEOI extends vmm_ral_reg;
	rand vmm_ral_field WDT_EOI;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.WDT_EOI = new(this, "WDT_EOI", 1, vmm_ral::RC, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_WDTEOI


class ral_reg_WDTSTAT extends vmm_ral_reg;
	rand vmm_ral_field WDT_INTSTAT;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.WDT_INTSTAT = new(this, "WDT_INTSTAT", 1, vmm_ral::RO, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_WDTSTAT


class ral_reg_WDTTORR extends vmm_ral_reg;
	rand vmm_ral_field TOP;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.TOP = new(this, "TOP", 4, vmm_ral::RW, 'h0, 4'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_WDTTORR


class ral_block_WDT extends vmm_ral_block;
	rand ral_reg_WDTCCVR WDTCCVR;
	rand ral_reg_WDTCRR WDTCRR;
	rand ral_reg_WDTCtrl WDTCtrl;
	rand ral_reg_WDTEOI WDTEOI;
	rand ral_reg_WDTSTAT WDTSTAT;
	rand ral_reg_WDTTORR WDTTORR;
	rand vmm_ral_field WDTCCVR_WDT_CCVR;
	rand vmm_ral_field WDT_CCVR;
	rand vmm_ral_field WDTCRR_WDT_CRR;
	rand vmm_ral_field WDT_CRR;
	rand vmm_ral_field WDTCtrl_WDT_EN;
	rand vmm_ral_field WDT_EN;
	rand vmm_ral_field WDTCtrl_RMOD;
	rand vmm_ral_field RMOD;
	rand vmm_ral_field WDTCtrl_RPL;
	rand vmm_ral_field RPL;
	rand vmm_ral_field WDTEOI_WDT_EOI;
	rand vmm_ral_field WDT_EOI;
	rand vmm_ral_field WDTSTAT_WDT_INTSTAT;
	rand vmm_ral_field WDT_INTSTAT;
	rand vmm_ral_field WDTTORR_TOP;
	rand vmm_ral_field TOP;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "WDT", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "WDT", 64, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on);
		this.WDTCCVR = new(this, "WDTCCVR", `VMM_RAL_ADDR_WIDTH'h8, "", cover_on, 2'b11, 0);
		this.WDTCCVR_WDT_CCVR = this.WDTCCVR.WDT_CCVR;
		this.WDT_CCVR = this.WDTCCVR.WDT_CCVR;
		this.WDTCRR = new(this, "WDTCRR", `VMM_RAL_ADDR_WIDTH'hC, "", cover_on, 2'b11, 0);
		this.WDTCRR_WDT_CRR = this.WDTCRR.WDT_CRR;
		this.WDT_CRR = this.WDTCRR.WDT_CRR;
		this.WDTCtrl = new(this, "WDTCtrl", `VMM_RAL_ADDR_WIDTH'h0, "", cover_on, 2'b11, 0);
		this.WDTCtrl_WDT_EN = this.WDTCtrl.WDT_EN;
		this.WDT_EN = this.WDTCtrl.WDT_EN;
		this.WDTCtrl_RMOD = this.WDTCtrl.RMOD;
		this.RMOD = this.WDTCtrl.RMOD;
		this.WDTCtrl_RPL = this.WDTCtrl.RPL;
		this.RPL = this.WDTCtrl.RPL;
		this.WDTEOI = new(this, "WDTEOI", `VMM_RAL_ADDR_WIDTH'h14, "", cover_on, 2'b11, 0);
		this.WDTEOI_WDT_EOI = this.WDTEOI.WDT_EOI;
		this.WDT_EOI = this.WDTEOI.WDT_EOI;
		this.WDTSTAT = new(this, "WDTSTAT", `VMM_RAL_ADDR_WIDTH'h10, "", cover_on, 2'b11, 0);
		this.WDTSTAT_WDT_INTSTAT = this.WDTSTAT.WDT_INTSTAT;
		this.WDT_INTSTAT = this.WDTSTAT.WDT_INTSTAT;
		this.WDTTORR = new(this, "WDTTORR", `VMM_RAL_ADDR_WIDTH'h4, "", cover_on, 2'b11, 0);
		this.WDTTORR_TOP = this.WDTTORR.TOP;
		this.TOP = this.WDTTORR.TOP;
		this.Xlock_modelX();
	endfunction : new
endclass : ral_block_WDT


class ral_reg_SCIBGTCTRL extends vmm_ral_reg;
	rand vmm_ral_field bgt_en;
	rand vmm_ral_field cwt_en;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.bgt_en = new(this, "bgt_en", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.cwt_en = new(this, "cwt_en", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
	endfunction: new
endclass : ral_reg_SCIBGTCTRL


class ral_reg_SCIBGTDATA extends vmm_ral_reg;
	rand vmm_ral_field BGTDATA;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.BGTDATA = new(this, "BGTDATA", 5, vmm_ral::RW, 'h16, 5'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SCIBGTDATA


class ral_reg_SCIBUFHW extends vmm_ral_reg;
	rand vmm_ral_field SCIBUFHW;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SCIBUFHW = new(this, "SCIBUFHW", 8, vmm_ral::RW, 'h0, 8'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SCIBUFHW


class ral_reg_SCICTRL extends vmm_ral_reg;
	rand vmm_ral_field IOMOD_SEL;
	rand vmm_ral_field IOPAD1_EN;
	rand vmm_ral_field IOPAD2_EN;
	rand vmm_ral_field retry_en;
	rand vmm_ral_field rx_fifo_clr;
	rand vmm_ral_field tx_fifo_clr;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IOMOD_SEL = new(this, "IOMOD_SEL", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.IOPAD1_EN = new(this, "IOPAD1_EN", 1, vmm_ral::RW, 'h1, 1'hx, 1, 0, cvr);
		this.IOPAD2_EN = new(this, "IOPAD2_EN", 1, vmm_ral::RW, 'h1, 1'hx, 2, 0, cvr);
		this.retry_en = new(this, "retry_en", 1, vmm_ral::RW, 'h1, 1'hx, 3, 0, cvr);
		this.rx_fifo_clr = new(this, "rx_fifo_clr", 1, vmm_ral::RW, 'h0, 1'hx, 4, 0, cvr);
		this.tx_fifo_clr = new(this, "tx_fifo_clr", 1, vmm_ral::RW, 'h0, 1'hx, 5, 0, cvr);
	endfunction: new
endclass : ral_reg_SCICTRL


class ral_reg_SCICWTDATA extends vmm_ral_reg;
	rand vmm_ral_field wtdata;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.wtdata = new(this, "wtdata", 16, vmm_ral::RW, 'h2580, 16'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SCICWTDATA


class ral_reg_SCIEDCCTRL extends vmm_ral_reg;
	rand vmm_ral_field edc_en;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.edc_en = new(this, "edc_en", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SCIEDCCTRL


class ral_reg_SCIEDCDATA extends vmm_ral_reg;
	rand vmm_ral_field EDCDATA;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.EDCDATA = new(this, "EDCDATA", 8, vmm_ral::RW, 'h0, 8'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SCIEDCDATA


class ral_reg_SCIETUDATA extends vmm_ral_reg;
	rand vmm_ral_field ETUDATA;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.ETUDATA = new(this, "ETUDATA", 13, vmm_ral::RW, 'h174, 13'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SCIETUDATA


class ral_reg_SCIINTIO1 extends vmm_ral_reg;
	rand vmm_ral_field iopad_int;
	rand vmm_ral_field rx_int;
	rand vmm_ral_field tx_int;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.iopad_int = new(this, "iopad_int", 1, vmm_ral::W1C, 'h0, 1'hx, 0, 0, cvr);
		this.rx_int = new(this, "rx_int", 1, vmm_ral::W1C, 'h0, 1'hx, 1, 0, cvr);
		this.tx_int = new(this, "tx_int", 1, vmm_ral::W1C, 'h0, 1'hx, 2, 0, cvr);
	endfunction: new
endclass : ral_reg_SCIINTIO1


class ral_reg_SCIMODHW extends vmm_ral_reg;
	rand vmm_ral_field tmode_sel;
	rand vmm_ral_field dirc_sel;
	rand vmm_ral_field outtyp_sel;
	rand vmm_ral_field etu_sel;
	rand vmm_ral_field retry_sel;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.tmode_sel = new(this, "tmode_sel", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.dirc_sel = new(this, "dirc_sel", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
		this.outtyp_sel = new(this, "outtyp_sel", 1, vmm_ral::RW, 'h1, 1'hx, 2, 0, cvr);
		this.etu_sel = new(this, "etu_sel", 2, vmm_ral::RW, 'h0, 2'hx, 3, 0, cvr);
		this.retry_sel = new(this, "retry_sel", 3, vmm_ral::RW, 'h2, 3'hx, 5, 0, cvr);
	endfunction: new
endclass : ral_reg_SCIMODHW


class ral_reg_SCISTAT extends vmm_ral_reg;
	rand vmm_ral_field rx_fifo_empty;
	rand vmm_ral_field rx_fifo_full;
	rand vmm_ral_field rx_error;
	rand vmm_ral_field tx_fifo_empty;
	rand vmm_ral_field tx_fifo_full;
	rand vmm_ral_field tx_error;
	rand vmm_ral_field bgt_flag;
	rand vmm_ral_field cwt_flag;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.rx_fifo_empty = new(this, "rx_fifo_empty", 1, vmm_ral::RO, 'h0, 1'hx, 0, 0, cvr);
		this.rx_fifo_full = new(this, "rx_fifo_full", 1, vmm_ral::RO, 'h0, 1'hx, 1, 0, cvr);
		this.rx_error = new(this, "rx_error", 1, vmm_ral::RO, 'h0, 1'hx, 2, 0, cvr);
		this.tx_fifo_empty = new(this, "tx_fifo_empty", 1, vmm_ral::RO, 'h0, 1'hx, 3, 0, cvr);
		this.tx_fifo_full = new(this, "tx_fifo_full", 1, vmm_ral::RO, 'h0, 1'hx, 4, 0, cvr);
		this.tx_error = new(this, "tx_error", 1, vmm_ral::RO, 'h0, 1'hx, 5, 0, cvr);
		this.bgt_flag = new(this, "bgt_flag", 1, vmm_ral::RO, 'h0, 1'hx, 6, 0, cvr);
		this.cwt_flag = new(this, "cwt_flag", 1, vmm_ral::RO, 'h0, 1'hx, 7, 0, cvr);
	endfunction: new
endclass : ral_reg_SCISTAT


class ral_block_SCI7816 extends vmm_ral_block;
	rand ral_reg_SCIBGTCTRL SCIBGTCTRL;
	rand ral_reg_SCIBGTDATA SCIBGTDATA;
	rand ral_reg_SCIBUFHW SCIBUFHW;
	rand ral_reg_SCICTRL SCICTRL;
	rand ral_reg_SCICWTDATA SCICWTDATA;
	rand ral_reg_SCIEDCCTRL SCIEDCCTRL;
	rand ral_reg_SCIEDCDATA SCIEDCDATA;
	rand ral_reg_SCIETUDATA SCIETUDATA;
	rand ral_reg_SCIINTIO1 SCIINTIO1;
	rand ral_reg_SCIMODHW SCIMODHW;
	rand ral_reg_SCISTAT SCISTAT;
	rand vmm_ral_field SCIBGTCTRL_bgt_en;
	rand vmm_ral_field bgt_en;
	rand vmm_ral_field SCIBGTCTRL_cwt_en;
	rand vmm_ral_field cwt_en;
	rand vmm_ral_field SCIBGTDATA_BGTDATA;
	rand vmm_ral_field BGTDATA;
	rand vmm_ral_field SCIBUFHW_SCIBUFHW;
	rand vmm_ral_field SCICTRL_IOMOD_SEL;
	rand vmm_ral_field IOMOD_SEL;
	rand vmm_ral_field SCICTRL_IOPAD1_EN;
	rand vmm_ral_field IOPAD1_EN;
	rand vmm_ral_field SCICTRL_IOPAD2_EN;
	rand vmm_ral_field IOPAD2_EN;
	rand vmm_ral_field SCICTRL_retry_en;
	rand vmm_ral_field retry_en;
	rand vmm_ral_field SCICTRL_rx_fifo_clr;
	rand vmm_ral_field rx_fifo_clr;
	rand vmm_ral_field SCICTRL_tx_fifo_clr;
	rand vmm_ral_field tx_fifo_clr;
	rand vmm_ral_field SCICWTDATA_wtdata;
	rand vmm_ral_field wtdata;
	rand vmm_ral_field SCIEDCCTRL_edc_en;
	rand vmm_ral_field edc_en;
	rand vmm_ral_field SCIEDCDATA_EDCDATA;
	rand vmm_ral_field EDCDATA;
	rand vmm_ral_field SCIETUDATA_ETUDATA;
	rand vmm_ral_field ETUDATA;
	rand vmm_ral_field SCIINTIO1_iopad_int;
	rand vmm_ral_field iopad_int;
	rand vmm_ral_field SCIINTIO1_rx_int;
	rand vmm_ral_field rx_int;
	rand vmm_ral_field SCIINTIO1_tx_int;
	rand vmm_ral_field tx_int;
	rand vmm_ral_field SCIMODHW_tmode_sel;
	rand vmm_ral_field tmode_sel;
	rand vmm_ral_field SCIMODHW_dirc_sel;
	rand vmm_ral_field dirc_sel;
	rand vmm_ral_field SCIMODHW_outtyp_sel;
	rand vmm_ral_field outtyp_sel;
	rand vmm_ral_field SCIMODHW_etu_sel;
	rand vmm_ral_field etu_sel;
	rand vmm_ral_field SCIMODHW_retry_sel;
	rand vmm_ral_field retry_sel;
	rand vmm_ral_field SCISTAT_rx_fifo_empty;
	rand vmm_ral_field rx_fifo_empty;
	rand vmm_ral_field SCISTAT_rx_fifo_full;
	rand vmm_ral_field rx_fifo_full;
	rand vmm_ral_field SCISTAT_rx_error;
	rand vmm_ral_field rx_error;
	rand vmm_ral_field SCISTAT_tx_fifo_empty;
	rand vmm_ral_field tx_fifo_empty;
	rand vmm_ral_field SCISTAT_tx_fifo_full;
	rand vmm_ral_field tx_fifo_full;
	rand vmm_ral_field SCISTAT_tx_error;
	rand vmm_ral_field tx_error;
	rand vmm_ral_field SCISTAT_bgt_flag;
	rand vmm_ral_field bgt_flag;
	rand vmm_ral_field SCISTAT_cwt_flag;
	rand vmm_ral_field cwt_flag;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "SCI7816", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "SCI7816", 128, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on);
		this.SCIBGTCTRL = new(this, "SCIBGTCTRL", `VMM_RAL_ADDR_WIDTH'h1C, "", cover_on, 2'b11, 0);
		this.SCIBGTCTRL_bgt_en = this.SCIBGTCTRL.bgt_en;
		this.bgt_en = this.SCIBGTCTRL.bgt_en;
		this.SCIBGTCTRL_cwt_en = this.SCIBGTCTRL.cwt_en;
		this.cwt_en = this.SCIBGTCTRL.cwt_en;
		this.SCIBGTDATA = new(this, "SCIBGTDATA", `VMM_RAL_ADDR_WIDTH'h2C, "", cover_on, 2'b11, 0);
		this.SCIBGTDATA_BGTDATA = this.SCIBGTDATA.BGTDATA;
		this.BGTDATA = this.SCIBGTDATA.BGTDATA;
		this.SCIBUFHW = new(this, "SCIBUFHW", `VMM_RAL_ADDR_WIDTH'h20, "", cover_on, 2'b11, 0);
		this.SCIBUFHW_SCIBUFHW = this.SCIBUFHW.SCIBUFHW;
		this.SCICTRL = new(this, "SCICTRL", `VMM_RAL_ADDR_WIDTH'h8, "", cover_on, 2'b11, 0);
		this.SCICTRL_IOMOD_SEL = this.SCICTRL.IOMOD_SEL;
		this.IOMOD_SEL = this.SCICTRL.IOMOD_SEL;
		this.SCICTRL_IOPAD1_EN = this.SCICTRL.IOPAD1_EN;
		this.IOPAD1_EN = this.SCICTRL.IOPAD1_EN;
		this.SCICTRL_IOPAD2_EN = this.SCICTRL.IOPAD2_EN;
		this.IOPAD2_EN = this.SCICTRL.IOPAD2_EN;
		this.SCICTRL_retry_en = this.SCICTRL.retry_en;
		this.retry_en = this.SCICTRL.retry_en;
		this.SCICTRL_rx_fifo_clr = this.SCICTRL.rx_fifo_clr;
		this.rx_fifo_clr = this.SCICTRL.rx_fifo_clr;
		this.SCICTRL_tx_fifo_clr = this.SCICTRL.tx_fifo_clr;
		this.tx_fifo_clr = this.SCICTRL.tx_fifo_clr;
		this.SCICWTDATA = new(this, "SCICWTDATA", `VMM_RAL_ADDR_WIDTH'h30, "", cover_on, 2'b11, 0);
		this.SCICWTDATA_wtdata = this.SCICWTDATA.wtdata;
		this.wtdata = this.SCICWTDATA.wtdata;
		this.SCIEDCCTRL = new(this, "SCIEDCCTRL", `VMM_RAL_ADDR_WIDTH'h18, "", cover_on, 2'b11, 0);
		this.SCIEDCCTRL_edc_en = this.SCIEDCCTRL.edc_en;
		this.edc_en = this.SCIEDCCTRL.edc_en;
		this.SCIEDCDATA = new(this, "SCIEDCDATA", `VMM_RAL_ADDR_WIDTH'h34, "", cover_on, 2'b11, 0);
		this.SCIEDCDATA_EDCDATA = this.SCIEDCDATA.EDCDATA;
		this.EDCDATA = this.SCIEDCDATA.EDCDATA;
		this.SCIETUDATA = new(this, "SCIETUDATA", `VMM_RAL_ADDR_WIDTH'h28, "", cover_on, 2'b11, 0);
		this.SCIETUDATA_ETUDATA = this.SCIETUDATA.ETUDATA;
		this.ETUDATA = this.SCIETUDATA.ETUDATA;
		this.SCIINTIO1 = new(this, "SCIINTIO1", `VMM_RAL_ADDR_WIDTH'h10, "", cover_on, 2'b11, 0);
		this.SCIINTIO1_iopad_int = this.SCIINTIO1.iopad_int;
		this.iopad_int = this.SCIINTIO1.iopad_int;
		this.SCIINTIO1_rx_int = this.SCIINTIO1.rx_int;
		this.rx_int = this.SCIINTIO1.rx_int;
		this.SCIINTIO1_tx_int = this.SCIINTIO1.tx_int;
		this.tx_int = this.SCIINTIO1.tx_int;
		this.SCIMODHW = new(this, "SCIMODHW", `VMM_RAL_ADDR_WIDTH'h0, "", cover_on, 2'b11, 0);
		this.SCIMODHW_tmode_sel = this.SCIMODHW.tmode_sel;
		this.tmode_sel = this.SCIMODHW.tmode_sel;
		this.SCIMODHW_dirc_sel = this.SCIMODHW.dirc_sel;
		this.dirc_sel = this.SCIMODHW.dirc_sel;
		this.SCIMODHW_outtyp_sel = this.SCIMODHW.outtyp_sel;
		this.outtyp_sel = this.SCIMODHW.outtyp_sel;
		this.SCIMODHW_etu_sel = this.SCIMODHW.etu_sel;
		this.etu_sel = this.SCIMODHW.etu_sel;
		this.SCIMODHW_retry_sel = this.SCIMODHW.retry_sel;
		this.retry_sel = this.SCIMODHW.retry_sel;
		this.SCISTAT = new(this, "SCISTAT", `VMM_RAL_ADDR_WIDTH'hC, "", cover_on, 2'b11, 0);
		this.SCISTAT_rx_fifo_empty = this.SCISTAT.rx_fifo_empty;
		this.rx_fifo_empty = this.SCISTAT.rx_fifo_empty;
		this.SCISTAT_rx_fifo_full = this.SCISTAT.rx_fifo_full;
		this.rx_fifo_full = this.SCISTAT.rx_fifo_full;
		this.SCISTAT_rx_error = this.SCISTAT.rx_error;
		this.rx_error = this.SCISTAT.rx_error;
		this.SCISTAT_tx_fifo_empty = this.SCISTAT.tx_fifo_empty;
		this.tx_fifo_empty = this.SCISTAT.tx_fifo_empty;
		this.SCISTAT_tx_fifo_full = this.SCISTAT.tx_fifo_full;
		this.tx_fifo_full = this.SCISTAT.tx_fifo_full;
		this.SCISTAT_tx_error = this.SCISTAT.tx_error;
		this.tx_error = this.SCISTAT.tx_error;
		this.SCISTAT_bgt_flag = this.SCISTAT.bgt_flag;
		this.bgt_flag = this.SCISTAT.bgt_flag;
		this.SCISTAT_cwt_flag = this.SCISTAT.cwt_flag;
		this.cwt_flag = this.SCISTAT.cwt_flag;
		this.Xlock_modelX();
	endfunction : new
endclass : ral_block_SCI7816


class ral_reg_FIQFinalStat extends vmm_ral_reg;
	rand vmm_ral_field WDT_int_finalstat;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.WDT_int_finalstat = new(this, "WDT_int_finalstat", 1, vmm_ral::RO, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_FIQFinalStat


class ral_reg_FIQRawStat extends vmm_ral_reg;
	rand vmm_ral_field WDT_Int_source;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.WDT_Int_source = new(this, "WDT_Int_source", 1, vmm_ral::RO, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_FIQRawStat


class ral_reg_FIQStat extends vmm_ral_reg;
	rand vmm_ral_field WDT_Int_status;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.WDT_Int_status = new(this, "WDT_Int_status", 1, vmm_ral::RO, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_FIQStat


class ral_reg_FIQ_inten extends vmm_ral_reg;
	rand vmm_ral_field wdt_int_en;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.wdt_int_en = new(this, "wdt_int_en", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_FIQ_inten


class ral_reg_FIQ_intmask extends vmm_ral_reg;
	rand vmm_ral_field wdt_int_mask;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.wdt_int_mask = new(this, "wdt_int_mask", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_FIQ_intmask


class ral_reg_FIQintforce extends vmm_ral_reg;
	rand vmm_ral_field WDT_int_force;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.WDT_int_force = new(this, "WDT_int_force", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_FIQintforce


class ral_reg_IRQFinalStat extends vmm_ral_reg;
	rand vmm_ral_field sci_rx_int_finalstatus;
	rand vmm_ral_field sci_tx_int_finalstatus;
	rand vmm_ral_field gpio_int_finalstatus;
	rand vmm_ral_field rf_int_finalstatus;
	rand vmm_ral_field timer0_int_finalstatus;
	rand vmm_ral_field timer1_int_finalstatus;
	rand vmm_ral_field timer2_int_finalstatus;
	rand vmm_ral_field ee_int_finalstatus;
	rand vmm_ral_field rsa_int_finalstatus;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.sci_rx_int_finalstatus = new(this, "sci_rx_int_finalstatus", 1, vmm_ral::RO, 'h0, 1'hx, 0, 0, cvr);
		this.sci_tx_int_finalstatus = new(this, "sci_tx_int_finalstatus", 1, vmm_ral::RO, 'h0, 1'hx, 1, 0, cvr);
		this.gpio_int_finalstatus = new(this, "gpio_int_finalstatus", 1, vmm_ral::RO, 'h0, 1'hx, 2, 0, cvr);
		this.rf_int_finalstatus = new(this, "rf_int_finalstatus", 1, vmm_ral::RO, 'h0, 1'hx, 3, 0, cvr);
		this.timer0_int_finalstatus = new(this, "timer0_int_finalstatus", 1, vmm_ral::RO, 'h0, 1'hx, 4, 0, cvr);
		this.timer1_int_finalstatus = new(this, "timer1_int_finalstatus", 1, vmm_ral::RO, 'h0, 1'hx, 5, 0, cvr);
		this.timer2_int_finalstatus = new(this, "timer2_int_finalstatus", 1, vmm_ral::RO, 'h0, 1'hx, 6, 0, cvr);
		this.ee_int_finalstatus = new(this, "ee_int_finalstatus", 1, vmm_ral::RO, 'h0, 1'hx, 7, 0, cvr);
		this.rsa_int_finalstatus = new(this, "rsa_int_finalstatus", 1, vmm_ral::RO, 'h0, 1'hx, 8, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQFinalStat


class ral_reg_IRQIntForce extends vmm_ral_reg;
	rand vmm_ral_field sci_rx_int_force;
	rand vmm_ral_field sci_tx_int_force;
	rand vmm_ral_field gpio_int_force;
	rand vmm_ral_field rf_int_force;
	rand vmm_ral_field timer0_int_force;
	rand vmm_ral_field timer1_int_force;
	rand vmm_ral_field timer2_int_force;
	rand vmm_ral_field ee_int_force;
	rand vmm_ral_field rsa_int_force;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.sci_rx_int_force = new(this, "sci_rx_int_force", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.sci_tx_int_force = new(this, "sci_tx_int_force", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
		this.gpio_int_force = new(this, "gpio_int_force", 1, vmm_ral::RW, 'h0, 1'hx, 2, 0, cvr);
		this.rf_int_force = new(this, "rf_int_force", 1, vmm_ral::RW, 'h0, 1'hx, 3, 0, cvr);
		this.timer0_int_force = new(this, "timer0_int_force", 1, vmm_ral::RW, 'h0, 1'hx, 4, 0, cvr);
		this.timer1_int_force = new(this, "timer1_int_force", 1, vmm_ral::RW, 'h0, 1'hx, 5, 0, cvr);
		this.timer2_int_force = new(this, "timer2_int_force", 1, vmm_ral::RW, 'h0, 1'hx, 6, 0, cvr);
		this.ee_int_force = new(this, "ee_int_force", 1, vmm_ral::RW, 'h0, 1'hx, 7, 0, cvr);
		this.rsa_int_force = new(this, "rsa_int_force", 1, vmm_ral::RW, 'h0, 1'hx, 8, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQIntForce


class ral_reg_IRQIntMsk extends vmm_ral_reg;
	rand vmm_ral_field sci_rx_int_mask;
	rand vmm_ral_field sci_tx_int_mask;
	rand vmm_ral_field gpio_int_mask;
	rand vmm_ral_field rf_int_mask;
	rand vmm_ral_field timer0_int_mask;
	rand vmm_ral_field timer1_int_mask;
	rand vmm_ral_field timer2_int_mask;
	rand vmm_ral_field ee_int_mask;
	rand vmm_ral_field rsa_int_mask;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.sci_rx_int_mask = new(this, "sci_rx_int_mask", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.sci_tx_int_mask = new(this, "sci_tx_int_mask", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
		this.gpio_int_mask = new(this, "gpio_int_mask", 1, vmm_ral::RW, 'h0, 1'hx, 2, 0, cvr);
		this.rf_int_mask = new(this, "rf_int_mask", 1, vmm_ral::RW, 'h0, 1'hx, 3, 0, cvr);
		this.timer0_int_mask = new(this, "timer0_int_mask", 1, vmm_ral::RW, 'h0, 1'hx, 4, 0, cvr);
		this.timer1_int_mask = new(this, "timer1_int_mask", 1, vmm_ral::RW, 'h0, 1'hx, 5, 0, cvr);
		this.timer2_int_mask = new(this, "timer2_int_mask", 1, vmm_ral::RW, 'h0, 1'hx, 6, 0, cvr);
		this.ee_int_mask = new(this, "ee_int_mask", 1, vmm_ral::RW, 'h0, 1'hx, 7, 0, cvr);
		this.rsa_int_mask = new(this, "rsa_int_mask", 1, vmm_ral::RW, 'h0, 1'hx, 8, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQIntMsk


class ral_reg_IRQMaskStat extends vmm_ral_reg;
	rand vmm_ral_field sci_rx_int_maskstatus;
	rand vmm_ral_field sci_tx_int_maskstatus;
	rand vmm_ral_field gpio_int_maskstatus;
	rand vmm_ral_field rf_int_maskstatus;
	rand vmm_ral_field timer0_int_maskstatus;
	rand vmm_ral_field timer1_int_maskstatus;
	rand vmm_ral_field timer2_int_maskstatus;
	rand vmm_ral_field ee_int_maskstatus;
	rand vmm_ral_field rsa_int_maskstatus;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.sci_rx_int_maskstatus = new(this, "sci_rx_int_maskstatus", 1, vmm_ral::RO, 'h0, 1'hx, 0, 0, cvr);
		this.sci_tx_int_maskstatus = new(this, "sci_tx_int_maskstatus", 1, vmm_ral::RO, 'h0, 1'hx, 1, 0, cvr);
		this.gpio_int_maskstatus = new(this, "gpio_int_maskstatus", 1, vmm_ral::RO, 'h0, 1'hx, 2, 0, cvr);
		this.rf_int_maskstatus = new(this, "rf_int_maskstatus", 1, vmm_ral::RO, 'h0, 1'hx, 3, 0, cvr);
		this.timer0_int_maskstatus = new(this, "timer0_int_maskstatus", 1, vmm_ral::RO, 'h0, 1'hx, 4, 0, cvr);
		this.timer1_int_maskstatus = new(this, "timer1_int_maskstatus", 1, vmm_ral::RO, 'h0, 1'hx, 5, 0, cvr);
		this.timer2_int_maskstatus = new(this, "timer2_int_maskstatus", 1, vmm_ral::RO, 'h0, 1'hx, 6, 0, cvr);
		this.ee_int_maskstatus = new(this, "ee_int_maskstatus", 1, vmm_ral::RO, 'h0, 1'hx, 7, 0, cvr);
		this.rsa_int_maskstatus = new(this, "rsa_int_maskstatus", 1, vmm_ral::RO, 'h0, 1'hx, 8, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQMaskStat


class ral_reg_IRQPLevel extends vmm_ral_reg;
	rand vmm_ral_field IRQPLevel;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQPLevel = new(this, "IRQPLevel", 4, vmm_ral::RW, 'h0, 4'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQPLevel


class ral_reg_IRQRawStat extends vmm_ral_reg;
	rand vmm_ral_field sci_rx_int_source;
	rand vmm_ral_field sci_tx_int_source;
	rand vmm_ral_field gpio_int_source;
	rand vmm_ral_field rf_int_source;
	rand vmm_ral_field timer0_int_source;
	rand vmm_ral_field timer1_int_source;
	rand vmm_ral_field timer2_int_source;
	rand vmm_ral_field ee_int_source;
	rand vmm_ral_field rsa_int_source;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.sci_rx_int_source = new(this, "sci_rx_int_source", 1, vmm_ral::RO, 'h0, 1'hx, 0, 0, cvr);
		this.sci_tx_int_source = new(this, "sci_tx_int_source", 1, vmm_ral::RO, 'h0, 1'hx, 1, 0, cvr);
		this.gpio_int_source = new(this, "gpio_int_source", 1, vmm_ral::RO, 'h0, 1'hx, 2, 0, cvr);
		this.rf_int_source = new(this, "rf_int_source", 1, vmm_ral::RO, 'h0, 1'hx, 3, 0, cvr);
		this.timer0_int_source = new(this, "timer0_int_source", 1, vmm_ral::RO, 'h0, 1'hx, 4, 0, cvr);
		this.timer1_int_source = new(this, "timer1_int_source", 1, vmm_ral::RO, 'h0, 1'hx, 5, 0, cvr);
		this.timer2_int_source = new(this, "timer2_int_source", 1, vmm_ral::RO, 'h0, 1'hx, 6, 0, cvr);
		this.ee_int_source = new(this, "ee_int_source", 1, vmm_ral::RO, 'h0, 1'hx, 7, 0, cvr);
		this.rsa_int_source = new(this, "rsa_int_source", 1, vmm_ral::RO, 'h0, 1'hx, 8, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQRawStat


class ral_reg_IRQStat extends vmm_ral_reg;
	rand vmm_ral_field sci_rx_int_status;
	rand vmm_ral_field sci_tx_int_status;
	rand vmm_ral_field gpio_int_status;
	rand vmm_ral_field rf_int_status;
	rand vmm_ral_field timer0_int_status;
	rand vmm_ral_field timer1_int_status;
	rand vmm_ral_field timer2_int_status;
	rand vmm_ral_field ee_int_status;
	rand vmm_ral_field rsa_int_status;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.sci_rx_int_status = new(this, "sci_rx_int_status", 1, vmm_ral::RO, 'h0, 1'hx, 0, 0, cvr);
		this.sci_tx_int_status = new(this, "sci_tx_int_status", 1, vmm_ral::RO, 'h0, 1'hx, 1, 0, cvr);
		this.gpio_int_status = new(this, "gpio_int_status", 1, vmm_ral::RO, 'h0, 1'hx, 2, 0, cvr);
		this.rf_int_status = new(this, "rf_int_status", 1, vmm_ral::RO, 'h0, 1'hx, 3, 0, cvr);
		this.timer0_int_status = new(this, "timer0_int_status", 1, vmm_ral::RO, 'h0, 1'hx, 4, 0, cvr);
		this.timer1_int_status = new(this, "timer1_int_status", 1, vmm_ral::RO, 'h0, 1'hx, 5, 0, cvr);
		this.timer2_int_status = new(this, "timer2_int_status", 1, vmm_ral::RO, 'h0, 1'hx, 6, 0, cvr);
		this.ee_int_status = new(this, "ee_int_status", 1, vmm_ral::RO, 'h0, 1'hx, 7, 0, cvr);
		this.rsa_int_status = new(this, "rsa_int_status", 1, vmm_ral::RO, 'h0, 1'hx, 8, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQStat


class ral_reg_IRQVector extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Vec_Current;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Vec_Current = new(this, "IRQ_Vec_Current", 32, vmm_ral::RO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQVector


class ral_reg_IRQVector0 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Vec_0;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Vec_0 = new(this, "IRQ_Vec_0", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQVector0


class ral_reg_IRQVector1 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Vec_1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Vec_1 = new(this, "IRQ_Vec_1", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQVector1


class ral_reg_IRQVector10 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Vec_10;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Vec_10 = new(this, "IRQ_Vec_10", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQVector10


class ral_reg_IRQVector11 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Vec_11;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Vec_11 = new(this, "IRQ_Vec_11", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQVector11


class ral_reg_IRQVector12 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Vec_12;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Vec_12 = new(this, "IRQ_Vec_12", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQVector12


class ral_reg_IRQVector13 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Vec_13;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Vec_13 = new(this, "IRQ_Vec_13", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQVector13


class ral_reg_IRQVector14 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Vec_14;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Vec_14 = new(this, "IRQ_Vec_14", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQVector14


class ral_reg_IRQVector15 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Vec_15;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Vec_15 = new(this, "IRQ_Vec_15", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQVector15


class ral_reg_IRQVector2 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Vec_2;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Vec_2 = new(this, "IRQ_Vec_2", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQVector2


class ral_reg_IRQVector3 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Vec_3;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Vec_3 = new(this, "IRQ_Vec_3", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQVector3


class ral_reg_IRQVector4 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Vec_4;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Vec_4 = new(this, "IRQ_Vec_4", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQVector4


class ral_reg_IRQVector5 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Vec_5;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Vec_5 = new(this, "IRQ_Vec_5", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQVector5


class ral_reg_IRQVector6 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Vec_6;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Vec_6 = new(this, "IRQ_Vec_6", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQVector6


class ral_reg_IRQVector7 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Vec_7;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Vec_7 = new(this, "IRQ_Vec_7", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQVector7


class ral_reg_IRQVector8 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Vec_8;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Vec_8 = new(this, "IRQ_Vec_8", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQVector8


class ral_reg_IRQVector9 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Vec_9;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Vec_9 = new(this, "IRQ_Vec_9", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQVector9


class ral_reg_IRQ_P_N_offset0 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Prio_0;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Prio_0 = new(this, "IRQ_Prio_0", 4, vmm_ral::RW, 'h0, 4'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQ_P_N_offset0


class ral_reg_IRQ_P_N_offset1 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Prio_1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Prio_1 = new(this, "IRQ_Prio_1", 4, vmm_ral::RW, 'h1, 4'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQ_P_N_offset1


class ral_reg_IRQ_P_N_offset10 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Prio_10;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Prio_10 = new(this, "IRQ_Prio_10", 4, vmm_ral::RW, 'ha, 4'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQ_P_N_offset10


class ral_reg_IRQ_P_N_offset11 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Prio_11;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Prio_11 = new(this, "IRQ_Prio_11", 4, vmm_ral::RW, 'hb, 4'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQ_P_N_offset11


class ral_reg_IRQ_P_N_offset2 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Prio_2;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Prio_2 = new(this, "IRQ_Prio_2", 4, vmm_ral::RW, 'h2, 4'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQ_P_N_offset2


class ral_reg_IRQ_P_N_offset3 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Prio_3;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Prio_3 = new(this, "IRQ_Prio_3", 4, vmm_ral::RW, 'h3, 4'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQ_P_N_offset3


class ral_reg_IRQ_P_N_offset4 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Prio_4;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Prio_4 = new(this, "IRQ_Prio_4", 4, vmm_ral::RW, 'h4, 4'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQ_P_N_offset4


class ral_reg_IRQ_P_N_offset5 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Prio_5;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Prio_5 = new(this, "IRQ_Prio_5", 4, vmm_ral::RW, 'h5, 4'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQ_P_N_offset5


class ral_reg_IRQ_P_N_offset6 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Prio_6;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Prio_6 = new(this, "IRQ_Prio_6", 4, vmm_ral::RW, 'h6, 4'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQ_P_N_offset6


class ral_reg_IRQ_P_N_offset7 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Prio_7;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Prio_7 = new(this, "IRQ_Prio_7", 4, vmm_ral::RW, 'h7, 4'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQ_P_N_offset7


class ral_reg_IRQ_P_N_offset8 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Prio_8;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Prio_8 = new(this, "IRQ_Prio_8", 4, vmm_ral::RW, 'h8, 4'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQ_P_N_offset8


class ral_reg_IRQ_P_N_offset9 extends vmm_ral_reg;
	rand vmm_ral_field IRQ_Prio_9;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.IRQ_Prio_9 = new(this, "IRQ_Prio_9", 4, vmm_ral::RW, 'h9, 4'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQ_P_N_offset9


class ral_reg_IRQ_inten extends vmm_ral_reg;
	rand vmm_ral_field sci_rx_int_en;
	rand vmm_ral_field sci_tx_int_en;
	rand vmm_ral_field gpio_int_en;
	rand vmm_ral_field rf_int_en;
	rand vmm_ral_field timer0_int_en;
	rand vmm_ral_field timer1_int_en;
	rand vmm_ral_field timer2_int_en;
	rand vmm_ral_field ee_int_en;
	rand vmm_ral_field rsa_int_en;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.sci_rx_int_en = new(this, "sci_rx_int_en", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.sci_tx_int_en = new(this, "sci_tx_int_en", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
		this.gpio_int_en = new(this, "gpio_int_en", 1, vmm_ral::RW, 'h0, 1'hx, 2, 0, cvr);
		this.rf_int_en = new(this, "rf_int_en", 1, vmm_ral::RW, 'h0, 1'hx, 3, 0, cvr);
		this.timer0_int_en = new(this, "timer0_int_en", 1, vmm_ral::RW, 'h0, 1'hx, 4, 0, cvr);
		this.timer1_int_en = new(this, "timer1_int_en", 1, vmm_ral::RW, 'h0, 1'hx, 5, 0, cvr);
		this.timer2_int_en = new(this, "timer2_int_en", 1, vmm_ral::RW, 'h0, 1'hx, 6, 0, cvr);
		this.ee_int_en = new(this, "ee_int_en", 1, vmm_ral::RW, 'h0, 1'hx, 7, 0, cvr);
		this.rsa_int_en = new(this, "rsa_int_en", 1, vmm_ral::RW, 'h0, 1'hx, 8, 0, cvr);
	endfunction: new
endclass : ral_reg_IRQ_inten


class ral_block_ICTL extends vmm_ral_block;
	rand ral_reg_FIQFinalStat FIQFinalStat;
	rand ral_reg_FIQRawStat FIQRawStat;
	rand ral_reg_FIQStat FIQStat;
	rand ral_reg_FIQ_inten FIQ_inten;
	rand ral_reg_FIQ_intmask FIQ_intmask;
	rand ral_reg_FIQintforce FIQintforce;
	rand ral_reg_IRQFinalStat IRQFinalStat;
	rand ral_reg_IRQIntForce IRQIntForce;
	rand ral_reg_IRQIntMsk IRQIntMsk;
	rand ral_reg_IRQMaskStat IRQMaskStat;
	rand ral_reg_IRQPLevel IRQPLevel;
	rand ral_reg_IRQRawStat IRQRawStat;
	rand ral_reg_IRQStat IRQStat;
	rand ral_reg_IRQVector IRQVector;
	rand ral_reg_IRQVector0 IRQVector0;
	rand ral_reg_IRQVector1 IRQVector1;
	rand ral_reg_IRQVector10 IRQVector10;
	rand ral_reg_IRQVector11 IRQVector11;
	rand ral_reg_IRQVector12 IRQVector12;
	rand ral_reg_IRQVector13 IRQVector13;
	rand ral_reg_IRQVector14 IRQVector14;
	rand ral_reg_IRQVector15 IRQVector15;
	rand ral_reg_IRQVector2 IRQVector2;
	rand ral_reg_IRQVector3 IRQVector3;
	rand ral_reg_IRQVector4 IRQVector4;
	rand ral_reg_IRQVector5 IRQVector5;
	rand ral_reg_IRQVector6 IRQVector6;
	rand ral_reg_IRQVector7 IRQVector7;
	rand ral_reg_IRQVector8 IRQVector8;
	rand ral_reg_IRQVector9 IRQVector9;
	rand ral_reg_IRQ_P_N_offset0 IRQ_P_N_offset0;
	rand ral_reg_IRQ_P_N_offset1 IRQ_P_N_offset1;
	rand ral_reg_IRQ_P_N_offset10 IRQ_P_N_offset10;
	rand ral_reg_IRQ_P_N_offset11 IRQ_P_N_offset11;
	rand ral_reg_IRQ_P_N_offset2 IRQ_P_N_offset2;
	rand ral_reg_IRQ_P_N_offset3 IRQ_P_N_offset3;
	rand ral_reg_IRQ_P_N_offset4 IRQ_P_N_offset4;
	rand ral_reg_IRQ_P_N_offset5 IRQ_P_N_offset5;
	rand ral_reg_IRQ_P_N_offset6 IRQ_P_N_offset6;
	rand ral_reg_IRQ_P_N_offset7 IRQ_P_N_offset7;
	rand ral_reg_IRQ_P_N_offset8 IRQ_P_N_offset8;
	rand ral_reg_IRQ_P_N_offset9 IRQ_P_N_offset9;
	rand ral_reg_IRQ_inten IRQ_inten;
	rand vmm_ral_field FIQFinalStat_WDT_int_finalstat;
	rand vmm_ral_field WDT_int_finalstat;
	rand vmm_ral_field FIQRawStat_WDT_Int_source;
	rand vmm_ral_field WDT_Int_source;
	rand vmm_ral_field FIQStat_WDT_Int_status;
	rand vmm_ral_field WDT_Int_status;
	rand vmm_ral_field FIQ_inten_wdt_int_en;
	rand vmm_ral_field wdt_int_en;
	rand vmm_ral_field FIQ_intmask_wdt_int_mask;
	rand vmm_ral_field wdt_int_mask;
	rand vmm_ral_field FIQintforce_WDT_int_force;
	rand vmm_ral_field WDT_int_force;
	rand vmm_ral_field IRQFinalStat_sci_rx_int_finalstatus;
	rand vmm_ral_field sci_rx_int_finalstatus;
	rand vmm_ral_field IRQFinalStat_sci_tx_int_finalstatus;
	rand vmm_ral_field sci_tx_int_finalstatus;
	rand vmm_ral_field IRQFinalStat_gpio_int_finalstatus;
	rand vmm_ral_field gpio_int_finalstatus;
	rand vmm_ral_field IRQFinalStat_rf_int_finalstatus;
	rand vmm_ral_field rf_int_finalstatus;
	rand vmm_ral_field IRQFinalStat_timer0_int_finalstatus;
	rand vmm_ral_field timer0_int_finalstatus;
	rand vmm_ral_field IRQFinalStat_timer1_int_finalstatus;
	rand vmm_ral_field timer1_int_finalstatus;
	rand vmm_ral_field IRQFinalStat_timer2_int_finalstatus;
	rand vmm_ral_field timer2_int_finalstatus;
	rand vmm_ral_field IRQFinalStat_ee_int_finalstatus;
	rand vmm_ral_field ee_int_finalstatus;
	rand vmm_ral_field IRQFinalStat_rsa_int_finalstatus;
	rand vmm_ral_field rsa_int_finalstatus;
	rand vmm_ral_field IRQIntForce_sci_rx_int_force;
	rand vmm_ral_field sci_rx_int_force;
	rand vmm_ral_field IRQIntForce_sci_tx_int_force;
	rand vmm_ral_field sci_tx_int_force;
	rand vmm_ral_field IRQIntForce_gpio_int_force;
	rand vmm_ral_field gpio_int_force;
	rand vmm_ral_field IRQIntForce_rf_int_force;
	rand vmm_ral_field rf_int_force;
	rand vmm_ral_field IRQIntForce_timer0_int_force;
	rand vmm_ral_field timer0_int_force;
	rand vmm_ral_field IRQIntForce_timer1_int_force;
	rand vmm_ral_field timer1_int_force;
	rand vmm_ral_field IRQIntForce_timer2_int_force;
	rand vmm_ral_field timer2_int_force;
	rand vmm_ral_field IRQIntForce_ee_int_force;
	rand vmm_ral_field ee_int_force;
	rand vmm_ral_field IRQIntForce_rsa_int_force;
	rand vmm_ral_field rsa_int_force;
	rand vmm_ral_field IRQIntMsk_sci_rx_int_mask;
	rand vmm_ral_field sci_rx_int_mask;
	rand vmm_ral_field IRQIntMsk_sci_tx_int_mask;
	rand vmm_ral_field sci_tx_int_mask;
	rand vmm_ral_field IRQIntMsk_gpio_int_mask;
	rand vmm_ral_field gpio_int_mask;
	rand vmm_ral_field IRQIntMsk_rf_int_mask;
	rand vmm_ral_field rf_int_mask;
	rand vmm_ral_field IRQIntMsk_timer0_int_mask;
	rand vmm_ral_field timer0_int_mask;
	rand vmm_ral_field IRQIntMsk_timer1_int_mask;
	rand vmm_ral_field timer1_int_mask;
	rand vmm_ral_field IRQIntMsk_timer2_int_mask;
	rand vmm_ral_field timer2_int_mask;
	rand vmm_ral_field IRQIntMsk_ee_int_mask;
	rand vmm_ral_field ee_int_mask;
	rand vmm_ral_field IRQIntMsk_rsa_int_mask;
	rand vmm_ral_field rsa_int_mask;
	rand vmm_ral_field IRQMaskStat_sci_rx_int_maskstatus;
	rand vmm_ral_field sci_rx_int_maskstatus;
	rand vmm_ral_field IRQMaskStat_sci_tx_int_maskstatus;
	rand vmm_ral_field sci_tx_int_maskstatus;
	rand vmm_ral_field IRQMaskStat_gpio_int_maskstatus;
	rand vmm_ral_field gpio_int_maskstatus;
	rand vmm_ral_field IRQMaskStat_rf_int_maskstatus;
	rand vmm_ral_field rf_int_maskstatus;
	rand vmm_ral_field IRQMaskStat_timer0_int_maskstatus;
	rand vmm_ral_field timer0_int_maskstatus;
	rand vmm_ral_field IRQMaskStat_timer1_int_maskstatus;
	rand vmm_ral_field timer1_int_maskstatus;
	rand vmm_ral_field IRQMaskStat_timer2_int_maskstatus;
	rand vmm_ral_field timer2_int_maskstatus;
	rand vmm_ral_field IRQMaskStat_ee_int_maskstatus;
	rand vmm_ral_field ee_int_maskstatus;
	rand vmm_ral_field IRQMaskStat_rsa_int_maskstatus;
	rand vmm_ral_field rsa_int_maskstatus;
	rand vmm_ral_field IRQPLevel_IRQPLevel;
	rand vmm_ral_field IRQRawStat_sci_rx_int_source;
	rand vmm_ral_field sci_rx_int_source;
	rand vmm_ral_field IRQRawStat_sci_tx_int_source;
	rand vmm_ral_field sci_tx_int_source;
	rand vmm_ral_field IRQRawStat_gpio_int_source;
	rand vmm_ral_field gpio_int_source;
	rand vmm_ral_field IRQRawStat_rf_int_source;
	rand vmm_ral_field rf_int_source;
	rand vmm_ral_field IRQRawStat_timer0_int_source;
	rand vmm_ral_field timer0_int_source;
	rand vmm_ral_field IRQRawStat_timer1_int_source;
	rand vmm_ral_field timer1_int_source;
	rand vmm_ral_field IRQRawStat_timer2_int_source;
	rand vmm_ral_field timer2_int_source;
	rand vmm_ral_field IRQRawStat_ee_int_source;
	rand vmm_ral_field ee_int_source;
	rand vmm_ral_field IRQRawStat_rsa_int_source;
	rand vmm_ral_field rsa_int_source;
	rand vmm_ral_field IRQStat_sci_rx_int_status;
	rand vmm_ral_field sci_rx_int_status;
	rand vmm_ral_field IRQStat_sci_tx_int_status;
	rand vmm_ral_field sci_tx_int_status;
	rand vmm_ral_field IRQStat_gpio_int_status;
	rand vmm_ral_field gpio_int_status;
	rand vmm_ral_field IRQStat_rf_int_status;
	rand vmm_ral_field rf_int_status;
	rand vmm_ral_field IRQStat_timer0_int_status;
	rand vmm_ral_field timer0_int_status;
	rand vmm_ral_field IRQStat_timer1_int_status;
	rand vmm_ral_field timer1_int_status;
	rand vmm_ral_field IRQStat_timer2_int_status;
	rand vmm_ral_field timer2_int_status;
	rand vmm_ral_field IRQStat_ee_int_status;
	rand vmm_ral_field ee_int_status;
	rand vmm_ral_field IRQStat_rsa_int_status;
	rand vmm_ral_field rsa_int_status;
	rand vmm_ral_field IRQVector_IRQ_Vec_Current;
	rand vmm_ral_field IRQ_Vec_Current;
	rand vmm_ral_field IRQVector0_IRQ_Vec_0;
	rand vmm_ral_field IRQ_Vec_0;
	rand vmm_ral_field IRQVector1_IRQ_Vec_1;
	rand vmm_ral_field IRQ_Vec_1;
	rand vmm_ral_field IRQVector10_IRQ_Vec_10;
	rand vmm_ral_field IRQ_Vec_10;
	rand vmm_ral_field IRQVector11_IRQ_Vec_11;
	rand vmm_ral_field IRQ_Vec_11;
	rand vmm_ral_field IRQVector12_IRQ_Vec_12;
	rand vmm_ral_field IRQ_Vec_12;
	rand vmm_ral_field IRQVector13_IRQ_Vec_13;
	rand vmm_ral_field IRQ_Vec_13;
	rand vmm_ral_field IRQVector14_IRQ_Vec_14;
	rand vmm_ral_field IRQ_Vec_14;
	rand vmm_ral_field IRQVector15_IRQ_Vec_15;
	rand vmm_ral_field IRQ_Vec_15;
	rand vmm_ral_field IRQVector2_IRQ_Vec_2;
	rand vmm_ral_field IRQ_Vec_2;
	rand vmm_ral_field IRQVector3_IRQ_Vec_3;
	rand vmm_ral_field IRQ_Vec_3;
	rand vmm_ral_field IRQVector4_IRQ_Vec_4;
	rand vmm_ral_field IRQ_Vec_4;
	rand vmm_ral_field IRQVector5_IRQ_Vec_5;
	rand vmm_ral_field IRQ_Vec_5;
	rand vmm_ral_field IRQVector6_IRQ_Vec_6;
	rand vmm_ral_field IRQ_Vec_6;
	rand vmm_ral_field IRQVector7_IRQ_Vec_7;
	rand vmm_ral_field IRQ_Vec_7;
	rand vmm_ral_field IRQVector8_IRQ_Vec_8;
	rand vmm_ral_field IRQ_Vec_8;
	rand vmm_ral_field IRQVector9_IRQ_Vec_9;
	rand vmm_ral_field IRQ_Vec_9;
	rand vmm_ral_field IRQ_P_N_offset0_IRQ_Prio_0;
	rand vmm_ral_field IRQ_Prio_0;
	rand vmm_ral_field IRQ_P_N_offset1_IRQ_Prio_1;
	rand vmm_ral_field IRQ_Prio_1;
	rand vmm_ral_field IRQ_P_N_offset10_IRQ_Prio_10;
	rand vmm_ral_field IRQ_Prio_10;
	rand vmm_ral_field IRQ_P_N_offset11_IRQ_Prio_11;
	rand vmm_ral_field IRQ_Prio_11;
	rand vmm_ral_field IRQ_P_N_offset2_IRQ_Prio_2;
	rand vmm_ral_field IRQ_Prio_2;
	rand vmm_ral_field IRQ_P_N_offset3_IRQ_Prio_3;
	rand vmm_ral_field IRQ_Prio_3;
	rand vmm_ral_field IRQ_P_N_offset4_IRQ_Prio_4;
	rand vmm_ral_field IRQ_Prio_4;
	rand vmm_ral_field IRQ_P_N_offset5_IRQ_Prio_5;
	rand vmm_ral_field IRQ_Prio_5;
	rand vmm_ral_field IRQ_P_N_offset6_IRQ_Prio_6;
	rand vmm_ral_field IRQ_Prio_6;
	rand vmm_ral_field IRQ_P_N_offset7_IRQ_Prio_7;
	rand vmm_ral_field IRQ_Prio_7;
	rand vmm_ral_field IRQ_P_N_offset8_IRQ_Prio_8;
	rand vmm_ral_field IRQ_Prio_8;
	rand vmm_ral_field IRQ_P_N_offset9_IRQ_Prio_9;
	rand vmm_ral_field IRQ_Prio_9;
	rand vmm_ral_field IRQ_inten_sci_rx_int_en;
	rand vmm_ral_field sci_rx_int_en;
	rand vmm_ral_field IRQ_inten_sci_tx_int_en;
	rand vmm_ral_field sci_tx_int_en;
	rand vmm_ral_field IRQ_inten_gpio_int_en;
	rand vmm_ral_field gpio_int_en;
	rand vmm_ral_field IRQ_inten_rf_int_en;
	rand vmm_ral_field rf_int_en;
	rand vmm_ral_field IRQ_inten_timer0_int_en;
	rand vmm_ral_field timer0_int_en;
	rand vmm_ral_field IRQ_inten_timer1_int_en;
	rand vmm_ral_field timer1_int_en;
	rand vmm_ral_field IRQ_inten_timer2_int_en;
	rand vmm_ral_field timer2_int_en;
	rand vmm_ral_field IRQ_inten_ee_int_en;
	rand vmm_ral_field ee_int_en;
	rand vmm_ral_field IRQ_inten_rsa_int_en;
	rand vmm_ral_field rsa_int_en;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "ICTL", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "ICTL", 1024, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on);
		this.FIQFinalStat = new(this, "FIQFinalStat", `VMM_RAL_ADDR_WIDTH'hD4, "", cover_on, 2'b11, 0);
		this.FIQFinalStat_WDT_int_finalstat = this.FIQFinalStat.WDT_int_finalstat;
		this.WDT_int_finalstat = this.FIQFinalStat.WDT_int_finalstat;
		this.FIQRawStat = new(this, "FIQRawStat", `VMM_RAL_ADDR_WIDTH'hCC, "", cover_on, 2'b11, 0);
		this.FIQRawStat_WDT_Int_source = this.FIQRawStat.WDT_Int_source;
		this.WDT_Int_source = this.FIQRawStat.WDT_Int_source;
		this.FIQStat = new(this, "FIQStat", `VMM_RAL_ADDR_WIDTH'hD0, "", cover_on, 2'b11, 0);
		this.FIQStat_WDT_Int_status = this.FIQStat.WDT_Int_status;
		this.WDT_Int_status = this.FIQStat.WDT_Int_status;
		this.FIQ_inten = new(this, "FIQ_inten", `VMM_RAL_ADDR_WIDTH'hC0, "", cover_on, 2'b11, 0);
		this.FIQ_inten_wdt_int_en = this.FIQ_inten.wdt_int_en;
		this.wdt_int_en = this.FIQ_inten.wdt_int_en;
		this.FIQ_intmask = new(this, "FIQ_intmask", `VMM_RAL_ADDR_WIDTH'hC4, "", cover_on, 2'b11, 0);
		this.FIQ_intmask_wdt_int_mask = this.FIQ_intmask.wdt_int_mask;
		this.wdt_int_mask = this.FIQ_intmask.wdt_int_mask;
		this.FIQintforce = new(this, "FIQintforce", `VMM_RAL_ADDR_WIDTH'hC8, "", cover_on, 2'b11, 0);
		this.FIQintforce_WDT_int_force = this.FIQintforce.WDT_int_force;
		this.WDT_int_force = this.FIQintforce.WDT_int_force;
		this.IRQFinalStat = new(this, "IRQFinalStat", `VMM_RAL_ADDR_WIDTH'h30, "", cover_on, 2'b11, 0);
		this.IRQFinalStat_sci_rx_int_finalstatus = this.IRQFinalStat.sci_rx_int_finalstatus;
		this.sci_rx_int_finalstatus = this.IRQFinalStat.sci_rx_int_finalstatus;
		this.IRQFinalStat_sci_tx_int_finalstatus = this.IRQFinalStat.sci_tx_int_finalstatus;
		this.sci_tx_int_finalstatus = this.IRQFinalStat.sci_tx_int_finalstatus;
		this.IRQFinalStat_gpio_int_finalstatus = this.IRQFinalStat.gpio_int_finalstatus;
		this.gpio_int_finalstatus = this.IRQFinalStat.gpio_int_finalstatus;
		this.IRQFinalStat_rf_int_finalstatus = this.IRQFinalStat.rf_int_finalstatus;
		this.rf_int_finalstatus = this.IRQFinalStat.rf_int_finalstatus;
		this.IRQFinalStat_timer0_int_finalstatus = this.IRQFinalStat.timer0_int_finalstatus;
		this.timer0_int_finalstatus = this.IRQFinalStat.timer0_int_finalstatus;
		this.IRQFinalStat_timer1_int_finalstatus = this.IRQFinalStat.timer1_int_finalstatus;
		this.timer1_int_finalstatus = this.IRQFinalStat.timer1_int_finalstatus;
		this.IRQFinalStat_timer2_int_finalstatus = this.IRQFinalStat.timer2_int_finalstatus;
		this.timer2_int_finalstatus = this.IRQFinalStat.timer2_int_finalstatus;
		this.IRQFinalStat_ee_int_finalstatus = this.IRQFinalStat.ee_int_finalstatus;
		this.ee_int_finalstatus = this.IRQFinalStat.ee_int_finalstatus;
		this.IRQFinalStat_rsa_int_finalstatus = this.IRQFinalStat.rsa_int_finalstatus;
		this.rsa_int_finalstatus = this.IRQFinalStat.rsa_int_finalstatus;
		this.IRQIntForce = new(this, "IRQIntForce", `VMM_RAL_ADDR_WIDTH'h10, "", cover_on, 2'b11, 0);
		this.IRQIntForce_sci_rx_int_force = this.IRQIntForce.sci_rx_int_force;
		this.sci_rx_int_force = this.IRQIntForce.sci_rx_int_force;
		this.IRQIntForce_sci_tx_int_force = this.IRQIntForce.sci_tx_int_force;
		this.sci_tx_int_force = this.IRQIntForce.sci_tx_int_force;
		this.IRQIntForce_gpio_int_force = this.IRQIntForce.gpio_int_force;
		this.gpio_int_force = this.IRQIntForce.gpio_int_force;
		this.IRQIntForce_rf_int_force = this.IRQIntForce.rf_int_force;
		this.rf_int_force = this.IRQIntForce.rf_int_force;
		this.IRQIntForce_timer0_int_force = this.IRQIntForce.timer0_int_force;
		this.timer0_int_force = this.IRQIntForce.timer0_int_force;
		this.IRQIntForce_timer1_int_force = this.IRQIntForce.timer1_int_force;
		this.timer1_int_force = this.IRQIntForce.timer1_int_force;
		this.IRQIntForce_timer2_int_force = this.IRQIntForce.timer2_int_force;
		this.timer2_int_force = this.IRQIntForce.timer2_int_force;
		this.IRQIntForce_ee_int_force = this.IRQIntForce.ee_int_force;
		this.ee_int_force = this.IRQIntForce.ee_int_force;
		this.IRQIntForce_rsa_int_force = this.IRQIntForce.rsa_int_force;
		this.rsa_int_force = this.IRQIntForce.rsa_int_force;
		this.IRQIntMsk = new(this, "IRQIntMsk", `VMM_RAL_ADDR_WIDTH'h8, "", cover_on, 2'b11, 0);
		this.IRQIntMsk_sci_rx_int_mask = this.IRQIntMsk.sci_rx_int_mask;
		this.sci_rx_int_mask = this.IRQIntMsk.sci_rx_int_mask;
		this.IRQIntMsk_sci_tx_int_mask = this.IRQIntMsk.sci_tx_int_mask;
		this.sci_tx_int_mask = this.IRQIntMsk.sci_tx_int_mask;
		this.IRQIntMsk_gpio_int_mask = this.IRQIntMsk.gpio_int_mask;
		this.gpio_int_mask = this.IRQIntMsk.gpio_int_mask;
		this.IRQIntMsk_rf_int_mask = this.IRQIntMsk.rf_int_mask;
		this.rf_int_mask = this.IRQIntMsk.rf_int_mask;
		this.IRQIntMsk_timer0_int_mask = this.IRQIntMsk.timer0_int_mask;
		this.timer0_int_mask = this.IRQIntMsk.timer0_int_mask;
		this.IRQIntMsk_timer1_int_mask = this.IRQIntMsk.timer1_int_mask;
		this.timer1_int_mask = this.IRQIntMsk.timer1_int_mask;
		this.IRQIntMsk_timer2_int_mask = this.IRQIntMsk.timer2_int_mask;
		this.timer2_int_mask = this.IRQIntMsk.timer2_int_mask;
		this.IRQIntMsk_ee_int_mask = this.IRQIntMsk.ee_int_mask;
		this.ee_int_mask = this.IRQIntMsk.ee_int_mask;
		this.IRQIntMsk_rsa_int_mask = this.IRQIntMsk.rsa_int_mask;
		this.rsa_int_mask = this.IRQIntMsk.rsa_int_mask;
		this.IRQMaskStat = new(this, "IRQMaskStat", `VMM_RAL_ADDR_WIDTH'h28, "", cover_on, 2'b11, 0);
		this.IRQMaskStat_sci_rx_int_maskstatus = this.IRQMaskStat.sci_rx_int_maskstatus;
		this.sci_rx_int_maskstatus = this.IRQMaskStat.sci_rx_int_maskstatus;
		this.IRQMaskStat_sci_tx_int_maskstatus = this.IRQMaskStat.sci_tx_int_maskstatus;
		this.sci_tx_int_maskstatus = this.IRQMaskStat.sci_tx_int_maskstatus;
		this.IRQMaskStat_gpio_int_maskstatus = this.IRQMaskStat.gpio_int_maskstatus;
		this.gpio_int_maskstatus = this.IRQMaskStat.gpio_int_maskstatus;
		this.IRQMaskStat_rf_int_maskstatus = this.IRQMaskStat.rf_int_maskstatus;
		this.rf_int_maskstatus = this.IRQMaskStat.rf_int_maskstatus;
		this.IRQMaskStat_timer0_int_maskstatus = this.IRQMaskStat.timer0_int_maskstatus;
		this.timer0_int_maskstatus = this.IRQMaskStat.timer0_int_maskstatus;
		this.IRQMaskStat_timer1_int_maskstatus = this.IRQMaskStat.timer1_int_maskstatus;
		this.timer1_int_maskstatus = this.IRQMaskStat.timer1_int_maskstatus;
		this.IRQMaskStat_timer2_int_maskstatus = this.IRQMaskStat.timer2_int_maskstatus;
		this.timer2_int_maskstatus = this.IRQMaskStat.timer2_int_maskstatus;
		this.IRQMaskStat_ee_int_maskstatus = this.IRQMaskStat.ee_int_maskstatus;
		this.ee_int_maskstatus = this.IRQMaskStat.ee_int_maskstatus;
		this.IRQMaskStat_rsa_int_maskstatus = this.IRQMaskStat.rsa_int_maskstatus;
		this.rsa_int_maskstatus = this.IRQMaskStat.rsa_int_maskstatus;
		this.IRQPLevel = new(this, "IRQPLevel", `VMM_RAL_ADDR_WIDTH'hD8, "", cover_on, 2'b11, 0);
		this.IRQPLevel_IRQPLevel = this.IRQPLevel.IRQPLevel;
		this.IRQRawStat = new(this, "IRQRawStat", `VMM_RAL_ADDR_WIDTH'h18, "", cover_on, 2'b11, 0);
		this.IRQRawStat_sci_rx_int_source = this.IRQRawStat.sci_rx_int_source;
		this.sci_rx_int_source = this.IRQRawStat.sci_rx_int_source;
		this.IRQRawStat_sci_tx_int_source = this.IRQRawStat.sci_tx_int_source;
		this.sci_tx_int_source = this.IRQRawStat.sci_tx_int_source;
		this.IRQRawStat_gpio_int_source = this.IRQRawStat.gpio_int_source;
		this.gpio_int_source = this.IRQRawStat.gpio_int_source;
		this.IRQRawStat_rf_int_source = this.IRQRawStat.rf_int_source;
		this.rf_int_source = this.IRQRawStat.rf_int_source;
		this.IRQRawStat_timer0_int_source = this.IRQRawStat.timer0_int_source;
		this.timer0_int_source = this.IRQRawStat.timer0_int_source;
		this.IRQRawStat_timer1_int_source = this.IRQRawStat.timer1_int_source;
		this.timer1_int_source = this.IRQRawStat.timer1_int_source;
		this.IRQRawStat_timer2_int_source = this.IRQRawStat.timer2_int_source;
		this.timer2_int_source = this.IRQRawStat.timer2_int_source;
		this.IRQRawStat_ee_int_source = this.IRQRawStat.ee_int_source;
		this.ee_int_source = this.IRQRawStat.ee_int_source;
		this.IRQRawStat_rsa_int_source = this.IRQRawStat.rsa_int_source;
		this.rsa_int_source = this.IRQRawStat.rsa_int_source;
		this.IRQStat = new(this, "IRQStat", `VMM_RAL_ADDR_WIDTH'h20, "", cover_on, 2'b11, 0);
		this.IRQStat_sci_rx_int_status = this.IRQStat.sci_rx_int_status;
		this.sci_rx_int_status = this.IRQStat.sci_rx_int_status;
		this.IRQStat_sci_tx_int_status = this.IRQStat.sci_tx_int_status;
		this.sci_tx_int_status = this.IRQStat.sci_tx_int_status;
		this.IRQStat_gpio_int_status = this.IRQStat.gpio_int_status;
		this.gpio_int_status = this.IRQStat.gpio_int_status;
		this.IRQStat_rf_int_status = this.IRQStat.rf_int_status;
		this.rf_int_status = this.IRQStat.rf_int_status;
		this.IRQStat_timer0_int_status = this.IRQStat.timer0_int_status;
		this.timer0_int_status = this.IRQStat.timer0_int_status;
		this.IRQStat_timer1_int_status = this.IRQStat.timer1_int_status;
		this.timer1_int_status = this.IRQStat.timer1_int_status;
		this.IRQStat_timer2_int_status = this.IRQStat.timer2_int_status;
		this.timer2_int_status = this.IRQStat.timer2_int_status;
		this.IRQStat_ee_int_status = this.IRQStat.ee_int_status;
		this.ee_int_status = this.IRQStat.ee_int_status;
		this.IRQStat_rsa_int_status = this.IRQStat.rsa_int_status;
		this.rsa_int_status = this.IRQStat.rsa_int_status;
		this.IRQVector = new(this, "IRQVector", `VMM_RAL_ADDR_WIDTH'h38, "", cover_on, 2'b11, 0);
		this.IRQVector_IRQ_Vec_Current = this.IRQVector.IRQ_Vec_Current;
		this.IRQ_Vec_Current = this.IRQVector.IRQ_Vec_Current;
		this.IRQVector0 = new(this, "IRQVector0", `VMM_RAL_ADDR_WIDTH'h40, "", cover_on, 2'b11, 0);
		this.IRQVector0_IRQ_Vec_0 = this.IRQVector0.IRQ_Vec_0;
		this.IRQ_Vec_0 = this.IRQVector0.IRQ_Vec_0;
		this.IRQVector1 = new(this, "IRQVector1", `VMM_RAL_ADDR_WIDTH'h48, "", cover_on, 2'b11, 0);
		this.IRQVector1_IRQ_Vec_1 = this.IRQVector1.IRQ_Vec_1;
		this.IRQ_Vec_1 = this.IRQVector1.IRQ_Vec_1;
		this.IRQVector10 = new(this, "IRQVector10", `VMM_RAL_ADDR_WIDTH'h90, "", cover_on, 2'b11, 0);
		this.IRQVector10_IRQ_Vec_10 = this.IRQVector10.IRQ_Vec_10;
		this.IRQ_Vec_10 = this.IRQVector10.IRQ_Vec_10;
		this.IRQVector11 = new(this, "IRQVector11", `VMM_RAL_ADDR_WIDTH'h98, "", cover_on, 2'b11, 0);
		this.IRQVector11_IRQ_Vec_11 = this.IRQVector11.IRQ_Vec_11;
		this.IRQ_Vec_11 = this.IRQVector11.IRQ_Vec_11;
		this.IRQVector12 = new(this, "IRQVector12", `VMM_RAL_ADDR_WIDTH'hA0, "", cover_on, 2'b11, 0);
		this.IRQVector12_IRQ_Vec_12 = this.IRQVector12.IRQ_Vec_12;
		this.IRQ_Vec_12 = this.IRQVector12.IRQ_Vec_12;
		this.IRQVector13 = new(this, "IRQVector13", `VMM_RAL_ADDR_WIDTH'hA8, "", cover_on, 2'b11, 0);
		this.IRQVector13_IRQ_Vec_13 = this.IRQVector13.IRQ_Vec_13;
		this.IRQ_Vec_13 = this.IRQVector13.IRQ_Vec_13;
		this.IRQVector14 = new(this, "IRQVector14", `VMM_RAL_ADDR_WIDTH'hB0, "", cover_on, 2'b11, 0);
		this.IRQVector14_IRQ_Vec_14 = this.IRQVector14.IRQ_Vec_14;
		this.IRQ_Vec_14 = this.IRQVector14.IRQ_Vec_14;
		this.IRQVector15 = new(this, "IRQVector15", `VMM_RAL_ADDR_WIDTH'hB8, "", cover_on, 2'b11, 0);
		this.IRQVector15_IRQ_Vec_15 = this.IRQVector15.IRQ_Vec_15;
		this.IRQ_Vec_15 = this.IRQVector15.IRQ_Vec_15;
		this.IRQVector2 = new(this, "IRQVector2", `VMM_RAL_ADDR_WIDTH'h50, "", cover_on, 2'b11, 0);
		this.IRQVector2_IRQ_Vec_2 = this.IRQVector2.IRQ_Vec_2;
		this.IRQ_Vec_2 = this.IRQVector2.IRQ_Vec_2;
		this.IRQVector3 = new(this, "IRQVector3", `VMM_RAL_ADDR_WIDTH'h58, "", cover_on, 2'b11, 0);
		this.IRQVector3_IRQ_Vec_3 = this.IRQVector3.IRQ_Vec_3;
		this.IRQ_Vec_3 = this.IRQVector3.IRQ_Vec_3;
		this.IRQVector4 = new(this, "IRQVector4", `VMM_RAL_ADDR_WIDTH'h60, "", cover_on, 2'b11, 0);
		this.IRQVector4_IRQ_Vec_4 = this.IRQVector4.IRQ_Vec_4;
		this.IRQ_Vec_4 = this.IRQVector4.IRQ_Vec_4;
		this.IRQVector5 = new(this, "IRQVector5", `VMM_RAL_ADDR_WIDTH'h68, "", cover_on, 2'b11, 0);
		this.IRQVector5_IRQ_Vec_5 = this.IRQVector5.IRQ_Vec_5;
		this.IRQ_Vec_5 = this.IRQVector5.IRQ_Vec_5;
		this.IRQVector6 = new(this, "IRQVector6", `VMM_RAL_ADDR_WIDTH'h70, "", cover_on, 2'b11, 0);
		this.IRQVector6_IRQ_Vec_6 = this.IRQVector6.IRQ_Vec_6;
		this.IRQ_Vec_6 = this.IRQVector6.IRQ_Vec_6;
		this.IRQVector7 = new(this, "IRQVector7", `VMM_RAL_ADDR_WIDTH'h78, "", cover_on, 2'b11, 0);
		this.IRQVector7_IRQ_Vec_7 = this.IRQVector7.IRQ_Vec_7;
		this.IRQ_Vec_7 = this.IRQVector7.IRQ_Vec_7;
		this.IRQVector8 = new(this, "IRQVector8", `VMM_RAL_ADDR_WIDTH'h80, "", cover_on, 2'b11, 0);
		this.IRQVector8_IRQ_Vec_8 = this.IRQVector8.IRQ_Vec_8;
		this.IRQ_Vec_8 = this.IRQVector8.IRQ_Vec_8;
		this.IRQVector9 = new(this, "IRQVector9", `VMM_RAL_ADDR_WIDTH'h88, "", cover_on, 2'b11, 0);
		this.IRQVector9_IRQ_Vec_9 = this.IRQVector9.IRQ_Vec_9;
		this.IRQ_Vec_9 = this.IRQVector9.IRQ_Vec_9;
		this.IRQ_P_N_offset0 = new(this, "IRQ_P_N_offset0", `VMM_RAL_ADDR_WIDTH'hE8, "", cover_on, 2'b11, 0);
		this.IRQ_P_N_offset0_IRQ_Prio_0 = this.IRQ_P_N_offset0.IRQ_Prio_0;
		this.IRQ_Prio_0 = this.IRQ_P_N_offset0.IRQ_Prio_0;
		this.IRQ_P_N_offset1 = new(this, "IRQ_P_N_offset1", `VMM_RAL_ADDR_WIDTH'hEC, "", cover_on, 2'b11, 0);
		this.IRQ_P_N_offset1_IRQ_Prio_1 = this.IRQ_P_N_offset1.IRQ_Prio_1;
		this.IRQ_Prio_1 = this.IRQ_P_N_offset1.IRQ_Prio_1;
		this.IRQ_P_N_offset10 = new(this, "IRQ_P_N_offset10", `VMM_RAL_ADDR_WIDTH'h110, "", cover_on, 2'b11, 0);
		this.IRQ_P_N_offset10_IRQ_Prio_10 = this.IRQ_P_N_offset10.IRQ_Prio_10;
		this.IRQ_Prio_10 = this.IRQ_P_N_offset10.IRQ_Prio_10;
		this.IRQ_P_N_offset11 = new(this, "IRQ_P_N_offset11", `VMM_RAL_ADDR_WIDTH'h114, "", cover_on, 2'b11, 0);
		this.IRQ_P_N_offset11_IRQ_Prio_11 = this.IRQ_P_N_offset11.IRQ_Prio_11;
		this.IRQ_Prio_11 = this.IRQ_P_N_offset11.IRQ_Prio_11;
		this.IRQ_P_N_offset2 = new(this, "IRQ_P_N_offset2", `VMM_RAL_ADDR_WIDTH'hF0, "", cover_on, 2'b11, 0);
		this.IRQ_P_N_offset2_IRQ_Prio_2 = this.IRQ_P_N_offset2.IRQ_Prio_2;
		this.IRQ_Prio_2 = this.IRQ_P_N_offset2.IRQ_Prio_2;
		this.IRQ_P_N_offset3 = new(this, "IRQ_P_N_offset3", `VMM_RAL_ADDR_WIDTH'hF4, "", cover_on, 2'b11, 0);
		this.IRQ_P_N_offset3_IRQ_Prio_3 = this.IRQ_P_N_offset3.IRQ_Prio_3;
		this.IRQ_Prio_3 = this.IRQ_P_N_offset3.IRQ_Prio_3;
		this.IRQ_P_N_offset4 = new(this, "IRQ_P_N_offset4", `VMM_RAL_ADDR_WIDTH'hF8, "", cover_on, 2'b11, 0);
		this.IRQ_P_N_offset4_IRQ_Prio_4 = this.IRQ_P_N_offset4.IRQ_Prio_4;
		this.IRQ_Prio_4 = this.IRQ_P_N_offset4.IRQ_Prio_4;
		this.IRQ_P_N_offset5 = new(this, "IRQ_P_N_offset5", `VMM_RAL_ADDR_WIDTH'hFC, "", cover_on, 2'b11, 0);
		this.IRQ_P_N_offset5_IRQ_Prio_5 = this.IRQ_P_N_offset5.IRQ_Prio_5;
		this.IRQ_Prio_5 = this.IRQ_P_N_offset5.IRQ_Prio_5;
		this.IRQ_P_N_offset6 = new(this, "IRQ_P_N_offset6", `VMM_RAL_ADDR_WIDTH'h100, "", cover_on, 2'b11, 0);
		this.IRQ_P_N_offset6_IRQ_Prio_6 = this.IRQ_P_N_offset6.IRQ_Prio_6;
		this.IRQ_Prio_6 = this.IRQ_P_N_offset6.IRQ_Prio_6;
		this.IRQ_P_N_offset7 = new(this, "IRQ_P_N_offset7", `VMM_RAL_ADDR_WIDTH'h104, "", cover_on, 2'b11, 0);
		this.IRQ_P_N_offset7_IRQ_Prio_7 = this.IRQ_P_N_offset7.IRQ_Prio_7;
		this.IRQ_Prio_7 = this.IRQ_P_N_offset7.IRQ_Prio_7;
		this.IRQ_P_N_offset8 = new(this, "IRQ_P_N_offset8", `VMM_RAL_ADDR_WIDTH'h108, "", cover_on, 2'b11, 0);
		this.IRQ_P_N_offset8_IRQ_Prio_8 = this.IRQ_P_N_offset8.IRQ_Prio_8;
		this.IRQ_Prio_8 = this.IRQ_P_N_offset8.IRQ_Prio_8;
		this.IRQ_P_N_offset9 = new(this, "IRQ_P_N_offset9", `VMM_RAL_ADDR_WIDTH'h10C, "", cover_on, 2'b11, 0);
		this.IRQ_P_N_offset9_IRQ_Prio_9 = this.IRQ_P_N_offset9.IRQ_Prio_9;
		this.IRQ_Prio_9 = this.IRQ_P_N_offset9.IRQ_Prio_9;
		this.IRQ_inten = new(this, "IRQ_inten", `VMM_RAL_ADDR_WIDTH'h0, "", cover_on, 2'b11, 0);
		this.IRQ_inten_sci_rx_int_en = this.IRQ_inten.sci_rx_int_en;
		this.sci_rx_int_en = this.IRQ_inten.sci_rx_int_en;
		this.IRQ_inten_sci_tx_int_en = this.IRQ_inten.sci_tx_int_en;
		this.sci_tx_int_en = this.IRQ_inten.sci_tx_int_en;
		this.IRQ_inten_gpio_int_en = this.IRQ_inten.gpio_int_en;
		this.gpio_int_en = this.IRQ_inten.gpio_int_en;
		this.IRQ_inten_rf_int_en = this.IRQ_inten.rf_int_en;
		this.rf_int_en = this.IRQ_inten.rf_int_en;
		this.IRQ_inten_timer0_int_en = this.IRQ_inten.timer0_int_en;
		this.timer0_int_en = this.IRQ_inten.timer0_int_en;
		this.IRQ_inten_timer1_int_en = this.IRQ_inten.timer1_int_en;
		this.timer1_int_en = this.IRQ_inten.timer1_int_en;
		this.IRQ_inten_timer2_int_en = this.IRQ_inten.timer2_int_en;
		this.timer2_int_en = this.IRQ_inten.timer2_int_en;
		this.IRQ_inten_ee_int_en = this.IRQ_inten.ee_int_en;
		this.ee_int_en = this.IRQ_inten.ee_int_en;
		this.IRQ_inten_rsa_int_en = this.IRQ_inten.rsa_int_en;
		this.rsa_int_en = this.IRQ_inten.rsa_int_en;
		this.Xlock_modelX();
	endfunction : new
endclass : ral_block_ICTL


class ral_reg_GPIOCtrl extends vmm_ral_reg;
	rand vmm_ral_field GPIOAFSEL;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.GPIOAFSEL = new(this, "GPIOAFSEL", 1, vmm_ral::RW, 'h1, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_GPIOCtrl


class ral_reg_GPIODATA extends vmm_ral_reg;
	rand vmm_ral_field GPIODATA;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.GPIODATA = new(this, "GPIODATA", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_GPIODATA


class ral_reg_GPIODIR extends vmm_ral_reg;
	rand vmm_ral_field GPIODIR;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.GPIODIR = new(this, "GPIODIR", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_GPIODIR


class ral_reg_GPIOEXTDATA extends vmm_ral_reg;
	rand vmm_ral_field GPIOEXTDATA;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.GPIOEXTDATA = new(this, "GPIOEXTDATA", 1, vmm_ral::RO, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_GPIOEXTDATA


class ral_reg_GPIOIC extends vmm_ral_reg;
	rand vmm_ral_field GPIOIC;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.GPIOIC = new(this, "GPIOIC", 1, vmm_ral::W1C, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_GPIOIC


class ral_reg_GPIOIEV extends vmm_ral_reg;
	rand vmm_ral_field GPIOIEV;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.GPIOIEV = new(this, "GPIOIEV", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_GPIOIEV


class ral_reg_GPIOIS extends vmm_ral_reg;
	rand vmm_ral_field GPIOIS;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.GPIOIS = new(this, "GPIOIS", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_GPIOIS


class ral_reg_GPIOIntEn extends vmm_ral_reg;
	rand vmm_ral_field GPIOIntEn;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.GPIOIntEn = new(this, "GPIOIntEn", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_GPIOIntEn


class ral_reg_GPIOMIS extends vmm_ral_reg;
	rand vmm_ral_field GPIOMIS;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.GPIOMIS = new(this, "GPIOMIS", 1, vmm_ral::RO, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_GPIOMIS


class ral_reg_GPIOMask extends vmm_ral_reg;
	rand vmm_ral_field GPIOMask;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.GPIOMask = new(this, "GPIOMask", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_GPIOMask


class ral_reg_GPIORIS extends vmm_ral_reg;
	rand vmm_ral_field GPIORIS;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.GPIORIS = new(this, "GPIORIS", 1, vmm_ral::RO, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_GPIORIS


class ral_block_GPIO extends vmm_ral_block;
	rand ral_reg_GPIOCtrl GPIOCtrl;
	rand ral_reg_GPIODATA GPIODATA;
	rand ral_reg_GPIODIR GPIODIR;
	rand ral_reg_GPIOEXTDATA GPIOEXTDATA;
	rand ral_reg_GPIOIC GPIOIC;
	rand ral_reg_GPIOIEV GPIOIEV;
	rand ral_reg_GPIOIS GPIOIS;
	rand ral_reg_GPIOIntEn GPIOIntEn;
	rand ral_reg_GPIOMIS GPIOMIS;
	rand ral_reg_GPIOMask GPIOMask;
	rand ral_reg_GPIORIS GPIORIS;
	rand vmm_ral_field GPIOCtrl_GPIOAFSEL;
	rand vmm_ral_field GPIOAFSEL;
	rand vmm_ral_field GPIODATA_GPIODATA;
	rand vmm_ral_field GPIODIR_GPIODIR;
	rand vmm_ral_field GPIOEXTDATA_GPIOEXTDATA;
	rand vmm_ral_field GPIOIC_GPIOIC;
	rand vmm_ral_field GPIOIEV_GPIOIEV;
	rand vmm_ral_field GPIOIS_GPIOIS;
	rand vmm_ral_field GPIOIntEn_GPIOIntEn;
	rand vmm_ral_field GPIOMIS_GPIOMIS;
	rand vmm_ral_field GPIOMask_GPIOMask;
	rand vmm_ral_field GPIORIS_GPIORIS;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "GPIO", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "GPIO", 128, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on);
		this.GPIOCtrl = new(this, "GPIOCtrl", `VMM_RAL_ADDR_WIDTH'h8, "", cover_on, 2'b11, 0);
		this.GPIOCtrl_GPIOAFSEL = this.GPIOCtrl.GPIOAFSEL;
		this.GPIOAFSEL = this.GPIOCtrl.GPIOAFSEL;
		this.GPIODATA = new(this, "GPIODATA", `VMM_RAL_ADDR_WIDTH'h0, "", cover_on, 2'b11, 0);
		this.GPIODATA_GPIODATA = this.GPIODATA.GPIODATA;
		this.GPIODIR = new(this, "GPIODIR", `VMM_RAL_ADDR_WIDTH'h4, "", cover_on, 2'b11, 0);
		this.GPIODIR_GPIODIR = this.GPIODIR.GPIODIR;
		this.GPIOEXTDATA = new(this, "GPIOEXTDATA", `VMM_RAL_ADDR_WIDTH'h50, "", cover_on, 2'b11, 0);
		this.GPIOEXTDATA_GPIOEXTDATA = this.GPIOEXTDATA.GPIOEXTDATA;
		this.GPIOIC = new(this, "GPIOIC", `VMM_RAL_ADDR_WIDTH'h4C, "", cover_on, 2'b11, 0);
		this.GPIOIC_GPIOIC = this.GPIOIC.GPIOIC;
		this.GPIOIEV = new(this, "GPIOIEV", `VMM_RAL_ADDR_WIDTH'h3C, "", cover_on, 2'b11, 0);
		this.GPIOIEV_GPIOIEV = this.GPIOIEV.GPIOIEV;
		this.GPIOIS = new(this, "GPIOIS", `VMM_RAL_ADDR_WIDTH'h38, "", cover_on, 2'b11, 0);
		this.GPIOIS_GPIOIS = this.GPIOIS.GPIOIS;
		this.GPIOIntEn = new(this, "GPIOIntEn", `VMM_RAL_ADDR_WIDTH'h30, "", cover_on, 2'b11, 0);
		this.GPIOIntEn_GPIOIntEn = this.GPIOIntEn.GPIOIntEn;
		this.GPIOMIS = new(this, "GPIOMIS", `VMM_RAL_ADDR_WIDTH'h40, "", cover_on, 2'b11, 0);
		this.GPIOMIS_GPIOMIS = this.GPIOMIS.GPIOMIS;
		this.GPIOMask = new(this, "GPIOMask", `VMM_RAL_ADDR_WIDTH'h34, "", cover_on, 2'b11, 0);
		this.GPIOMask_GPIOMask = this.GPIOMask.GPIOMask;
		this.GPIORIS = new(this, "GPIORIS", `VMM_RAL_ADDR_WIDTH'h44, "", cover_on, 2'b11, 0);
		this.GPIORIS_GPIORIS = this.GPIORIS.GPIORIS;
		this.Xlock_modelX();
	endfunction : new
endclass : ral_block_GPIO


class ral_reg_RNGCtrlReg extends vmm_ral_reg;
	rand vmm_ral_field rngcir_en;
	rand vmm_ral_field trng_run;
	rand vmm_ral_field prng_run;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.rngcir_en = new(this, "rngcir_en", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.trng_run = new(this, "trng_run", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
		this.prng_run = new(this, "prng_run", 1, vmm_ral::RW, 'h0, 1'hx, 2, 0, cvr);
	endfunction: new
endclass : ral_reg_RNGCtrlReg


class ral_reg_RNGDataReg0 extends vmm_ral_reg;
	rand vmm_ral_field RNGDataReg0;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.RNGDataReg0 = new(this, "RNGDataReg0", 32, vmm_ral::RO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_RNGDataReg0


class ral_reg_RNGDataReg1 extends vmm_ral_reg;
	rand vmm_ral_field RNGDataReg1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.RNGDataReg1 = new(this, "RNGDataReg1", 32, vmm_ral::RO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_RNGDataReg1


class ral_reg_RNGModeReg extends vmm_ral_reg;
	rand vmm_ral_field trng_load;
	rand vmm_ral_field trng_fdbk;
	rand vmm_ral_field trng_cnt;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.trng_load = new(this, "trng_load", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.trng_fdbk = new(this, "trng_fdbk", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
		this.trng_cnt = new(this, "trng_cnt", 3, vmm_ral::RW, 'h4, 3'hx, 2, 0, cvr);
	endfunction: new
endclass : ral_reg_RNGModeReg


class ral_reg_rngseqreg extends vmm_ral_reg;
	rand vmm_ral_field prng_cap;
	rand vmm_ral_field prng_data;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.prng_cap = new(this, "prng_cap", 1, vmm_ral::WO, 'h0, 1'hx, 0, 0, cvr);
		this.prng_data = new(this, "prng_data", 16, vmm_ral::RO, 'h0, 16'hx, 8, 0, cvr);
	endfunction: new
endclass : ral_reg_rngseqreg


class ral_block_RNG extends vmm_ral_block;
	rand ral_reg_RNGCtrlReg RNGCtrlReg;
	rand ral_reg_RNGDataReg0 RNGDataReg0;
	rand ral_reg_RNGDataReg1 RNGDataReg1;
	rand ral_reg_RNGModeReg RNGModeReg;
	rand ral_reg_rngseqreg rngseqreg;
	rand vmm_ral_field RNGCtrlReg_rngcir_en;
	rand vmm_ral_field rngcir_en;
	rand vmm_ral_field RNGCtrlReg_trng_run;
	rand vmm_ral_field trng_run;
	rand vmm_ral_field RNGCtrlReg_prng_run;
	rand vmm_ral_field prng_run;
	rand vmm_ral_field RNGDataReg0_RNGDataReg0;
	rand vmm_ral_field RNGDataReg1_RNGDataReg1;
	rand vmm_ral_field RNGModeReg_trng_load;
	rand vmm_ral_field trng_load;
	rand vmm_ral_field RNGModeReg_trng_fdbk;
	rand vmm_ral_field trng_fdbk;
	rand vmm_ral_field RNGModeReg_trng_cnt;
	rand vmm_ral_field trng_cnt;
	rand vmm_ral_field rngseqreg_prng_cap;
	rand vmm_ral_field prng_cap;
	rand vmm_ral_field rngseqreg_prng_data;
	rand vmm_ral_field prng_data;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "RNG", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "RNG", 32, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on);
		this.RNGCtrlReg = new(this, "RNGCtrlReg", `VMM_RAL_ADDR_WIDTH'h0, "", cover_on, 2'b11, 0);
		this.RNGCtrlReg_rngcir_en = this.RNGCtrlReg.rngcir_en;
		this.rngcir_en = this.RNGCtrlReg.rngcir_en;
		this.RNGCtrlReg_trng_run = this.RNGCtrlReg.trng_run;
		this.trng_run = this.RNGCtrlReg.trng_run;
		this.RNGCtrlReg_prng_run = this.RNGCtrlReg.prng_run;
		this.prng_run = this.RNGCtrlReg.prng_run;
		this.RNGDataReg0 = new(this, "RNGDataReg0", `VMM_RAL_ADDR_WIDTH'hC, "", cover_on, 2'b11, 0);
		this.RNGDataReg0_RNGDataReg0 = this.RNGDataReg0.RNGDataReg0;
		this.RNGDataReg1 = new(this, "RNGDataReg1", `VMM_RAL_ADDR_WIDTH'h10, "", cover_on, 2'b11, 0);
		this.RNGDataReg1_RNGDataReg1 = this.RNGDataReg1.RNGDataReg1;
		this.RNGModeReg = new(this, "RNGModeReg", `VMM_RAL_ADDR_WIDTH'h4, "", cover_on, 2'b11, 0);
		this.RNGModeReg_trng_load = this.RNGModeReg.trng_load;
		this.trng_load = this.RNGModeReg.trng_load;
		this.RNGModeReg_trng_fdbk = this.RNGModeReg.trng_fdbk;
		this.trng_fdbk = this.RNGModeReg.trng_fdbk;
		this.RNGModeReg_trng_cnt = this.RNGModeReg.trng_cnt;
		this.trng_cnt = this.RNGModeReg.trng_cnt;
		this.rngseqreg = new(this, "rngseqreg", `VMM_RAL_ADDR_WIDTH'h8, "", cover_on, 2'b11, 0);
		this.rngseqreg_prng_cap = this.rngseqreg.prng_cap;
		this.prng_cap = this.rngseqreg.prng_cap;
		this.rngseqreg_prng_data = this.rngseqreg.prng_data;
		this.prng_data = this.rngseqreg.prng_data;
		this.Xlock_modelX();
	endfunction : new
endclass : ral_block_RNG


class ral_reg_Timer1Ctrl extends vmm_ral_reg;
	rand vmm_ral_field Time1_en;
	rand vmm_ral_field Timer1_mode;
	rand vmm_ral_field Timer_mask;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Time1_en = new(this, "Time1_en", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.Timer1_mode = new(this, "Timer1_mode", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
		this.Timer_mask = new(this, "Timer_mask", 1, vmm_ral::RW, 'h0, 1'hx, 2, 0, cvr);
	endfunction: new
endclass : ral_reg_Timer1Ctrl


class ral_reg_Timer1CurValue extends vmm_ral_reg;
	rand vmm_ral_field Timer1CurValue;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Timer1CurValue = new(this, "Timer1CurValue", 20, vmm_ral::RO, 'h0, 20'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_Timer1CurValue


class ral_reg_Timer1LoadCount extends vmm_ral_reg;
	rand vmm_ral_field Timer1LoadCount;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Timer1LoadCount = new(this, "Timer1LoadCount", 20, vmm_ral::RW, 'h0, 20'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_Timer1LoadCount


class ral_reg_Timer1_EOI extends vmm_ral_reg;
	rand vmm_ral_field Timer1_EOI;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Timer1_EOI = new(this, "Timer1_EOI", 1, vmm_ral::RC, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_Timer1_EOI


class ral_reg_Timer1_intStat extends vmm_ral_reg;
	rand vmm_ral_field Timer1_intStat;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Timer1_intStat = new(this, "Timer1_intStat", 1, vmm_ral::RO, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_Timer1_intStat


class ral_reg_Timer2Ctrl extends vmm_ral_reg;
	rand vmm_ral_field Time2_en;
	rand vmm_ral_field Timer2_mode;
	rand vmm_ral_field Timer2mask;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Time2_en = new(this, "Time2_en", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.Timer2_mode = new(this, "Timer2_mode", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
		this.Timer2mask = new(this, "Timer2mask", 1, vmm_ral::RW, 'h0, 1'hx, 2, 0, cvr);
	endfunction: new
endclass : ral_reg_Timer2Ctrl


class ral_reg_Timer2CurValue extends vmm_ral_reg;
	rand vmm_ral_field Timer2CurValue;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Timer2CurValue = new(this, "Timer2CurValue", 16, vmm_ral::RO, 'h0, 16'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_Timer2CurValue


class ral_reg_Timer2LoadCount extends vmm_ral_reg;
	rand vmm_ral_field Timer2LoadCount;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Timer2LoadCount = new(this, "Timer2LoadCount", 16, vmm_ral::RW, 'h0, 16'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_Timer2LoadCount


class ral_reg_Timer2_EOI extends vmm_ral_reg;
	rand vmm_ral_field Timer2_EOI;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Timer2_EOI = new(this, "Timer2_EOI", 1, vmm_ral::RC, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_Timer2_EOI


class ral_reg_Timer2_intStat extends vmm_ral_reg;
	rand vmm_ral_field Timer2_intStat;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Timer2_intStat = new(this, "Timer2_intStat", 1, vmm_ral::RO, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_Timer2_intStat


class ral_reg_Timer3Ctrl extends vmm_ral_reg;
	rand vmm_ral_field Time3_en;
	rand vmm_ral_field Timer3_mode;
	rand vmm_ral_field Timer3mask;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Time3_en = new(this, "Time3_en", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.Timer3_mode = new(this, "Timer3_mode", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
		this.Timer3mask = new(this, "Timer3mask", 1, vmm_ral::RW, 'h0, 1'hx, 2, 0, cvr);
	endfunction: new
endclass : ral_reg_Timer3Ctrl


class ral_reg_Timer3CurValue extends vmm_ral_reg;
	rand vmm_ral_field Timer3CurValue;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Timer3CurValue = new(this, "Timer3CurValue", 16, vmm_ral::RO, 'h0, 16'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_Timer3CurValue


class ral_reg_Timer3LoadCount extends vmm_ral_reg;
	rand vmm_ral_field Timer3LoadCount;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Timer3LoadCount = new(this, "Timer3LoadCount", 16, vmm_ral::RW, 'h0, 16'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_Timer3LoadCount


class ral_reg_Timer3_EOI extends vmm_ral_reg;
	rand vmm_ral_field Timer3_EOI;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Timer3_EOI = new(this, "Timer3_EOI", 1, vmm_ral::RC, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_Timer3_EOI


class ral_reg_Timer3_intStat extends vmm_ral_reg;
	rand vmm_ral_field Timer3_intStat;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Timer3_intStat = new(this, "Timer3_intStat", 1, vmm_ral::RO, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_Timer3_intStat


class ral_reg_Timers_EOI extends vmm_ral_reg;
	rand vmm_ral_field Timer1_EOI;
	rand vmm_ral_field Timer2_EOI;
	rand vmm_ral_field Timer3_EOI;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Timer1_EOI = new(this, "Timer1_EOI", 1, vmm_ral::RC, 'h0, 1'hx, 0, 0, cvr);
		this.Timer2_EOI = new(this, "Timer2_EOI", 1, vmm_ral::RC, 'h0, 1'hx, 1, 0, cvr);
		this.Timer3_EOI = new(this, "Timer3_EOI", 1, vmm_ral::RC, 'h0, 1'hx, 2, 0, cvr);
	endfunction: new
endclass : ral_reg_Timers_EOI


class ral_reg_Timers_intStat extends vmm_ral_reg;
	rand vmm_ral_field Timer1_rawintStat;
	rand vmm_ral_field Timer2_rawintStat;
	rand vmm_ral_field Timer3_rawintStat;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Timer1_rawintStat = new(this, "Timer1_rawintStat", 1, vmm_ral::RO, 'h0, 1'hx, 0, 0, cvr);
		this.Timer2_rawintStat = new(this, "Timer2_rawintStat", 1, vmm_ral::RO, 'h0, 1'hx, 1, 0, cvr);
		this.Timer3_rawintStat = new(this, "Timer3_rawintStat", 1, vmm_ral::RO, 'h0, 1'hx, 2, 0, cvr);
	endfunction: new
endclass : ral_reg_Timers_intStat


class ral_reg_Timers_int_status extends vmm_ral_reg;
	rand vmm_ral_field Time1_int_status;
	rand vmm_ral_field Time2_int_status;
	rand vmm_ral_field Time3_int_status;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Time1_int_status = new(this, "Time1_int_status", 1, vmm_ral::RO, 'h0, 1'hx, 0, 0, cvr);
		this.Time2_int_status = new(this, "Time2_int_status", 1, vmm_ral::RO, 'h0, 1'hx, 1, 0, cvr);
		this.Time3_int_status = new(this, "Time3_int_status", 1, vmm_ral::RO, 'h0, 1'hx, 2, 0, cvr);
	endfunction: new
endclass : ral_reg_Timers_int_status


class ral_block_TIMER extends vmm_ral_block;
	rand ral_reg_Timer1Ctrl Timer1Ctrl;
	rand ral_reg_Timer1CurValue Timer1CurValue;
	rand ral_reg_Timer1LoadCount Timer1LoadCount;
	rand ral_reg_Timer1_EOI Timer1_EOI;
	rand ral_reg_Timer1_intStat Timer1_intStat;
	rand ral_reg_Timer2Ctrl Timer2Ctrl;
	rand ral_reg_Timer2CurValue Timer2CurValue;
	rand ral_reg_Timer2LoadCount Timer2LoadCount;
	rand ral_reg_Timer2_EOI Timer2_EOI;
	rand ral_reg_Timer2_intStat Timer2_intStat;
	rand ral_reg_Timer3Ctrl Timer3Ctrl;
	rand ral_reg_Timer3CurValue Timer3CurValue;
	rand ral_reg_Timer3LoadCount Timer3LoadCount;
	rand ral_reg_Timer3_EOI Timer3_EOI;
	rand ral_reg_Timer3_intStat Timer3_intStat;
	rand ral_reg_Timers_EOI Timers_EOI;
	rand ral_reg_Timers_intStat Timers_intStat;
	rand ral_reg_Timers_int_status Timers_int_status;
	rand vmm_ral_field Timer1Ctrl_Time1_en;
	rand vmm_ral_field Time1_en;
	rand vmm_ral_field Timer1Ctrl_Timer1_mode;
	rand vmm_ral_field Timer1_mode;
	rand vmm_ral_field Timer1Ctrl_Timer_mask;
	rand vmm_ral_field Timer_mask;
	rand vmm_ral_field Timer1CurValue_Timer1CurValue;
	rand vmm_ral_field Timer1LoadCount_Timer1LoadCount;
	rand vmm_ral_field Timer1_EOI_Timer1_EOI;
	rand vmm_ral_field Timer1_intStat_Timer1_intStat;
	rand vmm_ral_field Timer2Ctrl_Time2_en;
	rand vmm_ral_field Time2_en;
	rand vmm_ral_field Timer2Ctrl_Timer2_mode;
	rand vmm_ral_field Timer2_mode;
	rand vmm_ral_field Timer2Ctrl_Timer2mask;
	rand vmm_ral_field Timer2mask;
	rand vmm_ral_field Timer2CurValue_Timer2CurValue;
	rand vmm_ral_field Timer2LoadCount_Timer2LoadCount;
	rand vmm_ral_field Timer2_EOI_Timer2_EOI;
	rand vmm_ral_field Timer2_intStat_Timer2_intStat;
	rand vmm_ral_field Timer3Ctrl_Time3_en;
	rand vmm_ral_field Time3_en;
	rand vmm_ral_field Timer3Ctrl_Timer3_mode;
	rand vmm_ral_field Timer3_mode;
	rand vmm_ral_field Timer3Ctrl_Timer3mask;
	rand vmm_ral_field Timer3mask;
	rand vmm_ral_field Timer3CurValue_Timer3CurValue;
	rand vmm_ral_field Timer3LoadCount_Timer3LoadCount;
	rand vmm_ral_field Timer3_EOI_Timer3_EOI;
	rand vmm_ral_field Timer3_intStat_Timer3_intStat;
	rand vmm_ral_field Timers_EOI_Timer1_EOI;
	rand vmm_ral_field Timers_EOI_Timer2_EOI;
	rand vmm_ral_field Timers_EOI_Timer3_EOI;
	rand vmm_ral_field Timers_intStat_Timer1_rawintStat;
	rand vmm_ral_field Timer1_rawintStat;
	rand vmm_ral_field Timers_intStat_Timer2_rawintStat;
	rand vmm_ral_field Timer2_rawintStat;
	rand vmm_ral_field Timers_intStat_Timer3_rawintStat;
	rand vmm_ral_field Timer3_rawintStat;
	rand vmm_ral_field Timers_int_status_Time1_int_status;
	rand vmm_ral_field Time1_int_status;
	rand vmm_ral_field Timers_int_status_Time2_int_status;
	rand vmm_ral_field Time2_int_status;
	rand vmm_ral_field Timers_int_status_Time3_int_status;
	rand vmm_ral_field Time3_int_status;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "TIMER", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "TIMER", 512, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on);
		this.Timer1Ctrl = new(this, "Timer1Ctrl", `VMM_RAL_ADDR_WIDTH'h8, "", cover_on, 2'b11, 0);
		this.Timer1Ctrl_Time1_en = this.Timer1Ctrl.Time1_en;
		this.Time1_en = this.Timer1Ctrl.Time1_en;
		this.Timer1Ctrl_Timer1_mode = this.Timer1Ctrl.Timer1_mode;
		this.Timer1_mode = this.Timer1Ctrl.Timer1_mode;
		this.Timer1Ctrl_Timer_mask = this.Timer1Ctrl.Timer_mask;
		this.Timer_mask = this.Timer1Ctrl.Timer_mask;
		this.Timer1CurValue = new(this, "Timer1CurValue", `VMM_RAL_ADDR_WIDTH'h4, "", cover_on, 2'b11, 0);
		this.Timer1CurValue_Timer1CurValue = this.Timer1CurValue.Timer1CurValue;
		this.Timer1LoadCount = new(this, "Timer1LoadCount", `VMM_RAL_ADDR_WIDTH'h0, "", cover_on, 2'b11, 0);
		this.Timer1LoadCount_Timer1LoadCount = this.Timer1LoadCount.Timer1LoadCount;
		this.Timer1_EOI = new(this, "Timer1_EOI", `VMM_RAL_ADDR_WIDTH'hC, "", cover_on, 2'b11, 0);
		this.Timer1_EOI_Timer1_EOI = this.Timer1_EOI.Timer1_EOI;
		this.Timer1_intStat = new(this, "Timer1_intStat", `VMM_RAL_ADDR_WIDTH'h10, "", cover_on, 2'b11, 0);
		this.Timer1_intStat_Timer1_intStat = this.Timer1_intStat.Timer1_intStat;
		this.Timer2Ctrl = new(this, "Timer2Ctrl", `VMM_RAL_ADDR_WIDTH'h1C, "", cover_on, 2'b11, 0);
		this.Timer2Ctrl_Time2_en = this.Timer2Ctrl.Time2_en;
		this.Time2_en = this.Timer2Ctrl.Time2_en;
		this.Timer2Ctrl_Timer2_mode = this.Timer2Ctrl.Timer2_mode;
		this.Timer2_mode = this.Timer2Ctrl.Timer2_mode;
		this.Timer2Ctrl_Timer2mask = this.Timer2Ctrl.Timer2mask;
		this.Timer2mask = this.Timer2Ctrl.Timer2mask;
		this.Timer2CurValue = new(this, "Timer2CurValue", `VMM_RAL_ADDR_WIDTH'h18, "", cover_on, 2'b11, 0);
		this.Timer2CurValue_Timer2CurValue = this.Timer2CurValue.Timer2CurValue;
		this.Timer2LoadCount = new(this, "Timer2LoadCount", `VMM_RAL_ADDR_WIDTH'h14, "", cover_on, 2'b11, 0);
		this.Timer2LoadCount_Timer2LoadCount = this.Timer2LoadCount.Timer2LoadCount;
		this.Timer2_EOI = new(this, "Timer2_EOI", `VMM_RAL_ADDR_WIDTH'h20, "", cover_on, 2'b11, 0);
		this.Timer2_EOI_Timer2_EOI = this.Timer2_EOI.Timer2_EOI;
		this.Timer2_intStat = new(this, "Timer2_intStat", `VMM_RAL_ADDR_WIDTH'h24, "", cover_on, 2'b11, 0);
		this.Timer2_intStat_Timer2_intStat = this.Timer2_intStat.Timer2_intStat;
		this.Timer3Ctrl = new(this, "Timer3Ctrl", `VMM_RAL_ADDR_WIDTH'h30, "", cover_on, 2'b11, 0);
		this.Timer3Ctrl_Time3_en = this.Timer3Ctrl.Time3_en;
		this.Time3_en = this.Timer3Ctrl.Time3_en;
		this.Timer3Ctrl_Timer3_mode = this.Timer3Ctrl.Timer3_mode;
		this.Timer3_mode = this.Timer3Ctrl.Timer3_mode;
		this.Timer3Ctrl_Timer3mask = this.Timer3Ctrl.Timer3mask;
		this.Timer3mask = this.Timer3Ctrl.Timer3mask;
		this.Timer3CurValue = new(this, "Timer3CurValue", `VMM_RAL_ADDR_WIDTH'h2C, "", cover_on, 2'b11, 0);
		this.Timer3CurValue_Timer3CurValue = this.Timer3CurValue.Timer3CurValue;
		this.Timer3LoadCount = new(this, "Timer3LoadCount", `VMM_RAL_ADDR_WIDTH'h28, "", cover_on, 2'b11, 0);
		this.Timer3LoadCount_Timer3LoadCount = this.Timer3LoadCount.Timer3LoadCount;
		this.Timer3_EOI = new(this, "Timer3_EOI", `VMM_RAL_ADDR_WIDTH'h34, "", cover_on, 2'b11, 0);
		this.Timer3_EOI_Timer3_EOI = this.Timer3_EOI.Timer3_EOI;
		this.Timer3_intStat = new(this, "Timer3_intStat", `VMM_RAL_ADDR_WIDTH'h38, "", cover_on, 2'b11, 0);
		this.Timer3_intStat_Timer3_intStat = this.Timer3_intStat.Timer3_intStat;
		this.Timers_EOI = new(this, "Timers_EOI", `VMM_RAL_ADDR_WIDTH'hA4, "", cover_on, 2'b11, 0);
		this.Timers_EOI_Timer1_EOI = this.Timers_EOI.Timer1_EOI;
		this.Timers_EOI_Timer2_EOI = this.Timers_EOI.Timer2_EOI;
		this.Timers_EOI_Timer3_EOI = this.Timers_EOI.Timer3_EOI;
		this.Timers_intStat = new(this, "Timers_intStat", `VMM_RAL_ADDR_WIDTH'hA8, "", cover_on, 2'b11, 0);
		this.Timers_intStat_Timer1_rawintStat = this.Timers_intStat.Timer1_rawintStat;
		this.Timer1_rawintStat = this.Timers_intStat.Timer1_rawintStat;
		this.Timers_intStat_Timer2_rawintStat = this.Timers_intStat.Timer2_rawintStat;
		this.Timer2_rawintStat = this.Timers_intStat.Timer2_rawintStat;
		this.Timers_intStat_Timer3_rawintStat = this.Timers_intStat.Timer3_rawintStat;
		this.Timer3_rawintStat = this.Timers_intStat.Timer3_rawintStat;
		this.Timers_int_status = new(this, "Timers_int_status", `VMM_RAL_ADDR_WIDTH'hA0, "", cover_on, 2'b11, 0);
		this.Timers_int_status_Time1_int_status = this.Timers_int_status.Time1_int_status;
		this.Time1_int_status = this.Timers_int_status.Time1_int_status;
		this.Timers_int_status_Time2_int_status = this.Timers_int_status.Time2_int_status;
		this.Time2_int_status = this.Timers_int_status.Time2_int_status;
		this.Timers_int_status_Time3_int_status = this.Timers_int_status.Time3_int_status;
		this.Time3_int_status = this.Timers_int_status.Time3_int_status;
		this.Xlock_modelX();
	endfunction : new
endclass : ral_block_TIMER


class ral_reg_TRICKReg extends vmm_ral_reg;
	rand vmm_ral_field TRICKReg;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.TRICKReg = new(this, "TRICKReg", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_TRICKReg


class ral_block_TRICKBOX extends vmm_ral_block;
	rand ral_reg_TRICKReg TRICKReg;
	rand vmm_ral_field TRICKReg_TRICKReg;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "TRICKBOX", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "TRICKBOX", 16, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on);
		this.TRICKReg = new(this, "TRICKReg", `VMM_RAL_ADDR_WIDTH'h7C, "", cover_on, 2'b11, 0);
		this.TRICKReg_TRICKReg = this.TRICKReg.TRICKReg;
		this.Xlock_modelX();
	endfunction : new
endclass : ral_block_TRICKBOX


class ral_reg_DESCNTRL_REG extends vmm_ral_reg;
	rand vmm_ral_field start;
	rand vmm_ral_field encrypt;
	rand vmm_ral_field key_sel;
	rand vmm_ral_field des_mode;
	rand vmm_ral_field op_mode;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.start = new(this, "start", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.encrypt = new(this, "encrypt", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
		this.key_sel = new(this, "key_sel", 2, vmm_ral::RW, 'h0, 2'hx, 2, 0, cvr);
		this.des_mode = new(this, "des_mode", 1, vmm_ral::RW, 'h0, 1'hx, 4, 0, cvr);
		this.op_mode = new(this, "op_mode", 2, vmm_ral::RW, 'h0, 2'hx, 5, 0, cvr);
	endfunction: new
endclass : ral_reg_DESCNTRL_REG


class ral_reg_DESDATA_REG0 extends vmm_ral_reg;
	rand vmm_ral_field DESDATA0;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.DESDATA0 = new(this, "DESDATA0", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_DESDATA_REG0


class ral_reg_DESDATA_REG1 extends vmm_ral_reg;
	rand vmm_ral_field DESDATA1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.DESDATA1 = new(this, "DESDATA1", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_DESDATA_REG1


class ral_reg_DESIV_REG0 extends vmm_ral_reg;
	rand vmm_ral_field DESIV_REG0;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.DESIV_REG0 = new(this, "DESIV_REG0", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_DESIV_REG0


class ral_reg_DESIV_REG1 extends vmm_ral_reg;
	rand vmm_ral_field DESIV_REG1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.DESIV_REG1 = new(this, "DESIV_REG1", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_DESIV_REG1


class ral_reg_DESKEY1_REG0 extends vmm_ral_reg;
	rand vmm_ral_field DESKEY1_REG0;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.DESKEY1_REG0 = new(this, "DESKEY1_REG0", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_DESKEY1_REG0


class ral_reg_DESKEY1_REG1 extends vmm_ral_reg;
	rand vmm_ral_field DESKEY1_REG1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.DESKEY1_REG1 = new(this, "DESKEY1_REG1", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_DESKEY1_REG1


class ral_reg_DESKEY2_REG0 extends vmm_ral_reg;
	rand vmm_ral_field DESKEY2_REG0;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.DESKEY2_REG0 = new(this, "DESKEY2_REG0", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_DESKEY2_REG0


class ral_reg_DESKEY2_REG1 extends vmm_ral_reg;
	rand vmm_ral_field DESKEY2_REG1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.DESKEY2_REG1 = new(this, "DESKEY2_REG1", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_DESKEY2_REG1


class ral_reg_DESKEY3_REG0 extends vmm_ral_reg;
	rand vmm_ral_field DESKEY3_REG0;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.DESKEY3_REG0 = new(this, "DESKEY3_REG0", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_DESKEY3_REG0


class ral_reg_DESKEY3_REG1 extends vmm_ral_reg;
	rand vmm_ral_field DESKEY3_REG1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.DESKEY3_REG1 = new(this, "DESKEY3_REG1", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_DESKEY3_REG1


class ral_reg_DESRAND_REG0 extends vmm_ral_reg;
	rand vmm_ral_field DESRAND_REG0;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.DESRAND_REG0 = new(this, "DESRAND_REG0", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_DESRAND_REG0


class ral_reg_DESRAND_REG1 extends vmm_ral_reg;
	rand vmm_ral_field DESRAND_REG1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.DESRAND_REG1 = new(this, "DESRAND_REG1", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_DESRAND_REG1


class ral_block_DES extends vmm_ral_block;
	rand ral_reg_DESCNTRL_REG DESCNTRL_REG;
	rand ral_reg_DESDATA_REG0 DESDATA_REG0;
	rand ral_reg_DESDATA_REG1 DESDATA_REG1;
	rand ral_reg_DESIV_REG0 DESIV_REG0;
	rand ral_reg_DESIV_REG1 DESIV_REG1;
	rand ral_reg_DESKEY1_REG0 DESKEY1_REG0;
	rand ral_reg_DESKEY1_REG1 DESKEY1_REG1;
	rand ral_reg_DESKEY2_REG0 DESKEY2_REG0;
	rand ral_reg_DESKEY2_REG1 DESKEY2_REG1;
	rand ral_reg_DESKEY3_REG0 DESKEY3_REG0;
	rand ral_reg_DESKEY3_REG1 DESKEY3_REG1;
	rand ral_reg_DESRAND_REG0 DESRAND_REG0;
	rand ral_reg_DESRAND_REG1 DESRAND_REG1;
	rand vmm_ral_field DESCNTRL_REG_start;
	rand vmm_ral_field start;
	rand vmm_ral_field DESCNTRL_REG_encrypt;
	rand vmm_ral_field encrypt;
	rand vmm_ral_field DESCNTRL_REG_key_sel;
	rand vmm_ral_field key_sel;
	rand vmm_ral_field DESCNTRL_REG_des_mode;
	rand vmm_ral_field des_mode;
	rand vmm_ral_field DESCNTRL_REG_op_mode;
	rand vmm_ral_field op_mode;
	rand vmm_ral_field DESDATA_REG0_DESDATA0;
	rand vmm_ral_field DESDATA0;
	rand vmm_ral_field DESDATA_REG1_DESDATA1;
	rand vmm_ral_field DESDATA1;
	rand vmm_ral_field DESIV_REG0_DESIV_REG0;
	rand vmm_ral_field DESIV_REG1_DESIV_REG1;
	rand vmm_ral_field DESKEY1_REG0_DESKEY1_REG0;
	rand vmm_ral_field DESKEY1_REG1_DESKEY1_REG1;
	rand vmm_ral_field DESKEY2_REG0_DESKEY2_REG0;
	rand vmm_ral_field DESKEY2_REG1_DESKEY2_REG1;
	rand vmm_ral_field DESKEY3_REG0_DESKEY3_REG0;
	rand vmm_ral_field DESKEY3_REG1_DESKEY3_REG1;
	rand vmm_ral_field DESRAND_REG0_DESRAND_REG0;
	rand vmm_ral_field DESRAND_REG1_DESRAND_REG1;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "DES", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "DES", 128, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on);
		this.DESCNTRL_REG = new(this, "DESCNTRL_REG", `VMM_RAL_ADDR_WIDTH'h0, "", cover_on, 2'b11, 0);
		this.DESCNTRL_REG_start = this.DESCNTRL_REG.start;
		this.start = this.DESCNTRL_REG.start;
		this.DESCNTRL_REG_encrypt = this.DESCNTRL_REG.encrypt;
		this.encrypt = this.DESCNTRL_REG.encrypt;
		this.DESCNTRL_REG_key_sel = this.DESCNTRL_REG.key_sel;
		this.key_sel = this.DESCNTRL_REG.key_sel;
		this.DESCNTRL_REG_des_mode = this.DESCNTRL_REG.des_mode;
		this.des_mode = this.DESCNTRL_REG.des_mode;
		this.DESCNTRL_REG_op_mode = this.DESCNTRL_REG.op_mode;
		this.op_mode = this.DESCNTRL_REG.op_mode;
		this.DESDATA_REG0 = new(this, "DESDATA_REG0", `VMM_RAL_ADDR_WIDTH'h20, "", cover_on, 2'b11, 0);
		this.DESDATA_REG0_DESDATA0 = this.DESDATA_REG0.DESDATA0;
		this.DESDATA0 = this.DESDATA_REG0.DESDATA0;
		this.DESDATA_REG1 = new(this, "DESDATA_REG1", `VMM_RAL_ADDR_WIDTH'h24, "", cover_on, 2'b11, 0);
		this.DESDATA_REG1_DESDATA1 = this.DESDATA_REG1.DESDATA1;
		this.DESDATA1 = this.DESDATA_REG1.DESDATA1;
		this.DESIV_REG0 = new(this, "DESIV_REG0", `VMM_RAL_ADDR_WIDTH'h18, "", cover_on, 2'b11, 0);
		this.DESIV_REG0_DESIV_REG0 = this.DESIV_REG0.DESIV_REG0;
		this.DESIV_REG1 = new(this, "DESIV_REG1", `VMM_RAL_ADDR_WIDTH'h1C, "", cover_on, 2'b11, 0);
		this.DESIV_REG1_DESIV_REG1 = this.DESIV_REG1.DESIV_REG1;
		this.DESKEY1_REG0 = new(this, "DESKEY1_REG0", `VMM_RAL_ADDR_WIDTH'h28, "", cover_on, 2'b11, 0);
		this.DESKEY1_REG0_DESKEY1_REG0 = this.DESKEY1_REG0.DESKEY1_REG0;
		this.DESKEY1_REG1 = new(this, "DESKEY1_REG1", `VMM_RAL_ADDR_WIDTH'h2C, "", cover_on, 2'b11, 0);
		this.DESKEY1_REG1_DESKEY1_REG1 = this.DESKEY1_REG1.DESKEY1_REG1;
		this.DESKEY2_REG0 = new(this, "DESKEY2_REG0", `VMM_RAL_ADDR_WIDTH'h30, "", cover_on, 2'b11, 0);
		this.DESKEY2_REG0_DESKEY2_REG0 = this.DESKEY2_REG0.DESKEY2_REG0;
		this.DESKEY2_REG1 = new(this, "DESKEY2_REG1", `VMM_RAL_ADDR_WIDTH'h34, "", cover_on, 2'b11, 0);
		this.DESKEY2_REG1_DESKEY2_REG1 = this.DESKEY2_REG1.DESKEY2_REG1;
		this.DESKEY3_REG0 = new(this, "DESKEY3_REG0", `VMM_RAL_ADDR_WIDTH'h38, "", cover_on, 2'b11, 0);
		this.DESKEY3_REG0_DESKEY3_REG0 = this.DESKEY3_REG0.DESKEY3_REG0;
		this.DESKEY3_REG1 = new(this, "DESKEY3_REG1", `VMM_RAL_ADDR_WIDTH'h3C, "", cover_on, 2'b11, 0);
		this.DESKEY3_REG1_DESKEY3_REG1 = this.DESKEY3_REG1.DESKEY3_REG1;
		this.DESRAND_REG0 = new(this, "DESRAND_REG0", `VMM_RAL_ADDR_WIDTH'h10, "", cover_on, 2'b11, 0);
		this.DESRAND_REG0_DESRAND_REG0 = this.DESRAND_REG0.DESRAND_REG0;
		this.DESRAND_REG1 = new(this, "DESRAND_REG1", `VMM_RAL_ADDR_WIDTH'h14, "", cover_on, 2'b11, 0);
		this.DESRAND_REG1_DESRAND_REG1 = this.DESRAND_REG1.DESRAND_REG1;
		this.Xlock_modelX();
	endfunction : new
endclass : ral_block_DES


class ral_reg_SM1AKEY_REG0 extends vmm_ral_reg;
	rand vmm_ral_field SM1AKEY_REG0;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM1AKEY_REG0 = new(this, "SM1AKEY_REG0", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM1AKEY_REG0


class ral_reg_SM1AKEY_REG1 extends vmm_ral_reg;
	rand vmm_ral_field SM1AKEY_REG1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM1AKEY_REG1 = new(this, "SM1AKEY_REG1", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM1AKEY_REG1


class ral_reg_SM1AKEY_REG2 extends vmm_ral_reg;
	rand vmm_ral_field DESKEY1_REG2;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.DESKEY1_REG2 = new(this, "DESKEY1_REG2", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM1AKEY_REG2


class ral_reg_SM1AKEY_REG3 extends vmm_ral_reg;
	rand vmm_ral_field SM1AKEY_REG3;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM1AKEY_REG3 = new(this, "SM1AKEY_REG3", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM1AKEY_REG3


class ral_reg_SM1CNTRL_REG extends vmm_ral_reg;
	rand vmm_ral_field start;
	rand vmm_ral_field skey_sel;
	rand vmm_ral_field encrypt;
	rand vmm_ral_field round_sel;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.start = new(this, "start", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.skey_sel = new(this, "skey_sel", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
		this.encrypt = new(this, "encrypt", 1, vmm_ral::RW, 'h0, 1'hx, 2, 0, cvr);
		this.round_sel = new(this, "round_sel", 2, vmm_ral::RW, 'h0, 2'hx, 3, 0, cvr);
	endfunction: new
endclass : ral_reg_SM1CNTRL_REG


class ral_reg_SM1DATA_REG0 extends vmm_ral_reg;
	rand vmm_ral_field SM1DATA_REG0;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM1DATA_REG0 = new(this, "SM1DATA_REG0", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM1DATA_REG0


class ral_reg_SM1DATA_REG1 extends vmm_ral_reg;
	rand vmm_ral_field SM1DATA_REG1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM1DATA_REG1 = new(this, "SM1DATA_REG1", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM1DATA_REG1


class ral_reg_SM1DATA_REG2 extends vmm_ral_reg;
	rand vmm_ral_field SM1DATA_REG2;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM1DATA_REG2 = new(this, "SM1DATA_REG2", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM1DATA_REG2


class ral_reg_SM1DATA_REG3 extends vmm_ral_reg;
	rand vmm_ral_field SM1DATA_REG3;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM1DATA_REG3 = new(this, "SM1DATA_REG3", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM1DATA_REG3


class ral_reg_SM1EKEY_REG0 extends vmm_ral_reg;
	rand vmm_ral_field SM1EKEY_REG0;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM1EKEY_REG0 = new(this, "SM1EKEY_REG0", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM1EKEY_REG0


class ral_reg_SM1EKEY_REG1 extends vmm_ral_reg;
	rand vmm_ral_field SM1EKEY_REG1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM1EKEY_REG1 = new(this, "SM1EKEY_REG1", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM1EKEY_REG1


class ral_reg_SM1EKEY_REG2 extends vmm_ral_reg;
	rand vmm_ral_field SM1EKEY_REG2;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM1EKEY_REG2 = new(this, "SM1EKEY_REG2", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM1EKEY_REG2


class ral_reg_SM1EKEY_REG3 extends vmm_ral_reg;
	rand vmm_ral_field SM1EKEY_REG3;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM1EKEY_REG3 = new(this, "SM1EKEY_REG3", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM1EKEY_REG3


class ral_reg_SM1KEY_REG0 extends vmm_ral_reg;
	rand vmm_ral_field SM1KEY_REG0;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM1KEY_REG0 = new(this, "SM1KEY_REG0", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM1KEY_REG0


class ral_reg_SM1KEY_REG1 extends vmm_ral_reg;
	rand vmm_ral_field SM1KEY_REG1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM1KEY_REG1 = new(this, "SM1KEY_REG1", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM1KEY_REG1


class ral_reg_SM1KEY_REG2 extends vmm_ral_reg;
	rand vmm_ral_field SM1KEY_REG2;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM1KEY_REG2 = new(this, "SM1KEY_REG2", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM1KEY_REG2


class ral_reg_SM1KEY_REG3 extends vmm_ral_reg;
	rand vmm_ral_field SM1KEY_REG3;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM1KEY_REG3 = new(this, "SM1KEY_REG3", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM1KEY_REG3


class ral_block_SM1 extends vmm_ral_block;
	rand ral_reg_SM1AKEY_REG0 SM1AKEY_REG0;
	rand ral_reg_SM1AKEY_REG1 SM1AKEY_REG1;
	rand ral_reg_SM1AKEY_REG2 SM1AKEY_REG2;
	rand ral_reg_SM1AKEY_REG3 SM1AKEY_REG3;
	rand ral_reg_SM1CNTRL_REG SM1CNTRL_REG;
	rand ral_reg_SM1DATA_REG0 SM1DATA_REG0;
	rand ral_reg_SM1DATA_REG1 SM1DATA_REG1;
	rand ral_reg_SM1DATA_REG2 SM1DATA_REG2;
	rand ral_reg_SM1DATA_REG3 SM1DATA_REG3;
	rand ral_reg_SM1EKEY_REG0 SM1EKEY_REG0;
	rand ral_reg_SM1EKEY_REG1 SM1EKEY_REG1;
	rand ral_reg_SM1EKEY_REG2 SM1EKEY_REG2;
	rand ral_reg_SM1EKEY_REG3 SM1EKEY_REG3;
	rand ral_reg_SM1KEY_REG0 SM1KEY_REG0;
	rand ral_reg_SM1KEY_REG1 SM1KEY_REG1;
	rand ral_reg_SM1KEY_REG2 SM1KEY_REG2;
	rand ral_reg_SM1KEY_REG3 SM1KEY_REG3;
	rand vmm_ral_field SM1AKEY_REG0_SM1AKEY_REG0;
	rand vmm_ral_field SM1AKEY_REG1_SM1AKEY_REG1;
	rand vmm_ral_field SM1AKEY_REG2_DESKEY1_REG2;
	rand vmm_ral_field DESKEY1_REG2;
	rand vmm_ral_field SM1AKEY_REG3_SM1AKEY_REG3;
	rand vmm_ral_field SM1CNTRL_REG_start;
	rand vmm_ral_field start;
	rand vmm_ral_field SM1CNTRL_REG_skey_sel;
	rand vmm_ral_field skey_sel;
	rand vmm_ral_field SM1CNTRL_REG_encrypt;
	rand vmm_ral_field encrypt;
	rand vmm_ral_field SM1CNTRL_REG_round_sel;
	rand vmm_ral_field round_sel;
	rand vmm_ral_field SM1DATA_REG0_SM1DATA_REG0;
	rand vmm_ral_field SM1DATA_REG1_SM1DATA_REG1;
	rand vmm_ral_field SM1DATA_REG2_SM1DATA_REG2;
	rand vmm_ral_field SM1DATA_REG3_SM1DATA_REG3;
	rand vmm_ral_field SM1EKEY_REG0_SM1EKEY_REG0;
	rand vmm_ral_field SM1EKEY_REG1_SM1EKEY_REG1;
	rand vmm_ral_field SM1EKEY_REG2_SM1EKEY_REG2;
	rand vmm_ral_field SM1EKEY_REG3_SM1EKEY_REG3;
	rand vmm_ral_field SM1KEY_REG0_SM1KEY_REG0;
	rand vmm_ral_field SM1KEY_REG1_SM1KEY_REG1;
	rand vmm_ral_field SM1KEY_REG2_SM1KEY_REG2;
	rand vmm_ral_field SM1KEY_REG3_SM1KEY_REG3;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "SM1", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "SM1", 128, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on);
		this.SM1AKEY_REG0 = new(this, "SM1AKEY_REG0", `VMM_RAL_ADDR_WIDTH'h20, "", cover_on, 2'b11, 0);
		this.SM1AKEY_REG0_SM1AKEY_REG0 = this.SM1AKEY_REG0.SM1AKEY_REG0;
		this.SM1AKEY_REG1 = new(this, "SM1AKEY_REG1", `VMM_RAL_ADDR_WIDTH'h24, "", cover_on, 2'b11, 0);
		this.SM1AKEY_REG1_SM1AKEY_REG1 = this.SM1AKEY_REG1.SM1AKEY_REG1;
		this.SM1AKEY_REG2 = new(this, "SM1AKEY_REG2", `VMM_RAL_ADDR_WIDTH'h28, "", cover_on, 2'b11, 0);
		this.SM1AKEY_REG2_DESKEY1_REG2 = this.SM1AKEY_REG2.DESKEY1_REG2;
		this.DESKEY1_REG2 = this.SM1AKEY_REG2.DESKEY1_REG2;
		this.SM1AKEY_REG3 = new(this, "SM1AKEY_REG3", `VMM_RAL_ADDR_WIDTH'h2C, "", cover_on, 2'b11, 0);
		this.SM1AKEY_REG3_SM1AKEY_REG3 = this.SM1AKEY_REG3.SM1AKEY_REG3;
		this.SM1CNTRL_REG = new(this, "SM1CNTRL_REG", `VMM_RAL_ADDR_WIDTH'h0, "", cover_on, 2'b11, 0);
		this.SM1CNTRL_REG_start = this.SM1CNTRL_REG.start;
		this.start = this.SM1CNTRL_REG.start;
		this.SM1CNTRL_REG_skey_sel = this.SM1CNTRL_REG.skey_sel;
		this.skey_sel = this.SM1CNTRL_REG.skey_sel;
		this.SM1CNTRL_REG_encrypt = this.SM1CNTRL_REG.encrypt;
		this.encrypt = this.SM1CNTRL_REG.encrypt;
		this.SM1CNTRL_REG_round_sel = this.SM1CNTRL_REG.round_sel;
		this.round_sel = this.SM1CNTRL_REG.round_sel;
		this.SM1DATA_REG0 = new(this, "SM1DATA_REG0", `VMM_RAL_ADDR_WIDTH'h40, "", cover_on, 2'b11, 0);
		this.SM1DATA_REG0_SM1DATA_REG0 = this.SM1DATA_REG0.SM1DATA_REG0;
		this.SM1DATA_REG1 = new(this, "SM1DATA_REG1", `VMM_RAL_ADDR_WIDTH'h44, "", cover_on, 2'b11, 0);
		this.SM1DATA_REG1_SM1DATA_REG1 = this.SM1DATA_REG1.SM1DATA_REG1;
		this.SM1DATA_REG2 = new(this, "SM1DATA_REG2", `VMM_RAL_ADDR_WIDTH'h48, "", cover_on, 2'b11, 0);
		this.SM1DATA_REG2_SM1DATA_REG2 = this.SM1DATA_REG2.SM1DATA_REG2;
		this.SM1DATA_REG3 = new(this, "SM1DATA_REG3", `VMM_RAL_ADDR_WIDTH'h4C, "", cover_on, 2'b11, 0);
		this.SM1DATA_REG3_SM1DATA_REG3 = this.SM1DATA_REG3.SM1DATA_REG3;
		this.SM1EKEY_REG0 = new(this, "SM1EKEY_REG0", `VMM_RAL_ADDR_WIDTH'h10, "", cover_on, 2'b11, 0);
		this.SM1EKEY_REG0_SM1EKEY_REG0 = this.SM1EKEY_REG0.SM1EKEY_REG0;
		this.SM1EKEY_REG1 = new(this, "SM1EKEY_REG1", `VMM_RAL_ADDR_WIDTH'h14, "", cover_on, 2'b11, 0);
		this.SM1EKEY_REG1_SM1EKEY_REG1 = this.SM1EKEY_REG1.SM1EKEY_REG1;
		this.SM1EKEY_REG2 = new(this, "SM1EKEY_REG2", `VMM_RAL_ADDR_WIDTH'h18, "", cover_on, 2'b11, 0);
		this.SM1EKEY_REG2_SM1EKEY_REG2 = this.SM1EKEY_REG2.SM1EKEY_REG2;
		this.SM1EKEY_REG3 = new(this, "SM1EKEY_REG3", `VMM_RAL_ADDR_WIDTH'h1C, "", cover_on, 2'b11, 0);
		this.SM1EKEY_REG3_SM1EKEY_REG3 = this.SM1EKEY_REG3.SM1EKEY_REG3;
		this.SM1KEY_REG0 = new(this, "SM1KEY_REG0", `VMM_RAL_ADDR_WIDTH'h30, "", cover_on, 2'b11, 0);
		this.SM1KEY_REG0_SM1KEY_REG0 = this.SM1KEY_REG0.SM1KEY_REG0;
		this.SM1KEY_REG1 = new(this, "SM1KEY_REG1", `VMM_RAL_ADDR_WIDTH'h34, "", cover_on, 2'b11, 0);
		this.SM1KEY_REG1_SM1KEY_REG1 = this.SM1KEY_REG1.SM1KEY_REG1;
		this.SM1KEY_REG2 = new(this, "SM1KEY_REG2", `VMM_RAL_ADDR_WIDTH'h38, "", cover_on, 2'b11, 0);
		this.SM1KEY_REG2_SM1KEY_REG2 = this.SM1KEY_REG2.SM1KEY_REG2;
		this.SM1KEY_REG3 = new(this, "SM1KEY_REG3", `VMM_RAL_ADDR_WIDTH'h3C, "", cover_on, 2'b11, 0);
		this.SM1KEY_REG3_SM1KEY_REG3 = this.SM1KEY_REG3.SM1KEY_REG3;
		this.Xlock_modelX();
	endfunction : new
endclass : ral_block_SM1


class ral_reg_SSF33CNTRL_REG extends vmm_ral_reg;
	rand vmm_ral_field ssf33_start;
	rand vmm_ral_field ssf33ken_gen;
	rand vmm_ral_field ssf33key_sel;
	rand vmm_ral_field ssf33_encrypt;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.ssf33_start = new(this, "ssf33_start", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.ssf33ken_gen = new(this, "ssf33ken_gen", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
		this.ssf33key_sel = new(this, "ssf33key_sel", 1, vmm_ral::RW, 'h0, 1'hx, 2, 0, cvr);
		this.ssf33_encrypt = new(this, "ssf33_encrypt", 1, vmm_ral::RW, 'h0, 1'hx, 3, 0, cvr);
	endfunction: new
endclass : ral_reg_SSF33CNTRL_REG


class ral_reg_SSF33DATA_REG0 extends vmm_ral_reg;
	rand vmm_ral_field SSF33DATA_REG0;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SSF33DATA_REG0 = new(this, "SSF33DATA_REG0", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SSF33DATA_REG0


class ral_reg_SSF33DATA_REG1 extends vmm_ral_reg;
	rand vmm_ral_field SSF33DATA_REG1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SSF33DATA_REG1 = new(this, "SSF33DATA_REG1", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SSF33DATA_REG1


class ral_reg_SSF33DATA_REG2 extends vmm_ral_reg;
	rand vmm_ral_field SSF33DATA_REG3;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SSF33DATA_REG3 = new(this, "SSF33DATA_REG3", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SSF33DATA_REG2


class ral_reg_SSF33DATA_REG3 extends vmm_ral_reg;
	rand vmm_ral_field SSF33DATA_REG3;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SSF33DATA_REG3 = new(this, "SSF33DATA_REG3", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SSF33DATA_REG3


class ral_reg_SSF33Mkey_REG0 extends vmm_ral_reg;
	rand vmm_ral_field SSF33Mkey_REG0;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SSF33Mkey_REG0 = new(this, "SSF33Mkey_REG0", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SSF33Mkey_REG0


class ral_reg_SSF33Mkey_REG1 extends vmm_ral_reg;
	rand vmm_ral_field SSF33Mkey_REG1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SSF33Mkey_REG1 = new(this, "SSF33Mkey_REG1", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SSF33Mkey_REG1


class ral_reg_SSF33Mkey_REG2 extends vmm_ral_reg;
	rand vmm_ral_field SSF33Mkey_REG2;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SSF33Mkey_REG2 = new(this, "SSF33Mkey_REG2", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SSF33Mkey_REG2


class ral_reg_SSF33Mkey_REG3 extends vmm_ral_reg;
	rand vmm_ral_field SSF33Mkey_REG3;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SSF33Mkey_REG3 = new(this, "SSF33Mkey_REG3", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SSF33Mkey_REG3


class ral_reg_SSF33SKey_REG0 extends vmm_ral_reg;
	rand vmm_ral_field DESRAND_REG0;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.DESRAND_REG0 = new(this, "DESRAND_REG0", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SSF33SKey_REG0


class ral_reg_SSF33SKey_REG1 extends vmm_ral_reg;
	rand vmm_ral_field SSF33SKey_REG1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SSF33SKey_REG1 = new(this, "SSF33SKey_REG1", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SSF33SKey_REG1


class ral_reg_SSF33SKey_REG2 extends vmm_ral_reg;
	rand vmm_ral_field SSF33SKey_REG2;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SSF33SKey_REG2 = new(this, "SSF33SKey_REG2", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SSF33SKey_REG2


class ral_reg_SSF33SKey_REG3 extends vmm_ral_reg;
	rand vmm_ral_field SSF33SKey_REG3;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SSF33SKey_REG3 = new(this, "SSF33SKey_REG3", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SSF33SKey_REG3


class ral_block_SSF33 extends vmm_ral_block;
	rand ral_reg_SSF33CNTRL_REG SSF33CNTRL_REG;
	rand ral_reg_SSF33DATA_REG0 SSF33DATA_REG0;
	rand ral_reg_SSF33DATA_REG1 SSF33DATA_REG1;
	rand ral_reg_SSF33DATA_REG2 SSF33DATA_REG2;
	rand ral_reg_SSF33DATA_REG3 SSF33DATA_REG3;
	rand ral_reg_SSF33Mkey_REG0 SSF33Mkey_REG0;
	rand ral_reg_SSF33Mkey_REG1 SSF33Mkey_REG1;
	rand ral_reg_SSF33Mkey_REG2 SSF33Mkey_REG2;
	rand ral_reg_SSF33Mkey_REG3 SSF33Mkey_REG3;
	rand ral_reg_SSF33SKey_REG0 SSF33SKey_REG0;
	rand ral_reg_SSF33SKey_REG1 SSF33SKey_REG1;
	rand ral_reg_SSF33SKey_REG2 SSF33SKey_REG2;
	rand ral_reg_SSF33SKey_REG3 SSF33SKey_REG3;
	rand vmm_ral_field SSF33CNTRL_REG_ssf33_start;
	rand vmm_ral_field ssf33_start;
	rand vmm_ral_field SSF33CNTRL_REG_ssf33ken_gen;
	rand vmm_ral_field ssf33ken_gen;
	rand vmm_ral_field SSF33CNTRL_REG_ssf33key_sel;
	rand vmm_ral_field ssf33key_sel;
	rand vmm_ral_field SSF33CNTRL_REG_ssf33_encrypt;
	rand vmm_ral_field ssf33_encrypt;
	rand vmm_ral_field SSF33DATA_REG0_SSF33DATA_REG0;
	rand vmm_ral_field SSF33DATA_REG1_SSF33DATA_REG1;
	rand vmm_ral_field SSF33DATA_REG2_SSF33DATA_REG3;
	rand vmm_ral_field SSF33DATA_REG3_SSF33DATA_REG3;
	rand vmm_ral_field SSF33Mkey_REG0_SSF33Mkey_REG0;
	rand vmm_ral_field SSF33Mkey_REG1_SSF33Mkey_REG1;
	rand vmm_ral_field SSF33Mkey_REG2_SSF33Mkey_REG2;
	rand vmm_ral_field SSF33Mkey_REG3_SSF33Mkey_REG3;
	rand vmm_ral_field SSF33SKey_REG0_DESRAND_REG0;
	rand vmm_ral_field DESRAND_REG0;
	rand vmm_ral_field SSF33SKey_REG1_SSF33SKey_REG1;
	rand vmm_ral_field SSF33SKey_REG2_SSF33SKey_REG2;
	rand vmm_ral_field SSF33SKey_REG3_SSF33SKey_REG3;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "SSF33", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "SSF33", 128, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on);
		this.SSF33CNTRL_REG = new(this, "SSF33CNTRL_REG", `VMM_RAL_ADDR_WIDTH'h0, "", cover_on, 2'b11, 0);
		this.SSF33CNTRL_REG_ssf33_start = this.SSF33CNTRL_REG.ssf33_start;
		this.ssf33_start = this.SSF33CNTRL_REG.ssf33_start;
		this.SSF33CNTRL_REG_ssf33ken_gen = this.SSF33CNTRL_REG.ssf33ken_gen;
		this.ssf33ken_gen = this.SSF33CNTRL_REG.ssf33ken_gen;
		this.SSF33CNTRL_REG_ssf33key_sel = this.SSF33CNTRL_REG.ssf33key_sel;
		this.ssf33key_sel = this.SSF33CNTRL_REG.ssf33key_sel;
		this.SSF33CNTRL_REG_ssf33_encrypt = this.SSF33CNTRL_REG.ssf33_encrypt;
		this.ssf33_encrypt = this.SSF33CNTRL_REG.ssf33_encrypt;
		this.SSF33DATA_REG0 = new(this, "SSF33DATA_REG0", `VMM_RAL_ADDR_WIDTH'h30, "", cover_on, 2'b11, 0);
		this.SSF33DATA_REG0_SSF33DATA_REG0 = this.SSF33DATA_REG0.SSF33DATA_REG0;
		this.SSF33DATA_REG1 = new(this, "SSF33DATA_REG1", `VMM_RAL_ADDR_WIDTH'h34, "", cover_on, 2'b11, 0);
		this.SSF33DATA_REG1_SSF33DATA_REG1 = this.SSF33DATA_REG1.SSF33DATA_REG1;
		this.SSF33DATA_REG2 = new(this, "SSF33DATA_REG2", `VMM_RAL_ADDR_WIDTH'h38, "", cover_on, 2'b11, 0);
		this.SSF33DATA_REG2_SSF33DATA_REG3 = this.SSF33DATA_REG2.SSF33DATA_REG3;
		this.SSF33DATA_REG3 = new(this, "SSF33DATA_REG3", `VMM_RAL_ADDR_WIDTH'h3C, "", cover_on, 2'b11, 0);
		this.SSF33DATA_REG3_SSF33DATA_REG3 = this.SSF33DATA_REG3.SSF33DATA_REG3;
		this.SSF33Mkey_REG0 = new(this, "SSF33Mkey_REG0", `VMM_RAL_ADDR_WIDTH'h20, "", cover_on, 2'b11, 0);
		this.SSF33Mkey_REG0_SSF33Mkey_REG0 = this.SSF33Mkey_REG0.SSF33Mkey_REG0;
		this.SSF33Mkey_REG1 = new(this, "SSF33Mkey_REG1", `VMM_RAL_ADDR_WIDTH'h24, "", cover_on, 2'b11, 0);
		this.SSF33Mkey_REG1_SSF33Mkey_REG1 = this.SSF33Mkey_REG1.SSF33Mkey_REG1;
		this.SSF33Mkey_REG2 = new(this, "SSF33Mkey_REG2", `VMM_RAL_ADDR_WIDTH'h28, "", cover_on, 2'b11, 0);
		this.SSF33Mkey_REG2_SSF33Mkey_REG2 = this.SSF33Mkey_REG2.SSF33Mkey_REG2;
		this.SSF33Mkey_REG3 = new(this, "SSF33Mkey_REG3", `VMM_RAL_ADDR_WIDTH'h2C, "", cover_on, 2'b11, 0);
		this.SSF33Mkey_REG3_SSF33Mkey_REG3 = this.SSF33Mkey_REG3.SSF33Mkey_REG3;
		this.SSF33SKey_REG0 = new(this, "SSF33SKey_REG0", `VMM_RAL_ADDR_WIDTH'h10, "", cover_on, 2'b11, 0);
		this.SSF33SKey_REG0_DESRAND_REG0 = this.SSF33SKey_REG0.DESRAND_REG0;
		this.DESRAND_REG0 = this.SSF33SKey_REG0.DESRAND_REG0;
		this.SSF33SKey_REG1 = new(this, "SSF33SKey_REG1", `VMM_RAL_ADDR_WIDTH'h14, "", cover_on, 2'b11, 0);
		this.SSF33SKey_REG1_SSF33SKey_REG1 = this.SSF33SKey_REG1.SSF33SKey_REG1;
		this.SSF33SKey_REG2 = new(this, "SSF33SKey_REG2", `VMM_RAL_ADDR_WIDTH'h18, "", cover_on, 2'b11, 0);
		this.SSF33SKey_REG2_SSF33SKey_REG2 = this.SSF33SKey_REG2.SSF33SKey_REG2;
		this.SSF33SKey_REG3 = new(this, "SSF33SKey_REG3", `VMM_RAL_ADDR_WIDTH'h1C, "", cover_on, 2'b11, 0);
		this.SSF33SKey_REG3_SSF33SKey_REG3 = this.SSF33SKey_REG3.SSF33SKey_REG3;
		this.Xlock_modelX();
	endfunction : new
endclass : ral_block_SSF33


class ral_reg_SM7CNTRL_REG extends vmm_ral_reg;
	rand vmm_ral_field sm7_start;
	rand vmm_ral_field sm7_encrypt;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.sm7_start = new(this, "sm7_start", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.sm7_encrypt = new(this, "sm7_encrypt", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
	endfunction: new
endclass : ral_reg_SM7CNTRL_REG


class ral_reg_SM7DATA_REG0 extends vmm_ral_reg;
	rand vmm_ral_field SM7DATA_REG0;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM7DATA_REG0 = new(this, "SM7DATA_REG0", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM7DATA_REG0


class ral_reg_SM7DATA_REG1 extends vmm_ral_reg;
	rand vmm_ral_field SM7DATA_REG1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM7DATA_REG1 = new(this, "SM7DATA_REG1", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM7DATA_REG1


class ral_reg_SM7KEY_REG1 extends vmm_ral_reg;
	rand vmm_ral_field SM7KEY_REG1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM7KEY_REG1 = new(this, "SM7KEY_REG1", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM7KEY_REG1


class ral_reg_SM7KEY_REG2 extends vmm_ral_reg;
	rand vmm_ral_field SM7KEY_REG2;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM7KEY_REG2 = new(this, "SM7KEY_REG2", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM7KEY_REG2


class ral_reg_SM7KEY_REG3 extends vmm_ral_reg;
	rand vmm_ral_field SM7KEY_REG3;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM7KEY_REG3 = new(this, "SM7KEY_REG3", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM7KEY_REG3


class ral_reg_SM7KEY_REG4 extends vmm_ral_reg;
	rand vmm_ral_field SM7KEY_REG4;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM7KEY_REG4 = new(this, "SM7KEY_REG4", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM7KEY_REG4


class ral_block_SM7 extends vmm_ral_block;
	rand ral_reg_SM7CNTRL_REG SM7CNTRL_REG;
	rand ral_reg_SM7DATA_REG0 SM7DATA_REG0;
	rand ral_reg_SM7DATA_REG1 SM7DATA_REG1;
	rand ral_reg_SM7KEY_REG1 SM7KEY_REG1;
	rand ral_reg_SM7KEY_REG2 SM7KEY_REG2;
	rand ral_reg_SM7KEY_REG3 SM7KEY_REG3;
	rand ral_reg_SM7KEY_REG4 SM7KEY_REG4;
	rand vmm_ral_field SM7CNTRL_REG_sm7_start;
	rand vmm_ral_field sm7_start;
	rand vmm_ral_field SM7CNTRL_REG_sm7_encrypt;
	rand vmm_ral_field sm7_encrypt;
	rand vmm_ral_field SM7DATA_REG0_SM7DATA_REG0;
	rand vmm_ral_field SM7DATA_REG1_SM7DATA_REG1;
	rand vmm_ral_field SM7KEY_REG1_SM7KEY_REG1;
	rand vmm_ral_field SM7KEY_REG2_SM7KEY_REG2;
	rand vmm_ral_field SM7KEY_REG3_SM7KEY_REG3;
	rand vmm_ral_field SM7KEY_REG4_SM7KEY_REG4;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "SM7", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "SM7", 128, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on);
		this.SM7CNTRL_REG = new(this, "SM7CNTRL_REG", `VMM_RAL_ADDR_WIDTH'h0, "", cover_on, 2'b11, 0);
		this.SM7CNTRL_REG_sm7_start = this.SM7CNTRL_REG.sm7_start;
		this.sm7_start = this.SM7CNTRL_REG.sm7_start;
		this.SM7CNTRL_REG_sm7_encrypt = this.SM7CNTRL_REG.sm7_encrypt;
		this.sm7_encrypt = this.SM7CNTRL_REG.sm7_encrypt;
		this.SM7DATA_REG0 = new(this, "SM7DATA_REG0", `VMM_RAL_ADDR_WIDTH'h10, "", cover_on, 2'b11, 0);
		this.SM7DATA_REG0_SM7DATA_REG0 = this.SM7DATA_REG0.SM7DATA_REG0;
		this.SM7DATA_REG1 = new(this, "SM7DATA_REG1", `VMM_RAL_ADDR_WIDTH'h14, "", cover_on, 2'b11, 0);
		this.SM7DATA_REG1_SM7DATA_REG1 = this.SM7DATA_REG1.SM7DATA_REG1;
		this.SM7KEY_REG1 = new(this, "SM7KEY_REG1", `VMM_RAL_ADDR_WIDTH'h20, "", cover_on, 2'b11, 0);
		this.SM7KEY_REG1_SM7KEY_REG1 = this.SM7KEY_REG1.SM7KEY_REG1;
		this.SM7KEY_REG2 = new(this, "SM7KEY_REG2", `VMM_RAL_ADDR_WIDTH'h24, "", cover_on, 2'b11, 0);
		this.SM7KEY_REG2_SM7KEY_REG2 = this.SM7KEY_REG2.SM7KEY_REG2;
		this.SM7KEY_REG3 = new(this, "SM7KEY_REG3", `VMM_RAL_ADDR_WIDTH'h28, "", cover_on, 2'b11, 0);
		this.SM7KEY_REG3_SM7KEY_REG3 = this.SM7KEY_REG3.SM7KEY_REG3;
		this.SM7KEY_REG4 = new(this, "SM7KEY_REG4", `VMM_RAL_ADDR_WIDTH'h2C, "", cover_on, 2'b11, 0);
		this.SM7KEY_REG4_SM7KEY_REG4 = this.SM7KEY_REG4.SM7KEY_REG4;
		this.Xlock_modelX();
	endfunction : new
endclass : ral_block_SM7


class ral_reg_SM3CNTRL_REG extends vmm_ral_reg;
	rand vmm_ral_field sm3_start;
	rand vmm_ral_field hash_sel;
	rand vmm_ral_field first_group;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.sm3_start = new(this, "sm3_start", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.hash_sel = new(this, "hash_sel", 2, vmm_ral::RW, 'h0, 2'hx, 1, 0, cvr);
		this.first_group = new(this, "first_group", 1, vmm_ral::RW, 'h0, 1'hx, 3, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3CNTRL_REG


class ral_reg_SM3DATA_REG0 extends vmm_ral_reg;
	rand vmm_ral_field SM3DATA_REG0;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3DATA_REG0 = new(this, "SM3DATA_REG0", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3DATA_REG0


class ral_reg_SM3DATA_REG1 extends vmm_ral_reg;
	rand vmm_ral_field SM3DATA_REG1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3DATA_REG1 = new(this, "SM3DATA_REG1", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3DATA_REG1


class ral_reg_SM3DATA_REG10 extends vmm_ral_reg;
	rand vmm_ral_field SM3DATA_REG10;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3DATA_REG10 = new(this, "SM3DATA_REG10", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3DATA_REG10


class ral_reg_SM3DATA_REG11 extends vmm_ral_reg;
	rand vmm_ral_field SM3DATA_REG11;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3DATA_REG11 = new(this, "SM3DATA_REG11", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3DATA_REG11


class ral_reg_SM3DATA_REG12 extends vmm_ral_reg;
	rand vmm_ral_field SM3DATA_REG12;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3DATA_REG12 = new(this, "SM3DATA_REG12", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3DATA_REG12


class ral_reg_SM3DATA_REG13 extends vmm_ral_reg;
	rand vmm_ral_field SM3DATA_REG13;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3DATA_REG13 = new(this, "SM3DATA_REG13", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3DATA_REG13


class ral_reg_SM3DATA_REG14 extends vmm_ral_reg;
	rand vmm_ral_field SM3DATA_REG14;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3DATA_REG14 = new(this, "SM3DATA_REG14", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3DATA_REG14


class ral_reg_SM3DATA_REG15 extends vmm_ral_reg;
	rand vmm_ral_field SM3DATA_REG15;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3DATA_REG15 = new(this, "SM3DATA_REG15", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3DATA_REG15


class ral_reg_SM3DATA_REG2 extends vmm_ral_reg;
	rand vmm_ral_field SM3DATA_REG2;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3DATA_REG2 = new(this, "SM3DATA_REG2", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3DATA_REG2


class ral_reg_SM3DATA_REG3 extends vmm_ral_reg;
	rand vmm_ral_field SM3DATA_REG3;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3DATA_REG3 = new(this, "SM3DATA_REG3", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3DATA_REG3


class ral_reg_SM3DATA_REG4 extends vmm_ral_reg;
	rand vmm_ral_field SM3DATA_REG4;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3DATA_REG4 = new(this, "SM3DATA_REG4", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3DATA_REG4


class ral_reg_SM3DATA_REG5 extends vmm_ral_reg;
	rand vmm_ral_field SM3DATA_REG5;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3DATA_REG5 = new(this, "SM3DATA_REG5", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3DATA_REG5


class ral_reg_SM3DATA_REG6 extends vmm_ral_reg;
	rand vmm_ral_field SM3DATA_REG6;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3DATA_REG6 = new(this, "SM3DATA_REG6", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3DATA_REG6


class ral_reg_SM3DATA_REG7 extends vmm_ral_reg;
	rand vmm_ral_field SM3DATA_REG7;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3DATA_REG7 = new(this, "SM3DATA_REG7", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3DATA_REG7


class ral_reg_SM3DATA_REG8 extends vmm_ral_reg;
	rand vmm_ral_field SM3DATA_REG8;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3DATA_REG8 = new(this, "SM3DATA_REG8", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3DATA_REG8


class ral_reg_SM3DATA_REG9 extends vmm_ral_reg;
	rand vmm_ral_field SM3DATA_REG9;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3DATA_REG9 = new(this, "SM3DATA_REG9", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3DATA_REG9


class ral_reg_SM3HASH_REG0 extends vmm_ral_reg;
	rand vmm_ral_field SM3HASH_REG0;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3HASH_REG0 = new(this, "SM3HASH_REG0", 32, vmm_ral::RO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3HASH_REG0


class ral_reg_SM3HASH_REG1 extends vmm_ral_reg;
	rand vmm_ral_field SM3HASH_REG1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3HASH_REG1 = new(this, "SM3HASH_REG1", 32, vmm_ral::RO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3HASH_REG1


class ral_reg_SM3HASH_REG2 extends vmm_ral_reg;
	rand vmm_ral_field SM3HASH_REG2;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3HASH_REG2 = new(this, "SM3HASH_REG2", 32, vmm_ral::RO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3HASH_REG2


class ral_reg_SM3HASH_REG3 extends vmm_ral_reg;
	rand vmm_ral_field SM3HASH_REG3;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3HASH_REG3 = new(this, "SM3HASH_REG3", 32, vmm_ral::RO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3HASH_REG3


class ral_reg_SM3HASH_REG4 extends vmm_ral_reg;
	rand vmm_ral_field SM3HASH_REG4;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3HASH_REG4 = new(this, "SM3HASH_REG4", 32, vmm_ral::RO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3HASH_REG4


class ral_reg_SM3HASH_REG5 extends vmm_ral_reg;
	rand vmm_ral_field SM3HASH_REG5;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3HASH_REG5 = new(this, "SM3HASH_REG5", 32, vmm_ral::RO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3HASH_REG5


class ral_reg_SM3HASH_REG6 extends vmm_ral_reg;
	rand vmm_ral_field SM3HASH_REG6;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3HASH_REG6 = new(this, "SM3HASH_REG6", 32, vmm_ral::RO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3HASH_REG6


class ral_reg_SM3HASH_REG7 extends vmm_ral_reg;
	rand vmm_ral_field SM3HASH_REG7;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SM3HASH_REG7 = new(this, "SM3HASH_REG7", 32, vmm_ral::RO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SM3HASH_REG7


class ral_block_SM3 extends vmm_ral_block;
	rand ral_reg_SM3CNTRL_REG SM3CNTRL_REG;
	rand ral_reg_SM3DATA_REG0 SM3DATA_REG0;
	rand ral_reg_SM3DATA_REG1 SM3DATA_REG1;
	rand ral_reg_SM3DATA_REG10 SM3DATA_REG10;
	rand ral_reg_SM3DATA_REG11 SM3DATA_REG11;
	rand ral_reg_SM3DATA_REG12 SM3DATA_REG12;
	rand ral_reg_SM3DATA_REG13 SM3DATA_REG13;
	rand ral_reg_SM3DATA_REG14 SM3DATA_REG14;
	rand ral_reg_SM3DATA_REG15 SM3DATA_REG15;
	rand ral_reg_SM3DATA_REG2 SM3DATA_REG2;
	rand ral_reg_SM3DATA_REG3 SM3DATA_REG3;
	rand ral_reg_SM3DATA_REG4 SM3DATA_REG4;
	rand ral_reg_SM3DATA_REG5 SM3DATA_REG5;
	rand ral_reg_SM3DATA_REG6 SM3DATA_REG6;
	rand ral_reg_SM3DATA_REG7 SM3DATA_REG7;
	rand ral_reg_SM3DATA_REG8 SM3DATA_REG8;
	rand ral_reg_SM3DATA_REG9 SM3DATA_REG9;
	rand ral_reg_SM3HASH_REG0 SM3HASH_REG0;
	rand ral_reg_SM3HASH_REG1 SM3HASH_REG1;
	rand ral_reg_SM3HASH_REG2 SM3HASH_REG2;
	rand ral_reg_SM3HASH_REG3 SM3HASH_REG3;
	rand ral_reg_SM3HASH_REG4 SM3HASH_REG4;
	rand ral_reg_SM3HASH_REG5 SM3HASH_REG5;
	rand ral_reg_SM3HASH_REG6 SM3HASH_REG6;
	rand ral_reg_SM3HASH_REG7 SM3HASH_REG7;
	rand vmm_ral_field SM3CNTRL_REG_sm3_start;
	rand vmm_ral_field sm3_start;
	rand vmm_ral_field SM3CNTRL_REG_hash_sel;
	rand vmm_ral_field hash_sel;
	rand vmm_ral_field SM3CNTRL_REG_first_group;
	rand vmm_ral_field first_group;
	rand vmm_ral_field SM3DATA_REG0_SM3DATA_REG0;
	rand vmm_ral_field SM3DATA_REG1_SM3DATA_REG1;
	rand vmm_ral_field SM3DATA_REG10_SM3DATA_REG10;
	rand vmm_ral_field SM3DATA_REG11_SM3DATA_REG11;
	rand vmm_ral_field SM3DATA_REG12_SM3DATA_REG12;
	rand vmm_ral_field SM3DATA_REG13_SM3DATA_REG13;
	rand vmm_ral_field SM3DATA_REG14_SM3DATA_REG14;
	rand vmm_ral_field SM3DATA_REG15_SM3DATA_REG15;
	rand vmm_ral_field SM3DATA_REG2_SM3DATA_REG2;
	rand vmm_ral_field SM3DATA_REG3_SM3DATA_REG3;
	rand vmm_ral_field SM3DATA_REG4_SM3DATA_REG4;
	rand vmm_ral_field SM3DATA_REG5_SM3DATA_REG5;
	rand vmm_ral_field SM3DATA_REG6_SM3DATA_REG6;
	rand vmm_ral_field SM3DATA_REG7_SM3DATA_REG7;
	rand vmm_ral_field SM3DATA_REG8_SM3DATA_REG8;
	rand vmm_ral_field SM3DATA_REG9_SM3DATA_REG9;
	rand vmm_ral_field SM3HASH_REG0_SM3HASH_REG0;
	rand vmm_ral_field SM3HASH_REG1_SM3HASH_REG1;
	rand vmm_ral_field SM3HASH_REG2_SM3HASH_REG2;
	rand vmm_ral_field SM3HASH_REG3_SM3HASH_REG3;
	rand vmm_ral_field SM3HASH_REG4_SM3HASH_REG4;
	rand vmm_ral_field SM3HASH_REG5_SM3HASH_REG5;
	rand vmm_ral_field SM3HASH_REG6_SM3HASH_REG6;
	rand vmm_ral_field SM3HASH_REG7_SM3HASH_REG7;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "SM3", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "SM3", 352, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on);
		this.SM3CNTRL_REG = new(this, "SM3CNTRL_REG", `VMM_RAL_ADDR_WIDTH'h0, "", cover_on, 2'b11, 0);
		this.SM3CNTRL_REG_sm3_start = this.SM3CNTRL_REG.sm3_start;
		this.sm3_start = this.SM3CNTRL_REG.sm3_start;
		this.SM3CNTRL_REG_hash_sel = this.SM3CNTRL_REG.hash_sel;
		this.hash_sel = this.SM3CNTRL_REG.hash_sel;
		this.SM3CNTRL_REG_first_group = this.SM3CNTRL_REG.first_group;
		this.first_group = this.SM3CNTRL_REG.first_group;
		this.SM3DATA_REG0 = new(this, "SM3DATA_REG0", `VMM_RAL_ADDR_WIDTH'h40, "", cover_on, 2'b11, 0);
		this.SM3DATA_REG0_SM3DATA_REG0 = this.SM3DATA_REG0.SM3DATA_REG0;
		this.SM3DATA_REG1 = new(this, "SM3DATA_REG1", `VMM_RAL_ADDR_WIDTH'h44, "", cover_on, 2'b11, 0);
		this.SM3DATA_REG1_SM3DATA_REG1 = this.SM3DATA_REG1.SM3DATA_REG1;
		this.SM3DATA_REG10 = new(this, "SM3DATA_REG10", `VMM_RAL_ADDR_WIDTH'h68, "", cover_on, 2'b11, 0);
		this.SM3DATA_REG10_SM3DATA_REG10 = this.SM3DATA_REG10.SM3DATA_REG10;
		this.SM3DATA_REG11 = new(this, "SM3DATA_REG11", `VMM_RAL_ADDR_WIDTH'h6C, "", cover_on, 2'b11, 0);
		this.SM3DATA_REG11_SM3DATA_REG11 = this.SM3DATA_REG11.SM3DATA_REG11;
		this.SM3DATA_REG12 = new(this, "SM3DATA_REG12", `VMM_RAL_ADDR_WIDTH'h70, "", cover_on, 2'b11, 0);
		this.SM3DATA_REG12_SM3DATA_REG12 = this.SM3DATA_REG12.SM3DATA_REG12;
		this.SM3DATA_REG13 = new(this, "SM3DATA_REG13", `VMM_RAL_ADDR_WIDTH'h74, "", cover_on, 2'b11, 0);
		this.SM3DATA_REG13_SM3DATA_REG13 = this.SM3DATA_REG13.SM3DATA_REG13;
		this.SM3DATA_REG14 = new(this, "SM3DATA_REG14", `VMM_RAL_ADDR_WIDTH'h78, "", cover_on, 2'b11, 0);
		this.SM3DATA_REG14_SM3DATA_REG14 = this.SM3DATA_REG14.SM3DATA_REG14;
		this.SM3DATA_REG15 = new(this, "SM3DATA_REG15", `VMM_RAL_ADDR_WIDTH'h7C, "", cover_on, 2'b11, 0);
		this.SM3DATA_REG15_SM3DATA_REG15 = this.SM3DATA_REG15.SM3DATA_REG15;
		this.SM3DATA_REG2 = new(this, "SM3DATA_REG2", `VMM_RAL_ADDR_WIDTH'h48, "", cover_on, 2'b11, 0);
		this.SM3DATA_REG2_SM3DATA_REG2 = this.SM3DATA_REG2.SM3DATA_REG2;
		this.SM3DATA_REG3 = new(this, "SM3DATA_REG3", `VMM_RAL_ADDR_WIDTH'h4C, "", cover_on, 2'b11, 0);
		this.SM3DATA_REG3_SM3DATA_REG3 = this.SM3DATA_REG3.SM3DATA_REG3;
		this.SM3DATA_REG4 = new(this, "SM3DATA_REG4", `VMM_RAL_ADDR_WIDTH'h50, "", cover_on, 2'b11, 0);
		this.SM3DATA_REG4_SM3DATA_REG4 = this.SM3DATA_REG4.SM3DATA_REG4;
		this.SM3DATA_REG5 = new(this, "SM3DATA_REG5", `VMM_RAL_ADDR_WIDTH'h54, "", cover_on, 2'b11, 0);
		this.SM3DATA_REG5_SM3DATA_REG5 = this.SM3DATA_REG5.SM3DATA_REG5;
		this.SM3DATA_REG6 = new(this, "SM3DATA_REG6", `VMM_RAL_ADDR_WIDTH'h58, "", cover_on, 2'b11, 0);
		this.SM3DATA_REG6_SM3DATA_REG6 = this.SM3DATA_REG6.SM3DATA_REG6;
		this.SM3DATA_REG7 = new(this, "SM3DATA_REG7", `VMM_RAL_ADDR_WIDTH'h5C, "", cover_on, 2'b11, 0);
		this.SM3DATA_REG7_SM3DATA_REG7 = this.SM3DATA_REG7.SM3DATA_REG7;
		this.SM3DATA_REG8 = new(this, "SM3DATA_REG8", `VMM_RAL_ADDR_WIDTH'h60, "", cover_on, 2'b11, 0);
		this.SM3DATA_REG8_SM3DATA_REG8 = this.SM3DATA_REG8.SM3DATA_REG8;
		this.SM3DATA_REG9 = new(this, "SM3DATA_REG9", `VMM_RAL_ADDR_WIDTH'h64, "", cover_on, 2'b11, 0);
		this.SM3DATA_REG9_SM3DATA_REG9 = this.SM3DATA_REG9.SM3DATA_REG9;
		this.SM3HASH_REG0 = new(this, "SM3HASH_REG0", `VMM_RAL_ADDR_WIDTH'h20, "", cover_on, 2'b11, 0);
		this.SM3HASH_REG0_SM3HASH_REG0 = this.SM3HASH_REG0.SM3HASH_REG0;
		this.SM3HASH_REG1 = new(this, "SM3HASH_REG1", `VMM_RAL_ADDR_WIDTH'h24, "", cover_on, 2'b11, 0);
		this.SM3HASH_REG1_SM3HASH_REG1 = this.SM3HASH_REG1.SM3HASH_REG1;
		this.SM3HASH_REG2 = new(this, "SM3HASH_REG2", `VMM_RAL_ADDR_WIDTH'h28, "", cover_on, 2'b11, 0);
		this.SM3HASH_REG2_SM3HASH_REG2 = this.SM3HASH_REG2.SM3HASH_REG2;
		this.SM3HASH_REG3 = new(this, "SM3HASH_REG3", `VMM_RAL_ADDR_WIDTH'h2C, "", cover_on, 2'b11, 0);
		this.SM3HASH_REG3_SM3HASH_REG3 = this.SM3HASH_REG3.SM3HASH_REG3;
		this.SM3HASH_REG4 = new(this, "SM3HASH_REG4", `VMM_RAL_ADDR_WIDTH'h30, "", cover_on, 2'b11, 0);
		this.SM3HASH_REG4_SM3HASH_REG4 = this.SM3HASH_REG4.SM3HASH_REG4;
		this.SM3HASH_REG5 = new(this, "SM3HASH_REG5", `VMM_RAL_ADDR_WIDTH'h34, "", cover_on, 2'b11, 0);
		this.SM3HASH_REG5_SM3HASH_REG5 = this.SM3HASH_REG5.SM3HASH_REG5;
		this.SM3HASH_REG6 = new(this, "SM3HASH_REG6", `VMM_RAL_ADDR_WIDTH'h38, "", cover_on, 2'b11, 0);
		this.SM3HASH_REG6_SM3HASH_REG6 = this.SM3HASH_REG6.SM3HASH_REG6;
		this.SM3HASH_REG7 = new(this, "SM3HASH_REG7", `VMM_RAL_ADDR_WIDTH'h3C, "", cover_on, 2'b11, 0);
		this.SM3HASH_REG7_SM3HASH_REG7 = this.SM3HASH_REG7.SM3HASH_REG7;
		this.Xlock_modelX();
	endfunction : new
endclass : ral_block_SM3


class ral_reg_CRCREG extends vmm_ral_reg;
	rand vmm_ral_field crcReg;
	rand vmm_ral_field crcflag;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.crcReg = new(this, "crcReg", 16, vmm_ral::RW, 'h0000, 16'hx, 0, 0, cvr);
		this.crcflag = new(this, "crcflag", 1, vmm_ral::RO, 'h0, 1'hx, 16, 0, cvr);
	endfunction: new
endclass : ral_reg_CRCREG


class ral_reg_CrcDataReg0 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg0;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg0 = new(this, "CrcDataReg0", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg0


class ral_reg_CrcDataReg1 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg1 = new(this, "CrcDataReg1", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg1


class ral_reg_CrcDataReg10 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg10;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg10 = new(this, "CrcDataReg10", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg10


class ral_reg_CrcDataReg11 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg11;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg11 = new(this, "CrcDataReg11", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg11


class ral_reg_CrcDataReg12 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg12;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg12 = new(this, "CrcDataReg12", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg12


class ral_reg_CrcDataReg13 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg13;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg13 = new(this, "CrcDataReg13", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg13


class ral_reg_CrcDataReg14 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg14;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg14 = new(this, "CrcDataReg14", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg14


class ral_reg_CrcDataReg15 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg15;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg15 = new(this, "CrcDataReg15", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg15


class ral_reg_CrcDataReg16 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg16;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg16 = new(this, "CrcDataReg16", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg16


class ral_reg_CrcDataReg17 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg17;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg17 = new(this, "CrcDataReg17", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg17


class ral_reg_CrcDataReg18 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg18;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg18 = new(this, "CrcDataReg18", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg18


class ral_reg_CrcDataReg19 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg19;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg19 = new(this, "CrcDataReg19", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg19


class ral_reg_CrcDataReg2 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg2;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg2 = new(this, "CrcDataReg2", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg2


class ral_reg_CrcDataReg20 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg20;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg20 = new(this, "CrcDataReg20", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg20


class ral_reg_CrcDataReg21 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg21;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg21 = new(this, "CrcDataReg21", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg21


class ral_reg_CrcDataReg22 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg22;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg22 = new(this, "CrcDataReg22", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg22


class ral_reg_CrcDataReg23 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg23;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg23 = new(this, "CrcDataReg23", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg23


class ral_reg_CrcDataReg24 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg24;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg24 = new(this, "CrcDataReg24", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg24


class ral_reg_CrcDataReg25 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg25;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg25 = new(this, "CrcDataReg25", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg25


class ral_reg_CrcDataReg26 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg26;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg26 = new(this, "CrcDataReg26", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg26


class ral_reg_CrcDataReg27 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg27;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg27 = new(this, "CrcDataReg27", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg27


class ral_reg_CrcDataReg28 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg28;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg28 = new(this, "CrcDataReg28", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg28


class ral_reg_CrcDataReg29 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg29;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg29 = new(this, "CrcDataReg29", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg29


class ral_reg_CrcDataReg3 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg3;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg3 = new(this, "CrcDataReg3", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg3


class ral_reg_CrcDataReg30 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg30;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg30 = new(this, "CrcDataReg30", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg30


class ral_reg_CrcDataReg31 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg31;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg31 = new(this, "CrcDataReg31", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg31


class ral_reg_CrcDataReg4 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg4;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg4 = new(this, "CrcDataReg4", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg4


class ral_reg_CrcDataReg5 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg5;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg5 = new(this, "CrcDataReg5", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg5


class ral_reg_CrcDataReg6 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg6;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg6 = new(this, "CrcDataReg6", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg6


class ral_reg_CrcDataReg7 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg7;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg7 = new(this, "CrcDataReg7", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg7


class ral_reg_CrcDataReg8 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg8;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg8 = new(this, "CrcDataReg8", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg8


class ral_reg_CrcDataReg9 extends vmm_ral_reg;
	rand vmm_ral_field CrcDataReg9;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CrcDataReg9 = new(this, "CrcDataReg9", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_CrcDataReg9


class ral_block_CRC extends vmm_ral_block;
	rand ral_reg_CRCREG CRCREG;
	rand ral_reg_CrcDataReg0 CrcDataReg0;
	rand ral_reg_CrcDataReg1 CrcDataReg1;
	rand ral_reg_CrcDataReg10 CrcDataReg10;
	rand ral_reg_CrcDataReg11 CrcDataReg11;
	rand ral_reg_CrcDataReg12 CrcDataReg12;
	rand ral_reg_CrcDataReg13 CrcDataReg13;
	rand ral_reg_CrcDataReg14 CrcDataReg14;
	rand ral_reg_CrcDataReg15 CrcDataReg15;
	rand ral_reg_CrcDataReg16 CrcDataReg16;
	rand ral_reg_CrcDataReg17 CrcDataReg17;
	rand ral_reg_CrcDataReg18 CrcDataReg18;
	rand ral_reg_CrcDataReg19 CrcDataReg19;
	rand ral_reg_CrcDataReg2 CrcDataReg2;
	rand ral_reg_CrcDataReg20 CrcDataReg20;
	rand ral_reg_CrcDataReg21 CrcDataReg21;
	rand ral_reg_CrcDataReg22 CrcDataReg22;
	rand ral_reg_CrcDataReg23 CrcDataReg23;
	rand ral_reg_CrcDataReg24 CrcDataReg24;
	rand ral_reg_CrcDataReg25 CrcDataReg25;
	rand ral_reg_CrcDataReg26 CrcDataReg26;
	rand ral_reg_CrcDataReg27 CrcDataReg27;
	rand ral_reg_CrcDataReg28 CrcDataReg28;
	rand ral_reg_CrcDataReg29 CrcDataReg29;
	rand ral_reg_CrcDataReg3 CrcDataReg3;
	rand ral_reg_CrcDataReg30 CrcDataReg30;
	rand ral_reg_CrcDataReg31 CrcDataReg31;
	rand ral_reg_CrcDataReg4 CrcDataReg4;
	rand ral_reg_CrcDataReg5 CrcDataReg5;
	rand ral_reg_CrcDataReg6 CrcDataReg6;
	rand ral_reg_CrcDataReg7 CrcDataReg7;
	rand ral_reg_CrcDataReg8 CrcDataReg8;
	rand ral_reg_CrcDataReg9 CrcDataReg9;
	rand vmm_ral_field CRCREG_crcReg;
	rand vmm_ral_field crcReg;
	rand vmm_ral_field CRCREG_crcflag;
	rand vmm_ral_field crcflag;
	rand vmm_ral_field CrcDataReg0_CrcDataReg0;
	rand vmm_ral_field CrcDataReg1_CrcDataReg1;
	rand vmm_ral_field CrcDataReg10_CrcDataReg10;
	rand vmm_ral_field CrcDataReg11_CrcDataReg11;
	rand vmm_ral_field CrcDataReg12_CrcDataReg12;
	rand vmm_ral_field CrcDataReg13_CrcDataReg13;
	rand vmm_ral_field CrcDataReg14_CrcDataReg14;
	rand vmm_ral_field CrcDataReg15_CrcDataReg15;
	rand vmm_ral_field CrcDataReg16_CrcDataReg16;
	rand vmm_ral_field CrcDataReg17_CrcDataReg17;
	rand vmm_ral_field CrcDataReg18_CrcDataReg18;
	rand vmm_ral_field CrcDataReg19_CrcDataReg19;
	rand vmm_ral_field CrcDataReg2_CrcDataReg2;
	rand vmm_ral_field CrcDataReg20_CrcDataReg20;
	rand vmm_ral_field CrcDataReg21_CrcDataReg21;
	rand vmm_ral_field CrcDataReg22_CrcDataReg22;
	rand vmm_ral_field CrcDataReg23_CrcDataReg23;
	rand vmm_ral_field CrcDataReg24_CrcDataReg24;
	rand vmm_ral_field CrcDataReg25_CrcDataReg25;
	rand vmm_ral_field CrcDataReg26_CrcDataReg26;
	rand vmm_ral_field CrcDataReg27_CrcDataReg27;
	rand vmm_ral_field CrcDataReg28_CrcDataReg28;
	rand vmm_ral_field CrcDataReg29_CrcDataReg29;
	rand vmm_ral_field CrcDataReg3_CrcDataReg3;
	rand vmm_ral_field CrcDataReg30_CrcDataReg30;
	rand vmm_ral_field CrcDataReg31_CrcDataReg31;
	rand vmm_ral_field CrcDataReg4_CrcDataReg4;
	rand vmm_ral_field CrcDataReg5_CrcDataReg5;
	rand vmm_ral_field CrcDataReg6_CrcDataReg6;
	rand vmm_ral_field CrcDataReg7_CrcDataReg7;
	rand vmm_ral_field CrcDataReg8_CrcDataReg8;
	rand vmm_ral_field CrcDataReg9_CrcDataReg9;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "CRC", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "CRC", 768, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on);
		this.CRCREG = new(this, "CRCREG", `VMM_RAL_ADDR_WIDTH'h4, "", cover_on, 2'b11, 0);
		this.CRCREG_crcReg = this.CRCREG.crcReg;
		this.crcReg = this.CRCREG.crcReg;
		this.CRCREG_crcflag = this.CRCREG.crcflag;
		this.crcflag = this.CRCREG.crcflag;
		this.CrcDataReg0 = new(this, "CrcDataReg0", `VMM_RAL_ADDR_WIDTH'h80, "", cover_on, 2'b11, 0);
		this.CrcDataReg0_CrcDataReg0 = this.CrcDataReg0.CrcDataReg0;
		this.CrcDataReg1 = new(this, "CrcDataReg1", `VMM_RAL_ADDR_WIDTH'h84, "", cover_on, 2'b11, 0);
		this.CrcDataReg1_CrcDataReg1 = this.CrcDataReg1.CrcDataReg1;
		this.CrcDataReg10 = new(this, "CrcDataReg10", `VMM_RAL_ADDR_WIDTH'hA8, "", cover_on, 2'b11, 0);
		this.CrcDataReg10_CrcDataReg10 = this.CrcDataReg10.CrcDataReg10;
		this.CrcDataReg11 = new(this, "CrcDataReg11", `VMM_RAL_ADDR_WIDTH'hAC, "", cover_on, 2'b11, 0);
		this.CrcDataReg11_CrcDataReg11 = this.CrcDataReg11.CrcDataReg11;
		this.CrcDataReg12 = new(this, "CrcDataReg12", `VMM_RAL_ADDR_WIDTH'hB0, "", cover_on, 2'b11, 0);
		this.CrcDataReg12_CrcDataReg12 = this.CrcDataReg12.CrcDataReg12;
		this.CrcDataReg13 = new(this, "CrcDataReg13", `VMM_RAL_ADDR_WIDTH'hB4, "", cover_on, 2'b11, 0);
		this.CrcDataReg13_CrcDataReg13 = this.CrcDataReg13.CrcDataReg13;
		this.CrcDataReg14 = new(this, "CrcDataReg14", `VMM_RAL_ADDR_WIDTH'hB8, "", cover_on, 2'b11, 0);
		this.CrcDataReg14_CrcDataReg14 = this.CrcDataReg14.CrcDataReg14;
		this.CrcDataReg15 = new(this, "CrcDataReg15", `VMM_RAL_ADDR_WIDTH'hBC, "", cover_on, 2'b11, 0);
		this.CrcDataReg15_CrcDataReg15 = this.CrcDataReg15.CrcDataReg15;
		this.CrcDataReg16 = new(this, "CrcDataReg16", `VMM_RAL_ADDR_WIDTH'hC0, "", cover_on, 2'b11, 0);
		this.CrcDataReg16_CrcDataReg16 = this.CrcDataReg16.CrcDataReg16;
		this.CrcDataReg17 = new(this, "CrcDataReg17", `VMM_RAL_ADDR_WIDTH'hC4, "", cover_on, 2'b11, 0);
		this.CrcDataReg17_CrcDataReg17 = this.CrcDataReg17.CrcDataReg17;
		this.CrcDataReg18 = new(this, "CrcDataReg18", `VMM_RAL_ADDR_WIDTH'hC8, "", cover_on, 2'b11, 0);
		this.CrcDataReg18_CrcDataReg18 = this.CrcDataReg18.CrcDataReg18;
		this.CrcDataReg19 = new(this, "CrcDataReg19", `VMM_RAL_ADDR_WIDTH'hCC, "", cover_on, 2'b11, 0);
		this.CrcDataReg19_CrcDataReg19 = this.CrcDataReg19.CrcDataReg19;
		this.CrcDataReg2 = new(this, "CrcDataReg2", `VMM_RAL_ADDR_WIDTH'h88, "", cover_on, 2'b11, 0);
		this.CrcDataReg2_CrcDataReg2 = this.CrcDataReg2.CrcDataReg2;
		this.CrcDataReg20 = new(this, "CrcDataReg20", `VMM_RAL_ADDR_WIDTH'hD0, "", cover_on, 2'b11, 0);
		this.CrcDataReg20_CrcDataReg20 = this.CrcDataReg20.CrcDataReg20;
		this.CrcDataReg21 = new(this, "CrcDataReg21", `VMM_RAL_ADDR_WIDTH'hD4, "", cover_on, 2'b11, 0);
		this.CrcDataReg21_CrcDataReg21 = this.CrcDataReg21.CrcDataReg21;
		this.CrcDataReg22 = new(this, "CrcDataReg22", `VMM_RAL_ADDR_WIDTH'hD8, "", cover_on, 2'b11, 0);
		this.CrcDataReg22_CrcDataReg22 = this.CrcDataReg22.CrcDataReg22;
		this.CrcDataReg23 = new(this, "CrcDataReg23", `VMM_RAL_ADDR_WIDTH'hDC, "", cover_on, 2'b11, 0);
		this.CrcDataReg23_CrcDataReg23 = this.CrcDataReg23.CrcDataReg23;
		this.CrcDataReg24 = new(this, "CrcDataReg24", `VMM_RAL_ADDR_WIDTH'hE0, "", cover_on, 2'b11, 0);
		this.CrcDataReg24_CrcDataReg24 = this.CrcDataReg24.CrcDataReg24;
		this.CrcDataReg25 = new(this, "CrcDataReg25", `VMM_RAL_ADDR_WIDTH'hE4, "", cover_on, 2'b11, 0);
		this.CrcDataReg25_CrcDataReg25 = this.CrcDataReg25.CrcDataReg25;
		this.CrcDataReg26 = new(this, "CrcDataReg26", `VMM_RAL_ADDR_WIDTH'hE8, "", cover_on, 2'b11, 0);
		this.CrcDataReg26_CrcDataReg26 = this.CrcDataReg26.CrcDataReg26;
		this.CrcDataReg27 = new(this, "CrcDataReg27", `VMM_RAL_ADDR_WIDTH'hEC, "", cover_on, 2'b11, 0);
		this.CrcDataReg27_CrcDataReg27 = this.CrcDataReg27.CrcDataReg27;
		this.CrcDataReg28 = new(this, "CrcDataReg28", `VMM_RAL_ADDR_WIDTH'hF0, "", cover_on, 2'b11, 0);
		this.CrcDataReg28_CrcDataReg28 = this.CrcDataReg28.CrcDataReg28;
		this.CrcDataReg29 = new(this, "CrcDataReg29", `VMM_RAL_ADDR_WIDTH'hF4, "", cover_on, 2'b11, 0);
		this.CrcDataReg29_CrcDataReg29 = this.CrcDataReg29.CrcDataReg29;
		this.CrcDataReg3 = new(this, "CrcDataReg3", `VMM_RAL_ADDR_WIDTH'h8C, "", cover_on, 2'b11, 0);
		this.CrcDataReg3_CrcDataReg3 = this.CrcDataReg3.CrcDataReg3;
		this.CrcDataReg30 = new(this, "CrcDataReg30", `VMM_RAL_ADDR_WIDTH'hF8, "", cover_on, 2'b11, 0);
		this.CrcDataReg30_CrcDataReg30 = this.CrcDataReg30.CrcDataReg30;
		this.CrcDataReg31 = new(this, "CrcDataReg31", `VMM_RAL_ADDR_WIDTH'hFC, "", cover_on, 2'b11, 0);
		this.CrcDataReg31_CrcDataReg31 = this.CrcDataReg31.CrcDataReg31;
		this.CrcDataReg4 = new(this, "CrcDataReg4", `VMM_RAL_ADDR_WIDTH'h90, "", cover_on, 2'b11, 0);
		this.CrcDataReg4_CrcDataReg4 = this.CrcDataReg4.CrcDataReg4;
		this.CrcDataReg5 = new(this, "CrcDataReg5", `VMM_RAL_ADDR_WIDTH'h94, "", cover_on, 2'b11, 0);
		this.CrcDataReg5_CrcDataReg5 = this.CrcDataReg5.CrcDataReg5;
		this.CrcDataReg6 = new(this, "CrcDataReg6", `VMM_RAL_ADDR_WIDTH'h98, "", cover_on, 2'b11, 0);
		this.CrcDataReg6_CrcDataReg6 = this.CrcDataReg6.CrcDataReg6;
		this.CrcDataReg7 = new(this, "CrcDataReg7", `VMM_RAL_ADDR_WIDTH'h9C, "", cover_on, 2'b11, 0);
		this.CrcDataReg7_CrcDataReg7 = this.CrcDataReg7.CrcDataReg7;
		this.CrcDataReg8 = new(this, "CrcDataReg8", `VMM_RAL_ADDR_WIDTH'hA0, "", cover_on, 2'b11, 0);
		this.CrcDataReg8_CrcDataReg8 = this.CrcDataReg8.CrcDataReg8;
		this.CrcDataReg9 = new(this, "CrcDataReg9", `VMM_RAL_ADDR_WIDTH'hA4, "", cover_on, 2'b11, 0);
		this.CrcDataReg9_CrcDataReg9 = this.CrcDataReg9.CrcDataReg9;
		this.Xlock_modelX();
	endfunction : new
endclass : ral_block_CRC


class ral_reg_RECR extends vmm_ral_reg;
	rand vmm_ral_field rsa_start;
	rand vmm_ral_field idle_run;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.rsa_start = new(this, "rsa_start", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.idle_run = new(this, "idle_run", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
	endfunction: new
endclass : ral_reg_RECR


class ral_reg_REDAR extends vmm_ral_reg;
	rand vmm_ral_field REDAR;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.REDAR = new(this, "REDAR", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_REDAR


class ral_reg_REDAR31 extends vmm_ral_reg;
	rand vmm_ral_field REDAR31;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.REDAR31 = new(this, "REDAR31", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_REDAR31


class ral_reg_REDBR extends vmm_ral_reg;
	rand vmm_ral_field REDBR;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.REDBR = new(this, "REDBR", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_REDBR


class ral_reg_REDBR31 extends vmm_ral_reg;
	rand vmm_ral_field REDBR31;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.REDBR31 = new(this, "REDBR31", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_REDBR31


class ral_reg_REDCR extends vmm_ral_reg;
	rand vmm_ral_field REDBR;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.REDBR = new(this, "REDBR", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_REDCR


class ral_reg_REDCR31 extends vmm_ral_reg;
	rand vmm_ral_field REDCR31;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.REDCR31 = new(this, "REDCR31", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_REDCR31


class ral_reg_REDPR extends vmm_ral_reg;
	rand vmm_ral_field REDPR;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.REDPR = new(this, "REDPR", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_REDPR


class ral_reg_REDPR31 extends vmm_ral_reg;
	rand vmm_ral_field REDPR31;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.REDPR31 = new(this, "REDPR31", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_REDPR31


class ral_reg_REDQR extends vmm_ral_reg;
	rand vmm_ral_field REDQR;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.REDQR = new(this, "REDQR", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_REDQR


class ral_reg_REDUR extends vmm_ral_reg;
	rand vmm_ral_field REDUR;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.REDUR = new(this, "REDUR", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_REDUR


class ral_reg_REDUR31 extends vmm_ral_reg;
	rand vmm_ral_field REDUR31;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.REDUR31 = new(this, "REDUR31", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_REDUR31


class ral_reg_REDVR extends vmm_ral_reg;
	rand vmm_ral_field REDVR;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.REDVR = new(this, "REDVR", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_REDVR


class ral_reg_REDVR31 extends vmm_ral_reg;
	rand vmm_ral_field REDVR31;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.REDVR31 = new(this, "REDVR31", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_REDVR31


class ral_reg_REDXR extends vmm_ral_reg;
	rand vmm_ral_field REDXR;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.REDXR = new(this, "REDXR", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_REDXR


class ral_reg_REDXR31 extends vmm_ral_reg;
	rand vmm_ral_field REDXR31;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.REDXR31 = new(this, "REDXR31", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_REDXR31


class ral_reg_REDYR extends vmm_ral_reg;
	rand vmm_ral_field REDBR;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.REDBR = new(this, "REDBR", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_REDYR


class ral_reg_REDYR31 extends vmm_ral_reg;
	rand vmm_ral_field REDYR31;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.REDYR31 = new(this, "REDYR31", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_REDYR31


class ral_reg_REFR extends vmm_ral_reg;
	rand vmm_ral_field Function_ID;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Function_ID = new(this, "Function_ID", 8, vmm_ral::RW, 'h0, 8'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_REFR


class ral_reg_REINT extends vmm_ral_reg;
	rand vmm_ral_field RSA_int;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.RSA_int = new(this, "RSA_int", 1, vmm_ral::W1C, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_REINT


class ral_reg_RESCR extends vmm_ral_reg;
	rand vmm_ral_field Fix_time;
	rand vmm_ral_field Rnd_multi;
	rand vmm_ral_field Extra_exp;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Fix_time = new(this, "Fix_time", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.Rnd_multi = new(this, "Rnd_multi", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
		this.Extra_exp = new(this, "Extra_exp", 1, vmm_ral::RW, 'h0, 1'hx, 2, 0, cvr);
	endfunction: new
endclass : ral_reg_RESCR


class ral_reg_RESR extends vmm_ral_reg;
	rand vmm_ral_field Error_flag;
	rand vmm_ral_field Overflow;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Error_flag = new(this, "Error_flag", 1, vmm_ral::RO, 'h0, 1'hx, 0, 0, cvr);
		this.Overflow = new(this, "Overflow", 1, vmm_ral::RO, 'h0, 1'hx, 1, 0, cvr);
	endfunction: new
endclass : ral_reg_RESR


class ral_block_RSA extends vmm_ral_block;
	rand ral_reg_RECR RECR;
	rand ral_reg_REDAR REDAR;
	rand ral_reg_REDAR31 REDAR31;
	rand ral_reg_REDBR REDBR;
	rand ral_reg_REDBR31 REDBR31;
	rand ral_reg_REDCR REDCR;
	rand ral_reg_REDCR31 REDCR31;
	rand ral_reg_REDPR REDPR;
	rand ral_reg_REDPR31 REDPR31;
	rand ral_reg_REDQR REDQR;
	rand ral_reg_REDUR REDUR;
	rand ral_reg_REDUR31 REDUR31;
	rand ral_reg_REDVR REDVR;
	rand ral_reg_REDVR31 REDVR31;
	rand ral_reg_REDXR REDXR;
	rand ral_reg_REDXR31 REDXR31;
	rand ral_reg_REDYR REDYR;
	rand ral_reg_REDYR31 REDYR31;
	rand ral_reg_REFR REFR;
	rand ral_reg_REINT REINT;
	rand ral_reg_RESCR RESCR;
	rand ral_reg_RESR RESR;
	rand vmm_ral_field RECR_rsa_start;
	rand vmm_ral_field rsa_start;
	rand vmm_ral_field RECR_idle_run;
	rand vmm_ral_field idle_run;
	rand vmm_ral_field REDAR_REDAR;
	rand vmm_ral_field REDAR31_REDAR31;
	rand vmm_ral_field REDBR_REDBR;
	rand vmm_ral_field REDBR31_REDBR31;
	rand vmm_ral_field REDCR_REDBR;
	rand vmm_ral_field REDCR31_REDCR31;
	rand vmm_ral_field REDPR_REDPR;
	rand vmm_ral_field REDPR31_REDPR31;
	rand vmm_ral_field REDQR_REDQR;
	rand vmm_ral_field REDUR_REDUR;
	rand vmm_ral_field REDUR31_REDUR31;
	rand vmm_ral_field REDVR_REDVR;
	rand vmm_ral_field REDVR31_REDVR31;
	rand vmm_ral_field REDXR_REDXR;
	rand vmm_ral_field REDXR31_REDXR31;
	rand vmm_ral_field REDYR_REDBR;
	rand vmm_ral_field REDYR31_REDYR31;
	rand vmm_ral_field REFR_Function_ID;
	rand vmm_ral_field Function_ID;
	rand vmm_ral_field REINT_RSA_int;
	rand vmm_ral_field RSA_int;
	rand vmm_ral_field RESCR_Fix_time;
	rand vmm_ral_field Fix_time;
	rand vmm_ral_field RESCR_Rnd_multi;
	rand vmm_ral_field Rnd_multi;
	rand vmm_ral_field RESCR_Extra_exp;
	rand vmm_ral_field Extra_exp;
	rand vmm_ral_field RESR_Error_flag;
	rand vmm_ral_field Error_flag;
	rand vmm_ral_field RESR_Overflow;
	rand vmm_ral_field Overflow;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "RSA", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "RSA", 4096, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on);
		this.RECR = new(this, "RECR", `VMM_RAL_ADDR_WIDTH'h0, "", cover_on, 2'b11, 0);
		this.RECR_rsa_start = this.RECR.rsa_start;
		this.rsa_start = this.RECR.rsa_start;
		this.RECR_idle_run = this.RECR.idle_run;
		this.idle_run = this.RECR.idle_run;
		this.REDAR = new(this, "REDAR", `VMM_RAL_ADDR_WIDTH'h100, "", cover_on, 2'b11, 0);
		this.REDAR_REDAR = this.REDAR.REDAR;
		this.REDAR31 = new(this, "REDAR31", `VMM_RAL_ADDR_WIDTH'h17C, "", cover_on, 2'b11, 0);
		this.REDAR31_REDAR31 = this.REDAR31.REDAR31;
		this.REDBR = new(this, "REDBR", `VMM_RAL_ADDR_WIDTH'h200, "", cover_on, 2'b11, 0);
		this.REDBR_REDBR = this.REDBR.REDBR;
		this.REDBR31 = new(this, "REDBR31", `VMM_RAL_ADDR_WIDTH'h27C, "", cover_on, 2'b11, 0);
		this.REDBR31_REDBR31 = this.REDBR31.REDBR31;
		this.REDCR = new(this, "REDCR", `VMM_RAL_ADDR_WIDTH'h300, "", cover_on, 2'b11, 0);
		this.REDCR_REDBR = this.REDCR.REDBR;
		this.REDCR31 = new(this, "REDCR31", `VMM_RAL_ADDR_WIDTH'h3FC, "", cover_on, 2'b11, 0);
		this.REDCR31_REDCR31 = this.REDCR31.REDCR31;
		this.REDPR = new(this, "REDPR", `VMM_RAL_ADDR_WIDTH'h400, "", cover_on, 2'b11, 0);
		this.REDPR_REDPR = this.REDPR.REDPR;
		this.REDPR31 = new(this, "REDPR31", `VMM_RAL_ADDR_WIDTH'h4FC, "", cover_on, 2'b11, 0);
		this.REDPR31_REDPR31 = this.REDPR31.REDPR31;
		this.REDQR = new(this, "REDQR", `VMM_RAL_ADDR_WIDTH'h10, "", cover_on, 2'b11, 0);
		this.REDQR_REDQR = this.REDQR.REDQR;
		this.REDUR = new(this, "REDUR", `VMM_RAL_ADDR_WIDTH'h500, "", cover_on, 2'b11, 0);
		this.REDUR_REDUR = this.REDUR.REDUR;
		this.REDUR31 = new(this, "REDUR31", `VMM_RAL_ADDR_WIDTH'h5FC, "", cover_on, 2'b11, 0);
		this.REDUR31_REDUR31 = this.REDUR31.REDUR31;
		this.REDVR = new(this, "REDVR", `VMM_RAL_ADDR_WIDTH'h600, "", cover_on, 2'b11, 0);
		this.REDVR_REDVR = this.REDVR.REDVR;
		this.REDVR31 = new(this, "REDVR31", `VMM_RAL_ADDR_WIDTH'h67C, "", cover_on, 2'b11, 0);
		this.REDVR31_REDVR31 = this.REDVR31.REDVR31;
		this.REDXR = new(this, "REDXR", `VMM_RAL_ADDR_WIDTH'h180, "", cover_on, 2'b11, 0);
		this.REDXR_REDXR = this.REDXR.REDXR;
		this.REDXR31 = new(this, "REDXR31", `VMM_RAL_ADDR_WIDTH'h1FC, "", cover_on, 2'b11, 0);
		this.REDXR31_REDXR31 = this.REDXR31.REDXR31;
		this.REDYR = new(this, "REDYR", `VMM_RAL_ADDR_WIDTH'h280, "", cover_on, 2'b11, 0);
		this.REDYR_REDBR = this.REDYR.REDBR;
		this.REDYR31 = new(this, "REDYR31", `VMM_RAL_ADDR_WIDTH'h2FC, "", cover_on, 2'b11, 0);
		this.REDYR31_REDYR31 = this.REDYR31.REDYR31;
		this.REFR = new(this, "REFR", `VMM_RAL_ADDR_WIDTH'h8, "", cover_on, 2'b11, 0);
		this.REFR_Function_ID = this.REFR.Function_ID;
		this.Function_ID = this.REFR.Function_ID;
		this.REINT = new(this, "REINT", `VMM_RAL_ADDR_WIDTH'h14, "", cover_on, 2'b11, 0);
		this.REINT_RSA_int = this.REINT.RSA_int;
		this.RSA_int = this.REINT.RSA_int;
		this.RESCR = new(this, "RESCR", `VMM_RAL_ADDR_WIDTH'hC, "", cover_on, 2'b11, 0);
		this.RESCR_Fix_time = this.RESCR.Fix_time;
		this.Fix_time = this.RESCR.Fix_time;
		this.RESCR_Rnd_multi = this.RESCR.Rnd_multi;
		this.Rnd_multi = this.RESCR.Rnd_multi;
		this.RESCR_Extra_exp = this.RESCR.Extra_exp;
		this.Extra_exp = this.RESCR.Extra_exp;
		this.RESR = new(this, "RESR", `VMM_RAL_ADDR_WIDTH'h4, "", cover_on, 2'b11, 0);
		this.RESR_Error_flag = this.RESR.Error_flag;
		this.Error_flag = this.RESR.Error_flag;
		this.RESR_Overflow = this.RESR.Overflow;
		this.Overflow = this.RESR.Overflow;
		this.Xlock_modelX();
	endfunction : new
endclass : ral_block_RSA


class ral_reg_ClkClsReg extends vmm_ral_reg;
	rand vmm_ral_field Secure_cls;
	rand vmm_ral_field int_cls;
	rand vmm_ral_field rng_cls;
	rand vmm_ral_field crc_cls;
	rand vmm_ral_field timer_cls;
	rand vmm_ral_field wdt_cls;
	rand vmm_ral_field eectrl_cls;
	rand vmm_ral_field rf_cls;
	rand vmm_ral_field des_cls;
	rand vmm_ral_field rsa_cls;
	rand vmm_ral_field ssf33_cls;
	rand vmm_ral_field gpio_cls;
	rand vmm_ral_field sci7816;
	rand vmm_ral_field sm1_cls;
	rand vmm_ral_field sm3_cls;
	rand vmm_ral_field sm7_cls;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Secure_cls = new(this, "Secure_cls", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.int_cls = new(this, "int_cls", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
		this.rng_cls = new(this, "rng_cls", 1, vmm_ral::RW, 'h0, 1'hx, 2, 0, cvr);
		this.crc_cls = new(this, "crc_cls", 1, vmm_ral::RW, 'h1, 1'hx, 3, 0, cvr);
		this.timer_cls = new(this, "timer_cls", 1, vmm_ral::RW, 'h0, 1'hx, 4, 0, cvr);
		this.wdt_cls = new(this, "wdt_cls", 1, vmm_ral::RW, 'h0, 1'hx, 5, 0, cvr);
		this.eectrl_cls = new(this, "eectrl_cls", 1, vmm_ral::RW, 'h0, 1'hx, 6, 0, cvr);
		this.rf_cls = new(this, "rf_cls", 1, vmm_ral::RW, 'h0, 1'hx, 7, 0, cvr);
		this.des_cls = new(this, "des_cls", 1, vmm_ral::RW, 'h1, 1'hx, 8, 0, cvr);
		this.rsa_cls = new(this, "rsa_cls", 1, vmm_ral::RW, 'h1, 1'hx, 9, 0, cvr);
		this.ssf33_cls = new(this, "ssf33_cls", 1, vmm_ral::RW, 'h1, 1'hx, 10, 0, cvr);
		this.gpio_cls = new(this, "gpio_cls", 1, vmm_ral::RW, 'h0, 1'hx, 11, 0, cvr);
		this.sci7816 = new(this, "sci7816", 1, vmm_ral::RW, 'h0, 1'hx, 12, 0, cvr);
		this.sm1_cls = new(this, "sm1_cls", 1, vmm_ral::RW, 'h1, 1'hx, 13, 0, cvr);
		this.sm3_cls = new(this, "sm3_cls", 1, vmm_ral::RW, 'h1, 1'hx, 14, 0, cvr);
		this.sm7_cls = new(this, "sm7_cls", 1, vmm_ral::RW, 'h1, 1'hx, 15, 0, cvr);
	endfunction: new
endclass : ral_reg_ClkClsReg


class ral_reg_ClkRsaSelReg extends vmm_ral_reg;
	rand vmm_ral_field clkRsaSel;
	rand vmm_ral_field Clktime1sel;
	rand vmm_ral_field Clktime2sel;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.clkRsaSel = new(this, "clkRsaSel", 4, vmm_ral::RW, 'h0, 4'hx, 0, 0, cvr);
		this.Clktime1sel = new(this, "Clktime1sel", 2, vmm_ral::RW, 'h0, 2'hx, 4, 0, cvr);
		this.Clktime2sel = new(this, "Clktime2sel", 2, vmm_ral::RW, 'h0, 2'hx, 6, 0, cvr);
	endfunction: new
endclass : ral_reg_ClkRsaSelReg


class ral_reg_ClkTestReg extends vmm_ral_reg;
	rand vmm_ral_field Testrun;
	rand vmm_ral_field VCO_Count;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Testrun = new(this, "Testrun", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.VCO_Count = new(this, "VCO_Count", 12, vmm_ral::RW, 'h0, 12'hx, 8, 0, cvr);
	endfunction: new
endclass : ral_reg_ClkTestReg


class ral_reg_ClkVcoConReg extends vmm_ral_reg;
	rand vmm_ral_field vcoclk_en;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.vcoclk_en = new(this, "vcoclk_en", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_ClkVcoConReg


class ral_reg_ClkselReg extends vmm_ral_reg;
	rand vmm_ral_field Clksel;
	rand vmm_ral_field clkavailcl;
	rand vmm_ral_field clkavailcb;
	rand vmm_ral_field ClkPrior;
	rand vmm_ral_field Clkmaskcl;
	rand vmm_ral_field clkmaskcb;
	rand vmm_ral_field clkmaskps;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Clksel = new(this, "Clksel", 2, vmm_ral::RO, 'h0, 2'hx, 0, 0, cvr);
		this.clkavailcl = new(this, "clkavailcl", 1, vmm_ral::RO, 'h1, 1'hx, 2, 0, cvr);
		this.clkavailcb = new(this, "clkavailcb", 1, vmm_ral::RO, 'h1, 1'hx, 3, 0, cvr);
		this.ClkPrior = new(this, "ClkPrior", 2, vmm_ral::RW, 'h0, 2'hx, 4, 0, cvr);
		this.Clkmaskcl = new(this, "Clkmaskcl", 1, vmm_ral::RW, 'h0, 1'hx, 6, 0, cvr);
		this.clkmaskcb = new(this, "clkmaskcb", 1, vmm_ral::RW, 'h0, 1'hx, 7, 0, cvr);
		this.clkmaskps = new(this, "clkmaskps", 1, vmm_ral::RW, 'h0, 1'hx, 8, 0, cvr);
	endfunction: new
endclass : ral_reg_ClkselReg


class ral_reg_DrvParaReg0 extends vmm_ral_reg;
	rand vmm_ral_field DrvParaReg0;
	rand vmm_ral_field RFD_HDET_CON;
	rand vmm_ral_field RFD_LIMIT_EN;
	rand vmm_ral_field RFD_LIMIT_CON;
	rand vmm_ral_field VDOPT;
	rand vmm_ral_field LDOPT;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.DrvParaReg0 = new(this, "DrvParaReg0", 8, vmm_ral::RW, 'h0, 8'hx, 0, 0, cvr);
		this.RFD_HDET_CON = new(this, "RFD_HDET_CON", 4, vmm_ral::RW, 'ha, 4'hx, 8, 0, cvr);
		this.RFD_LIMIT_EN = new(this, "RFD_LIMIT_EN", 3, vmm_ral::RW, 'h7, 3'hx, 12, 0, cvr);
		this.RFD_LIMIT_CON = new(this, "RFD_LIMIT_CON", 6, vmm_ral::RW, 'h2a, 6'hx, 15, 0, cvr);
		this.VDOPT = new(this, "VDOPT", 4, vmm_ral::RW, 'h3, 4'hx, 21, 0, cvr);
		this.LDOPT = new(this, "LDOPT", 7, vmm_ral::RW, 'h1, 7'hx, 25, 0, cvr);
	endfunction: new
endclass : ral_reg_DrvParaReg0


class ral_reg_DrvParaReg1 extends vmm_ral_reg;
	rand vmm_ral_field PMV11_PMOPT;
	rand vmm_ral_field ATV11_EN_OPT;
	rand vmm_ral_field ATV11_AA_OPT;
	rand vmm_ral_field ATV11_DA_OPT;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.PMV11_PMOPT = new(this, "PMV11_PMOPT", 16, vmm_ral::RW, 'h0, 16'hx, 0, 0, cvr);
		this.ATV11_EN_OPT = new(this, "ATV11_EN_OPT", 1, vmm_ral::RW, 'h1, 1'hx, 16, 0, cvr);
		this.ATV11_AA_OPT = new(this, "ATV11_AA_OPT", 4, vmm_ral::RW, 'h0, 4'hx, 17, 0, cvr);
		this.ATV11_DA_OPT = new(this, "ATV11_DA_OPT", 4, vmm_ral::RW, 'h0, 4'hx, 21, 0, cvr);
	endfunction: new
endclass : ral_reg_DrvParaReg1


class ral_reg_DrvParaReg2 extends vmm_ral_reg;
	rand vmm_ral_field VCO_30m_q;
	rand vmm_ral_field TD_OPT;
	rand vmm_ral_field EEIREFSEL;
	rand vmm_ral_field EEVREFSEL;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.VCO_30m_q = new(this, "VCO_30m_q", 4, vmm_ral::RW, 'h04, 4'hx, 0, 0, cvr);
		this.TD_OPT = new(this, "TD_OPT", 4, vmm_ral::RW, 'h05, 4'hx, 4, 0, cvr);
		this.EEIREFSEL = new(this, "EEIREFSEL", 2, vmm_ral::RW, 'h0, 2'hx, 8, 0, cvr);
		this.EEVREFSEL = new(this, "EEVREFSEL", 2, vmm_ral::RW, 'h0, 2'hx, 10, 0, cvr);
	endfunction: new
endclass : ral_reg_DrvParaReg2


class ral_reg_DrvParaReg3 extends vmm_ral_reg;
	rand vmm_ral_field DrvParaReg3;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.DrvParaReg3 = new(this, "DrvParaReg3", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_DrvParaReg3


class ral_reg_DrvParaReg4 extends vmm_ral_reg;
	rand vmm_ral_field DrvParaReg4;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.DrvParaReg4 = new(this, "DrvParaReg4", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_DrvParaReg4


class ral_reg_DrvParaReg5 extends vmm_ral_reg;
	rand vmm_ral_field drvParaReg5;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.drvParaReg5 = new(this, "drvParaReg5", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_DrvParaReg5


class ral_reg_DrvParaReg6 extends vmm_ral_reg;
	rand vmm_ral_field DrvParaReg6;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.DrvParaReg6 = new(this, "DrvParaReg6", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_DrvParaReg6


class ral_reg_DrvParaReg7 extends vmm_ral_reg;
	rand vmm_ral_field DrvParaReg7;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.DrvParaReg7 = new(this, "DrvParaReg7", 32, vmm_ral::RW, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_DrvParaReg7


class ral_reg_HclkConReg extends vmm_ral_reg;
	rand vmm_ral_field Hclk_sel;
	rand vmm_ral_field Fmax;
	rand vmm_ral_field ClkvocDiv;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Hclk_sel = new(this, "Hclk_sel", 3, vmm_ral::RW, 'h0, 3'hx, 0, 0, cvr);
		this.Fmax = new(this, "Fmax", 1, vmm_ral::RW, 'h0, 1'hx, 3, 0, cvr);
		this.ClkvocDiv = new(this, "ClkvocDiv", 1, vmm_ral::RW, 'h0, 1'hx, 4, 0, cvr);
	endfunction: new
endclass : ral_reg_HclkConReg


class ral_reg_ModuleRstReg extends vmm_ral_reg;
	rand vmm_ral_field Rst_sec;
	rand vmm_ral_field Rst_int;
	rand vmm_ral_field Rst_rng;
	rand vmm_ral_field Rst_crc;
	rand vmm_ral_field Rst_pit;
	rand vmm_ral_field Rst_pit1;
	rand vmm_ral_field Rst_wdt;
	rand vmm_ral_field Rst_eectrl;
	rand vmm_ral_field Rst_rf;
	rand vmm_ral_field Rst_des;
	rand vmm_ral_field Rst_rsa;
	rand vmm_ral_field Rst_ssf33;
	rand vmm_ral_field Rst_gpio;
	rand vmm_ral_field Rst_uart;
	rand vmm_ral_field Rst_sm1;
	rand vmm_ral_field Rst_sm3;
	rand vmm_ral_field Rst_sm7;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Rst_sec = new(this, "Rst_sec", 1, vmm_ral::RW, 'h1, 1'hx, 0, 0, cvr);
		this.Rst_int = new(this, "Rst_int", 1, vmm_ral::RW, 'h1, 1'hx, 1, 0, cvr);
		this.Rst_rng = new(this, "Rst_rng", 1, vmm_ral::RW, 'h1, 1'hx, 2, 0, cvr);
		this.Rst_crc = new(this, "Rst_crc", 1, vmm_ral::RW, 'h1, 1'hx, 3, 0, cvr);
		this.Rst_pit = new(this, "Rst_pit", 1, vmm_ral::RW, 'h1, 1'hx, 4, 0, cvr);
		this.Rst_pit1 = new(this, "Rst_pit1", 1, vmm_ral::RW, 'h1, 1'hx, 5, 0, cvr);
		this.Rst_wdt = new(this, "Rst_wdt", 1, vmm_ral::RW, 'h1, 1'hx, 6, 0, cvr);
		this.Rst_eectrl = new(this, "Rst_eectrl", 1, vmm_ral::RW, 'h1, 1'hx, 7, 0, cvr);
		this.Rst_rf = new(this, "Rst_rf", 1, vmm_ral::RW, 'h1, 1'hx, 8, 0, cvr);
		this.Rst_des = new(this, "Rst_des", 1, vmm_ral::RW, 'h1, 1'hx, 9, 0, cvr);
		this.Rst_rsa = new(this, "Rst_rsa", 1, vmm_ral::RW, 'h1, 1'hx, 10, 0, cvr);
		this.Rst_ssf33 = new(this, "Rst_ssf33", 1, vmm_ral::RW, 'h1, 1'hx, 11, 0, cvr);
		this.Rst_gpio = new(this, "Rst_gpio", 1, vmm_ral::RW, 'h1, 1'hx, 12, 0, cvr);
		this.Rst_uart = new(this, "Rst_uart", 1, vmm_ral::RW, 'h1, 1'hx, 13, 0, cvr);
		this.Rst_sm1 = new(this, "Rst_sm1", 1, vmm_ral::RW, 'h1, 1'hx, 14, 0, cvr);
		this.Rst_sm3 = new(this, "Rst_sm3", 1, vmm_ral::RW, 'h1, 1'hx, 15, 0, cvr);
		this.Rst_sm7 = new(this, "Rst_sm7", 1, vmm_ral::RW, 'h1, 1'hx, 16, 0, cvr);
	endfunction: new
endclass : ral_reg_ModuleRstReg


class ral_reg_PclkselReg extends vmm_ral_reg;
	rand vmm_ral_field Pclksel;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Pclksel = new(this, "Pclksel", 2, vmm_ral::RW, 'h2, 2'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_PclkselReg


class ral_reg_PowerAvailReg extends vmm_ral_reg;
	rand vmm_ral_field PowerAvailReg;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.PowerAvailReg = new(this, "PowerAvailReg", 2, vmm_ral::RO, 'h3, 2'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_PowerAvailReg


class ral_reg_PowerModeReg extends vmm_ral_reg;
	rand vmm_ral_field idle;
	rand vmm_ral_field stop;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.idle = new(this, "idle", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.stop = new(this, "stop", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
	endfunction: new
endclass : ral_reg_PowerModeReg


class ral_reg_PrivCtrlReg extends vmm_ral_reg;
	rand vmm_ral_field System_user;
	rand vmm_ral_field secure_user;
	rand vmm_ral_field crc_user;
	rand vmm_ral_field eeprom_user;
	rand vmm_ral_field rf_user;
	rand vmm_ral_field des_user;
	rand vmm_ral_field rsa_user;
	rand vmm_ral_field clk_user;
	rand vmm_ral_field ssf33_user;
	rand vmm_ral_field sm1_user;
	rand vmm_ral_field sm3_user;
	rand vmm_ral_field sm7_user;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.System_user = new(this, "System_user", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.secure_user = new(this, "secure_user", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
		this.crc_user = new(this, "crc_user", 1, vmm_ral::RW, 'h0, 1'hx, 2, 0, cvr);
		this.eeprom_user = new(this, "eeprom_user", 1, vmm_ral::RW, 'h0, 1'hx, 3, 0, cvr);
		this.rf_user = new(this, "rf_user", 1, vmm_ral::RW, 'h0, 1'hx, 4, 0, cvr);
		this.des_user = new(this, "des_user", 1, vmm_ral::RW, 'h0, 1'hx, 5, 0, cvr);
		this.rsa_user = new(this, "rsa_user", 1, vmm_ral::RW, 'h0, 1'hx, 6, 0, cvr);
		this.clk_user = new(this, "clk_user", 1, vmm_ral::RW, 'h0, 1'hx, 7, 0, cvr);
		this.ssf33_user = new(this, "ssf33_user", 1, vmm_ral::RW, 'h0, 1'hx, 8, 0, cvr);
		this.sm1_user = new(this, "sm1_user", 1, vmm_ral::RW, 'h0, 1'hx, 9, 0, cvr);
		this.sm3_user = new(this, "sm3_user", 1, vmm_ral::RW, 'h0, 1'hx, 10, 0, cvr);
		this.sm7_user = new(this, "sm7_user", 1, vmm_ral::RW, 'h0, 1'hx, 11, 0, cvr);
	endfunction: new
endclass : ral_reg_PrivCtrlReg


class ral_reg_RstEnReg extends vmm_ral_reg;
	rand vmm_ral_field sw_rst_en;
	rand vmm_ral_field wd_rst_en;
	rand vmm_ral_field tdh_rst_en;
	rand vmm_ral_field tdl_rst_en;
	rand vmm_ral_field fdh_rst_en;
	rand vmm_ral_field fdl_rst_en;
	rand vmm_ral_field light_rst_en;
	rand vmm_ral_field md_rst_en;
	rand vmm_ral_field shield_rst_en;
	rand vmm_ral_field vdh_rst_en;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.sw_rst_en = new(this, "sw_rst_en", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.wd_rst_en = new(this, "wd_rst_en", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
		this.tdh_rst_en = new(this, "tdh_rst_en", 1, vmm_ral::RW, 'h0, 1'hx, 2, 0, cvr);
		this.tdl_rst_en = new(this, "tdl_rst_en", 1, vmm_ral::RW, 'h0, 1'hx, 3, 0, cvr);
		this.fdh_rst_en = new(this, "fdh_rst_en", 1, vmm_ral::RW, 'h0, 1'hx, 4, 0, cvr);
		this.fdl_rst_en = new(this, "fdl_rst_en", 1, vmm_ral::RW, 'h0, 1'hx, 5, 0, cvr);
		this.light_rst_en = new(this, "light_rst_en", 1, vmm_ral::RW, 'h0, 1'hx, 6, 0, cvr);
		this.md_rst_en = new(this, "md_rst_en", 1, vmm_ral::RW, 'h0, 1'hx, 7, 0, cvr);
		this.shield_rst_en = new(this, "shield_rst_en", 1, vmm_ral::RW, 'h0, 1'hx, 8, 0, cvr);
		this.vdh_rst_en = new(this, "vdh_rst_en", 1, vmm_ral::RW, 'h0, 1'hx, 9, 0, cvr);
	endfunction: new
endclass : ral_reg_RstEnReg


class ral_reg_RstTypReg extends vmm_ral_reg;
	rand vmm_ral_field sw_rst_typ;
	rand vmm_ral_field wd_rst_typ;
	rand vmm_ral_field tdh_rst_typ;
	rand vmm_ral_field tdl_rst_typ;
	rand vmm_ral_field fdh_rst_typ;
	rand vmm_ral_field fdl_rst_typ;
	rand vmm_ral_field light_rst_typ;
	rand vmm_ral_field md_rst_typ;
	rand vmm_ral_field shield_rst_typ;
	rand vmm_ral_field sci7816_rst_typ;
	rand vmm_ral_field vdh_rst_typ;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.sw_rst_typ = new(this, "sw_rst_typ", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.wd_rst_typ = new(this, "wd_rst_typ", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
		this.tdh_rst_typ = new(this, "tdh_rst_typ", 1, vmm_ral::RW, 'h0, 1'hx, 2, 0, cvr);
		this.tdl_rst_typ = new(this, "tdl_rst_typ", 1, vmm_ral::RW, 'h0, 1'hx, 3, 0, cvr);
		this.fdh_rst_typ = new(this, "fdh_rst_typ", 1, vmm_ral::RW, 'h0, 1'hx, 4, 0, cvr);
		this.fdl_rst_typ = new(this, "fdl_rst_typ", 1, vmm_ral::RW, 'h0, 1'hx, 5, 0, cvr);
		this.light_rst_typ = new(this, "light_rst_typ", 1, vmm_ral::RW, 'h0, 1'hx, 6, 0, cvr);
		this.md_rst_typ = new(this, "md_rst_typ", 1, vmm_ral::RW, 'h0, 1'hx, 7, 0, cvr);
		this.shield_rst_typ = new(this, "shield_rst_typ", 1, vmm_ral::RW, 'h0, 1'hx, 8, 0, cvr);
		this.sci7816_rst_typ = new(this, "sci7816_rst_typ", 1, vmm_ral::RW, 'h0, 1'hx, 9, 0, cvr);
		this.vdh_rst_typ = new(this, "vdh_rst_typ", 1, vmm_ral::RW, 'h0, 1'hx, 10, 0, cvr);
	endfunction: new
endclass : ral_reg_RstTypReg


class ral_reg_SDCntrlReg extends vmm_ral_reg;
	rand vmm_ral_field MD_open;
	rand vmm_ral_field FD_open;
	rand vmm_ral_field FDH_en;
	rand vmm_ral_field FDL_en;
	rand vmm_ral_field Light_en;
	rand vmm_ral_field TD_open;
	rand vmm_ral_field TDH_en;
	rand vmm_ral_field TDL_en;
	rand vmm_ral_field VD_open;
	rand vmm_ral_field VDH_en;
	rand vmm_ral_field VHL_en;
	rand vmm_ral_field MD_en;
	rand vmm_ral_field LD_en;
	rand vmm_ral_field RNI_en;
	rand vmm_ral_field RNI_sel;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.MD_open = new(this, "MD_open", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.FD_open = new(this, "FD_open", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
		this.FDH_en = new(this, "FDH_en", 1, vmm_ral::RW, 'h0, 1'hx, 2, 0, cvr);
		this.FDL_en = new(this, "FDL_en", 1, vmm_ral::RW, 'h0, 1'hx, 3, 0, cvr);
		this.Light_en = new(this, "Light_en", 1, vmm_ral::RW, 'h0, 1'hx, 4, 0, cvr);
		this.TD_open = new(this, "TD_open", 1, vmm_ral::RW, 'h0, 1'hx, 5, 0, cvr);
		this.TDH_en = new(this, "TDH_en", 1, vmm_ral::RW, 'h0, 1'hx, 6, 0, cvr);
		this.TDL_en = new(this, "TDL_en", 1, vmm_ral::RW, 'h0, 1'hx, 7, 0, cvr);
		this.VD_open = new(this, "VD_open", 1, vmm_ral::RW, 'h0, 1'hx, 8, 0, cvr);
		this.VDH_en = new(this, "VDH_en", 1, vmm_ral::RW, 'h0, 1'hx, 9, 0, cvr);
		this.VHL_en = new(this, "VHL_en", 1, vmm_ral::RW, 'h0, 1'hx, 10, 0, cvr);
		this.MD_en = new(this, "MD_en", 1, vmm_ral::RW, 'h0, 1'hx, 11, 0, cvr);
		this.LD_en = new(this, "LD_en", 1, vmm_ral::RW, 'h0, 1'hx, 12, 0, cvr);
		this.RNI_en = new(this, "RNI_en", 1, vmm_ral::RW, 'h0, 1'hx, 13, 0, cvr);
		this.RNI_sel = new(this, "RNI_sel", 2, vmm_ral::RW, 'h0, 2'hx, 14, 0, cvr);
	endfunction: new
endclass : ral_reg_SDCntrlReg


class ral_reg_SWGenReg extends vmm_ral_reg;
	rand vmm_ral_field SWGenReg;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SWGenReg = new(this, "SWGenReg", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_SWGenReg


class ral_reg_med_con extends vmm_ral_reg;
	rand vmm_ral_field ram_en;
	rand vmm_ral_field ee_en;
	rand vmm_ral_field rom_en;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.ram_en = new(this, "ram_en", 1, vmm_ral::RW, 'h1, 1'hx, 0, 0, cvr);
		this.ee_en = new(this, "ee_en", 1, vmm_ral::RW, 'h1, 1'hx, 1, 0, cvr);
		this.rom_en = new(this, "rom_en", 1, vmm_ral::RW, 'h1, 1'hx, 2, 0, cvr);
	endfunction: new
endclass : ral_reg_med_con


class ral_reg_ramkey_cap extends vmm_ral_reg;
	rand vmm_ral_field ramkey_cap;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.ramkey_cap = new(this, "ramkey_cap", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_ramkey_cap


class ral_reg_romswitch extends vmm_ral_reg;
	rand vmm_ral_field romswitch;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.romswitch = new(this, "romswitch", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_romswitch


class ral_reg_shield1data extends vmm_ral_reg;
	rand vmm_ral_field shield1_din;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.shield1_din = new(this, "shield1_din", 9, vmm_ral::RW, 'h0, 9'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_shield1data


class ral_reg_shield1stat extends vmm_ral_reg;
	rand vmm_ral_field shield1_dout;
	rand vmm_ral_field valid1;
	rand vmm_ral_field alarm1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.shield1_dout = new(this, "shield1_dout", 9, vmm_ral::RO, 'h0, 9'hx, 0, 0, cvr);
		this.valid1 = new(this, "valid1", 1, vmm_ral::RO, 'h0, 1'hx, 9, 0, cvr);
		this.alarm1 = new(this, "alarm1", 1, vmm_ral::RO, 'h0, 1'hx, 10, 0, cvr);
	endfunction: new
endclass : ral_reg_shield1stat


class ral_reg_shield2data extends vmm_ral_reg;
	rand vmm_ral_field shield2_din;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.shield2_din = new(this, "shield2_din", 9, vmm_ral::RW, 'h0, 9'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_shield2data


class ral_reg_shield2stat extends vmm_ral_reg;
	rand vmm_ral_field shield2_dout;
	rand vmm_ral_field valid2;
	rand vmm_ral_field alarm2;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.shield2_dout = new(this, "shield2_dout", 9, vmm_ral::RO, 'h0, 9'hx, 0, 0, cvr);
		this.valid2 = new(this, "valid2", 1, vmm_ral::RO, 'h0, 1'hx, 9, 0, cvr);
		this.alarm2 = new(this, "alarm2", 1, vmm_ral::RO, 'h0, 1'hx, 10, 0, cvr);
	endfunction: new
endclass : ral_reg_shield2stat


class ral_reg_testfuse extends vmm_ral_reg;
	rand vmm_ral_field testfuse;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.testfuse = new(this, "testfuse", 1, vmm_ral::RO, 'h1, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_testfuse


class ral_block_SYSCTRL extends vmm_ral_block;
	rand ral_reg_ClkClsReg ClkClsReg;
	rand ral_reg_ClkRsaSelReg ClkRsaSelReg;
	rand ral_reg_ClkTestReg ClkTestReg;
	rand ral_reg_ClkVcoConReg ClkVcoConReg;
	rand ral_reg_ClkselReg ClkselReg;
	rand ral_reg_DrvParaReg0 DrvParaReg0;
	rand ral_reg_DrvParaReg1 DrvParaReg1;
	rand ral_reg_DrvParaReg2 DrvParaReg2;
	rand ral_reg_DrvParaReg3 DrvParaReg3;
	rand ral_reg_DrvParaReg4 DrvParaReg4;
	rand ral_reg_DrvParaReg5 DrvParaReg5;
	rand ral_reg_DrvParaReg6 DrvParaReg6;
	rand ral_reg_DrvParaReg7 DrvParaReg7;
	rand ral_reg_HclkConReg HclkConReg;
	rand ral_reg_ModuleRstReg ModuleRstReg;
	rand ral_reg_PclkselReg PclkselReg;
	rand ral_reg_PowerAvailReg PowerAvailReg;
	rand ral_reg_PowerModeReg PowerModeReg;
	rand ral_reg_PrivCtrlReg PrivCtrlReg;
	rand ral_reg_RstEnReg RstEnReg;
	rand ral_reg_RstTypReg RstTypReg;
	rand ral_reg_SDCntrlReg SDCntrlReg;
	rand ral_reg_SWGenReg SWGenReg;
	rand ral_reg_med_con med_con;
	rand ral_reg_ramkey_cap ramkey_cap;
	rand ral_reg_romswitch romswitch;
	rand ral_reg_shield1data shield1data;
	rand ral_reg_shield1stat shield1stat;
	rand ral_reg_shield2data shield2data;
	rand ral_reg_shield2stat shield2stat;
	rand ral_reg_testfuse testfuse;
	rand vmm_ral_field ClkClsReg_Secure_cls;
	rand vmm_ral_field Secure_cls;
	rand vmm_ral_field ClkClsReg_int_cls;
	rand vmm_ral_field int_cls;
	rand vmm_ral_field ClkClsReg_rng_cls;
	rand vmm_ral_field rng_cls;
	rand vmm_ral_field ClkClsReg_crc_cls;
	rand vmm_ral_field crc_cls;
	rand vmm_ral_field ClkClsReg_timer_cls;
	rand vmm_ral_field timer_cls;
	rand vmm_ral_field ClkClsReg_wdt_cls;
	rand vmm_ral_field wdt_cls;
	rand vmm_ral_field ClkClsReg_eectrl_cls;
	rand vmm_ral_field eectrl_cls;
	rand vmm_ral_field ClkClsReg_rf_cls;
	rand vmm_ral_field rf_cls;
	rand vmm_ral_field ClkClsReg_des_cls;
	rand vmm_ral_field des_cls;
	rand vmm_ral_field ClkClsReg_rsa_cls;
	rand vmm_ral_field rsa_cls;
	rand vmm_ral_field ClkClsReg_ssf33_cls;
	rand vmm_ral_field ssf33_cls;
	rand vmm_ral_field ClkClsReg_gpio_cls;
	rand vmm_ral_field gpio_cls;
	rand vmm_ral_field ClkClsReg_sci7816;
	rand vmm_ral_field sci7816;
	rand vmm_ral_field ClkClsReg_sm1_cls;
	rand vmm_ral_field sm1_cls;
	rand vmm_ral_field ClkClsReg_sm3_cls;
	rand vmm_ral_field sm3_cls;
	rand vmm_ral_field ClkClsReg_sm7_cls;
	rand vmm_ral_field sm7_cls;
	rand vmm_ral_field ClkRsaSelReg_clkRsaSel;
	rand vmm_ral_field clkRsaSel;
	rand vmm_ral_field ClkRsaSelReg_Clktime1sel;
	rand vmm_ral_field Clktime1sel;
	rand vmm_ral_field ClkRsaSelReg_Clktime2sel;
	rand vmm_ral_field Clktime2sel;
	rand vmm_ral_field ClkTestReg_Testrun;
	rand vmm_ral_field Testrun;
	rand vmm_ral_field ClkTestReg_VCO_Count;
	rand vmm_ral_field VCO_Count;
	rand vmm_ral_field ClkVcoConReg_vcoclk_en;
	rand vmm_ral_field vcoclk_en;
	rand vmm_ral_field ClkselReg_Clksel;
	rand vmm_ral_field Clksel;
	rand vmm_ral_field ClkselReg_clkavailcl;
	rand vmm_ral_field clkavailcl;
	rand vmm_ral_field ClkselReg_clkavailcb;
	rand vmm_ral_field clkavailcb;
	rand vmm_ral_field ClkselReg_ClkPrior;
	rand vmm_ral_field ClkPrior;
	rand vmm_ral_field ClkselReg_Clkmaskcl;
	rand vmm_ral_field Clkmaskcl;
	rand vmm_ral_field ClkselReg_clkmaskcb;
	rand vmm_ral_field clkmaskcb;
	rand vmm_ral_field ClkselReg_clkmaskps;
	rand vmm_ral_field clkmaskps;
	rand vmm_ral_field DrvParaReg0_DrvParaReg0;
	rand vmm_ral_field DrvParaReg0_RFD_HDET_CON;
	rand vmm_ral_field RFD_HDET_CON;
	rand vmm_ral_field DrvParaReg0_RFD_LIMIT_EN;
	rand vmm_ral_field RFD_LIMIT_EN;
	rand vmm_ral_field DrvParaReg0_RFD_LIMIT_CON;
	rand vmm_ral_field RFD_LIMIT_CON;
	rand vmm_ral_field DrvParaReg0_VDOPT;
	rand vmm_ral_field VDOPT;
	rand vmm_ral_field DrvParaReg0_LDOPT;
	rand vmm_ral_field LDOPT;
	rand vmm_ral_field DrvParaReg1_PMV11_PMOPT;
	rand vmm_ral_field PMV11_PMOPT;
	rand vmm_ral_field DrvParaReg1_ATV11_EN_OPT;
	rand vmm_ral_field ATV11_EN_OPT;
	rand vmm_ral_field DrvParaReg1_ATV11_AA_OPT;
	rand vmm_ral_field ATV11_AA_OPT;
	rand vmm_ral_field DrvParaReg1_ATV11_DA_OPT;
	rand vmm_ral_field ATV11_DA_OPT;
	rand vmm_ral_field DrvParaReg2_VCO_30m_q;
	rand vmm_ral_field VCO_30m_q;
	rand vmm_ral_field DrvParaReg2_TD_OPT;
	rand vmm_ral_field TD_OPT;
	rand vmm_ral_field DrvParaReg2_EEIREFSEL;
	rand vmm_ral_field EEIREFSEL;
	rand vmm_ral_field DrvParaReg2_EEVREFSEL;
	rand vmm_ral_field EEVREFSEL;
	rand vmm_ral_field DrvParaReg3_DrvParaReg3;
	rand vmm_ral_field DrvParaReg4_DrvParaReg4;
	rand vmm_ral_field DrvParaReg5_drvParaReg5;
	rand vmm_ral_field drvParaReg5;
	rand vmm_ral_field DrvParaReg6_DrvParaReg6;
	rand vmm_ral_field DrvParaReg7_DrvParaReg7;
	rand vmm_ral_field HclkConReg_Hclk_sel;
	rand vmm_ral_field Hclk_sel;
	rand vmm_ral_field HclkConReg_Fmax;
	rand vmm_ral_field Fmax;
	rand vmm_ral_field HclkConReg_ClkvocDiv;
	rand vmm_ral_field ClkvocDiv;
	rand vmm_ral_field ModuleRstReg_Rst_sec;
	rand vmm_ral_field Rst_sec;
	rand vmm_ral_field ModuleRstReg_Rst_int;
	rand vmm_ral_field Rst_int;
	rand vmm_ral_field ModuleRstReg_Rst_rng;
	rand vmm_ral_field Rst_rng;
	rand vmm_ral_field ModuleRstReg_Rst_crc;
	rand vmm_ral_field Rst_crc;
	rand vmm_ral_field ModuleRstReg_Rst_pit;
	rand vmm_ral_field Rst_pit;
	rand vmm_ral_field ModuleRstReg_Rst_pit1;
	rand vmm_ral_field Rst_pit1;
	rand vmm_ral_field ModuleRstReg_Rst_wdt;
	rand vmm_ral_field Rst_wdt;
	rand vmm_ral_field ModuleRstReg_Rst_eectrl;
	rand vmm_ral_field Rst_eectrl;
	rand vmm_ral_field ModuleRstReg_Rst_rf;
	rand vmm_ral_field Rst_rf;
	rand vmm_ral_field ModuleRstReg_Rst_des;
	rand vmm_ral_field Rst_des;
	rand vmm_ral_field ModuleRstReg_Rst_rsa;
	rand vmm_ral_field Rst_rsa;
	rand vmm_ral_field ModuleRstReg_Rst_ssf33;
	rand vmm_ral_field Rst_ssf33;
	rand vmm_ral_field ModuleRstReg_Rst_gpio;
	rand vmm_ral_field Rst_gpio;
	rand vmm_ral_field ModuleRstReg_Rst_uart;
	rand vmm_ral_field Rst_uart;
	rand vmm_ral_field ModuleRstReg_Rst_sm1;
	rand vmm_ral_field Rst_sm1;
	rand vmm_ral_field ModuleRstReg_Rst_sm3;
	rand vmm_ral_field Rst_sm3;
	rand vmm_ral_field ModuleRstReg_Rst_sm7;
	rand vmm_ral_field Rst_sm7;
	rand vmm_ral_field PclkselReg_Pclksel;
	rand vmm_ral_field Pclksel;
	rand vmm_ral_field PowerAvailReg_PowerAvailReg;
	rand vmm_ral_field PowerModeReg_idle;
	rand vmm_ral_field idle;
	rand vmm_ral_field PowerModeReg_stop;
	rand vmm_ral_field stop;
	rand vmm_ral_field PrivCtrlReg_System_user;
	rand vmm_ral_field System_user;
	rand vmm_ral_field PrivCtrlReg_secure_user;
	rand vmm_ral_field secure_user;
	rand vmm_ral_field PrivCtrlReg_crc_user;
	rand vmm_ral_field crc_user;
	rand vmm_ral_field PrivCtrlReg_eeprom_user;
	rand vmm_ral_field eeprom_user;
	rand vmm_ral_field PrivCtrlReg_rf_user;
	rand vmm_ral_field rf_user;
	rand vmm_ral_field PrivCtrlReg_des_user;
	rand vmm_ral_field des_user;
	rand vmm_ral_field PrivCtrlReg_rsa_user;
	rand vmm_ral_field rsa_user;
	rand vmm_ral_field PrivCtrlReg_clk_user;
	rand vmm_ral_field clk_user;
	rand vmm_ral_field PrivCtrlReg_ssf33_user;
	rand vmm_ral_field ssf33_user;
	rand vmm_ral_field PrivCtrlReg_sm1_user;
	rand vmm_ral_field sm1_user;
	rand vmm_ral_field PrivCtrlReg_sm3_user;
	rand vmm_ral_field sm3_user;
	rand vmm_ral_field PrivCtrlReg_sm7_user;
	rand vmm_ral_field sm7_user;
	rand vmm_ral_field RstEnReg_sw_rst_en;
	rand vmm_ral_field sw_rst_en;
	rand vmm_ral_field RstEnReg_wd_rst_en;
	rand vmm_ral_field wd_rst_en;
	rand vmm_ral_field RstEnReg_tdh_rst_en;
	rand vmm_ral_field tdh_rst_en;
	rand vmm_ral_field RstEnReg_tdl_rst_en;
	rand vmm_ral_field tdl_rst_en;
	rand vmm_ral_field RstEnReg_fdh_rst_en;
	rand vmm_ral_field fdh_rst_en;
	rand vmm_ral_field RstEnReg_fdl_rst_en;
	rand vmm_ral_field fdl_rst_en;
	rand vmm_ral_field RstEnReg_light_rst_en;
	rand vmm_ral_field light_rst_en;
	rand vmm_ral_field RstEnReg_md_rst_en;
	rand vmm_ral_field md_rst_en;
	rand vmm_ral_field RstEnReg_shield_rst_en;
	rand vmm_ral_field shield_rst_en;
	rand vmm_ral_field RstEnReg_vdh_rst_en;
	rand vmm_ral_field vdh_rst_en;
	rand vmm_ral_field RstTypReg_sw_rst_typ;
	rand vmm_ral_field sw_rst_typ;
	rand vmm_ral_field RstTypReg_wd_rst_typ;
	rand vmm_ral_field wd_rst_typ;
	rand vmm_ral_field RstTypReg_tdh_rst_typ;
	rand vmm_ral_field tdh_rst_typ;
	rand vmm_ral_field RstTypReg_tdl_rst_typ;
	rand vmm_ral_field tdl_rst_typ;
	rand vmm_ral_field RstTypReg_fdh_rst_typ;
	rand vmm_ral_field fdh_rst_typ;
	rand vmm_ral_field RstTypReg_fdl_rst_typ;
	rand vmm_ral_field fdl_rst_typ;
	rand vmm_ral_field RstTypReg_light_rst_typ;
	rand vmm_ral_field light_rst_typ;
	rand vmm_ral_field RstTypReg_md_rst_typ;
	rand vmm_ral_field md_rst_typ;
	rand vmm_ral_field RstTypReg_shield_rst_typ;
	rand vmm_ral_field shield_rst_typ;
	rand vmm_ral_field RstTypReg_sci7816_rst_typ;
	rand vmm_ral_field sci7816_rst_typ;
	rand vmm_ral_field RstTypReg_vdh_rst_typ;
	rand vmm_ral_field vdh_rst_typ;
	rand vmm_ral_field SDCntrlReg_MD_open;
	rand vmm_ral_field MD_open;
	rand vmm_ral_field SDCntrlReg_FD_open;
	rand vmm_ral_field FD_open;
	rand vmm_ral_field SDCntrlReg_FDH_en;
	rand vmm_ral_field FDH_en;
	rand vmm_ral_field SDCntrlReg_FDL_en;
	rand vmm_ral_field FDL_en;
	rand vmm_ral_field SDCntrlReg_Light_en;
	rand vmm_ral_field Light_en;
	rand vmm_ral_field SDCntrlReg_TD_open;
	rand vmm_ral_field TD_open;
	rand vmm_ral_field SDCntrlReg_TDH_en;
	rand vmm_ral_field TDH_en;
	rand vmm_ral_field SDCntrlReg_TDL_en;
	rand vmm_ral_field TDL_en;
	rand vmm_ral_field SDCntrlReg_VD_open;
	rand vmm_ral_field VD_open;
	rand vmm_ral_field SDCntrlReg_VDH_en;
	rand vmm_ral_field VDH_en;
	rand vmm_ral_field SDCntrlReg_VHL_en;
	rand vmm_ral_field VHL_en;
	rand vmm_ral_field SDCntrlReg_MD_en;
	rand vmm_ral_field MD_en;
	rand vmm_ral_field SDCntrlReg_LD_en;
	rand vmm_ral_field LD_en;
	rand vmm_ral_field SDCntrlReg_RNI_en;
	rand vmm_ral_field RNI_en;
	rand vmm_ral_field SDCntrlReg_RNI_sel;
	rand vmm_ral_field RNI_sel;
	rand vmm_ral_field SWGenReg_SWGenReg;
	rand vmm_ral_field med_con_ram_en;
	rand vmm_ral_field ram_en;
	rand vmm_ral_field med_con_ee_en;
	rand vmm_ral_field ee_en;
	rand vmm_ral_field med_con_rom_en;
	rand vmm_ral_field rom_en;
	rand vmm_ral_field ramkey_cap_ramkey_cap;
	rand vmm_ral_field romswitch_romswitch;
	rand vmm_ral_field shield1data_shield1_din;
	rand vmm_ral_field shield1_din;
	rand vmm_ral_field shield1stat_shield1_dout;
	rand vmm_ral_field shield1_dout;
	rand vmm_ral_field shield1stat_valid1;
	rand vmm_ral_field valid1;
	rand vmm_ral_field shield1stat_alarm1;
	rand vmm_ral_field alarm1;
	rand vmm_ral_field shield2data_shield2_din;
	rand vmm_ral_field shield2_din;
	rand vmm_ral_field shield2stat_shield2_dout;
	rand vmm_ral_field shield2_dout;
	rand vmm_ral_field shield2stat_valid2;
	rand vmm_ral_field valid2;
	rand vmm_ral_field shield2stat_alarm2;
	rand vmm_ral_field alarm2;
	rand vmm_ral_field testfuse_testfuse;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "SYSCTRL", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "SYSCTRL", 4096, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on);
		this.ClkClsReg = new(this, "ClkClsReg", `VMM_RAL_ADDR_WIDTH'h214, "", cover_on, 2'b11, 0);
		this.ClkClsReg_Secure_cls = this.ClkClsReg.Secure_cls;
		this.Secure_cls = this.ClkClsReg.Secure_cls;
		this.ClkClsReg_int_cls = this.ClkClsReg.int_cls;
		this.int_cls = this.ClkClsReg.int_cls;
		this.ClkClsReg_rng_cls = this.ClkClsReg.rng_cls;
		this.rng_cls = this.ClkClsReg.rng_cls;
		this.ClkClsReg_crc_cls = this.ClkClsReg.crc_cls;
		this.crc_cls = this.ClkClsReg.crc_cls;
		this.ClkClsReg_timer_cls = this.ClkClsReg.timer_cls;
		this.timer_cls = this.ClkClsReg.timer_cls;
		this.ClkClsReg_wdt_cls = this.ClkClsReg.wdt_cls;
		this.wdt_cls = this.ClkClsReg.wdt_cls;
		this.ClkClsReg_eectrl_cls = this.ClkClsReg.eectrl_cls;
		this.eectrl_cls = this.ClkClsReg.eectrl_cls;
		this.ClkClsReg_rf_cls = this.ClkClsReg.rf_cls;
		this.rf_cls = this.ClkClsReg.rf_cls;
		this.ClkClsReg_des_cls = this.ClkClsReg.des_cls;
		this.des_cls = this.ClkClsReg.des_cls;
		this.ClkClsReg_rsa_cls = this.ClkClsReg.rsa_cls;
		this.rsa_cls = this.ClkClsReg.rsa_cls;
		this.ClkClsReg_ssf33_cls = this.ClkClsReg.ssf33_cls;
		this.ssf33_cls = this.ClkClsReg.ssf33_cls;
		this.ClkClsReg_gpio_cls = this.ClkClsReg.gpio_cls;
		this.gpio_cls = this.ClkClsReg.gpio_cls;
		this.ClkClsReg_sci7816 = this.ClkClsReg.sci7816;
		this.sci7816 = this.ClkClsReg.sci7816;
		this.ClkClsReg_sm1_cls = this.ClkClsReg.sm1_cls;
		this.sm1_cls = this.ClkClsReg.sm1_cls;
		this.ClkClsReg_sm3_cls = this.ClkClsReg.sm3_cls;
		this.sm3_cls = this.ClkClsReg.sm3_cls;
		this.ClkClsReg_sm7_cls = this.ClkClsReg.sm7_cls;
		this.sm7_cls = this.ClkClsReg.sm7_cls;
		this.ClkRsaSelReg = new(this, "ClkRsaSelReg", `VMM_RAL_ADDR_WIDTH'h210, "", cover_on, 2'b11, 0);
		this.ClkRsaSelReg_clkRsaSel = this.ClkRsaSelReg.clkRsaSel;
		this.clkRsaSel = this.ClkRsaSelReg.clkRsaSel;
		this.ClkRsaSelReg_Clktime1sel = this.ClkRsaSelReg.Clktime1sel;
		this.Clktime1sel = this.ClkRsaSelReg.Clktime1sel;
		this.ClkRsaSelReg_Clktime2sel = this.ClkRsaSelReg.Clktime2sel;
		this.Clktime2sel = this.ClkRsaSelReg.Clktime2sel;
		this.ClkTestReg = new(this, "ClkTestReg", `VMM_RAL_ADDR_WIDTH'h2FC, "", cover_on, 2'b11, 0);
		this.ClkTestReg_Testrun = this.ClkTestReg.Testrun;
		this.Testrun = this.ClkTestReg.Testrun;
		this.ClkTestReg_VCO_Count = this.ClkTestReg.VCO_Count;
		this.VCO_Count = this.ClkTestReg.VCO_Count;
		this.ClkVcoConReg = new(this, "ClkVcoConReg", `VMM_RAL_ADDR_WIDTH'h20C, "", cover_on, 2'b11, 0);
		this.ClkVcoConReg_vcoclk_en = this.ClkVcoConReg.vcoclk_en;
		this.vcoclk_en = this.ClkVcoConReg.vcoclk_en;
		this.ClkselReg = new(this, "ClkselReg", `VMM_RAL_ADDR_WIDTH'h200, "", cover_on, 2'b11, 0);
		this.ClkselReg_Clksel = this.ClkselReg.Clksel;
		this.Clksel = this.ClkselReg.Clksel;
		this.ClkselReg_clkavailcl = this.ClkselReg.clkavailcl;
		this.clkavailcl = this.ClkselReg.clkavailcl;
		this.ClkselReg_clkavailcb = this.ClkselReg.clkavailcb;
		this.clkavailcb = this.ClkselReg.clkavailcb;
		this.ClkselReg_ClkPrior = this.ClkselReg.ClkPrior;
		this.ClkPrior = this.ClkselReg.ClkPrior;
		this.ClkselReg_Clkmaskcl = this.ClkselReg.Clkmaskcl;
		this.Clkmaskcl = this.ClkselReg.Clkmaskcl;
		this.ClkselReg_clkmaskcb = this.ClkselReg.clkmaskcb;
		this.clkmaskcb = this.ClkselReg.clkmaskcb;
		this.ClkselReg_clkmaskps = this.ClkselReg.clkmaskps;
		this.clkmaskps = this.ClkselReg.clkmaskps;
		this.DrvParaReg0 = new(this, "DrvParaReg0", `VMM_RAL_ADDR_WIDTH'h80, "", cover_on, 2'b11, 0);
		this.DrvParaReg0_DrvParaReg0 = this.DrvParaReg0.DrvParaReg0;
		this.DrvParaReg0_RFD_HDET_CON = this.DrvParaReg0.RFD_HDET_CON;
		this.RFD_HDET_CON = this.DrvParaReg0.RFD_HDET_CON;
		this.DrvParaReg0_RFD_LIMIT_EN = this.DrvParaReg0.RFD_LIMIT_EN;
		this.RFD_LIMIT_EN = this.DrvParaReg0.RFD_LIMIT_EN;
		this.DrvParaReg0_RFD_LIMIT_CON = this.DrvParaReg0.RFD_LIMIT_CON;
		this.RFD_LIMIT_CON = this.DrvParaReg0.RFD_LIMIT_CON;
		this.DrvParaReg0_VDOPT = this.DrvParaReg0.VDOPT;
		this.VDOPT = this.DrvParaReg0.VDOPT;
		this.DrvParaReg0_LDOPT = this.DrvParaReg0.LDOPT;
		this.LDOPT = this.DrvParaReg0.LDOPT;
		this.DrvParaReg1 = new(this, "DrvParaReg1", `VMM_RAL_ADDR_WIDTH'h84, "", cover_on, 2'b11, 0);
		this.DrvParaReg1_PMV11_PMOPT = this.DrvParaReg1.PMV11_PMOPT;
		this.PMV11_PMOPT = this.DrvParaReg1.PMV11_PMOPT;
		this.DrvParaReg1_ATV11_EN_OPT = this.DrvParaReg1.ATV11_EN_OPT;
		this.ATV11_EN_OPT = this.DrvParaReg1.ATV11_EN_OPT;
		this.DrvParaReg1_ATV11_AA_OPT = this.DrvParaReg1.ATV11_AA_OPT;
		this.ATV11_AA_OPT = this.DrvParaReg1.ATV11_AA_OPT;
		this.DrvParaReg1_ATV11_DA_OPT = this.DrvParaReg1.ATV11_DA_OPT;
		this.ATV11_DA_OPT = this.DrvParaReg1.ATV11_DA_OPT;
		this.DrvParaReg2 = new(this, "DrvParaReg2", `VMM_RAL_ADDR_WIDTH'h88, "", cover_on, 2'b11, 0);
		this.DrvParaReg2_VCO_30m_q = this.DrvParaReg2.VCO_30m_q;
		this.VCO_30m_q = this.DrvParaReg2.VCO_30m_q;
		this.DrvParaReg2_TD_OPT = this.DrvParaReg2.TD_OPT;
		this.TD_OPT = this.DrvParaReg2.TD_OPT;
		this.DrvParaReg2_EEIREFSEL = this.DrvParaReg2.EEIREFSEL;
		this.EEIREFSEL = this.DrvParaReg2.EEIREFSEL;
		this.DrvParaReg2_EEVREFSEL = this.DrvParaReg2.EEVREFSEL;
		this.EEVREFSEL = this.DrvParaReg2.EEVREFSEL;
		this.DrvParaReg3 = new(this, "DrvParaReg3", `VMM_RAL_ADDR_WIDTH'h8C, "", cover_on, 2'b11, 0);
		this.DrvParaReg3_DrvParaReg3 = this.DrvParaReg3.DrvParaReg3;
		this.DrvParaReg4 = new(this, "DrvParaReg4", `VMM_RAL_ADDR_WIDTH'h90, "", cover_on, 2'b11, 0);
		this.DrvParaReg4_DrvParaReg4 = this.DrvParaReg4.DrvParaReg4;
		this.DrvParaReg5 = new(this, "DrvParaReg5", `VMM_RAL_ADDR_WIDTH'h94, "", cover_on, 2'b11, 0);
		this.DrvParaReg5_drvParaReg5 = this.DrvParaReg5.drvParaReg5;
		this.drvParaReg5 = this.DrvParaReg5.drvParaReg5;
		this.DrvParaReg6 = new(this, "DrvParaReg6", `VMM_RAL_ADDR_WIDTH'h98, "", cover_on, 2'b11, 0);
		this.DrvParaReg6_DrvParaReg6 = this.DrvParaReg6.DrvParaReg6;
		this.DrvParaReg7 = new(this, "DrvParaReg7", `VMM_RAL_ADDR_WIDTH'h9C, "", cover_on, 2'b11, 0);
		this.DrvParaReg7_DrvParaReg7 = this.DrvParaReg7.DrvParaReg7;
		this.HclkConReg = new(this, "HclkConReg", `VMM_RAL_ADDR_WIDTH'h204, "", cover_on, 2'b11, 0);
		this.HclkConReg_Hclk_sel = this.HclkConReg.Hclk_sel;
		this.Hclk_sel = this.HclkConReg.Hclk_sel;
		this.HclkConReg_Fmax = this.HclkConReg.Fmax;
		this.Fmax = this.HclkConReg.Fmax;
		this.HclkConReg_ClkvocDiv = this.HclkConReg.ClkvocDiv;
		this.ClkvocDiv = this.HclkConReg.ClkvocDiv;
		this.ModuleRstReg = new(this, "ModuleRstReg", `VMM_RAL_ADDR_WIDTH'hC, "", cover_on, 2'b11, 0);
		this.ModuleRstReg_Rst_sec = this.ModuleRstReg.Rst_sec;
		this.Rst_sec = this.ModuleRstReg.Rst_sec;
		this.ModuleRstReg_Rst_int = this.ModuleRstReg.Rst_int;
		this.Rst_int = this.ModuleRstReg.Rst_int;
		this.ModuleRstReg_Rst_rng = this.ModuleRstReg.Rst_rng;
		this.Rst_rng = this.ModuleRstReg.Rst_rng;
		this.ModuleRstReg_Rst_crc = this.ModuleRstReg.Rst_crc;
		this.Rst_crc = this.ModuleRstReg.Rst_crc;
		this.ModuleRstReg_Rst_pit = this.ModuleRstReg.Rst_pit;
		this.Rst_pit = this.ModuleRstReg.Rst_pit;
		this.ModuleRstReg_Rst_pit1 = this.ModuleRstReg.Rst_pit1;
		this.Rst_pit1 = this.ModuleRstReg.Rst_pit1;
		this.ModuleRstReg_Rst_wdt = this.ModuleRstReg.Rst_wdt;
		this.Rst_wdt = this.ModuleRstReg.Rst_wdt;
		this.ModuleRstReg_Rst_eectrl = this.ModuleRstReg.Rst_eectrl;
		this.Rst_eectrl = this.ModuleRstReg.Rst_eectrl;
		this.ModuleRstReg_Rst_rf = this.ModuleRstReg.Rst_rf;
		this.Rst_rf = this.ModuleRstReg.Rst_rf;
		this.ModuleRstReg_Rst_des = this.ModuleRstReg.Rst_des;
		this.Rst_des = this.ModuleRstReg.Rst_des;
		this.ModuleRstReg_Rst_rsa = this.ModuleRstReg.Rst_rsa;
		this.Rst_rsa = this.ModuleRstReg.Rst_rsa;
		this.ModuleRstReg_Rst_ssf33 = this.ModuleRstReg.Rst_ssf33;
		this.Rst_ssf33 = this.ModuleRstReg.Rst_ssf33;
		this.ModuleRstReg_Rst_gpio = this.ModuleRstReg.Rst_gpio;
		this.Rst_gpio = this.ModuleRstReg.Rst_gpio;
		this.ModuleRstReg_Rst_uart = this.ModuleRstReg.Rst_uart;
		this.Rst_uart = this.ModuleRstReg.Rst_uart;
		this.ModuleRstReg_Rst_sm1 = this.ModuleRstReg.Rst_sm1;
		this.Rst_sm1 = this.ModuleRstReg.Rst_sm1;
		this.ModuleRstReg_Rst_sm3 = this.ModuleRstReg.Rst_sm3;
		this.Rst_sm3 = this.ModuleRstReg.Rst_sm3;
		this.ModuleRstReg_Rst_sm7 = this.ModuleRstReg.Rst_sm7;
		this.Rst_sm7 = this.ModuleRstReg.Rst_sm7;
		this.PclkselReg = new(this, "PclkselReg", `VMM_RAL_ADDR_WIDTH'h208, "", cover_on, 2'b11, 0);
		this.PclkselReg_Pclksel = this.PclkselReg.Pclksel;
		this.Pclksel = this.PclkselReg.Pclksel;
		this.PowerAvailReg = new(this, "PowerAvailReg", `VMM_RAL_ADDR_WIDTH'hF4, "", cover_on, 2'b11, 0);
		this.PowerAvailReg_PowerAvailReg = this.PowerAvailReg.PowerAvailReg;
		this.PowerModeReg = new(this, "PowerModeReg", `VMM_RAL_ADDR_WIDTH'h218, "", cover_on, 2'b11, 0);
		this.PowerModeReg_idle = this.PowerModeReg.idle;
		this.idle = this.PowerModeReg.idle;
		this.PowerModeReg_stop = this.PowerModeReg.stop;
		this.stop = this.PowerModeReg.stop;
		this.PrivCtrlReg = new(this, "PrivCtrlReg", `VMM_RAL_ADDR_WIDTH'h10, "", cover_on, 2'b11, 0);
		this.PrivCtrlReg_System_user = this.PrivCtrlReg.System_user;
		this.System_user = this.PrivCtrlReg.System_user;
		this.PrivCtrlReg_secure_user = this.PrivCtrlReg.secure_user;
		this.secure_user = this.PrivCtrlReg.secure_user;
		this.PrivCtrlReg_crc_user = this.PrivCtrlReg.crc_user;
		this.crc_user = this.PrivCtrlReg.crc_user;
		this.PrivCtrlReg_eeprom_user = this.PrivCtrlReg.eeprom_user;
		this.eeprom_user = this.PrivCtrlReg.eeprom_user;
		this.PrivCtrlReg_rf_user = this.PrivCtrlReg.rf_user;
		this.rf_user = this.PrivCtrlReg.rf_user;
		this.PrivCtrlReg_des_user = this.PrivCtrlReg.des_user;
		this.des_user = this.PrivCtrlReg.des_user;
		this.PrivCtrlReg_rsa_user = this.PrivCtrlReg.rsa_user;
		this.rsa_user = this.PrivCtrlReg.rsa_user;
		this.PrivCtrlReg_clk_user = this.PrivCtrlReg.clk_user;
		this.clk_user = this.PrivCtrlReg.clk_user;
		this.PrivCtrlReg_ssf33_user = this.PrivCtrlReg.ssf33_user;
		this.ssf33_user = this.PrivCtrlReg.ssf33_user;
		this.PrivCtrlReg_sm1_user = this.PrivCtrlReg.sm1_user;
		this.sm1_user = this.PrivCtrlReg.sm1_user;
		this.PrivCtrlReg_sm3_user = this.PrivCtrlReg.sm3_user;
		this.sm3_user = this.PrivCtrlReg.sm3_user;
		this.PrivCtrlReg_sm7_user = this.PrivCtrlReg.sm7_user;
		this.sm7_user = this.PrivCtrlReg.sm7_user;
		this.RstEnReg = new(this, "RstEnReg", `VMM_RAL_ADDR_WIDTH'h0, "", cover_on, 2'b11, 0);
		this.RstEnReg_sw_rst_en = this.RstEnReg.sw_rst_en;
		this.sw_rst_en = this.RstEnReg.sw_rst_en;
		this.RstEnReg_wd_rst_en = this.RstEnReg.wd_rst_en;
		this.wd_rst_en = this.RstEnReg.wd_rst_en;
		this.RstEnReg_tdh_rst_en = this.RstEnReg.tdh_rst_en;
		this.tdh_rst_en = this.RstEnReg.tdh_rst_en;
		this.RstEnReg_tdl_rst_en = this.RstEnReg.tdl_rst_en;
		this.tdl_rst_en = this.RstEnReg.tdl_rst_en;
		this.RstEnReg_fdh_rst_en = this.RstEnReg.fdh_rst_en;
		this.fdh_rst_en = this.RstEnReg.fdh_rst_en;
		this.RstEnReg_fdl_rst_en = this.RstEnReg.fdl_rst_en;
		this.fdl_rst_en = this.RstEnReg.fdl_rst_en;
		this.RstEnReg_light_rst_en = this.RstEnReg.light_rst_en;
		this.light_rst_en = this.RstEnReg.light_rst_en;
		this.RstEnReg_md_rst_en = this.RstEnReg.md_rst_en;
		this.md_rst_en = this.RstEnReg.md_rst_en;
		this.RstEnReg_shield_rst_en = this.RstEnReg.shield_rst_en;
		this.shield_rst_en = this.RstEnReg.shield_rst_en;
		this.RstEnReg_vdh_rst_en = this.RstEnReg.vdh_rst_en;
		this.vdh_rst_en = this.RstEnReg.vdh_rst_en;
		this.RstTypReg = new(this, "RstTypReg", `VMM_RAL_ADDR_WIDTH'h4, "", cover_on, 2'b11, 0);
		this.RstTypReg_sw_rst_typ = this.RstTypReg.sw_rst_typ;
		this.sw_rst_typ = this.RstTypReg.sw_rst_typ;
		this.RstTypReg_wd_rst_typ = this.RstTypReg.wd_rst_typ;
		this.wd_rst_typ = this.RstTypReg.wd_rst_typ;
		this.RstTypReg_tdh_rst_typ = this.RstTypReg.tdh_rst_typ;
		this.tdh_rst_typ = this.RstTypReg.tdh_rst_typ;
		this.RstTypReg_tdl_rst_typ = this.RstTypReg.tdl_rst_typ;
		this.tdl_rst_typ = this.RstTypReg.tdl_rst_typ;
		this.RstTypReg_fdh_rst_typ = this.RstTypReg.fdh_rst_typ;
		this.fdh_rst_typ = this.RstTypReg.fdh_rst_typ;
		this.RstTypReg_fdl_rst_typ = this.RstTypReg.fdl_rst_typ;
		this.fdl_rst_typ = this.RstTypReg.fdl_rst_typ;
		this.RstTypReg_light_rst_typ = this.RstTypReg.light_rst_typ;
		this.light_rst_typ = this.RstTypReg.light_rst_typ;
		this.RstTypReg_md_rst_typ = this.RstTypReg.md_rst_typ;
		this.md_rst_typ = this.RstTypReg.md_rst_typ;
		this.RstTypReg_shield_rst_typ = this.RstTypReg.shield_rst_typ;
		this.shield_rst_typ = this.RstTypReg.shield_rst_typ;
		this.RstTypReg_sci7816_rst_typ = this.RstTypReg.sci7816_rst_typ;
		this.sci7816_rst_typ = this.RstTypReg.sci7816_rst_typ;
		this.RstTypReg_vdh_rst_typ = this.RstTypReg.vdh_rst_typ;
		this.vdh_rst_typ = this.RstTypReg.vdh_rst_typ;
		this.SDCntrlReg = new(this, "SDCntrlReg", `VMM_RAL_ADDR_WIDTH'h100, "", cover_on, 2'b11, 0);
		this.SDCntrlReg_MD_open = this.SDCntrlReg.MD_open;
		this.MD_open = this.SDCntrlReg.MD_open;
		this.SDCntrlReg_FD_open = this.SDCntrlReg.FD_open;
		this.FD_open = this.SDCntrlReg.FD_open;
		this.SDCntrlReg_FDH_en = this.SDCntrlReg.FDH_en;
		this.FDH_en = this.SDCntrlReg.FDH_en;
		this.SDCntrlReg_FDL_en = this.SDCntrlReg.FDL_en;
		this.FDL_en = this.SDCntrlReg.FDL_en;
		this.SDCntrlReg_Light_en = this.SDCntrlReg.Light_en;
		this.Light_en = this.SDCntrlReg.Light_en;
		this.SDCntrlReg_TD_open = this.SDCntrlReg.TD_open;
		this.TD_open = this.SDCntrlReg.TD_open;
		this.SDCntrlReg_TDH_en = this.SDCntrlReg.TDH_en;
		this.TDH_en = this.SDCntrlReg.TDH_en;
		this.SDCntrlReg_TDL_en = this.SDCntrlReg.TDL_en;
		this.TDL_en = this.SDCntrlReg.TDL_en;
		this.SDCntrlReg_VD_open = this.SDCntrlReg.VD_open;
		this.VD_open = this.SDCntrlReg.VD_open;
		this.SDCntrlReg_VDH_en = this.SDCntrlReg.VDH_en;
		this.VDH_en = this.SDCntrlReg.VDH_en;
		this.SDCntrlReg_VHL_en = this.SDCntrlReg.VHL_en;
		this.VHL_en = this.SDCntrlReg.VHL_en;
		this.SDCntrlReg_MD_en = this.SDCntrlReg.MD_en;
		this.MD_en = this.SDCntrlReg.MD_en;
		this.SDCntrlReg_LD_en = this.SDCntrlReg.LD_en;
		this.LD_en = this.SDCntrlReg.LD_en;
		this.SDCntrlReg_RNI_en = this.SDCntrlReg.RNI_en;
		this.RNI_en = this.SDCntrlReg.RNI_en;
		this.SDCntrlReg_RNI_sel = this.SDCntrlReg.RNI_sel;
		this.RNI_sel = this.SDCntrlReg.RNI_sel;
		this.SWGenReg = new(this, "SWGenReg", `VMM_RAL_ADDR_WIDTH'h8, "", cover_on, 2'b11, 0);
		this.SWGenReg_SWGenReg = this.SWGenReg.SWGenReg;
		this.med_con = new(this, "med_con", `VMM_RAL_ADDR_WIDTH'h114, "", cover_on, 2'b11, 0);
		this.med_con_ram_en = this.med_con.ram_en;
		this.ram_en = this.med_con.ram_en;
		this.med_con_ee_en = this.med_con.ee_en;
		this.ee_en = this.med_con.ee_en;
		this.med_con_rom_en = this.med_con.rom_en;
		this.rom_en = this.med_con.rom_en;
		this.ramkey_cap = new(this, "ramkey_cap", `VMM_RAL_ADDR_WIDTH'h118, "", cover_on, 2'b11, 0);
		this.ramkey_cap_ramkey_cap = this.ramkey_cap.ramkey_cap;
		this.romswitch = new(this, "romswitch", `VMM_RAL_ADDR_WIDTH'hFC, "", cover_on, 2'b11, 0);
		this.romswitch_romswitch = this.romswitch.romswitch;
		this.shield1data = new(this, "shield1data", `VMM_RAL_ADDR_WIDTH'h104, "", cover_on, 2'b11, 0);
		this.shield1data_shield1_din = this.shield1data.shield1_din;
		this.shield1_din = this.shield1data.shield1_din;
		this.shield1stat = new(this, "shield1stat", `VMM_RAL_ADDR_WIDTH'h10C, "", cover_on, 2'b11, 0);
		this.shield1stat_shield1_dout = this.shield1stat.shield1_dout;
		this.shield1_dout = this.shield1stat.shield1_dout;
		this.shield1stat_valid1 = this.shield1stat.valid1;
		this.valid1 = this.shield1stat.valid1;
		this.shield1stat_alarm1 = this.shield1stat.alarm1;
		this.alarm1 = this.shield1stat.alarm1;
		this.shield2data = new(this, "shield2data", `VMM_RAL_ADDR_WIDTH'h108, "", cover_on, 2'b11, 0);
		this.shield2data_shield2_din = this.shield2data.shield2_din;
		this.shield2_din = this.shield2data.shield2_din;
		this.shield2stat = new(this, "shield2stat", `VMM_RAL_ADDR_WIDTH'h110, "", cover_on, 2'b11, 0);
		this.shield2stat_shield2_dout = this.shield2stat.shield2_dout;
		this.shield2_dout = this.shield2stat.shield2_dout;
		this.shield2stat_valid2 = this.shield2stat.valid2;
		this.valid2 = this.shield2stat.valid2;
		this.shield2stat_alarm2 = this.shield2stat.alarm2;
		this.alarm2 = this.shield2stat.alarm2;
		this.testfuse = new(this, "testfuse", `VMM_RAL_ADDR_WIDTH'hF8, "", cover_on, 2'b11, 0);
		this.testfuse_testfuse = this.testfuse.testfuse;
		this.Xlock_modelX();
	endfunction : new
endclass : ral_block_SYSCTRL


class ral_reg_EECTRLCFG extends vmm_ral_reg;
	rand vmm_ral_field WR_MODE;
	rand vmm_ral_field EVPP_EN;
	rand vmm_ral_field SEL_OTP;
	rand vmm_ral_field SEL32;
	rand vmm_ral_field KEY_LOAD;
	rand vmm_ral_field TC;
	rand vmm_ral_field TEST_SEL;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.WR_MODE = new(this, "WR_MODE", 2, vmm_ral::RW, 'h0, 2'hx, 0, 0, cvr);
		this.EVPP_EN = new(this, "EVPP_EN", 1, vmm_ral::RW, 'h0, 1'hx, 2, 0, cvr);
		this.SEL_OTP = new(this, "SEL_OTP", 1, vmm_ral::RW, 'h0, 1'hx, 3, 0, cvr);
		this.SEL32 = new(this, "SEL32", 2, vmm_ral::RW, 'h2, 2'hx, 4, 0, cvr);
		this.KEY_LOAD = new(this, "KEY_LOAD", 1, vmm_ral::RW, 'h0, 1'hx, 7, 0, cvr);
		this.TC = new(this, "TC", 1, vmm_ral::RW, 'h0, 1'hx, 8, 0, cvr);
		this.TEST_SEL = new(this, "TEST_SEL", 5, vmm_ral::RW, 'h0, 5'hx, 9, 0, cvr);
	endfunction: new
endclass : ral_reg_EECTRLCFG


class ral_reg_EECTRLINT extends vmm_ral_reg;
	rand vmm_ral_field EE_Int;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.EE_Int = new(this, "EE_Int", 1, vmm_ral::W1C, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_EECTRLINT


class ral_reg_EECTRLTIMEPARA extends vmm_ral_reg;
	rand vmm_ral_field Trspra;
	rand vmm_ral_field Trdpara;
	rand vmm_ral_field T1dpara;
	rand vmm_ral_field Twepara;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.Trspra = new(this, "Trspra", 8, vmm_ral::RW, 'h1D, 8'hx, 0, 0, cvr);
		this.Trdpara = new(this, "Trdpara", 8, vmm_ral::RW, 'h1D, 8'hx, 8, 0, cvr);
		this.T1dpara = new(this, "T1dpara", 8, vmm_ral::RW, 'h02, 8'hx, 16, 0, cvr);
		this.Twepara = new(this, "Twepara", 8, vmm_ral::RW, 'h06, 8'hx, 24, 0, cvr);
	endfunction: new
endclass : ral_reg_EECTRLTIMEPARA


class ral_reg_EECTRLWRCTRL extends vmm_ral_reg;
	rand vmm_ral_field BUF_CLR;
	rand vmm_ral_field PROGRAM_EN;
	rand vmm_ral_field ERASE;
	rand vmm_ral_field WRITE;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.BUF_CLR = new(this, "BUF_CLR", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.PROGRAM_EN = new(this, "PROGRAM_EN", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
		this.ERASE = new(this, "ERASE", 1, vmm_ral::RW, 'h0, 1'hx, 2, 0, cvr);
		this.WRITE = new(this, "WRITE", 1, vmm_ral::RW, 'h0, 1'hx, 3, 0, cvr);
	endfunction: new
endclass : ral_reg_EECTRLWRCTRL


class ral_reg_EECTRLWRMODE extends vmm_ral_reg;
	rand vmm_ral_field HwEwStart;
	rand vmm_ral_field HwErOrWr;
	rand vmm_ral_field HwEWMode;
	rand vmm_ral_field EW_En;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.HwEwStart = new(this, "HwEwStart", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.HwErOrWr = new(this, "HwErOrWr", 2, vmm_ral::RW, 'h0, 2'hx, 1, 0, cvr);
		this.HwEWMode = new(this, "HwEWMode", 1, vmm_ral::RW, 'h0, 1'hx, 3, 0, cvr);
		this.EW_En = new(this, "EW_En", 1, vmm_ral::RW, 'h0, 1'hx, 4, 0, cvr);
	endfunction: new
endclass : ral_reg_EECTRLWRMODE


class ral_reg_eectrlrdmode extends vmm_ral_reg;
	rand vmm_ral_field readmode;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.readmode = new(this, "readmode", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_eectrlrdmode


class ral_block_EECTRL extends vmm_ral_block;
	rand ral_reg_EECTRLCFG EECTRLCFG;
	rand ral_reg_EECTRLINT EECTRLINT;
	rand ral_reg_EECTRLTIMEPARA EECTRLTIMEPARA;
	rand ral_reg_EECTRLWRCTRL EECTRLWRCTRL;
	rand ral_reg_EECTRLWRMODE EECTRLWRMODE;
	rand ral_reg_eectrlrdmode eectrlrdmode;
	rand vmm_ral_field EECTRLCFG_WR_MODE;
	rand vmm_ral_field WR_MODE;
	rand vmm_ral_field EECTRLCFG_EVPP_EN;
	rand vmm_ral_field EVPP_EN;
	rand vmm_ral_field EECTRLCFG_SEL_OTP;
	rand vmm_ral_field SEL_OTP;
	rand vmm_ral_field EECTRLCFG_SEL32;
	rand vmm_ral_field SEL32;
	rand vmm_ral_field EECTRLCFG_KEY_LOAD;
	rand vmm_ral_field KEY_LOAD;
	rand vmm_ral_field EECTRLCFG_TC;
	rand vmm_ral_field TC;
	rand vmm_ral_field EECTRLCFG_TEST_SEL;
	rand vmm_ral_field TEST_SEL;
	rand vmm_ral_field EECTRLINT_EE_Int;
	rand vmm_ral_field EE_Int;
	rand vmm_ral_field EECTRLTIMEPARA_Trspra;
	rand vmm_ral_field Trspra;
	rand vmm_ral_field EECTRLTIMEPARA_Trdpara;
	rand vmm_ral_field Trdpara;
	rand vmm_ral_field EECTRLTIMEPARA_T1dpara;
	rand vmm_ral_field T1dpara;
	rand vmm_ral_field EECTRLTIMEPARA_Twepara;
	rand vmm_ral_field Twepara;
	rand vmm_ral_field EECTRLWRCTRL_BUF_CLR;
	rand vmm_ral_field BUF_CLR;
	rand vmm_ral_field EECTRLWRCTRL_PROGRAM_EN;
	rand vmm_ral_field PROGRAM_EN;
	rand vmm_ral_field EECTRLWRCTRL_ERASE;
	rand vmm_ral_field ERASE;
	rand vmm_ral_field EECTRLWRCTRL_WRITE;
	rand vmm_ral_field WRITE;
	rand vmm_ral_field EECTRLWRMODE_HwEwStart;
	rand vmm_ral_field HwEwStart;
	rand vmm_ral_field EECTRLWRMODE_HwErOrWr;
	rand vmm_ral_field HwErOrWr;
	rand vmm_ral_field EECTRLWRMODE_HwEWMode;
	rand vmm_ral_field HwEWMode;
	rand vmm_ral_field EECTRLWRMODE_EW_En;
	rand vmm_ral_field EW_En;
	rand vmm_ral_field eectrlrdmode_readmode;
	rand vmm_ral_field readmode;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "EECTRL", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "EECTRL", 128, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on);
		this.EECTRLCFG = new(this, "EECTRLCFG", `VMM_RAL_ADDR_WIDTH'h10, "", cover_on, 2'b11, 0);
		this.EECTRLCFG_WR_MODE = this.EECTRLCFG.WR_MODE;
		this.WR_MODE = this.EECTRLCFG.WR_MODE;
		this.EECTRLCFG_EVPP_EN = this.EECTRLCFG.EVPP_EN;
		this.EVPP_EN = this.EECTRLCFG.EVPP_EN;
		this.EECTRLCFG_SEL_OTP = this.EECTRLCFG.SEL_OTP;
		this.SEL_OTP = this.EECTRLCFG.SEL_OTP;
		this.EECTRLCFG_SEL32 = this.EECTRLCFG.SEL32;
		this.SEL32 = this.EECTRLCFG.SEL32;
		this.EECTRLCFG_KEY_LOAD = this.EECTRLCFG.KEY_LOAD;
		this.KEY_LOAD = this.EECTRLCFG.KEY_LOAD;
		this.EECTRLCFG_TC = this.EECTRLCFG.TC;
		this.TC = this.EECTRLCFG.TC;
		this.EECTRLCFG_TEST_SEL = this.EECTRLCFG.TEST_SEL;
		this.TEST_SEL = this.EECTRLCFG.TEST_SEL;
		this.EECTRLINT = new(this, "EECTRLINT", `VMM_RAL_ADDR_WIDTH'h14, "", cover_on, 2'b11, 0);
		this.EECTRLINT_EE_Int = this.EECTRLINT.EE_Int;
		this.EE_Int = this.EECTRLINT.EE_Int;
		this.EECTRLTIMEPARA = new(this, "EECTRLTIMEPARA", `VMM_RAL_ADDR_WIDTH'h0, "", cover_on, 2'b11, 0);
		this.EECTRLTIMEPARA_Trspra = this.EECTRLTIMEPARA.Trspra;
		this.Trspra = this.EECTRLTIMEPARA.Trspra;
		this.EECTRLTIMEPARA_Trdpara = this.EECTRLTIMEPARA.Trdpara;
		this.Trdpara = this.EECTRLTIMEPARA.Trdpara;
		this.EECTRLTIMEPARA_T1dpara = this.EECTRLTIMEPARA.T1dpara;
		this.T1dpara = this.EECTRLTIMEPARA.T1dpara;
		this.EECTRLTIMEPARA_Twepara = this.EECTRLTIMEPARA.Twepara;
		this.Twepara = this.EECTRLTIMEPARA.Twepara;
		this.EECTRLWRCTRL = new(this, "EECTRLWRCTRL", `VMM_RAL_ADDR_WIDTH'hC, "", cover_on, 2'b11, 0);
		this.EECTRLWRCTRL_BUF_CLR = this.EECTRLWRCTRL.BUF_CLR;
		this.BUF_CLR = this.EECTRLWRCTRL.BUF_CLR;
		this.EECTRLWRCTRL_PROGRAM_EN = this.EECTRLWRCTRL.PROGRAM_EN;
		this.PROGRAM_EN = this.EECTRLWRCTRL.PROGRAM_EN;
		this.EECTRLWRCTRL_ERASE = this.EECTRLWRCTRL.ERASE;
		this.ERASE = this.EECTRLWRCTRL.ERASE;
		this.EECTRLWRCTRL_WRITE = this.EECTRLWRCTRL.WRITE;
		this.WRITE = this.EECTRLWRCTRL.WRITE;
		this.EECTRLWRMODE = new(this, "EECTRLWRMODE", `VMM_RAL_ADDR_WIDTH'h8, "", cover_on, 2'b11, 0);
		this.EECTRLWRMODE_HwEwStart = this.EECTRLWRMODE.HwEwStart;
		this.HwEwStart = this.EECTRLWRMODE.HwEwStart;
		this.EECTRLWRMODE_HwErOrWr = this.EECTRLWRMODE.HwErOrWr;
		this.HwErOrWr = this.EECTRLWRMODE.HwErOrWr;
		this.EECTRLWRMODE_HwEWMode = this.EECTRLWRMODE.HwEWMode;
		this.HwEWMode = this.EECTRLWRMODE.HwEWMode;
		this.EECTRLWRMODE_EW_En = this.EECTRLWRMODE.EW_En;
		this.EW_En = this.EECTRLWRMODE.EW_En;
		this.eectrlrdmode = new(this, "eectrlrdmode", `VMM_RAL_ADDR_WIDTH'h4, "", cover_on, 2'b11, 0);
		this.eectrlrdmode_readmode = this.eectrlrdmode.readmode;
		this.readmode = this.eectrlrdmode.readmode;
		this.Xlock_modelX();
	endfunction : new
endclass : ral_block_EECTRL


class ral_reg_RFBAUT extends vmm_ral_reg;
	rand vmm_ral_field RX_BAUD;
	rand vmm_ral_field TX_BAUD;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.RX_BAUD = new(this, "RX_BAUD", 2, vmm_ral::RW, 'h0, 2'hx, 0, 0, cvr);
		this.TX_BAUD = new(this, "TX_BAUD", 2, vmm_ral::RW, 'h0, 2'hx, 4, 0, cvr);
	endfunction: new
endclass : ral_reg_RFBAUT


class ral_reg_RFCONFIG extends vmm_ral_reg;
	rand vmm_ral_field SWUPTX_TIM;
	rand vmm_ral_field CRC_EN;
	rand vmm_ral_field DIS_INT_ON_ERR;
	rand vmm_ral_field ACB_AUTO_CLOSE;
	rand vmm_ral_field ACB_VALUE;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.SWUPTX_TIM = new(this, "SWUPTX_TIM", 2, vmm_ral::RW, 'h0, 2'hx, 0, 0, cvr);
		this.CRC_EN = new(this, "CRC_EN", 1, vmm_ral::RW, 'h1, 1'hx, 2, 0, cvr);
		this.DIS_INT_ON_ERR = new(this, "DIS_INT_ON_ERR", 1, vmm_ral::RW, 'h0, 1'hx, 3, 0, cvr);
		this.ACB_AUTO_CLOSE = new(this, "ACB_AUTO_CLOSE", 1, vmm_ral::RW, 'h0, 1'hx, 4, 0, cvr);
		this.ACB_VALUE = new(this, "ACB_VALUE", 3, vmm_ral::RW, 'h3, 3'hx, 5, 0, cvr);
	endfunction: new
endclass : ral_reg_RFCONFIG


class ral_reg_RFCTRLR extends vmm_ral_reg;
	rand vmm_ral_field ERR;
	rand vmm_ral_field ACB;
	rand vmm_ral_field ARX;
	rand vmm_ral_field F_F;
	rand vmm_ral_field TX;
	rand vmm_ral_field F_E;
	rand vmm_ral_field RX;
	rand vmm_ral_field RFP;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.ERR = new(this, "ERR", 1, vmm_ral::RO, 'h0, 1'hx, 0, 0, cvr);
		this.ACB = new(this, "ACB", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
		this.ARX = new(this, "ARX", 1, vmm_ral::RW, 'h0, 1'hx, 2, 0, cvr);
		this.F_F = new(this, "F_F", 1, vmm_ral::RO, 'h0, 1'hx, 3, 0, cvr);
		this.TX = new(this, "TX", 1, vmm_ral::RO, 'h0, 1'hx, 4, 0, cvr);
		this.F_E = new(this, "F_E", 1, vmm_ral::RO, 'h0, 1'hx, 5, 0, cvr);
		this.RX = new(this, "RX", 1, vmm_ral::RW, 'h0, 1'hx, 6, 0, cvr);
		this.RFP = new(this, "RFP", 1, vmm_ral::WO, 'h0, 1'hx, 7, 0, cvr);
	endfunction: new
endclass : ral_reg_RFCTRLR


class ral_reg_RFFEATURE extends vmm_ral_reg;
	rand vmm_ral_field RFION;
	rand vmm_ral_field TA;
	rand vmm_ral_field TB;
	rand vmm_ral_field AUTO_SEL;
	rand vmm_ral_field TYPE_ERR;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.RFION = new(this, "RFION", 1, vmm_ral::RW, 'h1, 1'hx, 0, 0, cvr);
		this.TA = new(this, "TA", 1, vmm_ral::RW, 'h1, 1'hx, 1, 0, cvr);
		this.TB = new(this, "TB", 1, vmm_ral::RW, 'h0, 1'hx, 2, 0, cvr);
		this.AUTO_SEL = new(this, "AUTO_SEL", 1, vmm_ral::RW, 'h0, 1'hx, 6, 0, cvr);
		this.TYPE_ERR = new(this, "TYPE_ERR", 1, vmm_ral::RO, 'h0, 1'hx, 7, 0, cvr);
	endfunction: new
endclass : ral_reg_RFFEATURE


class ral_reg_RFFIFODATA extends vmm_ral_reg;
	rand vmm_ral_field RFDATA;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.RFDATA = new(this, "RFDATA", 8, vmm_ral::RW, 'h0, 8'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_RFFIFODATA


class ral_reg_RFFIFORDPTR extends vmm_ral_reg;
	rand vmm_ral_field RFRPTR;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.RFRPTR = new(this, "RFRPTR", 8, vmm_ral::RW, 'h0, 8'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_RFFIFORDPTR


class ral_reg_RFFIFOWRPTR extends vmm_ral_reg;
	rand vmm_ral_field RFWPTR;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.RFWPTR = new(this, "RFWPTR", 8, vmm_ral::RW, 'h0, 8'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_RFFIFOWRPTR


class ral_reg_RFHHAUTH1REG extends vmm_ral_reg;
	rand vmm_ral_field HHAUTHREG1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.HHAUTHREG1 = new(this, "HHAUTHREG1", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_RFHHAUTH1REG


class ral_reg_RFHHAUTH2REG extends vmm_ral_reg;
	rand vmm_ral_field HHAUTHREG2;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.HHAUTHREG2 = new(this, "HHAUTHREG2", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_RFHHAUTH2REG


class ral_reg_RFINTREG extends vmm_ral_reg;
	rand vmm_ral_field RFIntMode;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.RFIntMode = new(this, "RFIntMode", 1, vmm_ral::W1C, 'h0, 1'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_RFINTREG


class ral_reg_RFM1AUTH1REG extends vmm_ral_reg;
	rand vmm_ral_field M1AUTHREG1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.M1AUTHREG1 = new(this, "M1AUTHREG1", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_RFM1AUTH1REG


class ral_reg_RFM1AUTH2REG extends vmm_ral_reg;
	rand vmm_ral_field M1AUTHREG2;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.M1AUTHREG2 = new(this, "M1AUTHREG2", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_RFM1AUTH2REG


class ral_reg_RFMODE extends vmm_ral_reg;
	rand vmm_ral_field TXOSM;
	rand vmm_ral_field RXOSM;
	rand vmm_ral_field RXOSM_TIM;
	rand vmm_ral_field TXOSM_TIM;
	rand vmm_ral_field RFPTX;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.TXOSM = new(this, "TXOSM", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.RXOSM = new(this, "RXOSM", 1, vmm_ral::RW, 'h0, 1'hx, 1, 0, cvr);
		this.RXOSM_TIM = new(this, "RXOSM_TIM", 2, vmm_ral::RW, 'h0, 2'hx, 2, 0, cvr);
		this.TXOSM_TIM = new(this, "TXOSM_TIM", 3, vmm_ral::RW, 'h0, 3'hx, 4, 0, cvr);
		this.RFPTX = new(this, "RFPTX", 1, vmm_ral::RW, 'h0, 1'hx, 7, 0, cvr);
	endfunction: new
endclass : ral_reg_RFMODE


class ral_reg_RFSTATE extends vmm_ral_reg;
	rand vmm_ral_field CRCERR;
	rand vmm_ral_field FERR;
	rand vmm_ral_field EGTERR;
	rand vmm_ral_field BERR;
	rand vmm_ral_field PERR;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.CRCERR = new(this, "CRCERR", 1, vmm_ral::RO, 'h0, 1'hx, 0, 0, cvr);
		this.FERR = new(this, "FERR", 1, vmm_ral::RO, 'h0, 1'hx, 1, 0, cvr);
		this.EGTERR = new(this, "EGTERR", 1, vmm_ral::RO, 'h0, 1'hx, 2, 0, cvr);
		this.BERR = new(this, "BERR", 1, vmm_ral::RO, 'h0, 1'hx, 3, 0, cvr);
		this.PERR = new(this, "PERR", 1, vmm_ral::RO, 'h0, 1'hx, 4, 0, cvr);
	endfunction: new
endclass : ral_reg_RFSTATE


class ral_reg_RFTYPEACFG extends vmm_ral_reg;
	rand vmm_ral_field TA_CAS_LEV;
	rand vmm_ral_field TA_PRTY;
	rand vmm_ral_field TA_LPRTY_INV;
	rand vmm_ral_field HALF_BYTE;
	rand vmm_ral_field M1_AUTH;
	rand vmm_ral_field HH_AUTH;
	rand vmm_ral_field M1_DIS_CRYPTO;
	rand vmm_ral_field HH_DIS_CRYPTO;
	rand vmm_ral_field KEY_SEL;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.TA_CAS_LEV = new(this, "TA_CAS_LEV", 2, vmm_ral::RW, 'h0, 2'hx, 0, 0, cvr);
		this.TA_PRTY = new(this, "TA_PRTY", 2, vmm_ral::RW, 'h01, 2'hx, 4, 0, cvr);
		this.TA_LPRTY_INV = new(this, "TA_LPRTY_INV", 1, vmm_ral::RW, 'h0, 1'hx, 6, 0, cvr);
		this.HALF_BYTE = new(this, "HALF_BYTE", 1, vmm_ral::RW, 'h0, 1'hx, 7, 0, cvr);
		this.M1_AUTH = new(this, "M1_AUTH", 1, vmm_ral::RW, 'h0, 1'hx, 8, 0, cvr);
		this.HH_AUTH = new(this, "HH_AUTH", 1, vmm_ral::RW, 'h0, 1'hx, 9, 0, cvr);
		this.M1_DIS_CRYPTO = new(this, "M1_DIS_CRYPTO", 1, vmm_ral::RW, 'h0, 1'hx, 10, 0, cvr);
		this.HH_DIS_CRYPTO = new(this, "HH_DIS_CRYPTO", 1, vmm_ral::RW, 'h0, 1'hx, 11, 0, cvr);
		this.KEY_SEL = new(this, "KEY_SEL", 1, vmm_ral::RW, 'h0, 1'hx, 12, 0, cvr);
	endfunction: new
endclass : ral_reg_RFTYPEACFG


class ral_reg_RFTYPEACTRL extends vmm_ral_reg;
	rand vmm_ral_field AUTH_START;
	rand vmm_ral_field SET_IDLE;
	rand vmm_ral_field SET_HALT;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.AUTH_START = new(this, "AUTH_START", 1, vmm_ral::RW, 'h0, 1'hx, 0, 0, cvr);
		this.SET_IDLE = new(this, "SET_IDLE", 1, vmm_ral::W1, 'h0, 1'hx, 1, 0, cvr);
		this.SET_HALT = new(this, "SET_HALT", 1, vmm_ral::W1, 'h0, 1'hx, 2, 0, cvr);
	endfunction: new
endclass : ral_reg_RFTYPEACTRL


class ral_reg_RFTYPEADATA1 extends vmm_ral_reg;
	rand vmm_ral_field UID0;
	rand vmm_ral_field UID1;
	rand vmm_ral_field UID2;
	rand vmm_ral_field UID3;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.UID0 = new(this, "UID0", 8, vmm_ral::RW, 'h0, 8'hx, 0, 0, cvr);
		this.UID1 = new(this, "UID1", 8, vmm_ral::RW, 'h0, 8'hx, 8, 0, cvr);
		this.UID2 = new(this, "UID2", 8, vmm_ral::RW, 'h0, 8'hx, 16, 0, cvr);
		this.UID3 = new(this, "UID3", 8, vmm_ral::RW, 'h0, 8'hx, 24, 0, cvr);
	endfunction: new
endclass : ral_reg_RFTYPEADATA1


class ral_reg_RFTYPEADATA2 extends vmm_ral_reg;
	rand vmm_ral_field UID4;
	rand vmm_ral_field UID5;
	rand vmm_ral_field UID6;
	rand vmm_ral_field UID7;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.UID4 = new(this, "UID4", 8, vmm_ral::RW, 'h0, 8'hx, 0, 0, cvr);
		this.UID5 = new(this, "UID5", 8, vmm_ral::RW, 'h0, 8'hx, 8, 0, cvr);
		this.UID6 = new(this, "UID6", 8, vmm_ral::RW, 'h0, 8'hx, 16, 0, cvr);
		this.UID7 = new(this, "UID7", 8, vmm_ral::RW, 'h0, 8'hx, 24, 0, cvr);
	endfunction: new
endclass : ral_reg_RFTYPEADATA2


class ral_reg_RFTYPEADATA3 extends vmm_ral_reg;
	rand vmm_ral_field UID8;
	rand vmm_ral_field UID9;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.UID8 = new(this, "UID8", 8, vmm_ral::RW, 'h0, 8'hx, 0, 0, cvr);
		this.UID9 = new(this, "UID9", 8, vmm_ral::RW, 'h0, 8'hx, 8, 0, cvr);
	endfunction: new
endclass : ral_reg_RFTYPEADATA3


class ral_reg_RFTYPEADATA4 extends vmm_ral_reg;
	rand vmm_ral_field PCODE;
	rand vmm_ral_field SAK;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.PCODE = new(this, "PCODE", 16, vmm_ral::RW, 'h0, 16'hx, 0, 0, cvr);
		this.SAK = new(this, "SAK", 8, vmm_ral::RW, 'h0, 8'hx, 16, 0, cvr);
	endfunction: new
endclass : ral_reg_RFTYPEADATA4


class ral_reg_RFTYPEASTAT extends vmm_ral_reg;
	rand vmm_ral_field M1_VALID;
	rand vmm_ral_field HH_VALID;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.M1_VALID = new(this, "M1_VALID", 1, vmm_ral::RO, 'h0, 1'hx, 0, 0, cvr);
		this.HH_VALID = new(this, "HH_VALID", 1, vmm_ral::RO, 'h0, 1'hx, 1, 0, cvr);
	endfunction: new
endclass : ral_reg_RFTYPEASTAT


class ral_reg_RFTYPEBCFG extends vmm_ral_reg;
	rand vmm_ral_field TBTR1;
	rand vmm_ral_field TB_EGT;
	rand vmm_ral_field TB_SOF_DIS;
	rand vmm_ral_field TB_EOF_DIS;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.TBTR1 = new(this, "TBTR1", 4, vmm_ral::RW, 'h0, 4'hx, 0, 0, cvr);
		this.TB_EGT = new(this, "TB_EGT", 1, vmm_ral::RW, 'h0, 1'hx, 4, 0, cvr);
		this.TB_SOF_DIS = new(this, "TB_SOF_DIS", 1, vmm_ral::RW, 'h0, 1'hx, 5, 0, cvr);
		this.TB_EOF_DIS = new(this, "TB_EOF_DIS", 1, vmm_ral::RW, 'h0, 1'hx, 6, 0, cvr);
	endfunction: new
endclass : ral_reg_RFTYPEBCFG


class ral_block_RFCTRL extends vmm_ral_block;
	rand ral_reg_RFBAUT RFBAUT;
	rand ral_reg_RFCONFIG RFCONFIG;
	rand ral_reg_RFCTRLR RFCTRLR;
	rand ral_reg_RFFEATURE RFFEATURE;
	rand ral_reg_RFFIFODATA RFFIFODATA;
	rand ral_reg_RFFIFORDPTR RFFIFORDPTR;
	rand ral_reg_RFFIFOWRPTR RFFIFOWRPTR;
	rand ral_reg_RFHHAUTH1REG RFHHAUTH1REG;
	rand ral_reg_RFHHAUTH2REG RFHHAUTH2REG;
	rand ral_reg_RFINTREG RFINTREG;
	rand ral_reg_RFM1AUTH1REG RFM1AUTH1REG;
	rand ral_reg_RFM1AUTH2REG RFM1AUTH2REG;
	rand ral_reg_RFMODE RFMODE;
	rand ral_reg_RFSTATE RFSTATE;
	rand ral_reg_RFTYPEACFG RFTYPEACFG;
	rand ral_reg_RFTYPEACTRL RFTYPEACTRL;
	rand ral_reg_RFTYPEADATA1 RFTYPEADATA1;
	rand ral_reg_RFTYPEADATA2 RFTYPEADATA2;
	rand ral_reg_RFTYPEADATA3 RFTYPEADATA3;
	rand ral_reg_RFTYPEADATA4 RFTYPEADATA4;
	rand ral_reg_RFTYPEASTAT RFTYPEASTAT;
	rand ral_reg_RFTYPEBCFG RFTYPEBCFG;
	rand vmm_ral_field RFBAUT_RX_BAUD;
	rand vmm_ral_field RX_BAUD;
	rand vmm_ral_field RFBAUT_TX_BAUD;
	rand vmm_ral_field TX_BAUD;
	rand vmm_ral_field RFCONFIG_SWUPTX_TIM;
	rand vmm_ral_field SWUPTX_TIM;
	rand vmm_ral_field RFCONFIG_CRC_EN;
	rand vmm_ral_field CRC_EN;
	rand vmm_ral_field RFCONFIG_DIS_INT_ON_ERR;
	rand vmm_ral_field DIS_INT_ON_ERR;
	rand vmm_ral_field RFCONFIG_ACB_AUTO_CLOSE;
	rand vmm_ral_field ACB_AUTO_CLOSE;
	rand vmm_ral_field RFCONFIG_ACB_VALUE;
	rand vmm_ral_field ACB_VALUE;
	rand vmm_ral_field RFCTRLR_ERR;
	rand vmm_ral_field ERR;
	rand vmm_ral_field RFCTRLR_ACB;
	rand vmm_ral_field ACB;
	rand vmm_ral_field RFCTRLR_ARX;
	rand vmm_ral_field ARX;
	rand vmm_ral_field RFCTRLR_F_F;
	rand vmm_ral_field F_F;
	rand vmm_ral_field RFCTRLR_TX;
	rand vmm_ral_field TX;
	rand vmm_ral_field RFCTRLR_F_E;
	rand vmm_ral_field F_E;
	rand vmm_ral_field RFCTRLR_RX;
	rand vmm_ral_field RX;
	rand vmm_ral_field RFCTRLR_RFP;
	rand vmm_ral_field RFP;
	rand vmm_ral_field RFFEATURE_RFION;
	rand vmm_ral_field RFION;
	rand vmm_ral_field RFFEATURE_TA;
	rand vmm_ral_field TA;
	rand vmm_ral_field RFFEATURE_TB;
	rand vmm_ral_field TB;
	rand vmm_ral_field RFFEATURE_AUTO_SEL;
	rand vmm_ral_field AUTO_SEL;
	rand vmm_ral_field RFFEATURE_TYPE_ERR;
	rand vmm_ral_field TYPE_ERR;
	rand vmm_ral_field RFFIFODATA_RFDATA;
	rand vmm_ral_field RFDATA;
	rand vmm_ral_field RFFIFORDPTR_RFRPTR;
	rand vmm_ral_field RFRPTR;
	rand vmm_ral_field RFFIFOWRPTR_RFWPTR;
	rand vmm_ral_field RFWPTR;
	rand vmm_ral_field RFHHAUTH1REG_HHAUTHREG1;
	rand vmm_ral_field HHAUTHREG1;
	rand vmm_ral_field RFHHAUTH2REG_HHAUTHREG2;
	rand vmm_ral_field HHAUTHREG2;
	rand vmm_ral_field RFINTREG_RFIntMode;
	rand vmm_ral_field RFIntMode;
	rand vmm_ral_field RFM1AUTH1REG_M1AUTHREG1;
	rand vmm_ral_field M1AUTHREG1;
	rand vmm_ral_field RFM1AUTH2REG_M1AUTHREG2;
	rand vmm_ral_field M1AUTHREG2;
	rand vmm_ral_field RFMODE_TXOSM;
	rand vmm_ral_field TXOSM;
	rand vmm_ral_field RFMODE_RXOSM;
	rand vmm_ral_field RXOSM;
	rand vmm_ral_field RFMODE_RXOSM_TIM;
	rand vmm_ral_field RXOSM_TIM;
	rand vmm_ral_field RFMODE_TXOSM_TIM;
	rand vmm_ral_field TXOSM_TIM;
	rand vmm_ral_field RFMODE_RFPTX;
	rand vmm_ral_field RFPTX;
	rand vmm_ral_field RFSTATE_CRCERR;
	rand vmm_ral_field CRCERR;
	rand vmm_ral_field RFSTATE_FERR;
	rand vmm_ral_field FERR;
	rand vmm_ral_field RFSTATE_EGTERR;
	rand vmm_ral_field EGTERR;
	rand vmm_ral_field RFSTATE_BERR;
	rand vmm_ral_field BERR;
	rand vmm_ral_field RFSTATE_PERR;
	rand vmm_ral_field PERR;
	rand vmm_ral_field RFTYPEACFG_TA_CAS_LEV;
	rand vmm_ral_field TA_CAS_LEV;
	rand vmm_ral_field RFTYPEACFG_TA_PRTY;
	rand vmm_ral_field TA_PRTY;
	rand vmm_ral_field RFTYPEACFG_TA_LPRTY_INV;
	rand vmm_ral_field TA_LPRTY_INV;
	rand vmm_ral_field RFTYPEACFG_HALF_BYTE;
	rand vmm_ral_field HALF_BYTE;
	rand vmm_ral_field RFTYPEACFG_M1_AUTH;
	rand vmm_ral_field M1_AUTH;
	rand vmm_ral_field RFTYPEACFG_HH_AUTH;
	rand vmm_ral_field HH_AUTH;
	rand vmm_ral_field RFTYPEACFG_M1_DIS_CRYPTO;
	rand vmm_ral_field M1_DIS_CRYPTO;
	rand vmm_ral_field RFTYPEACFG_HH_DIS_CRYPTO;
	rand vmm_ral_field HH_DIS_CRYPTO;
	rand vmm_ral_field RFTYPEACFG_KEY_SEL;
	rand vmm_ral_field KEY_SEL;
	rand vmm_ral_field RFTYPEACTRL_AUTH_START;
	rand vmm_ral_field AUTH_START;
	rand vmm_ral_field RFTYPEACTRL_SET_IDLE;
	rand vmm_ral_field SET_IDLE;
	rand vmm_ral_field RFTYPEACTRL_SET_HALT;
	rand vmm_ral_field SET_HALT;
	rand vmm_ral_field RFTYPEADATA1_UID0;
	rand vmm_ral_field UID0;
	rand vmm_ral_field RFTYPEADATA1_UID1;
	rand vmm_ral_field UID1;
	rand vmm_ral_field RFTYPEADATA1_UID2;
	rand vmm_ral_field UID2;
	rand vmm_ral_field RFTYPEADATA1_UID3;
	rand vmm_ral_field UID3;
	rand vmm_ral_field RFTYPEADATA2_UID4;
	rand vmm_ral_field UID4;
	rand vmm_ral_field RFTYPEADATA2_UID5;
	rand vmm_ral_field UID5;
	rand vmm_ral_field RFTYPEADATA2_UID6;
	rand vmm_ral_field UID6;
	rand vmm_ral_field RFTYPEADATA2_UID7;
	rand vmm_ral_field UID7;
	rand vmm_ral_field RFTYPEADATA3_UID8;
	rand vmm_ral_field UID8;
	rand vmm_ral_field RFTYPEADATA3_UID9;
	rand vmm_ral_field UID9;
	rand vmm_ral_field RFTYPEADATA4_PCODE;
	rand vmm_ral_field PCODE;
	rand vmm_ral_field RFTYPEADATA4_SAK;
	rand vmm_ral_field SAK;
	rand vmm_ral_field RFTYPEASTAT_M1_VALID;
	rand vmm_ral_field M1_VALID;
	rand vmm_ral_field RFTYPEASTAT_HH_VALID;
	rand vmm_ral_field HH_VALID;
	rand vmm_ral_field RFTYPEBCFG_TBTR1;
	rand vmm_ral_field TBTR1;
	rand vmm_ral_field RFTYPEBCFG_TB_EGT;
	rand vmm_ral_field TB_EGT;
	rand vmm_ral_field RFTYPEBCFG_TB_SOF_DIS;
	rand vmm_ral_field TB_SOF_DIS;
	rand vmm_ral_field RFTYPEBCFG_TB_EOF_DIS;
	rand vmm_ral_field TB_EOF_DIS;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "RFCTRL", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "RFCTRL", 512, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on);
		this.RFBAUT = new(this, "RFBAUT", `VMM_RAL_ADDR_WIDTH'hC, "", cover_on, 2'b11, 0);
		this.RFBAUT_RX_BAUD = this.RFBAUT.RX_BAUD;
		this.RX_BAUD = this.RFBAUT.RX_BAUD;
		this.RFBAUT_TX_BAUD = this.RFBAUT.TX_BAUD;
		this.TX_BAUD = this.RFBAUT.TX_BAUD;
		this.RFCONFIG = new(this, "RFCONFIG", `VMM_RAL_ADDR_WIDTH'h20, "", cover_on, 2'b11, 0);
		this.RFCONFIG_SWUPTX_TIM = this.RFCONFIG.SWUPTX_TIM;
		this.SWUPTX_TIM = this.RFCONFIG.SWUPTX_TIM;
		this.RFCONFIG_CRC_EN = this.RFCONFIG.CRC_EN;
		this.CRC_EN = this.RFCONFIG.CRC_EN;
		this.RFCONFIG_DIS_INT_ON_ERR = this.RFCONFIG.DIS_INT_ON_ERR;
		this.DIS_INT_ON_ERR = this.RFCONFIG.DIS_INT_ON_ERR;
		this.RFCONFIG_ACB_AUTO_CLOSE = this.RFCONFIG.ACB_AUTO_CLOSE;
		this.ACB_AUTO_CLOSE = this.RFCONFIG.ACB_AUTO_CLOSE;
		this.RFCONFIG_ACB_VALUE = this.RFCONFIG.ACB_VALUE;
		this.ACB_VALUE = this.RFCONFIG.ACB_VALUE;
		this.RFCTRLR = new(this, "RFCTRLR", `VMM_RAL_ADDR_WIDTH'h10, "", cover_on, 2'b11, 0);
		this.RFCTRLR_ERR = this.RFCTRLR.ERR;
		this.ERR = this.RFCTRLR.ERR;
		this.RFCTRLR_ACB = this.RFCTRLR.ACB;
		this.ACB = this.RFCTRLR.ACB;
		this.RFCTRLR_ARX = this.RFCTRLR.ARX;
		this.ARX = this.RFCTRLR.ARX;
		this.RFCTRLR_F_F = this.RFCTRLR.F_F;
		this.F_F = this.RFCTRLR.F_F;
		this.RFCTRLR_TX = this.RFCTRLR.TX;
		this.TX = this.RFCTRLR.TX;
		this.RFCTRLR_F_E = this.RFCTRLR.F_E;
		this.F_E = this.RFCTRLR.F_E;
		this.RFCTRLR_RX = this.RFCTRLR.RX;
		this.RX = this.RFCTRLR.RX;
		this.RFCTRLR_RFP = this.RFCTRLR.RFP;
		this.RFP = this.RFCTRLR.RFP;
		this.RFFEATURE = new(this, "RFFEATURE", `VMM_RAL_ADDR_WIDTH'h1C, "", cover_on, 2'b11, 0);
		this.RFFEATURE_RFION = this.RFFEATURE.RFION;
		this.RFION = this.RFFEATURE.RFION;
		this.RFFEATURE_TA = this.RFFEATURE.TA;
		this.TA = this.RFFEATURE.TA;
		this.RFFEATURE_TB = this.RFFEATURE.TB;
		this.TB = this.RFFEATURE.TB;
		this.RFFEATURE_AUTO_SEL = this.RFFEATURE.AUTO_SEL;
		this.AUTO_SEL = this.RFFEATURE.AUTO_SEL;
		this.RFFEATURE_TYPE_ERR = this.RFFEATURE.TYPE_ERR;
		this.TYPE_ERR = this.RFFEATURE.TYPE_ERR;
		this.RFFIFODATA = new(this, "RFFIFODATA", `VMM_RAL_ADDR_WIDTH'h0, "", cover_on, 2'b11, 0);
		this.RFFIFODATA_RFDATA = this.RFFIFODATA.RFDATA;
		this.RFDATA = this.RFFIFODATA.RFDATA;
		this.RFFIFORDPTR = new(this, "RFFIFORDPTR", `VMM_RAL_ADDR_WIDTH'h8, "", cover_on, 2'b11, 0);
		this.RFFIFORDPTR_RFRPTR = this.RFFIFORDPTR.RFRPTR;
		this.RFRPTR = this.RFFIFORDPTR.RFRPTR;
		this.RFFIFOWRPTR = new(this, "RFFIFOWRPTR", `VMM_RAL_ADDR_WIDTH'h4, "", cover_on, 2'b11, 0);
		this.RFFIFOWRPTR_RFWPTR = this.RFFIFOWRPTR.RFWPTR;
		this.RFWPTR = this.RFFIFOWRPTR.RFWPTR;
		this.RFHHAUTH1REG = new(this, "RFHHAUTH1REG", `VMM_RAL_ADDR_WIDTH'hF8, "", cover_on, 2'b11, 0);
		this.RFHHAUTH1REG_HHAUTHREG1 = this.RFHHAUTH1REG.HHAUTHREG1;
		this.HHAUTHREG1 = this.RFHHAUTH1REG.HHAUTHREG1;
		this.RFHHAUTH2REG = new(this, "RFHHAUTH2REG", `VMM_RAL_ADDR_WIDTH'hFC, "", cover_on, 2'b11, 0);
		this.RFHHAUTH2REG_HHAUTHREG2 = this.RFHHAUTH2REG.HHAUTHREG2;
		this.HHAUTHREG2 = this.RFHHAUTH2REG.HHAUTHREG2;
		this.RFINTREG = new(this, "RFINTREG", `VMM_RAL_ADDR_WIDTH'h44, "", cover_on, 2'b11, 0);
		this.RFINTREG_RFIntMode = this.RFINTREG.RFIntMode;
		this.RFIntMode = this.RFINTREG.RFIntMode;
		this.RFM1AUTH1REG = new(this, "RFM1AUTH1REG", `VMM_RAL_ADDR_WIDTH'hF0, "", cover_on, 2'b11, 0);
		this.RFM1AUTH1REG_M1AUTHREG1 = this.RFM1AUTH1REG.M1AUTHREG1;
		this.M1AUTHREG1 = this.RFM1AUTH1REG.M1AUTHREG1;
		this.RFM1AUTH2REG = new(this, "RFM1AUTH2REG", `VMM_RAL_ADDR_WIDTH'hF4, "", cover_on, 2'b11, 0);
		this.RFM1AUTH2REG_M1AUTHREG2 = this.RFM1AUTH2REG.M1AUTHREG2;
		this.M1AUTHREG2 = this.RFM1AUTH2REG.M1AUTHREG2;
		this.RFMODE = new(this, "RFMODE", `VMM_RAL_ADDR_WIDTH'h18, "", cover_on, 2'b11, 0);
		this.RFMODE_TXOSM = this.RFMODE.TXOSM;
		this.TXOSM = this.RFMODE.TXOSM;
		this.RFMODE_RXOSM = this.RFMODE.RXOSM;
		this.RXOSM = this.RFMODE.RXOSM;
		this.RFMODE_RXOSM_TIM = this.RFMODE.RXOSM_TIM;
		this.RXOSM_TIM = this.RFMODE.RXOSM_TIM;
		this.RFMODE_TXOSM_TIM = this.RFMODE.TXOSM_TIM;
		this.TXOSM_TIM = this.RFMODE.TXOSM_TIM;
		this.RFMODE_RFPTX = this.RFMODE.RFPTX;
		this.RFPTX = this.RFMODE.RFPTX;
		this.RFSTATE = new(this, "RFSTATE", `VMM_RAL_ADDR_WIDTH'h14, "", cover_on, 2'b11, 0);
		this.RFSTATE_CRCERR = this.RFSTATE.CRCERR;
		this.CRCERR = this.RFSTATE.CRCERR;
		this.RFSTATE_FERR = this.RFSTATE.FERR;
		this.FERR = this.RFSTATE.FERR;
		this.RFSTATE_EGTERR = this.RFSTATE.EGTERR;
		this.EGTERR = this.RFSTATE.EGTERR;
		this.RFSTATE_BERR = this.RFSTATE.BERR;
		this.BERR = this.RFSTATE.BERR;
		this.RFSTATE_PERR = this.RFSTATE.PERR;
		this.PERR = this.RFSTATE.PERR;
		this.RFTYPEACFG = new(this, "RFTYPEACFG", `VMM_RAL_ADDR_WIDTH'h24, "", cover_on, 2'b11, 0);
		this.RFTYPEACFG_TA_CAS_LEV = this.RFTYPEACFG.TA_CAS_LEV;
		this.TA_CAS_LEV = this.RFTYPEACFG.TA_CAS_LEV;
		this.RFTYPEACFG_TA_PRTY = this.RFTYPEACFG.TA_PRTY;
		this.TA_PRTY = this.RFTYPEACFG.TA_PRTY;
		this.RFTYPEACFG_TA_LPRTY_INV = this.RFTYPEACFG.TA_LPRTY_INV;
		this.TA_LPRTY_INV = this.RFTYPEACFG.TA_LPRTY_INV;
		this.RFTYPEACFG_HALF_BYTE = this.RFTYPEACFG.HALF_BYTE;
		this.HALF_BYTE = this.RFTYPEACFG.HALF_BYTE;
		this.RFTYPEACFG_M1_AUTH = this.RFTYPEACFG.M1_AUTH;
		this.M1_AUTH = this.RFTYPEACFG.M1_AUTH;
		this.RFTYPEACFG_HH_AUTH = this.RFTYPEACFG.HH_AUTH;
		this.HH_AUTH = this.RFTYPEACFG.HH_AUTH;
		this.RFTYPEACFG_M1_DIS_CRYPTO = this.RFTYPEACFG.M1_DIS_CRYPTO;
		this.M1_DIS_CRYPTO = this.RFTYPEACFG.M1_DIS_CRYPTO;
		this.RFTYPEACFG_HH_DIS_CRYPTO = this.RFTYPEACFG.HH_DIS_CRYPTO;
		this.HH_DIS_CRYPTO = this.RFTYPEACFG.HH_DIS_CRYPTO;
		this.RFTYPEACFG_KEY_SEL = this.RFTYPEACFG.KEY_SEL;
		this.KEY_SEL = this.RFTYPEACFG.KEY_SEL;
		this.RFTYPEACTRL = new(this, "RFTYPEACTRL", `VMM_RAL_ADDR_WIDTH'h28, "", cover_on, 2'b11, 0);
		this.RFTYPEACTRL_AUTH_START = this.RFTYPEACTRL.AUTH_START;
		this.AUTH_START = this.RFTYPEACTRL.AUTH_START;
		this.RFTYPEACTRL_SET_IDLE = this.RFTYPEACTRL.SET_IDLE;
		this.SET_IDLE = this.RFTYPEACTRL.SET_IDLE;
		this.RFTYPEACTRL_SET_HALT = this.RFTYPEACTRL.SET_HALT;
		this.SET_HALT = this.RFTYPEACTRL.SET_HALT;
		this.RFTYPEADATA1 = new(this, "RFTYPEADATA1", `VMM_RAL_ADDR_WIDTH'h30, "", cover_on, 2'b11, 0);
		this.RFTYPEADATA1_UID0 = this.RFTYPEADATA1.UID0;
		this.UID0 = this.RFTYPEADATA1.UID0;
		this.RFTYPEADATA1_UID1 = this.RFTYPEADATA1.UID1;
		this.UID1 = this.RFTYPEADATA1.UID1;
		this.RFTYPEADATA1_UID2 = this.RFTYPEADATA1.UID2;
		this.UID2 = this.RFTYPEADATA1.UID2;
		this.RFTYPEADATA1_UID3 = this.RFTYPEADATA1.UID3;
		this.UID3 = this.RFTYPEADATA1.UID3;
		this.RFTYPEADATA2 = new(this, "RFTYPEADATA2", `VMM_RAL_ADDR_WIDTH'h34, "", cover_on, 2'b11, 0);
		this.RFTYPEADATA2_UID4 = this.RFTYPEADATA2.UID4;
		this.UID4 = this.RFTYPEADATA2.UID4;
		this.RFTYPEADATA2_UID5 = this.RFTYPEADATA2.UID5;
		this.UID5 = this.RFTYPEADATA2.UID5;
		this.RFTYPEADATA2_UID6 = this.RFTYPEADATA2.UID6;
		this.UID6 = this.RFTYPEADATA2.UID6;
		this.RFTYPEADATA2_UID7 = this.RFTYPEADATA2.UID7;
		this.UID7 = this.RFTYPEADATA2.UID7;
		this.RFTYPEADATA3 = new(this, "RFTYPEADATA3", `VMM_RAL_ADDR_WIDTH'h38, "", cover_on, 2'b11, 0);
		this.RFTYPEADATA3_UID8 = this.RFTYPEADATA3.UID8;
		this.UID8 = this.RFTYPEADATA3.UID8;
		this.RFTYPEADATA3_UID9 = this.RFTYPEADATA3.UID9;
		this.UID9 = this.RFTYPEADATA3.UID9;
		this.RFTYPEADATA4 = new(this, "RFTYPEADATA4", `VMM_RAL_ADDR_WIDTH'h3C, "", cover_on, 2'b11, 0);
		this.RFTYPEADATA4_PCODE = this.RFTYPEADATA4.PCODE;
		this.PCODE = this.RFTYPEADATA4.PCODE;
		this.RFTYPEADATA4_SAK = this.RFTYPEADATA4.SAK;
		this.SAK = this.RFTYPEADATA4.SAK;
		this.RFTYPEASTAT = new(this, "RFTYPEASTAT", `VMM_RAL_ADDR_WIDTH'h2C, "", cover_on, 2'b11, 0);
		this.RFTYPEASTAT_M1_VALID = this.RFTYPEASTAT.M1_VALID;
		this.M1_VALID = this.RFTYPEASTAT.M1_VALID;
		this.RFTYPEASTAT_HH_VALID = this.RFTYPEASTAT.HH_VALID;
		this.HH_VALID = this.RFTYPEASTAT.HH_VALID;
		this.RFTYPEBCFG = new(this, "RFTYPEBCFG", `VMM_RAL_ADDR_WIDTH'h40, "", cover_on, 2'b11, 0);
		this.RFTYPEBCFG_TBTR1 = this.RFTYPEBCFG.TBTR1;
		this.TBTR1 = this.RFTYPEBCFG.TBTR1;
		this.RFTYPEBCFG_TB_EGT = this.RFTYPEBCFG.TB_EGT;
		this.TB_EGT = this.RFTYPEBCFG.TB_EGT;
		this.RFTYPEBCFG_TB_SOF_DIS = this.RFTYPEBCFG.TB_SOF_DIS;
		this.TB_SOF_DIS = this.RFTYPEBCFG.TB_SOF_DIS;
		this.RFTYPEBCFG_TB_EOF_DIS = this.RFTYPEBCFG.TB_EOF_DIS;
		this.TB_EOF_DIS = this.RFTYPEBCFG.TB_EOF_DIS;
		this.Xlock_modelX();
	endfunction : new
endclass : ral_block_RFCTRL


class ral_mem_EEPROM extends vmm_ral_mem;
	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] base_address, string domain, int cvr,
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, vmm_ral::RW, `VMM_RAL_ADDR_WIDTH'h4800, 32, base_address, domain, cvr, rights, unmapped);
	endfunction: new
endclass : ral_mem_EEPROM


class ral_mem_PROM_P extends vmm_ral_mem;
	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] base_address, string domain, int cvr,
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, vmm_ral::RW, `VMM_RAL_ADDR_WIDTH'h4800, 32, base_address, domain, cvr, rights, unmapped);
	endfunction: new
endclass : ral_mem_PROM_P


class ral_mem_PROM_T extends vmm_ral_mem;
	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] base_address, string domain, int cvr,
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, vmm_ral::RW, `VMM_RAL_ADDR_WIDTH'h4800, 32, base_address, domain, cvr, rights, unmapped);
	endfunction: new
endclass : ral_mem_PROM_T


class ral_mem_SRAM extends vmm_ral_mem;
	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] base_address, string domain, int cvr,
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, vmm_ral::RW, `VMM_RAL_ADDR_WIDTH'h800, 32, base_address, domain, cvr, rights, unmapped);
	endfunction: new
endclass : ral_mem_SRAM


class ral_mem_TROM1 extends vmm_ral_mem;
	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] base_address, string domain, int cvr,
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, vmm_ral::RO, `VMM_RAL_ADDR_WIDTH'h2000, 32, base_address, domain, cvr, rights, unmapped);
	endfunction: new
endclass : ral_mem_TROM1


class ral_mem_TROM2 extends vmm_ral_mem;
	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] base_address, string domain, int cvr,
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, vmm_ral::RO, `VMM_RAL_ADDR_WIDTH'h2000, 32, base_address, domain, cvr, rights, unmapped);
	endfunction: new
endclass : ral_mem_TROM2


class ral_block_MEM extends vmm_ral_block;
	rand ral_mem_EEPROM EEPROM;
	rand ral_mem_PROM_P PROM_P;
	rand ral_mem_PROM_T PROM_T;
	rand ral_mem_SRAM SRAM;
	rand ral_mem_TROM1 TROM1;
	rand ral_mem_TROM2 TROM2;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "MEM", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "MEM", 163840, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on);
		this.EEPROM = new(this, "EEPROM", `VMM_RAL_ADDR_WIDTH'h80000, "", cover_on, 2'b11, 0);
		this.PROM_P = new(this, "PROM_P", `VMM_RAL_ADDR_WIDTH'h0, "", cover_on, 2'b11, 0);
		this.PROM_T = new(this, "PROM_T", `VMM_RAL_ADDR_WIDTH'h10000, "", cover_on, 2'b11, 0);
		this.SRAM = new(this, "SRAM", `VMM_RAL_ADDR_WIDTH'hD0000, "", cover_on, 2'b11, 0);
		this.TROM1 = new(this, "TROM1", `VMM_RAL_ADDR_WIDTH'h0, "", cover_on, 2'b11, 0);
		this.TROM2 = new(this, "TROM2", `VMM_RAL_ADDR_WIDTH'h78000, "", cover_on, 2'b11, 0);
		this.Xlock_modelX();
	endfunction : new
endclass : ral_block_MEM


class ral_sys_CHIP2901M4 extends vmm_ral_sys;
	rand ral_block_WDT WDT;
	rand ral_block_SCI7816 SCI7816;
	rand ral_block_ICTL ICTL;
	rand ral_block_GPIO GPIO;
	rand ral_block_RNG RNG;
	rand ral_block_TIMER TIMER;
	rand ral_block_TRICKBOX TRICKBOX;
	rand ral_block_DES DES;
	rand ral_block_SM1 SM1;
	rand ral_block_SSF33 SSF33;
	rand ral_block_SM7 SM7;
	rand ral_block_SM3 SM3;
	rand ral_block_CRC CRC;
	rand ral_block_RSA RSA;
	rand ral_block_SYSCTRL SYSCTRL;
	rand ral_block_EECTRL EECTRL;
	rand ral_block_RFCTRL RFCTRL;
	rand ral_block_MEM MEM;

	function new(int cover_on = vmm_ral::NO_COVERAGE, string name = "CHIP2901M4", vmm_ral_sys parent = null, integer base_addr = 0);
		super.new(parent, name, "CHIP2901M4", 1048576, vmm_ral::LITTLE_ENDIAN, base_addr, "", cover_on);
		this.WDT = new(cover_on, "WDT", this, `VMM_RAL_ADDR_WIDTH'hF0000);
		this.register_block(this.WDT, "", "", `VMM_RAL_ADDR_WIDTH'hF0000);
		this.SCI7816 = new(cover_on, "SCI7816", this, `VMM_RAL_ADDR_WIDTH'hF0400);
		this.register_block(this.SCI7816, "", "", `VMM_RAL_ADDR_WIDTH'hF0400);
		this.ICTL = new(cover_on, "ICTL", this, `VMM_RAL_ADDR_WIDTH'hF0C00);
		this.register_block(this.ICTL, "", "", `VMM_RAL_ADDR_WIDTH'hF0C00);
		this.GPIO = new(cover_on, "GPIO", this, `VMM_RAL_ADDR_WIDTH'hF1000);
		this.register_block(this.GPIO, "", "", `VMM_RAL_ADDR_WIDTH'hF1000);
		this.RNG = new(cover_on, "RNG", this, `VMM_RAL_ADDR_WIDTH'hF1800);
		this.register_block(this.RNG, "", "", `VMM_RAL_ADDR_WIDTH'hF1800);
		this.TIMER = new(cover_on, "TIMER", this, `VMM_RAL_ADDR_WIDTH'hF1C00);
		this.register_block(this.TIMER, "", "", `VMM_RAL_ADDR_WIDTH'hF1C00);
		this.TRICKBOX = new(cover_on, "TRICKBOX", this, `VMM_RAL_ADDR_WIDTH'hF3C00);
		this.register_block(this.TRICKBOX, "", "", `VMM_RAL_ADDR_WIDTH'hF3C00);
		this.DES = new(cover_on, "DES", this, `VMM_RAL_ADDR_WIDTH'hF4000);
		this.register_block(this.DES, "", "", `VMM_RAL_ADDR_WIDTH'hF4000);
		this.SM1 = new(cover_on, "SM1", this, `VMM_RAL_ADDR_WIDTH'hF4400);
		this.register_block(this.SM1, "", "", `VMM_RAL_ADDR_WIDTH'hF4400);
		this.SSF33 = new(cover_on, "SSF33", this, `VMM_RAL_ADDR_WIDTH'hF4800);
		this.register_block(this.SSF33, "", "", `VMM_RAL_ADDR_WIDTH'hF4800);
		this.SM7 = new(cover_on, "SM7", this, `VMM_RAL_ADDR_WIDTH'hF4C00);
		this.register_block(this.SM7, "", "", `VMM_RAL_ADDR_WIDTH'hF4C00);
		this.SM3 = new(cover_on, "SM3", this, `VMM_RAL_ADDR_WIDTH'hF5000);
		this.register_block(this.SM3, "", "", `VMM_RAL_ADDR_WIDTH'hF5000);
		this.CRC = new(cover_on, "CRC", this, `VMM_RAL_ADDR_WIDTH'hF5400);
		this.register_block(this.CRC, "", "", `VMM_RAL_ADDR_WIDTH'hF5400);
		this.RSA = new(cover_on, "RSA", this, `VMM_RAL_ADDR_WIDTH'hF5800);
		this.register_block(this.RSA, "", "", `VMM_RAL_ADDR_WIDTH'hF5800);
		this.SYSCTRL = new(cover_on, "SYSCTRL", this, `VMM_RAL_ADDR_WIDTH'hF7000);
		this.register_block(this.SYSCTRL, "", "", `VMM_RAL_ADDR_WIDTH'hF7000);
		this.EECTRL = new(cover_on, "EECTRL", this, `VMM_RAL_ADDR_WIDTH'hF8000);
		this.register_block(this.EECTRL, "", "", `VMM_RAL_ADDR_WIDTH'hF8000);
		this.RFCTRL = new(cover_on, "RFCTRL", this, `VMM_RAL_ADDR_WIDTH'hF9400);
		this.register_block(this.RFCTRL, "", "", `VMM_RAL_ADDR_WIDTH'hF9400);
		this.MEM = new(cover_on, "MEM", this, `VMM_RAL_ADDR_WIDTH'h0);
		this.register_block(this.MEM, "", "", `VMM_RAL_ADDR_WIDTH'h0);
		this.Xlock_modelX();
	endfunction : new
endclass : ral_sys_CHIP2901M4


`endif

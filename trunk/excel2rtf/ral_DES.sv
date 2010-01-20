`ifndef RAL_DES
`define RAL_DES

`include "vmm_ral.sv"

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
		this.DESDATA0 = new(this, "DESDATA0", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
	endfunction: new
endclass : ral_reg_DESDATA_REG0


class ral_reg_DESDATA_REG1 extends vmm_ral_reg;
	rand vmm_ral_field DESDATA1;

	function new(vmm_ral_block parent, string name, bit[`VMM_RAL_ADDR_WIDTH-1:0] offset, string domain, int cvr, 
				bit[1:0] rights = 2'b11, bit unmapped = 0);
		super.new(parent, name, 32, offset, domain, cvr, rights, unmapped);
		this.DESDATA1 = new(this, "DESDATA1", 32, vmm_ral::WO, 'h0, 32'hx, 0, 0, cvr);
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


`endif

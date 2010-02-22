`ifdef DEBUG
integer file;

initial 
begin
file = $fopen("../debussy/lq.csv");
DEBUG;
end

task DEBUG;
integer k;
begin
    #100000
    wait(u_ldpc_dec.u_ram00.ADDRB == 8'hf5) begin
    $display("OK,%dns",$time);
    for(k=0;k<256;k=k+1) begin
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram00 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram01 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram02 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram03 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram04 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram05 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram06 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram07 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram08 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram09 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram10 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram11 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram12 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram13 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram14 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram15 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram16 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram17 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram18 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram19 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram20 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram21 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram22 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram23 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram24 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram25 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram26 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram27 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram28 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram29 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram30 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram31 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram32 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram33 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram34 .mem[k]));
    $fdisplay(file,"%d",$signed(u_ldpc_dec.u_ram35 .mem[k]));  
      end
    end                                        
end
endtask

`endif
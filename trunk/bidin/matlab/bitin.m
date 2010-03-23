function [dout] = bitin(din)

%global sim_consts;
Mb = 384;
Ib = 360;
M = Mb*Ib;
N = numel(din)/M;

dout = [];
for i=1 : N
    din_tmp = din((i-1)*M+1 : i*M);
    t1 = reshape (din_tmp', Ib, Mb)';
    dout_tmp= reshape(t1, 1, numel(t1));
    dout = [dout, dout_tmp];
end

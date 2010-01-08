% log_ten test
clear all;
for i = 1:767
   r1(i) = 20*log10(i);
   t2 = log_ten(i);
   r2(i) = double(t2)/2^3;
end
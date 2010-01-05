function y = log_fun(u)
% This block supports the Embedded MATLAB subset.
% See the help menu for details. 
table2 = [0 0.58496093750000  0.32189941406250  0.16992187500000  0.08743286132813 0.04437255859375  0.02233886718750  0.01119995117188  0.00561523437500 0.00280761718750  0.00140380859375  0.00070190429688  0.00033569335938 0.00015258789063  0.00006103515625  0.00003051757813];
y0 = 0;
x2 = int16(0);
xn = int16(0);
n = 0;
u1 = int16(u);
for i=0:15
    if( (u*(2^i))>=(2^14))
        xn = u1*(2^i);
        n = i;
        break;
    end
end

for i=0:15
    x2 = xn + (xn*2^(-i));
    if(x2<(2^15-1))
%        i
        xn = x2;
        y0 = y0 -table2(i+1);
    end
end
   
% 1/log2(10) * j
%dBm = floor(20 * 0.30102539062500*(y0+15-n)*2^8); %12 bit
dBm = floor((5 * 1233 *(y0+15-n))/2^7); %12 bit
y = int16(dBm);

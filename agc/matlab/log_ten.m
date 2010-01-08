function y = log_ten(u)
% function y = log_ten
% u must be a interger with 14 bit
for i=1:14
    tab(i)=log2(1+2^(-i));
end
%tab2 = tab;
tab2 = floor(tab*2^8)/2^8 ;

% Initialization
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

for i=0:8
    x2 = xn + (xn*2^(-i));
    if(x2<(2^15-1))
%        i
        xn = x2;
        y0 = y0 -tab2(i);
    end
end
% y0 = y0 / 2^14   
% 1/log2(10) * j
%dBm = floor(20 * 0.30102539062500*(y0+15-n)*2^8); %12 bit
dBm = floor((5 * 1233 *(y0+15-n))/2^7); %12 bit
y = int16(dBm);

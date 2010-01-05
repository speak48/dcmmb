clear all;
agc.accum_length = 4096;
agc.weight = 128;
agc.num = 10;
para = 1/agc.weight;
num = agc.accum_length*agc.num;
x = randint(1,num/2,[-512 511])+sqrt(-1)*randint(1,num/2,[-512 511]);
x = [x randint(1,num/2,[-256 255])+sqrt(-1)*randint(1,num/2,[-256 255])];

% |I| + |Q|
x1 = (abs(real(x))+abs(imag(x)))/2;

% Accum sum
%x3 = filter(ones(1,agc.accum_length),1,x2);
x11(1) = x1(1)*para;
for i=2:1:length(x1)
x11(i) = x11(i-1)*(1-para)+x1(i)*para;
end

% Logagrithm
for i = 1:agc.num
y1(i) = 20*log10(x11(i*agc.accum_length));
y11(i) = log_fun(x11(i*agc.accum_length));
end
y12 = double(y11)./(2^3);

% I^2 + Q^2
x2 = floor(abs(x));
% Accum sum
%x3 = filter(ones(1,agc.accum_length),1,x2);
x21(1) = x2(1)*para;
for i=2:1:length(x2)
x21(i) = x21(i-1)*(1-para)+x2(i)*para;
end

% Logagrithm
for i = 1:agc.num
y2(i) = 20*log10(x21(i*agc.accum_length));
y21(i) = log_fun(x21(i*agc.accum_length));
end
y22 = double(y21)./(2^3);

% max(|I|,|Q|)+0.5*min(|I|,|Q|)
for i=1:length(x)
    max_iq = max(abs(real(x(i))),abs(imag(x(i))));
    min_iq = min(abs(real(x(i))),abs(imag(x(i))));
    x3(i) = max_iq+floor(min_iq/2);
end
% Accum sum
%x3 = filter(ones(1,agc.accum_length),1,x2);
x31(1) = x3(1)*para;
for i=2:1:length(x3)
x31(i) = x31(i-1)*(1-para)+x3(i)*para;
end

% Logagrithm
for i = 1:agc.num
y3(i) = 20*log10(x31(i*agc.accum_length));
y31(i) = log_fun(x31(i*agc.accum_length));
end
y32 = double(y31)./(2^3);
clear figure
plot(y12-mean(y12-y22),'.-');
hold on
plot(y22,'.-r');
plot(y32-mean(y32-y22),'.-m');
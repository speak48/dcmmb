clear all;
agc.accum_length = 4096;
agc.weight = 128;
agc.num = 10;
para = 1/agc.weight;
num = agc.accum_length*agc.num;
x = randint(1,num/2,[-512 511])+sqrt(-1)*randint(1,num/2,[-512 511]);
x = [x randint(1,num/2,[-256 255])+sqrt(-1)*randint(1,num/2,[-256 255])];

% |I| + |Q|
x2 = (abs(real(x))+abs(imag(x)))/2;

% Accum sum
%x3 = filter(ones(1,agc.accum_length),1,x2);
x3(1) = x2(1)*para;
for i=2:1:length(x2)
x3(i) = x3(i-1)*(1-para)+x2(i)*para;
end

% Logagrithm
for i = 1:agc.num
y(i) = 20*log10(x3(i*agc.accum_length));
y1(i) = log_fun(x3(i*agc.accum_length));
end


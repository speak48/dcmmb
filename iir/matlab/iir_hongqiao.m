function [y] = iir_hongqiao(x);
%function [H]=genH(coderate);
% IIR filter for hongqiao demodulator
% sample rate          : 30MHz
% bandwidth            : 8MHz
% filter type          : Cauer A
% passband ripple      : 0.5dB
% stopband attenuation : 55 dB (floating point) > 50dB (fix point)
% Cut Off Frequency    : 0.133
% X can be either interger or complex interger type
% 
%                  Editor Chenzy on Mar-15-2010

scale = 10;
coeff = [0.64668, -0.77616, 0.72263, -0.55040, 0.83023, -0.93712, 0.67449];
coeff = round(coeff * (2^scale))/(2^scale);
state    = zeros( 1, 7 );
prestate = zeros( 1, 7 );
b        = zeros( 1, 7 );

for i = 1:length(x)
    [b(1),state(1)] = adaptor_2port(x(i),prestate(1),coeff(1));
    [b(3),state(3)] = adaptor_2port(prestate(2),prestate(3),coeff(3));
    [b(2),state(2)] = adaptor_2port(b(1),b(3),coeff(2));
    
    [b(5),state(5)] = adaptor_2port(prestate(4),prestate(5),coeff(5));
    [b(4),state(4)] = adaptor_2port(x(i),b(5),coeff(4));
    [b(7),state(7)] = adaptor_2port(prestate(6),prestate(7),coeff(7));
    [b(6),state(6)] = adaptor_2port(b(4),b(7),coeff(6));
    
    prestate = state;
    y(i) = 1/2 * ( b(2) + b(6) );
end       


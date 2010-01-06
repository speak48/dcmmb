clc;
clear all;

agc.accum_length = 4096;
agc.weight = 128;
agc.num = 20;
agc.gain = 0;
agc.ajust_step = 1;
vga.range = 20;
agc.voltage = 0.5;
para = 1/agc.weight;
num = agc.accum_length*agc.num;
ref_dB = 45.125; % 20*log10(128*2^0.5) = 45.154 log_fun()=45.125

% Signal generator
% Random signal multiply abs(sin)+bias
t=agc.num/2;
x=randint(1,4096*t,[-127 127])+sqrt(-1)*(randint(1,4096*t,[-127 127]));
x=[x randint(1,4096*t,[-255 255])+sqrt(-1)*(randint(1,4096*t,[-255 255]))];
% for i=1:length(x)
% xsin(i) = abs(cos(2*pi*i/16384/t));
% end
% xi=floor(x.*(xsin*3.5+1)');
% xi = x;
%plot(xi)

% Receiver
lpd_energy = 0;
i = int32(0);
k = int32(1);

for i=1:length(x)    
    u1 = vga.range*(agc.voltage-0.5)/1.0;
%    u1 = 2;
    adc = floor(x(i).* (10^(u1/20)));   
    y(i) = adc;    
% Energy estimation
    max_iq = max(abs(real(adc)),abs(imag(adc)));
    min_iq = min(abs(real(adc)),abs(imag(adc)));
    energy_est = max_iq+floor(min_iq/2);
% Long period statics
% IIR filter
    lpd_energy = lpd_energy*(1-para)+energy_est*para;

% Logagrithm
    if mod(i,agc.accum_length) == 0
%         lpd_energy
        pwr_log(k) = 20*log10(lpd_energy);
        r = log_fun(lpd_energy);
        pwr_dB(k) = double(r)./(2^3);
        
% PWM generator        
        delta_dB = ref_dB - pwr_log(k);
        if delta_dB < -1 
            if (agc.gain - agc.ajust_step) < -10
                agc.gain = -10;
            else
                agc.gain = agc.gain - agc.ajust_step;
            end
        elseif delta_dB > 1
            if (agc.gain + agc.ajust_step) > 10
                agc.gain = 10;
            else
                agc.gain = agc.gain + agc.ajust_step;
            end
        else
            agc.gain = agc.gain;
        end
        pwm_threshold(k) = 64+floor(64*(agc.gain/10));       
        agc.voltage = 0.5 + agc.gain * 0.05;
        v(k) = agc.voltage;
%         u1 = vga.range*(agc.voltage-0.5)/1.0
        k = k + 1;
    end
    
end

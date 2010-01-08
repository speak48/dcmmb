clc;
clear all;

agc.accum_length = 1024;%4096;
agc.weight = 128;
agc.num = 20;
agc.gain = 0;
agc.ajust_step = 30/128;
vga.range = 20;
agc.voltage = 0.5;
para = 1/agc.weight;
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
lpd_energy2 = 0;
i = int32(0);
k = int32(1);

for i=1:length(x)    
    u1 = vga.range*(agc.voltage-0.5)/1.0;
%    u1 = 2;
    adc = floor(x(i).* (10^(u1/20)));   
    y(i) = adc;    
% Energy estimation 
    max_iq = max(abs(real(adc)),abs(imag(adc))); % 10-bit i, 10-bit o
    min_iq = min(abs(real(adc)),abs(imag(adc))); % 10-bit i, 10-bit o
    energy_est = max_iq+round(min_iq/2);         % 10-bit unsigned max = 512 + 256 = 768 
% Long period statics
% IIR filter
    lpd_energy = lpd_energy*(1-para)+energy_est*para;
    lpd_energy2 = ((lpd_energy2*2^4-round(lpd_energy2/2^3)+round(energy_est/2^3))/2^4); 
%   round(energy_est/2^3) 10 bit intger + 4 bit fraction = 14 bit
%    lpd_energy2 = lpd_energy2*(1-para)+floor(energy_est/2^4)*para*2^4;
%    lpd_energy2 = (lpd_energy2/2^4);
    
% Logagrithm
    if mod(i,agc.accum_length) == 0
        temp(k)=(lpd_energy)-lpd_energy2;
        pwr_log(k) = 20*log10(lpd_energy);
        r = log_ten(lpd_energy2); %10 bit i, 9 bit o 
        pwr_dB(k) = double(r)./(2^3); %9 bit o ( 6 bit integer + 3 bit fraction )
        
% PWM generator        
        delta_dB = ref_dB - pwr_log(k);
        if delta_dB < -0.625 
            if (agc.gain - agc.ajust_step) < -10
                agc.gain = -10;
            else
                agc.gain = agc.gain - agc.ajust_step;
            end
        elseif delta_dB > 0.625
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

clear figure
H = SUBPLOT(2,2,1);
plot(abs(x),'.-')
axis([1 length(x) 0 600])
xlabel('N sample')
ylabel('Magnitude sample value')
grid on
H = SUBPLOT(2,2,2);
plot(abs(y),'.-')
axis([1 length(x) 0 600])
xlabel('N sample')
ylabel('Magnitude sample value')
grid on
H = SUBPLOT(2,2,3);
plot(pwr_dB,'.-r')
axis([1 length(pwr_dB) 35 60])
xlabel('N period')
ylabel('Energy Estimation dB')
grid on
H = SUBPLOT(2,2,4);
plot(v,'.-m')
axis([1 length(pwr_dB) 0.3 1.0])
xlabel('N period')
ylabel('VGA input voltage V')
grid on

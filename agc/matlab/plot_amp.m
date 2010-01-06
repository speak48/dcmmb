plot(y1,'.-');
hold on
plot(y2,'.-r');
plot(y3,'.-m');

axis([1 10 38 55])
grid on
legend('|I|+|Q|', 'magnitude(I,Q)','max(|I|,|Q|+0.5min(|I|,|Q|)');
xlabel('time')
ylabel('Power Energy dB')
title('Power Estimation Comparsion')
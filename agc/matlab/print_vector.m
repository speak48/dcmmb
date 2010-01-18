fid_i = fopen('data_in_i.dat','wb');
fid_q = fopen('data_in_q.dat','wb');
for i=1:length(y)
r_y=int16(real(y(i)));
i_y=int16(imag(y(i)));
if r_y < 0
   r_y = 32768 + r_y ;
end
if i_y < 0
    i_y = 32768 + i_y;
end
fprintf(fid_i,'%x\n',r_y);
fprintf(fid_q,'%x\n',i_y);
end
fclose(fid_i);
fclose(fid_q);
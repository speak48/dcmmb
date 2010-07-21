%CMMB Reed-Solomon Matlab File
%Author by:Chenzy
clear all;
clc;
%parameter definition
mode = 2; % 1, 224; 2, 192; 3, 176
info_mode = 0; % 0 all 0xFF; 1 rand function

%number of bits each symbol
m=8;
%code length        
n=240;      
%error correction ability
if(mode==1) t=8;        
elseif(mode==2) t=24;
else t=32;
end
%information length
k=n-2*t;
%primitive polynomial {8,4,3,2,0}    
pp=285;
%GF table length    
q=2^m-1;   


%generate rand vaule
if(info_mode)
    info = rand(1,k);
    info = round(info.* 2^8);   
else    
    info = 255*ones(1,k); 
end

%rs encode using matlab function
msg = gf(info,m,pp);
code=rsenc(msg,n,k);

%Galois Fied basic 
gf_alpha = gf(2,m,pp);
gf_zero  = gf(0,m,pp);
gf_one   = gf(1,m,pp);

%add error in special postion
reccode = zeros(1,n);
reccode(101:100+t)=35;
%reccode(199)=35;

%add different error channel here to test more case


%add error byte in encode code
reccode = gf(reccode,m,pp);
reccode = code + reccode;

%cor_code is 1xN matrix
%fail '1' means correction failed, cor_code = reccode
[cor_code,fail] = rs_decode(reccode,t,m,k,n,q,pp);

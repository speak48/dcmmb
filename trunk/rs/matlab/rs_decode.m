%Reed-Solomon Decoder Matlab File
%Author by:Chenzy
function [cor_code,fail] = rs_decode(reccode,t,m,k,n,q,pp);

%Galois Fied basic 
gf_alpha = gf(2,m,pp);
gf_zero  = gf(0,m,pp);
gf_one   = gf(1,m,pp);

%functional simualation of decoding
%creating alpha array
alpha_tb = gf(zeros(1,2*t),m,pp);
for i=1:2*t,
    alpha_tb(i)=gf_alpha^i;
end;    

%syndrome compuation
syndrome = gf(zeros(1,2*t),m,pp);
for i = 1:n,
    syndrome=syndrome.*alpha_tb+reccode(i);
end

r_top = gf(zeros(1,2*t+1),m,pp);
r_bot = gf(zeros(1,2*t+1),m,pp);
r_temp = gf(zeros(1,2*t+1),m,pp);
s_top = zeros(1,2*t+1);
s_bot = zeros(1,2*t+1);
s_temp = zeros(1,2*t+1);

%reverse s(2^t-1) ...s(0)
for i = 1:2*t,
    r_top(i) = syndrome(2*t+1-i);
end
r_top(2*t+1) = gf_zero;
r_bot(2*t+1) = gf_one;
s_top(2*t+1) = 1;
s_bot(2*t+1) = 1;

d_top = 0;
d_bot = 0;
lead_bot = gf_one;
quot = gf_zero;
num = gf_zero;
denom = gf_zero;

for i = 1:2*t,
%     r_top
%     r_bot
%     s_top
%     s_bot
    if((r_top(1)~=gf_zero) & ((d_top-d_bot)>=0))
            num = lead_bot;
            denom = r_top(1);
            %swap top down vector
            r_temp = r_top;
            r_top = r_bot;
            r_bot = r_temp;
            s_temp = s_top;
            s_top = s_bot;
            s_bot = s_temp;
            lead_bot = r_bot(1);
            %shift one position to left
            for j = 1:2*t,
            r_bot(j) = r_bot(j+1);
            s_bot(j) = s_bot(j+1);
            end
            r_bot(end) = gf_zero;
            s_bot(end) = 1;
            d_bot = d_bot + 1;
    else
            num = r_top(1);
            denom = lead_bot;
            for j = 1:2*t,
            r_top(j) = r_top(j+1);
            s_top(j) = s_top(j+1);
            end
            r_top(end) = gf_zero;
            s_top(end) = 1;
            d_top = d_top + 1;
    end
    quot = num/denom;
    for j = 1:2*t+1,
        if((s_top(j)==0)&(s_bot(j)==0))    
        r_top(j) = r_top(j) + quot * r_bot(j);
        elseif((s_top(j)==1)&(s_bot(j)==1))
        r_bot(j) = r_bot(j) + quot * r_top(j);
        end
    end

end    

if(d_top<d_bot)
    disp('undecodable!'); 
else    
   omega =  gf(zeros(1,t),m,pp);
   lambda  =  gf(zeros(1,t+1),m,pp);
   t1=find((s_top==0)&(s_bot==0));
   t2=find((s_top==1)&(s_bot==1)); 
   for i=1:length(t1),
       omega(i)=r_top(length(t1)+1-i);
   end
   for i=1:length(t2),
       lambda(i)=r_bot(t2(i));
   end
   
%chien search algorithm and forney algorithm in paralle
%seperate the even and the odd parts of lamda and omega
even=floor(t/2)*2;
if(even==t)
    odd=t-1;
else
    odd=t;
end
%inversetable
inverse_tb = gf(zeros(1, t+1), m, pp);
for i=1:t+1,
    inverse_tb(i) = gf_alpha^(i-1);
end;

lamda_v=gf_zero;
lamda_ov=gf_zero;
omega_v=gf_zero;
accu_tb=gf(ones(1, t+1), m,pp);
accu_tb1=gf(ones(1, t), m, pp);
ev=gf(zeros(1,q),m,pp);
for i=1:q
    accu_tb=accu_tb.*inverse_tb;
    accu_tb1=accu_tb1.*inverse_tb(1:t);
    lambda_v=lambda*accu_tb';
    lambda_ov=lambda(2:2:odd+1)*accu_tb(1:2:odd)';
    omega_v=omega*accu_tb1';
    if(lambda_v==gf_zero)
        error(1,i)=1;
        ev(i)=omega_v/lambda_ov;
    else
        error(1,i)=0;
    end
end

cor_code = reccode;
fail = 0;
found = find(error(1,:)~=0);
if(length(found) == d_bot)
    el=found-q+n
    ev(found)
    cor_code(el)=cor_code(el)+ev(found);
else
    disp('decode fail');
    fail = 1;
end

end    %end else
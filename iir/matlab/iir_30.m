function [y] = iir_30(x);

scale = 10;
in_wid = 10;

coeff(1) = round(  0.64668 * ( 2 ^ 10) ) / (2 ^ 10);
coeff(2) = round( -0.77616 * ( 2 ^ 10) ) / (2 ^ 10);
coeff(3) = round(  0.72263 * ( 2 ^ 10) ) / (2 ^ 10);  
coeff(4) = round( -0.55040 * ( 2 ^ 10) ) / (2 ^ 10);
coeff(5) = round(  0.83023 * ( 2 ^ 10) ) / (2 ^ 10);
coeff(6) = round( -0.93712 * ( 2 ^ 10) ) / (2 ^ 10);
coeff(7) = round(  0.67449 * ( 2 ^ 10) ) / (2 ^ 10);
% coeff1 =   0.64668 ;
% coeff2 =  -0.77616 ;
% coeff3 =   0.72263 ;  
% coeff4 =  -0.55040 ;
% coeff5 =   0.83023 ;
% coeff6 =  -0.93712 ;
% coeff7 =   0.67449 ;

state    = zeros( 1, 7 );
prestate = zeros( 1, 7 );
b        = zeros( 1, 7 );
max_b    = zeros( 1, 7 );
max_state= zeros( 1, 7 );

for i = 1:length(x)
%     [b(1),state(1)] = adaptor_2port(x(i),prestate(1),coeff(1));
%     [b(3),state(3)] = adaptor_2port(prestate(2),prestate(3),coeff(3));
%     [b(2),state(2)] = adaptor_2port(b(1),b(3),coeff(2));
%     
%     [b(5),state(5)] = adaptor_2port(prestate(4),prestate(5),coeff(5));
%     [b(4),state(4)] = adaptor_2port(x(i),b(5),coeff(4));
%     [b(7),state(7)] = adaptor_2port(prestate(6),prestate(7),coeff(7));
%     [b(6),state(6)] = adaptor_2port(b(4),b(7),coeff(6));
    

    [b(1),state(1)] = adaptor_2port(x(i),prestate(1),coeff(1));
    b(1) = sat(b(1), in_wid+2);
    state(1) = sat(state(1), in_wid+1);
    [b(3),state(3)] = adaptor_2port(prestate(2),prestate(3),coeff(3));
    b(3) = sat(b(3), in_wid+4);
    state(3) = sat(state(3), in_wid+3);
    [b(2),state(2)] = adaptor_2port(b(1),b(3),coeff(2));
    b(2) = sat(b(2), in_wid+2);
    state(2) = sat(state(2), in_wid+4);
    
    [b(5),state(5)] = adaptor_2port(prestate(4),prestate(5),coeff(5));
    b(5) = sat(b(5), in_wid+4);
    state(5) = sat(state(5), in_wid+2);
    [b(4),state(4)] = adaptor_2port(x(i),b(5),coeff(4));
    b(4) = sat(b(4), in_wid+2);
    state(4) = sat(state(4), in_wid+3);
    
    [b(7),state(7)] = adaptor_2port(prestate(6),prestate(7),coeff(7));
    b(7) = sat(b(7), in_wid+5);
    state(7) = sat(state(7), in_wid+4);
    [b(6),state(6)] = adaptor_2port(b(4),b(7),coeff(6));
    b(6) = sat(b(6), in_wid+2);
    state(6) = sat(state(6), in_wid+5);
    
    prestate = state;
    y1 = 1/2 * ( b(2) + b(6) );
    y(i) = sat( y1, 9);
    for j = 1:7
        if abs(b(j)) > max_b(j)
        max_b(j) = abs(b(j));
        end
        if abs(state(j)) > max_state(j)
        max_state(j) = abs(state(j));
        end
    end
end   

max_b
max_state
    
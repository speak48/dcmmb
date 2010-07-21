function [y] = iir_30(x);

scale = 10;

alpha1 =   0.64668 ;
alpha2 =  -0.77616 ;
alpha3 =   0.72263 ;  
alpha4 =  -0.55040 ;
alpha5 =   0.83023 ;
alpha6 =  -0.93712 ;
alpha7 =   0.67449 ;

state    = zeros( 1, 7 );
prestate = zeros( 1, 7 );
b        = zeros( 1, 7 );

for i = 1:length(x)
    [b(1),state(1)] = adaptor_2port(x(i),prestate(1));
    [b(3),state(3)] = adaptor_2port(prestate(2),prestate(3));
    [b(2),state(2)] = adaptor_2port(b(1),b(3));
    
    [b(5),state(5)] = adaptor_2port(prestate(4),prestate(5));
    [b(4),state(4)] = adaptor_2port(x(i),b(5));
    [b(7),state(7)] = adaptor_2port(prestate(6),prestate(7));
    [b(6),state(6)] = adaptor_2port(b(4),b(7));
    
    prestate = state;
    y(i) = 1/2( b(2) + b(6) );
end    
    
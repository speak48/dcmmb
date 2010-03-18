function [b1,b2] = adaptor_2port(a1, a2, alpha);
%function [b1,b2] = adaptor_2port(a1, a2, alpha);
%It is a sub module in iir_hongqiao
% 
%                  Editor Chenzy on Mar-15-2010

b1  =round(a2 + (a2-a1)*alpha);
b2 = round(a1 + (a2-a1)*alpha);

 
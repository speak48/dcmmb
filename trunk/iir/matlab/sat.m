function [s] = sat(x,a)
a1 = 2^a-1;
if(x>a1)
    s=a1;
else
    if(x<-1*a1)
    s= -1*a1;
    else
        s = x;
    end
end
     
function r = integ1 

r  = quadv(@(x)(sin(x.^2+(1:6))),0,1);


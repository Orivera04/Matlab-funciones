 function [com]= comision (cantidad)
    if cantidad<50
        com=0;
    elseif cantidad >=50 & cantidad <=500
        com=cantidad*0.1;
    elseif cantidad >500
        com=50 + cantidad*0.08;
    end
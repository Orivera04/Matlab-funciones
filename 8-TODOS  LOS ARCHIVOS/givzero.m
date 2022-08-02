  function [c,s] = givzero(x)
%GIVZERO Givens zeroing in a vector x.
%[c,s] = givzero(x) produces the Givens parameters c and s
%for a 2-vector x such that J(1,2,theta)x has a zero 
%in the second place. c = cos(theta), s = sin(theta).
%This program implements Algorithm 5.5.1 of the book.
%input   : Vector x 
%output  : Scalars c and s 


        if abs(x(2)) > abs(x(1))
           t = x(1)/x(2);
            s = 1/((1+t*t)^.5);
            c = s*t ;
        else
           t = x(2)/x(1);
            c = 1/((1+t*t)^.5);
            s = c*t ;
        end
         
        
        end;


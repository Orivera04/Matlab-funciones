  function [p] = absmax(y);
%ABSMAX  The position p in a vector where the absolute maximum occurs.
%p = absmax(y) returns the postion p in the vector y
%where the absolute maximum of the vector y occurs.
%input  : Vector y
%output : Integer p

	[m,n] = size(y);
        s = y(1);
        n1 = 1;
	for k = 1:m
         if abs(y(k)) > abs(s)
          p = k;
          s = y(k);
         end;
	end; 
	end; 

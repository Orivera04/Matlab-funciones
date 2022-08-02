function y=ctmctc(R,c,t);
%y=ctmctc(R,c,t)
%R = rate matrix of a CTMC (0 diagonal entries).
%c(i) = expected cost of visiting state i. (column vector).
%ep = error tolerance.
%output y(i) =total expected cost over time 0 thru t, starting from i.
y=checkR(R);
if y(1,1) ~= 'error'
   y=checkcR(c,R);
   if y(1,1)~='error'
      y=ctmcom(R,t);
      if y(1,1) ~= 'error'
         y=y*c;
         end;
   end;
end;

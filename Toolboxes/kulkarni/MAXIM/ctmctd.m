function y=ctmctd(a,R,t);
%y=ctmctd(a,R,t)
%y(i) = P(X(t) = i) for a ctmc X with rate matrix R (zero diagonal entries),  
% and initial distribution a.
y=checkaR(a,R);
if y(1,1) ~= 'error'
   y=ctmctm(R,t);
   if y(1,1) ~= 'error'
      y=a*y;
      end;
end;

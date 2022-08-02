function y = dtmctd(a,P,n)
%y = dtmctd(a,P,n)
%compute the distribution of $X_n$ for a DTMC with transition
% probability matrix
%P and initial distribution a.
if (n < 0) | (n - fix(n) ~= 0)
   msgbox('invalid entry for n'); y='error'; return;
else
   y = checkaP(a,P);   
if (y(1,1) ~= 'error') 
   y = a*P^n;
end; 
end;
function y = checkaR(a,R);
% checks if R is a valid rate matrix of a CTMC.
% and if a is a valid and compatible pmf;
[ma na] = size(a);
[m n] = size(R);
if (any(a < 0)) 
   msgbox(' initial probabilities must be non-negative');y='error';return;
elseif abs(sum(a)-1) > 10^(-12)
   msgbox('initial probabiliies must sum to 1'); y='error'; return;
elseif m ~= n
   msgbox('transition matrix must be square'); y='error'; return;
elseif any((any(R< 0)))
   msgbox('transition rates must be non-negative'); y='error'; return;
elseif (any(diag(R)> 0))
   msgbox('diagonal elements of R must be zero'); y='error'; return;
elseif na ~=n 
   msgbox('the initial distribution is not compatible with the transition matrix'); y='error'; return;
else y = 'no error'; return;   
end;

   
   
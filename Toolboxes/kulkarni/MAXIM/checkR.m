function y = checkR(R);
% checks if P is a square stochastic matrix.
[m n] = size(R);
if m ~= n
   msgbox('transition matrix must be square'); y='error'; return;
elseif any(any(R < 0))
   msgbox('transition rates must be non-negative'); y='error'; return;
elseif any(diag(R) > 0)
   msgbox('diagonal elements of R must be zero'); y='error'; return;   
else y = 'no error'; return;   
end;

   
   
function y = checkaP(a,P);
% checks if P is a square stochastic matrix.
% checks if a is a valid and compatible pmf;
[ma na] = size(a);
[m n] = size(P);
if (a >= zeros(size(a))) ~= ones(size(a))
   msgbox(' initial probabilities must be non-negative');y='error';return;
elseif abs(sum(a)-1) > 10^(-12)
   msgbox('initial probabiliies must sum to 1'); y='error'; return;
elseif m ~= n
   msgbox('transition matrix must be square'); y='error'; return;
elseif max(abs(sum(P')-ones(1,m))) > 10^(-12)
   msgbox('row sums of the transition matrix must be 1'); y='error'; return;
elseif (P >= zeros(m,n)) ~= ones(m,n)
   msgbox('transition probabilities must be non-negative'); y='error'; return;
elseif na ~=n 
   msgbox('the initial distribution is not compatible with the transition matrix'); y='error'; return;
else y = 'no error'; return;   
end;

   
   
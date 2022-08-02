function y = checkP(P);
% checks if P is a square stochastic matrix.
[m n] = size(P);
if m ~= n
   msgbox('transition matrix must be square'); y='error'; return;
elseif max(abs(sum(P')-ones(1,m))) > 10^(-12)
   msgbox('row sums of the transition matrix must be 1'); y='error'; return;
elseif (P >= zeros(m,n)) ~= ones(m,n)
   msgbox('transition probabilities must be non-negative'); y='error'; return;
else y = 'no error'; return;   
end;

   
   
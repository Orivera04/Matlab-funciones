function R = ex6ssq(l,m,K);
%R = ex6ssq(l,m,K)
%l arrival rate;
%m service rate m;
%K capacity;
if l < 0 
msgbox('invalid entry for l'); R='error';return;
elseif  m < 0 
msgbox('invalid entry for m');R='error'; return;
elseif  K < 0 | K - fix(K) ~= 0
msgbox('invalid entry for K'); R='error';return;
else
   y=ex6fbd(l*ones(1,K), m*ones(1,K));
   if y(1,1) ~= 'error'
      R=y;
      end;
end;

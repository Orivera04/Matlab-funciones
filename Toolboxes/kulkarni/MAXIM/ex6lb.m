function R = ex6lb(l,m,D,M);
%R = ex6lb(l,m,D,M)
%l packet arrival rate;
%m token generation  rate;
%D capacity of the data buffer;
%M token buffer size;
if isempty(l) | l < 0 
msgbox('invalid entry for l');R='error'; return;
elseif isempty(m) | m < 0 
msgbox('invalid entry for l');R='error'; return;
elseif isempty(D) | D < 0 |fix(D) - D ~=0 
msgbox('invalid entry for D');R='error'; return;
elseif isempty(M) | M < 0 |fix(M) - M ~=0 
msgbox('invalid entry for M');R='error'; return;
else
K=M+D;
R=ex6fbd(l*ones(1,K), m*ones(1,K));
end;

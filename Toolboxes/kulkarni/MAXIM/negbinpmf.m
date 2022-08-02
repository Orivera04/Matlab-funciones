function y = negbinpmf(r,p,k)
%y = negbinpmf(r,p,k)
% computes y(i) = P(X = i) for i=r, r+1,..., r+k, where X ~ Negative Binomial (r,p) $ rv. 
if  (r <= 0) | (fix(r) - r ~= 0)
msgbox('invalid entry for r');y='error';return; 
elseif (p < 0) | (p > 1)
msgbox('invalid entry for p');y='error';return;  
elseif (k <= 0) | (fix(k) - k ~= 0)
msgbox('invalid entry for k');y='error';return;
else
y=zeros(1,r+k);
y(r)=p^r;
for i=r+1:r+k
y(i)=y(i-1)*(i-1)*(1-p)/(i-r);
end;
end;

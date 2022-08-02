function truth=is_sqr(A)
% CALL: function truth=is_sqr(A)
%  truth=1 (true) if A is square, truth=0 if not
s=size(A);
if s(1)==s(2)
 truth=1;
else
 truth=0;
end 
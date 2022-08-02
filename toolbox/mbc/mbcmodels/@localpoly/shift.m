function p = shift(p,k)
%SHIFT Shift polynomial p(x) to p(x-k)
%
%  SHIFT(P, K) shifts the MBC polynomial model P(x) to be P(x-K).  The
%  shifted polynomial is returned.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:40:48 $

b = double(p);
i = find(b);
if ~isempty(i)
    i = i(1);
    bs = b(i);
    b1 = b(i:end)/bs;
    c = compan(b1);
    c = c - eye(size(c))*k;
    b(i:end) = poly(c)'*bs;
    p.xreglinear = update(p.xreglinear ,b);
end

function ch= char(ts,TeX)
%CHAR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 07:42:52 $

if nargin<2
    TeX=1;
end

s= get(ts,'symbol');
if TeX
    s= detex(s);
end

ch= char(polynom(ts),TeX);

p= double(ts);
m= ts.order-1;

nk = length(ts.knots);
beta= p(end-nk+1:end);
if m>0
    for i=1:nk
        if beta(i)>=0
            signbeta = ' +';
        else
            signbeta = ' -';
        end
        ch= [ch signbeta sprintf(' %.3g*(%s%+.3g)^%1d',abs(beta(i)),s{1},-ts.knots(i),m)];
    end
end
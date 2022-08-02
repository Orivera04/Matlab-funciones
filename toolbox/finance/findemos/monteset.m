%MONTESET Initializes variables used in Monte Carlo simulation.
%
%   See also MONTECAR, MONTEPLO.
%

%       Author(s): C.F. Garvin, 3-10-95
%       Copyright 1995-2002 The MathWorks, Inc. 
%       $Revision: 1.6 $   $Date: 2002/04/14 21:43:18 $

msize = normrnd(10e+6,3e+5,10000,1);
mshare = normrnd(.01,.002,10000,1);
fcost = normrnd(3e+6,2.5e+5,10000,1);
ucost = normrnd(3000,60,10000,1);
uprice = normrnd(3600,60,10000,1);
invest = 150e+6;
rate = .1;
[r,c] = size(msize);
k = ones(r,1);

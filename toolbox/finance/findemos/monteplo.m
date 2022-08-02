%MONTEPLO Net present values of system and plots distribution.
%
%   See also MONTEHEL, MONTESET.

%       Author(s): C.F. Garvin, 3-10-95
%       Copyright 1995-2002 The MathWorks, Inc. 
%       $Revision: 1.6 $   $Date: 2002/04/14 21:43:27 $

[r,c] = size(msize);
pv = zeros(r,1);

for i = 1:r
  pv(i) = -invest + sum(cf(:,i)./rs);
end

figure('NumberTitle','off','Name','Business Model Graph');
hist(pv,30);
title('Electric Car Project - NPV distribution')
xlabel('Net Present Value ($)')
ylabel('Number of samples')
cl = uicontrol('string','Close','position',[5 5 50 20],'callback','close');
set(cl,'units','normal')

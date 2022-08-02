function ind = binfind(var, varlist)
% SWEEP/BINFIND finds the location of var within varlist using a binary search

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:11:10 $

varlist=char(varlist);
[max,len]=size(varlist);
var=char([{var};{'         '}]); %set var to a 9 letter string
var=var(1,:); %get the real value of var

varlist(max,:)=[];
factor=[256 128 64 32 16 8 4 2 1]';

stop=length(dec2bin(max))+2; %add 1 because we need to cover 2^(n+1) elements. Add another 1 because we start the loop at 2.
pos=round(max/2);

for i = 2:stop % start the loop at 2 so that the 2^i term divides the element range into 4.
   if varlist(pos,:) == var
      i=stop;
   elseif (varlist(pos,:)<var)*factor < (varlist(pos,:)>var)*factor
      pos = pos - (round(max/(2^i)));
   else
      pos = pos + (round(max/(2^i)));
   end
end

ind=pos;

      






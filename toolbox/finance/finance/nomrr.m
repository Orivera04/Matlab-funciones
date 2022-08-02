function apr = nomrr(er,per)
%NOMRR Nominal rate of return.
%   APR = NOMRR(ER,PER) returns the nominal rate of return based on the 
%   effective annual percentage rate, ER, and the number of compounding 
%   periods per year, PER.
%
%   For example, the nominal annual rate of return based on an effective
%   annual percentage rate of 9.38% compounded monthly is represented as 
%
%   apr = nomrr(.0938,12) returning apr = 0.09 or 9%.  
%
%   See also EFFRR, IRR, MIRR,TAXEDRR, XIRR.

%       Author(s): C.F. Garvin, 2-23-95
%       Copyright 1995-2002 The MathWorks, Inc. 
%       $Revision: 1.6 $   $Date: 2002/04/14 21:55:08 $

if nargin < 2
  error('Missing one of ER and PER.')
end

% Call argument checking routines
if checkrng('er',er,0,inf,'0','inf','e','l',mfilename);return;end
if checktyp('per',per,'int',mfilename);return;end

apr = per.*((er+1).^(1./per)-1);

function [Nrvect, Nrstr] = pr_getrunopts(nf)
%PR_GETRUNOPTS   Private function for cset_pb
%
%  NR = PR_GETRUNOPTS  returns a vector of the possible number
%  of runs for a Plackett-Burman design, up to a maximum of 768.
%  NR = PR_GETRUNOPTS(NF)  where NF is the number of factors, 
%  returns just the run sizes available for that number of factors.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:01:13 $

Nrvect=[1 2 4 8 12 16 20 24 32 40 48 64 80 96 128 160 192 256 320 384 512 640 768];

if nargin
   % cut out run options below nf
   Nrvect=Nrvect(Nrvect>nf);
end

if nargout==2
   Nrstr = {'1','2','4','8','12','16','20','24','32','40','48','64','80','96',...
         '128','160','192','256','320','384','512','640','768'};
   if nargin
      Nrstr=Nrstr(Nrvect>nf);
   end
end
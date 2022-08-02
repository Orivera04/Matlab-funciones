function obj=set(obj,param,data)
% SET Set candidate set parameters
%
%   OBJ=SET(OBJ,PARAM,DATA)
%
%   PARAM may be one of:
%
%       Runs:  Integer indicating desired number of runs

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:01:22 $


switch lower(param)
case 'limits'
   lims=cat(1,data{:});
   obj.candidateset=limits(obj.candidateset,lims);
case 'runs'
   [f,e] = log2([data data/12 data/20]);
   k = find(f==1/2 & e>0);
   if data>nfactors(obj) & ~isempty(data)
      obj.Nr = data;
   else
      error(['Invalid number of runs for Plackett-Burman design.']);
   end
case 'qruns'
   % undocumented interface for bypassing checking the requested number of runs
   obj.Nr = data;
end
return

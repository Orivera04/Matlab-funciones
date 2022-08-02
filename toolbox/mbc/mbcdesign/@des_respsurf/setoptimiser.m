function desout=setoptimiser(des,opt)
% SETOPTIMISER  Set the preferred optimising routine
%
%   DES = SETOPTIMISER(DES,OPT) sets the design DES to have
%   a preferred optimise routine of OPT.  OPT may be either
%   'v-optimal' or 'd-optimal'.  This setting is used in
%   GUI's and also in the OPTIMISE routine.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:56 $


if any(strcmp(opt,{'v-optimal','d-optimal','a-optimal'}))
   des.preferredoptimiser=opt;
end
if ~nargout
   % place des back into caller workspace
   nm=inputname(1);
   assignin('caller',nm,des);
else
   desout=des;
end

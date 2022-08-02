function desout=optimise(des,varargin)
% OPTIMISE   Optimise design using preferredoptimiser setting
%
%   D=OPTIMISE(D,VARARGIN) dispatches the input arguments to 
%   the optimising function indicated by the design's
%   preferred optimiser settting.  See also SETOPTIMISER and
%   GETOPTIMISER, VOPTIMISE, AOPTIMISE and DOPTIMISE.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:49 $


switch des.preferredoptimiser
case 'd-optimal'
   des=doptimise(des,varargin{:});
case 'v-optimal'
   des=voptimise(des,varargin{:});
case 'a-optimal'
   des=aoptimise(des,varargin{:});
end

if ~nargout
   % place des back into caller workspace
   nm=inputname(1);
   assignin('caller',nm,des);
else
   desout=des;
end

return




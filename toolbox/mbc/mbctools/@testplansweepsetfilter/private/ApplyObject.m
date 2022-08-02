function out = ApplyObject(obj, out)
% SWEEPSETFILTER/APPLYOBJECT applies the filter to the underlieing object
%
% out = ApplyObject(obj, flags)
%
%  where flags is a bitwise scalar which is used to turn on and off certain operations
%  see the private function getflags for the flag values

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.6.2 $  $Date: 2004/02/09 08:12:31 $



if nargin < 2
    out = sweepset(obj.sweepsetfilter);
end

OKind = ~ismember(getSweepGuids(out), obj.excludedData);
% Note that if out has no tests defined (zero tests) then OKind will be
% empty and remove all records from the data - this isn't desired behaviour
% and should be caught
if ~isempty(OKind)
    % Only pass on those data in the list of selectedGUIDs
    out = out(:, :, OKind);
end

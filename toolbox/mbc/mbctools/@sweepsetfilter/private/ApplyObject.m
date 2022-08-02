function out = ApplyObject(obj, flagIn, ssIn)
% SWEEPSETFILTER/APPLYOBJECT applies the filter to the underlieing object
%
% out = ApplyObject(obj, flags)
%
%  where flags is a bitwise scalar which is used to turn on and off certain operations
%  see the private function getflags for the flag values

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:11:48 $

% Shortcut using cached sweepset
if nargin == 1 && obj.allowsCacheing && isobject(obj.cachedSweepset)
    out = obj.cachedSweepset;
    return
end

flags = obj.allowsFlag;
if nargin > 1
	% Set all flags on
	flags = bitand(flags, xregbitset(flagIn));
end

% Get the flag definitions
f = getFlags;

% Make sure we initialise out correctly
if ~isvalid(obj.pSweepset)
    out = sweepset;
    return
end

% Make sure that we get the sweepset version of the output object, complete with record and variable
% indicies

% nargin > 2 intended for private functions to systematically build up
% a copy of the underlying sweepset efficiently
if nargin > 2
    out = ssIn;
elseif isa(obj.pSweepset.info, 'sweepset')
    out = obj.pSweepset.info;
else
    out = sweepset(obj.pSweepset.info);
end


% First modify the data with the sparse modifyData infomation
% Temp copy of the modifyData field
if bitget(flags, f.APPLY_DATA) && any(obj.modifiedData.fullPosition(:))
    md = obj.modifiedData;
    % Mask not applicable data - i.e. beyond validRows and validCols
    md.dataPosition(md.validRows + 1:end, md.validCols + 1:end) = false;
    % Now subsasgn into the sweepset
    out(md.fullPosition) = md.dataValues(md.dataPosition);
end


% Second append any user-defined variables
if bitget(flags, f.APPLY_VARS) && ~isempty(obj.variableSweepset)
	out = [out obj.variableSweepset];
end

% Third apply record and variable filters
if bitget(flags, f.APPLY_FILT) && ~isempty(obj.recordsToRemove)
	out = filter(out, obj.recordsToRemove, [], []);
end

% Change the test definitions
if  bitget(flags, f.APPLY_TEST) && ~isempty(obj.defineTests)
	args = struct2cell(obj.defineTests);
	out = DefineSweepSet(out, args{:});
end

% Fifth apply record and variable filters
if bitget(flags, f.APPLY_SFILT) && ~(isempty(obj.sweepsToRemove) && isempty(obj.variablesToKeep))
	out = filter(out, [],  obj.variablesToKeep, obj.sweepsToRemove);
    % Was anything returned? If variablesToKeep contains names not in the
    % sweepset then the output out will be empty. Also variablesToKeep
    % could be empty, which means keep everything
    if ~isempty(obj.variablesToKeep) && size(out, 2) > 0 
        out = out(:,obj.variablesToKeep);
    end
end

% Sixth reorder the sweeps
if bitget(flags, f.APPLY_REOR) && ~isempty(obj.reorderSweeps)
	out = out(:,:,obj.reorderSweeps{1});
end

% Lastly call a derived class to apply whatever changes they have defined
if bitget(flags, f.APPLY_DERIVED)
    out = pAfterSweepsetfilterApplyObject(obj, out);
end

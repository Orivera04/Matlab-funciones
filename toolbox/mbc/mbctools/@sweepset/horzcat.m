function C = horzcat(varargin)
% SWEEPSET/HORZCAT add variable(s) to sweepset
% 
% [A,B]  
%   Concatenates 2 sweepset objects (adds variables togther)
%   An error is returned if the same variable is defined in both sweepsets

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.4 $  $Date: 2004/04/20 23:19:07 $


% Remove any built-in emptys first
varargin = varargin(~cellfun('isempty', varargin));

% Is anything left?
if isempty(varargin)
    C = sweepset;
    return
end

% Note that there is no gaurantee that the elements of varargin are
% actually sweepsets ... only one of them is
C = varargin{1};
if ~isa(C, 'sweepset')
    error('mbc:sweepset:InvalidArgument', 'All arguments to [A, B] must be sweepsets');
end

for i = 2:length(varargin)
    B = varargin{i};
    if isa(B,'sweepset') & (size(C,1) == size(B,1) | size(C,1) == 0)
        if ~any(ismember({C.var.name},{B.var.name}))
            % Special case of [ [] M] being allowed will not copy guid or
            % xregdataset. Note that this only applies to an empty sweepset
            % with no records, not an empty sweepset with no variables
            if size(C.data,1) == 0 
                C.guid = B.guid;
                C.xregdataset = B.xregdataset;
            end
            C.data = [C.data, B.data];
            C.baddata = [C.baddata, B.baddata];
            C.var = [C.var  B.var];
            C.nrec = size(C.data,1);
            C.nvar = size(C.data,2);
        else
            error('mbc:sweepset:InvalidArgument', 'Variable already exists');
        end
    elseif isequal(size(B), [0 0 0])
        % No error for empty concatenation 
    else
        error('mbc:sweepset:InvalidArgument', '[A,B] Incompatible Sweepset Object Sizes')
    end
end


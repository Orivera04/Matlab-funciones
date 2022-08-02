function P = vertcat(varargin);
% cgOpPoint / vertcat
% Concatenate two operating point sets with the same factors

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:52:22 $

if nargin > 0
	P = varargin{1};
	numpoints = get(P,'numpoints');
	numfactors = get(P,'numfactors');
    ptrlist = get(P,'ptrlist');
	if nargin > 1
		for i = 2:nargin
			if isa(varargin{i},'double')
				thisData = varargin{i};
				S = size(thisData);
				if S(2) == numfactors
					P.data = [P.data;thisData];
				else
					error('data sets have different numbers of factors');
				end
			elseif isa(varargin{i},'cgoppoint')
				this = varargin{i};
				if ~isempty(this)
					if get(this,'numfactors') == numfactors
						for j = 1:numfactors
							index = find(this.ptrlist(j) == ptrlist);
							if isempty(index)
								error('Couldn''t match one or more factors')
							else
								matched(j) = index;
							end
						end
						if ~isempty(setdiff(1:numfactors,matched))
							error('Couldn''t match one or more factors')
						end
						P.data = [P.data;this.data(:,matched)];
					end
				end
			end
		end
	end
end

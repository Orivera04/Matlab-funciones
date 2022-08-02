function [op,dependant] = SetGroupDependants(op,ind,groups);
% op = SetGroupDependants(op,[ind],[groups])
% [op,dependant] = SetGroupDependants(op,[ind],[groups])
%    dependant returns index for each factor, of dominant group member,
%     or 0 if not in a group
%
% Check that only one member of each group has a range selected - 
%   set others to dependant.  This may be necessary if the inputs
%   page has not yet been visited (eg we've just imported from a file
%   and assigned a few inputs), or if we've just clicked on a group 
%   member and altered it.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:20 $

if nargin<3, groups = BuildRelatedGroups(op); end
if nargin<2, ind = 0; end

range = op.range;
grid_flag = op.grid_flag;

selected = [];
dependant = repmat(0,1,length(op.ptrlist));
for i = 1:length(groups)
    gr = groups{i};
    % switch any 'blank' to 'dependant'
    f = find(grid_flag(gr)==4); %4 = blank
    grid_flag(gr(f)) = 8;       %8 = dependant

    % Ensure only one is non-dependant
    f = find(grid_flag(gr)~=8);
    if length(f)==0 %All dependant - set first one to blank
        grid_flag(gr(1))=0;
        sel = gr(1);
    elseif length(f)==1
        sel = gr(f);
    else
        sel = gr(f(1));
        thisind = intersect(gr,ind);
        if isempty(thisind)
            thisind = 0;
        else
            thisind = thisind(1);
        end
        % Set first member (or match to ind) to something, others to dependant
        f = find(gr==thisind);
        if isempty(f), f = 1; end
        if isempty(range), r = []; 
        else, r = range{gr(f)};
        end
        old = grid_flag(gr(f));
        grid_flag(gr)=8;
        % Work out what first one should be, based on length of its range.
        if ismember(old,0:8)
            do_r = old;
        else
            switch length(r)
            case 0  %blank
                do_r = 0;
            case 1  %constant
                do_r = 0;
            otherwise  %range
                do_r = 1;
            end
        end
        grid_flag(gr(f))=do_r;
        sel = gr(f);
    end
    selected = [selected sel];
    dependant(gr) = sel;
    dependant(sel) = 0;
end

oldblocklen = get(op, 'blocklen');
op = set(op,'grid_flag',grid_flag);
op = set(op, 'blocklen', oldblocklen);

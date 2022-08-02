function d = subsref(d,S)
% cgOpPoint / subsref
% P(n) - an OperatingPoint object containing just the nth factor
% P(n,m) - an OperatingPoint object containing just the nth factor and the mth data point
% P(n,m).property = get(P(n,m),property)
%   e.g. P(1:4) returns an operating point object with just the first 4 factors in it
%        P(2,1:100).data returns the first 100 data points for the 2nd factor
%		 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:52:20 $
if strcmp(S(1).type,'()')
    index = S(1).subs;
    if length(index) > 2 | max(index{1}) > get(d,'numfactors') | min(index{1}) < 1
        error('Invalid index');
    else
        if ~isempty(d.data)
            if length(index) == 1
                d.data = d.data(:,index{1});
            else
                d.data = d.data(index{2},index{1});
            end
        end
        ind = index{1};
        d.ptrlist = d.ptrlist(ind);
        d.units = d.units(ind);
        d.orig_name = d.orig_name(ind);
        d.factor_type = d.factor_type(ind);
        d.linkptrlist = d.linkptrlist(ind);
        d.overwrite = d.overwrite(ind);
        d.group = d.group(ind);
        d.grid_flag = d.grid_flag(ind);
        d.range = d.range(ind);
        d.constant = d.constant(ind);
        d.tolerance = d.tolerance(ind);
        
    end
    if length(S)==1
        return
    end
    S = S(2:end);
end
if strcmp(S(1).type,'.') 
    try
        d = get(d,S(1).subs);
        if length(S)>1
            if strcmp(S(2).type,'()')
                index = S(2).subs;
                if length(index)==1 & all(ismember(index{1},1:length(d)))
                    d = d(index{1});
                else
                    error('Bad index');
                end
            elseif strcmp(S(2).type,'{}')
                index = S(2).subs;
                if length(index)==1 & length(index{1})==1 & ...
                        all(ismember(index{1},1:length(d)))
                    d = d{index{1}};
                else
                    error('Bad index');
                end
            end
        end
    catch
        error('Invalid action subsref');
    end
end

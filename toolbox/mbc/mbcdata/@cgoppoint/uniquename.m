function list = uniquename(op,list,fact_i)
% newnamelist = uniquename(p,namelist) ensures all new
%    names are unique.
% newnamelist = uniquename(p,namelist,fact_i) ensures all 
%    names are unique when compared against orig_names, apart from fact_i

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:52:21 $

if nargin<3, fact_i = []; end
l = op.orig_name;
single = 0;
if ischar(list)
    single = 1;
    list = {list}; 
end
for k = 1:length(list)
    name = list{k};
    for i=1:length(l)
        if ~ismember(i,fact_i)
        currentName=l{i};
        if strcmp(name,currentName)
            for j = 0:length(name)-1
                if isempty(str2num((name(end-j))))
                    break;
                end
            end
            if j == 0
                num = 1;
            else
                num = str2num(name(end-j+1:end)) + 1;
            end
            name = [name(1:end-j) num2str(num)];
        end
    end
    end
    list{k} = name;
end

if single
    list = list{1};
end
function [nm,chnged]=uniquename(prj,rt)
%UNIQUENAME  Generate a unique name from a root
%
%  NM = UNIQUENAME(PROJ, NM) generates a name which is unique among the
%  items in the project.
%
%  [NM,CHANGED] = UNIQUENAME(PROJ,NM) also returns a vector indicating
%  which names have been altered.  If an entry is non-zero then the name
%  was altered.  If an entry is positive then it is the pointer address of
%  the project item that caused the name change.  If it is -1 then the name
%  clash was with a variable.  If it is -2 then the name clash was with an
%  earlier name that is being checked.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.4 $  $Date: 2004/02/09 08:28:30 $


prj = address(prj);

used_nm_ptr=[prj prj.allchildren];
used_nm = pveceval(used_nm_ptr, @name);

% Always add the entire data dictionary.
DD = prj.getdd;
used_nm = [used_nm(:); DD.listnames(true)];
used_nm_ptr = double(used_nm_ptr);
used_nm_ptr(end+1:length(used_nm))=-1;  % -1 = data dictionary origin

% Only check new names against the unique set of current names.
[used_nm, uniq_reord] = unique(used_nm);
used_nm_ptr = used_nm_ptr(uniq_reord);

% If input is a char, convert to cell for the algorithm and back again at
% end.
dochangetochar = false;
if ~iscell(rt)
    dochangetochar = true;
    rt={rt};
end

chnged = zeros(size(rt));
nm = cell(size(rt));
for k = 1:length(rt)
    thisrt = rt{k};
    thisnm = thisrt;
    
    used_ind = strmatch(thisnm,used_nm, 'exact');
    if ~isempty(used_ind)
        % Look for a number at the end of the name
        [thisrt, tryagain] = i_trimroot(thisrt);
        
        while tryagain
            if ~any(strcmp(thisnm,used_nm))
                tryagain = 0;
            else
                thisnm = sprintf(thisrt,tryagain);
                tryagain = tryagain+1;
            end  
        end
        
        chnged(k)=used_nm_ptr(used_ind(1));
    end
    % Add the checked name toe the list of used ones.
    used_nm = [used_nm; {thisnm}];
    used_nm_ptr = [used_nm_ptr, -2];
    nm{k} = thisnm;
end

if dochangetochar
    nm = nm{1};
end



function [newroot, startnumber] = i_trimroot(root)

numeric_indx = (double(root)<='9' & double(root)>='0');
len = length(root);
if numeric_indx(len)
    % Find the number of numeric characters
    while(numeric_indx(len))
        len = len-1;
    end
    
    if strcmp(root(len), '_')
        % The root ended in _x so we can increment it
        startnumber = sscanf(root(len+1:end), '%d')+1;
        newroot = [root(1:len), '%d'];
    else
        % The root wasn't quite the right format so we'll just append to the
        % original
        newroot = [root, '_%d'];
        startnumber = 1;
    end
else
    newroot = [root, '_%d'];
    startnumber = 1;
end

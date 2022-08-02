function objNameNew = reorder_includeFile(objName)
%REORDER_INCLUDEFILE reorders include files
%  [OBJECTNAMENEW] = REORDER_INCLUDEFILE(OBJNAME)
%         This function returns a new order of include files for objects associated 
%         with a file.
%
%  INPUT:
%        objName:   Names of include files in old order
%   OUTPUT:
%        objNameNew: Names of include files in new order

%  Linghui Zhang
%  Copyright 2002-2004 The MathWorks, Inc.
%  $Revision: 1.1.4.2 $
%  $Date: 2004/04/15 00:28:48 $

userTypes = rtwprivate('rtwattic', 'AtticData', 'userTypes');

userTypeDepend = '';
objNameNew =  objName; 

for i = 1 : length(userTypes)
    userTypeDepend{i} = userTypes{i}.userTypeDepend;
end
userTypeDepend = unique(userTypeDepend);
for j = length(userTypeDepend) : -1:1
    Ifirst = 1;
    for i = 1: length(objName)
        if isequal(objName{i}, userTypeDepend{j})
            Ifirst = i;
            break;
        end
    end
    if Ifirst > 1
        objNameNew{1} =  objName{Ifirst};
        for i = 1: Ifirst-1
             objNameNew{i+1} =  objName{i};
        end
        for i = Ifirst+1: length(objName)
             objNameNew{i} =  objName{i};
        end
    end
end

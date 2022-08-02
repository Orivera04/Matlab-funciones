function NameList = TreeName(MD)
%TREENAME

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:09:55 $

NameList = i_Inorder(MD);


function List = i_Inorder(MD)
List= {MD.name};
for i=1:length(MD.children)
    ch= MD.children(i).info;
    List= [List;i_Inorder(ch)];
end

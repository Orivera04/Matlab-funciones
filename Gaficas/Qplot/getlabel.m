function getlabel
global label

prompt= {'X label','Y label','Z label','Title'};
title= 'Axis Legends';
lines= 1;
resize= 'off';
tmp= inputdlg(prompt,title,lines,struct2cell(label));
fields= {'x','y','z','t'};
if size(tmp,1) > 0 label= cell2struct(tmp,fields,1); end
return

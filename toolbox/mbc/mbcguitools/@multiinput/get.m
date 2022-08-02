function out = get(obj , prop)
%GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:19:12 $

out = [];
switch lower(prop)
case 'objects'
   out = obj.objects;
case 'value'
    for i = 1:length(obj.objects)
        out{i} = get(obj.objects{i},'value');
    end
case 'gapx'
    out = obj.gapx;
case {'colsizes','colsize'}
    out = obj.colsize;
end

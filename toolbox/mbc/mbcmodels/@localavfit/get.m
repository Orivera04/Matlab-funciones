function Value= get(L,Property);
%LOCALAVFIT/GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:37:41 $

if nargin==1
    Value= [{'model'}; get(L.localmod) ; get(L.model) ];
else
    
    switch lower(Property)
    case 'model'
        m= L.model;
        set(m,'ytrans',get(L.xregmodel,'ytrans'));
        Value= m;
    otherwise
        try
            Value= get(L.localmod,Property);
        catch
            try
                Value= get(L.xregmodel,Property);
            catch
                Value= get(L.model,Property);
            end
        end
    end
end

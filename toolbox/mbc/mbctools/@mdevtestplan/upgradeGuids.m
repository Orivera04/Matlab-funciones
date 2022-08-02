function T= upgradeGuids(T)
%MDEVTESTPLAN/UPGRADETESTPLAN upgrade test plan data guids to match original data

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.4.6.3 $  $Date: 2004/02/09 08:08:25 $

if IsMatched(T)
    % testplan response data should have same guids as datalink
    if isa(T.DataLink,'xregpointer')
        dguids= getGuids(T.DataLink.info);
    else
        dguids= getGuids(T.DataLink);
    end
    Yp= dataptr(T,'Y');
    if length(dguids)==size(Yp.info,1)
        Yp.info= setGuids(Yp.info,dguids);
    end
    
    if numstages(T)>1 && numChildren(T)>0
        % upgrade local nodes
        lptrs= children(T,@children);
        lptrs= [lptrs{:}];
        if ~isempty(lptrs)
            out= pveceval(lptrs,@upgradeGuids);
        end
    end
    
end

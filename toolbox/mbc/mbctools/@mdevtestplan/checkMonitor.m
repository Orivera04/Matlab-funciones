function T= checkMonitor(T);
%CHECKMONITOR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.6.4.3 $  $Date: 2004/02/09 08:07:35 $



if IsMatched(T)
    vars= get(T.DataLink.info,'name');    
    if ~isempty(T.Monitor)
        n= length(T.Monitor.values);
        ok= false(1,n); 
        for i=1:n
            ok(i)= any(strcmp(T.Monitor.values{i},vars));
        end
        T.Monitor.values= T.Monitor.values(ok);
        if ~any(strcmp(T.Monitor.Xdata,vars))
            T.Monitor.Xdata= [];
        end
        xregpointer(T);
    end
end

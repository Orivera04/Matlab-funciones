function [TP, lChanged, NameMap] = pUpdateToValidNames(TP,NameMap)
%PUPDATETOVALIDNAMES
% 
%  TP = PUPDATETOVALIDNAMES(TP,NameMap)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.4 $  $Date: 2004/04/04 03:31:37 $

% update input + response variables
lChanged= false;
[Xp,Yp] = dataptr(TP);
if Yp==0
    return
end

Yp.info = pUpdateToValidNames(Yp.info, NameMap);

% update input variables - These sweepset should be drawn from the root sweepsets ONLY
X = pveceval(Xp,@pUpdateToValidNames,NameMap);
passign(Xp,X);

% update model names
for i = 1:numstages(TP)
    D = TP.DesignDev(i);
    m = pUpdateToValidNames(getModel(D), NameMap);
    TP.DesignDev(i) = setmodel(D, m);
end


if numstages(TP)>1
    % update all response nodes
    children(TP,@pUpdateToValidNames,NameMap);

    % pointers to all local nodes
    pLocal = children(TP,@children);
    % local nodes have to be handled differently because of response feature
    % dats
    if ~isempty(pLocal)
        pveceval([pLocal{:}],@pUpdateToValidNames,NameMap);
    end
else
    % update all one-stage model nodes
    children(TP,'preorder',@pUpdateToValidNames,NameMap);
end

% Monitor Plots
if ~isempty(TP.Monitor)
    if ~isempty(TP.Monitor.values)
        TP.Monitor.values = pUpdateToValidNames(TP.Monitor.values, NameMap);
    end
    if ~isempty(TP.Monitor.Xdata)
        TP.Monitor.Xdata = pUpdateToValidNames(TP.Monitor.Xdata, NameMap);
    end
end

xregpointer(TP);

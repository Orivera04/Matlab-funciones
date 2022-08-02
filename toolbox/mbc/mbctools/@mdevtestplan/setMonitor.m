function varargout=setMonitor(Tp,Monitor);
%SETMONITOR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:08:17 $

Tp.Monitor=Monitor;

pointer(Tp);

if nargout==1
   varargout{1}=Tp;
%else
%   assignin('caller',inputname(1),Tp);
end
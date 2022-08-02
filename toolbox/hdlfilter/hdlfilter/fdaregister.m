function fdapluginstruct = fdaregister
%FDAREGISTER   Plug-in registration function for FDATool.

%   Author(s): J. Schickler
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $  $Date: 2004/04/12 23:33:39 $

fdapluginstruct.plugin           = {@vhdlplugin};
fdapluginstruct.name             = {'Filter Design HDL Coder'};
fdapluginstruct.version          = {1.0};
fdapluginstruct.licenseavailable = license('test', 'Filter_Design_HDL_Coder');

% [EOF]

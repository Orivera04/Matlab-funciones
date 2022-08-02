function status = mpt_gui_technology
%MPT_GUI_TECHNOLOGY specifies which GUI technology MPT should use.
%
%  Choices:
%     hg....Handle Graphics
%     me....Model Explorer with Embedded Dynamic Dialog
%     sdd...Stand alone dynamic dialog GUI

%   Steve Toeppe
%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  
%   $Date: 2003/09/18 18:05:19 $

status = 'hg';
try
%feature('SimPrmDynamicDialog',0);
catch
end
% status = 'me';
status = 'sdd';
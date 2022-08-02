function T = createTestplanFromTemplate(MP,TemplateName,NewName)
%CREATETESTPLANFROMTEMPLATE
% 
% pTP= CreateTestplanFromTemplate(MP,templateName,NewName)
% Inputs
%   MP    mdevproject object
%   

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

% $Revision: 1.1.6.3 $  $Date: 2004/04/04 03:31:23 $

[p,f,e] = fileparts(TemplateName);

if isempty(e)
    % default extension
    e = '.mbt';
end
if isempty(p) && exist([f,e]) ~= 2
    % default directory
    p = xregGetDefaultDir('Designs');
end

TemplateName = fullfile(p,[f,e]);
% Need to check that the requested file exists on the local machine
if exist(TemplateName) ~= 2
    error('mbc:mdevproject:InvalidArgument', 'Testplan template file does not exist');
end
% load from file
Ti = struct2cell(load('-mat',TemplateName));
T = Ti{1};
if ~isa(T, 'mdevtestplan')
    error('mbc:mdevproject:InvalidArgument', 'Testplan template file does not contain a valid template');
end


pTP= xregpointer(T);
if pTP~=0
    MP= AddChild(MP,pTP);
    if nargin>2
        % Name new testplan
        pTP.name(NewName);
    end
    % Get the heap copy
    T = info(pTP);
end

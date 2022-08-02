%function xregmaskinitialization
%XREGMASKINITIALIZATION helper function to initialise mask variables
%
%  XREGMASKINITIALIZATION

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:02:58 $ 

% NOTE the cryptic use of aAbBzZ_ to attempt to avoid namespace clashes!

% Get the userdata
aAbBzZ_ud = get_param(gcb, 'userdata');
% Only initialise the variables if it is a structure
if isstruct(aAbBzZ_ud)
    aAbBzZ_names = fieldnames(aAbBzZ_ud);
    aAbBzZ_values = struct2cell(aAbBzZ_ud);    
    % Loop over the variables
    for aAbBzZ_i = 1:length(aAbBzZ_names)
        eval([aAbBzZ_names{aAbBzZ_i} '= aAbBzZ_values{aAbBzZ_i};']); 
    end
    clear('aAbBzZ_names', 'aAbBzZ_values', 'aAbBzZ_ud', 'aAbBzZ_i');
end


%% Get the userdata
%ud = get_param(gcb, 'userdata');
%% Only initialise the variables if it is a structure
%if isstruct(ud)
%    names = fieldnames(ud);
%    values = struct2cell(ud);    
%    % Loop over the variables
%    for i = 1:length(names)
%        eval([names{i} '= values{i};']); 
%    end
%    clear('names', 'values', 'ud');
%end
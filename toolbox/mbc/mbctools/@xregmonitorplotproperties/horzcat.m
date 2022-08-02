function A = horzcat(varargin)
%HORZCAT A short description of the function
%
%  OUT = HORZCAT(IN)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:19:15 $ 

% Remove any builtin isempty's
args = varargin(~cellfun('isempty', varargin));
% Anything left
if isempty(args)
    A = xregmonitorplotproperties;
    return
end

% Are all the inputs of the correct type
if all(cellfun('isclass', args, 'xregmonitorplotproperties'))
    A = xregmonitorplotproperties;
    % Need to treat args like a structure not an object and concatenate
    % into a structure array
    args = builtin('horzcat', args{:});
    % Now concatenate the structure array
    A.plots = horzcat(args(:).plots);
else
    error('mbc:xregmonitorplotproperties:InvalidArgument', 'All arguments to xregmonitorplotproperties/horzcat must be xregmonitorplotproperties objects');
end
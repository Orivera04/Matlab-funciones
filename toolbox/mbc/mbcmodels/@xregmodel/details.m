function out=details(m,option,VarName)
% MODEL/DETAILS details of model
%
%   str=details(m,'PlainView')
%     outputs a plain formatted cell array of strings describing the input model
%   str=details(m,'TexView')
%     outputs a TeX formatted cell array of strings
%   figH=details(m,'View',[VarName])
%     Instead of returning the string representation details formats and displays the
%     information onto a figure and returns the handle.
%     Adding the optional VarName to the input arguments labels the plot

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:42 $

if nargin < 3
   VarName= 'Y';
   if nargin < 2
      option = 'PlainView';
   end
end
% Call appropriate method
try
   out= feval(option,m,VarName);
catch
   error('Unknown model view option')
end


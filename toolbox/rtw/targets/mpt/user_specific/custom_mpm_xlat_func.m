function str = custom_mpm_xlat_func(varargin)
%CUSTOM_MPM_XLAT_FUNC c function translation script
%
%   This script is ment to be a placeholder for customers to add custom c 
% function translation capability.  This will allow customers to have 
% function translation for substitution of TMW functions with custom code 
% utilities or legacy code.
%
%

%   Steve Toeppe
%   Copyright 1984-2002 The MathWorks, Inc.
%   $Revision: 1.5 $
%   $Date: 2002/04/14 17:52:15 $

    str =[];
    strTemp = varargin{2};
    
    for i=1:length(strTemp),
       if i == 1,
          str = [ str,char(strTemp{i})];
       elseif i > 1,
          str = [ str,',',char(strTemp{i})];
       end
    end 
    return;
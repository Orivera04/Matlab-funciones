function cff = apply_user_types(cff)
%APPLY_USER_TYPES replaces all character string matches of the given type.
%
%   CFF = APPLY_USER_TYPES(CFF)
%         Replaces all character string matches of the given type.
%
%   INPUT:
%         cff: Input string
%
%   OUTPUT:
%         cff: Output string

%   Steve Toeppe
%   Copyright 2001-2004 The MathWorks, Inc.
%   $Revision: 1.12.4.2 $
%   $Date: 2004/04/15 00:27:47 $

% UPGRADE PLANS.  This function needs to be improved to only apply string
% replacement on actual data types found either in local declarations with
% the C function or in casts. It also needs to account for primary user data
% types. A partial upgrade is applied with rev 1.2.

%
% A fix has been made to use regular expressions to only do word boundry
% exact match replacements for user data types. This corrects an error
% where the data type was being munged by the strrep function and adds soem
% robustness to this function. PWM 8-23-2002
%

userTypes = rtwprivate('rtwattic', 'AtticData', 'userTypes');
%
% If apply_user_types was called from process_objects then cff will exactly match a
% mathworks type and this section will be executed and return 
%
for i=1:length(userTypes)
    if strmatch(cff,userTypes{i}.tmwName,'exact')
      cff = regexprep(cff,['\<',userTypes{i}.tmwName,'\>'],userTypes{i}.userName);
      cff = regexprep(cff,['\<',lower(userTypes{i}.tmwName),'\>'],userTypes{i}.userName); 
      return
    end
end
%
% If apply_user_types was called from make_single_c_function then cff will be an
% extended string for the c code body. The function will fall through to this section.
%
for i=1:length(userTypes)
    if isempty(cff)==0,
      cff = regexprep(cff,['\<',userTypes{i}.tmwName,'\>'],userTypes{i}.userName);
      cff = regexprep(cff,['\<',lower(userTypes{i}.tmwName),'\>'],userTypes{i}.userName); 
    end
end

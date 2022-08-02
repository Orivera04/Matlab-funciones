function result=get_rtw_option(modelName,optionName)

%   Steve Toeppe
%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $
%   $Date: 2003/09/18 18:06:04 $

result=[];
o=get_param(modelName,'Object');
rtwOption = o.RTWOptions;

b=rtwOption;
while  isempty(b) == 0
    [a,b]=strtok(b,' ');
    a=strrep(a,'-a','');
    if strncmp(a,optionName,length(optionName)) == 1
        [c,d]=strtok(a,'=');
        result = d(2:end);
    end
end
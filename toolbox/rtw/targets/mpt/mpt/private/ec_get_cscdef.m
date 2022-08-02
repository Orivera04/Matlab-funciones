function cscdef = ec_get_cscdef(name)
%EC_GET_CSCDEF


%   Steve Toeppe
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $
%   $Date: 2004/04/15 00:27:56 $

cscdef=[];
obj = evalin('base',name);
if isempty(obj) == 0
  try
    objStruct = obj.get;
    if isfield(objStruct,'RTWInfo')
      className = class(obj.RTWInfo);
      package = strtok(className,'.');
      if isempty(package) == 0
        cscDefns = processcsc('GetCSCDefns',package,false);
        for i=1:length(cscDefns)
          if strcmp(cscDefns(i).Name,obj.RTWInfo.CustomStorageClass)
            cscdef = cscDefns(i);
            return
          end
        end
      end
    end
  catch
  end
end

function result = do_in_global(globalObject, appendedObjMethod, varargin)
%DO_IN_GLOBAL will operate on an object.method in the global workspace
%
%   RESULT = DO_IN_GLOBAL(VARARGIN) will put together an object.method call
%   that can have any number of arguments passed in via a cell array
%   varargin. The object.method will be executed in the global workspace.
%
%   INPUT:
%         globalObject:        object name
%         appendedObjMethod:   method name
%         varargin:            list of method arguments
%   OUTPUT:
%         result:    Result of evaluation of object.method in global ws.

%   Steve Toeppe
%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.6.4.2 $
%   $Date: 2004/04/15 00:26:37 $

str = ['global ',globalObject];
eval(str);
result = [];
str=[globalObject,'.',appendedObjMethod];
if nargin > 2
    str = [str,'('];
    for i=1:length(varargin)
        if ischar(varargin{i}) == 1
            str=[str,'''''',varargin{i},'''''',','];
        else
            str=[str,num2str(varargin{i}),','];
        end
    end
    str=[str(1:end-1),');'];
end
try
  result = eval(eval(['''',str,'''']));
  if ~exist('result')
     result=[];
  end
catch
end

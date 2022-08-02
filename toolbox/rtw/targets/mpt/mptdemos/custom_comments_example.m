function comments = custom_comments_example(objectName, modelName, request)
% An example of creating custom comments using a M script. The created
% custom comments will be placed right above data declaration or 
% definition in generated code.
% You can define your own function name. But the function must have three
% auguments.
%   INPUTS:
%         objectName: The name of mpt Parameter or Signal object
%         modelName:  The name of working model
%         request:    The nature of the code or information requested. 
%                     Two kinds of requests are supported:
%                     'declComment' -- comment for data declaration
%                     'defnComment' -- comment for data definition
%   OUTPUT:
%         comments:   A comment according to standard C convention
%
% Note: This file has to be on the MATLAB path.
% Recommend: Use get_data_info to get property value of the Simulink or mpt
%            data object for named object.
% See also get_data_info.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $
%   $Date: 2004/04/15 00:29:16 $

dataType = get_data_info(objectName,'DATATYPE');
units = get_data_info(objectName,'UNITS');
csc = get_data_info(objectName,'CUSSTORAGECLASS');
cr = sprintf('\n');
if strcmp(request,'defnComment')
		comments = ['/* Object: ',objectName,' - description:',cr,...
	             	'           DataType -- ', dataType,cr,...
	             	'           Units    -- ', units,cr,...
             		'           CSC      -- ', csc,' */'];
elseif strcmp(request,'declComment')
		comments = ['/* Object: ',objectName,' - extern reference:',cr,...
	              '           CSC      -- ', csc,' */'];
else
		comments = '';
end

%EOF

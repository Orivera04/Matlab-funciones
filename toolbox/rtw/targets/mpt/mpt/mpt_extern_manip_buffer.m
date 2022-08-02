function bufferOut   = mpt_extern_manip_buffer(resolvedStr,symbolName,fileName,modelName,operationName)
%MPT_EXTERN_MANIP_BUFFER provides a hook for select custom modifications.
%
% BUFFEROUT = MPT_EXTERN_MANIP_BUFFER(RESOLVEDSTR,SYMBOLNAME,FILENAME,
%                                     MODELNAME,OPERATIONNAME) permits
% customization of manipulation of symbol strings.
%
%   INPUT:
%            resolvedStr:    Buffer string
%            symbolName:     Name of symbol
%            fileName:       Name of file
%            modelName:      Name of model
%            operationName:  Name of manipulation operation
%   OUPPUT:
%            bufferOut:      Output string
 
%   Steve Toeppe
%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $
%   $Date: 2003/03/05 07:07:17 $
bufferOut = resolvedStr;
result = mpt_get_registration(operationName);
if isempty(result) == 0
    if isfield(result,'modifyName') == 1
        manip = getfield(result,'modifyName');

            bufferOut  = eval([manip ,'(resolvedStr,symbolName,fileName,modelName)']);

    end
end

if isempty(bufferOut) == 1
    bufferOut = ' ';
end
function scopeInfo = get_scope_info(modelName)
%GET_SCOPE_INFO Initialize scopeInfo global variable
%
%   [SCOPEINFO]=GET_SCOPE_INFO(MODELNAME)
%   This intialized the the scopeinfo global variable to its
%   default values.
%
%   INPUTS: 
%           modelName : Name of Model to initialize this with
%   
%   OUTPUTS: 
%           scopeInfo : The global scope information from the database
%

%   Steve Toeppe
%   Copyright 2001-2003 The MathWorks, Inc.
%   $Revision: 1.11.4.2 $
%   $Date: 2004/04/15 00:28:08 $

scopeInfo = do_in_global([modelName,'_mpm_options'],'GlobalData.get_scope_data');
if ~isempty(scopeInfo.globalFileName_nodot)
    scopeInfo.globalFileName = [scopeInfo.globalFileName_nodot,'.c'];
end
if ~isempty(scopeInfo.globalExternFileName_nodot)
    scopeInfo.globalExternFileName = [scopeInfo.globalExternFileName_nodot,'.h'];
end

% global scopeInfo;
% Cases to consider:
%
% 1)  All globals in a single file with extern reference in source code files
% 2)  All globals in a single file with extern reference via xxx.h file included in source code files
% 3)  Only machine globals in a signle file with extern reference in source code files
% 4)  Only machine globals in a signle file with extern reference via xxx.h file included in source code files
% 5)  Globals declared in source file with extern reference in source code files
% 6)  Globals declared in source file with extern reference via xxx.h file included in source code files
% 7)  Any of above with overrides





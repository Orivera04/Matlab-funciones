function init_template_info
%INIT_TEMPLATE_INFO Initialize global variable templateInfo
%
%   INIT_TEMPLATE_INFO()
%   This function initializes the template information with the default
%   templates.
%
%   INPUTS: 
%            none
%
%   OUTPUTS:
%            none
%
%


%   Steve Toeppe
%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.11.4.1 $
%   $Date: 2004/04/15 00:28:17 $

global templateInfo;

templateInfo = [];

templateInfo.cFunctionTemplate  = 'cfile_template.tlc';
templateInfo.globalTemplate = 'global_c_template.tlc';
templateInfo.globalIncludeTemplate = 'global_h_template.tlc';
templateInfo.filePrototypeTemplate = [];
templateInfo.typeDefTemplate = [];
templateInfo.miscTemplate = [];
templateInfo.activeTemplateFullPath = [];
templateInfo.useBaseERTTemplate = 'no';
function establish_data_mapping
%ESTABLISH_DATA_MAPPING creates an empty database for data mapping rules.
%
%   ESTABLISH_DATA_MAPPING()
%   Established the core data mapping structure for global use.
%
%   INPUTS: 
%            none
%
%   OUTPUTS:
%            none
%

%   Steve Toeppe
%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.9.4.1 $  $Date: 2004/04/15 00:28:00 $

global ecac;
ecac.mapping=[];

function  mpt_add_seq_subs(fileId)
%MPT_ADD_SEQ_SUBS Adds sequencial substitutions to the replacement file 
%
%  MPT_ADD_SEQ_SUBS(FILEID)
%  This function gets the dynamically added substrutions from the global
%  structure used and adds them to the replacement file that the perl script
%  uses later for post processing.
%  
%  Inputs:  
%           fileId : the handle to an open text file passed in to add to.
%  
%  Outputs: 
%           none
%

%

%  Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.4.2 $  $Date: 2004/04/15 00:28:33 $
%  $ Date:  $ $ Revision:  $ 
%

global mpt_seq_subs;
cr = sprintf('\n');

%
% Add the sequential substitution into the alias list of things to alias. 
%

for i=1:length(mpt_seq_subs)
   fprintf(fileId,'%s',[mpt_seq_subs{i}.pre,' ',mpt_seq_subs{i}.post,cr]);
end

%
% Dump evidence of global structure
%

eval('clear global mpt_seq_subs;');

return
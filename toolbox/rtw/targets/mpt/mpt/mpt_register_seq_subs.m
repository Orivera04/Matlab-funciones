function mpt_register_seq_subs(pre,post)
%MPT_REGISTER_SEQ_SUBS - Registers sequencial substitution for generated
%
%
%   MPT_REGISTER_SEG_SUBS(PRE,POST)
%   This function is used to register the substitution of the "pre" input 
%   with the "post" input.  Effectively substituting pre for post in the
%   post processing of a file.
%
%   Inputs: 
%            pre  : input to substitute 
%            post : the text that is substituted for pre
%
%   Outputs:
%            none
%

%

%  Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.4.2 $  $Date: 2004/04/15 00:27:39 $
%  % Date:  $ $ Revision: $
%

%
% use a transatory global variable that is distroyed when completed
%

global mpt_seq_subs;

%
% Populate the structure to be used later.
%

if length(mpt_seq_subs) > 0,
  mpt_seq_subs{end+1}.pre = pre;
  mpt_seq_subs{end}.post  = post;
else
  mpt_seq_subs{1}.pre  = pre;
  mpt_seq_subs{1}.post = post;
end

return
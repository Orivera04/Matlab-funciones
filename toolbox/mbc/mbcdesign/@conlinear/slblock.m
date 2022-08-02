function nm=slblock(obj,sys)
%SLBLOCK  Create a simulink block for constraint
%
%  BLK=SLBLOCK(OBJ,PARENTSYS)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:58:29 $

load_system('constraints');

% create name for block
basenm='Linear%d';
search=1;
while search
   nm=sprintf(basenm,search);
   if isempty(find_system(sys,'SearchDepth',1,'Name',nm))
      search=0;
   else
      search=search+1;
   end
end
blk=[sys '/' nm];

P=getparams(obj);
add_block('constraints/Linear constraint',blk,...
   'linkstatus','none');
% Set up parameters
set_param(blk,'A', [' [' sprintf('%g ',P.A) '] '] ,'b', sprintf('%g', P.b));
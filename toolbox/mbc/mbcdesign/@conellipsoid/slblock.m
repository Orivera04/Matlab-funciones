function nm=slblock(obj,sys)
%SLBLOCK  Create a simulink block for constraint
%
%  BLK=SLBLOCK(OBJ,PARENTSYS)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 06:58:13 $

load_system('constraints');

% create name for block
basenm='Ellipsoid%d';
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
add_block('constraints/Ellipsoid constraint',blk,...
   'linkstatus','none');
% Set up parameters
P=getparams(obj);
Wspr=[repmat(' %g',1,getsize(obj)) ';'];
Wstr=['[' sprintf(Wspr, P.W)];
Wstr(end)=']';    % remove trailing ;

set_param(blk,'W',Wstr,...
   'Xc',['[' sprintf('%g ', P.xc) ']'],...
   'SF',sprintf('%g', P.ScaleFactor));
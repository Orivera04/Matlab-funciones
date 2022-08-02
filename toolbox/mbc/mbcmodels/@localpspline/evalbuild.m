function Blk = evalbuild(m,sys)
% localpspline evalbuild method adds an evaluation simulink block to
% a simulink implementation of a global model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 07:41:07 $



Blk= add_block('models2/LocalMod/polysplineEval',[sys,'/PolysplineEval']);

% break library link
set_param(Blk,'linkstatus','none');

% If datumtype is 0, then we need to add a constant datum of 0
if ~DatumType(m)
   mxinfo= xinfo(m);
   Xn= validmlname(mxinfo.Names{1});
   blk=find_system(gcs,'searchdepth',1,'name',Xn);
   pos= get_param(blk,'position');
   pos=pos{1}+[0 45 10 55];
   dtm= add_block('built-in/constant',[sys,'/Datum']);
   mdlPort= get_param(Blk,'inport');
   set_param(dtm,'position',pos,...
      'value','0');
   add_line(sys,'Datum/1','PolysplineEval/3');
end

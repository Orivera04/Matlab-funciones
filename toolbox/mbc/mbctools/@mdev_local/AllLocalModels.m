function L= AllLocalModels(mdev,AsXMs);
%MDEV_LOCAL/ALLLOCALMODELS create a cell array of all local models
%
% L= AllLocalModels(mdev,AsXMs);
%   mdev     mdev_local object
%   AsXMs    export as an xregStatsModel for CAGE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.4 $  $Date: 2004/02/09 08:03:52 $




TS= BestModel(mdev);

X= getdata(mdev,'FIT');
op= double(X{end});
[L,ok]= LocalModel(mdev,':');

if ~isempty(TS)
   XL= getdata(mdev,'X');
   for i= find(~ok)
      % reconstruct models from twostage models
      L{i}= LocalModel(TS,op(i,:));
   end
else
   Lbad= update( L{1} , NaN*zeros(size(L{1},1),1) );
   L(~ok)= {Lbad};
end
tnum= testnum(X{1});
name= varname(L{1});
for i=1:length(L)
   tname= sprintf('%s_%1d',varname(L{i}),tnum(i));
   L{i}= varname(L{i},tname);
end


if nargin==1 | AsXMs
   name= peval('name',Parent(mdev));
   minfo= exportinfo( info(project(mdev)) ,address(mdev),L(1));
   for i=1:length(L)
      tname= varname(L{i});
      L{i}= xregstatsmodel(L{i},tname,minfo,[]);
   end
end

function obj=set(obj,param,data)
% SET Set candidate set parameters
%
%   OBJ=SET(OBJ,PARAM,DATA)
%
%   PARAM may be one of:
%
%       Limits   :  cell array of [min max] values
%       NumCenter:  number of center points
%       NLevels    :  vector of number of levels for each dim

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:28 $

% Created 30/12/2000


switch lower(param)
case 'limits'
   lims=cat(1,data{:});
   obj.candidateset=limits(obj.candidateset,lims);
   nl=cellfun('length',get(obj.grid,'levels'));
   obj.grid= set(obj.grid,'levels',i_createlvlvect(limits(obj.candidateset),nl));
case 'numcenter'
   if data>=0
      obj.Nc=data;
   end
case 'nlevels'
   obj.grid= set(obj.grid,'levels',i_createlvlvect(limits(obj.candidateset),data));
end
return


function lvls= i_createlvlvect(lims,nlvl)
nf=length(nlvl);
lvls=cell(1,nf);
for n=1:nf
   lvls(n)={linspace(lims(n,1), lims(n,2), nlvl(n))};
end
return
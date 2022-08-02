function obj=set(obj,param,data)
% SET Set candidate set parameters
%
%   OBJ=SET(OBJ,PARAM,DATA)
%
%   PARAM may be one of:
%
%       Levels: Cell array of factor levels for grid dimensions
%       Limits: Cell array of [Min Max] values for lattice
%       g     : Vector of prime generator numbers
%       N     : Number of points
%       griddims: dimensions to grid over
%       latticedims: dimensions to create lattice over
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:39 $

% Created 1/11/2000


switch lower(param)
case 'levels';
   obj.grid=set(obj.grid,'levels',data);
   l=limits(obj.candidateset);
   for n=1:length(data)
      l(obj.griddims(n),:)=[min(data{n}) max(data{n})];
   end
   obj.candidateset=limits(obj.candidateset,l);
case 'limits'
   obj.lattice= set(obj.lattice,'limits',data);
   l=limits(obj.candidateset);
   for n=1:length(data)
      l(obj.lattdims(n),:)=data{n};
   end
   obj.candidateset=limits(obj.candidateset,l);
case 'g'
   obj.lattice= set(obj.lattice,'g',data);
case 'n'
   obj.lattice= set(obj.lattice,'n',data);
case 'griddims'
   data2=setxor(data,1:nfactors(obj));
   obj=i_changedims(obj,data,data2);
case 'latticedims'
   data2=data;
   data=setxor(data2,1:nfactors(obj));
   obj=i_changedims(obj,data,data2);
end
return




function obj=i_changedims(obj,gdim,ldim)
lims=limits(obj.candidateset);
if length(gdim)>length(obj.griddims)
   % Expand nunmber of grid dims
   g=get(obj.lattice,'g');
   obj.lattice=set(obj.lattice,'g',g(1:length(ldim)));
   obj.lattice=limits(obj.lattice,lims(ldim,:));
   lvls=get(obj.grid,'levels');
   for n=1+length(obj.griddims):length(gdim)
      lvls(end+1)={linspace(lims(n,1),lims(n,2),3)};
   end
   obj.grid=set(obj.grid,'levels',lvls);
elseif length(gdim)<length(obj.griddims)
   % Expand number of lattice dims
   lvls=get(obj.grid,'levels');
   obj.grid= set(obj.grid,'levels',lvls(1:length(gdim)));
   g=get(obj.lattice,'g');
   g= [g i_createg(length(ldim)-length(obj.lattdims),get(obj.lattice,'n'))];
   obj.lattice=set(obj.lattice,'g',g);
   obj.lattice=limits(obj.lattice,lims(ldim,:));
end
obj.griddims= gdim;
obj.lattdims= ldim;
return




function g=i_createg(nf, N)
% create a vector of primes, g, all less than N and preferably different
g=primes(max(N/50,30));
g=g(5:end);
if length(g)<nf
   g=g(floor(rand(1,nf)*(length(g)))+1);
else
   g=g(randperm(length(g)));
   g=g(1:nf);
end
return
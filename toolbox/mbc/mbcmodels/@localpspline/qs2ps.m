function ps= qs2ps(ps,p,L,m);
%QS2PS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:41:30 $

ps.xregmodel=m;
ps.localmod= L;

ps= update(ps,p,[]);

Lf= get(L,'features');
f= features(ps);

pf=zeros(1,numfeats(L));
v= get(L,'values');
lim=get(L,'limits');
for i= 1:numfeats(L)
   Nind= strmatch(Lf(i).Function,{f.Function},'exact');
	if isempty(Nind) & strcmp(Lf(i).Function,'eval(f,f.Values(i))')
		Nind= length(f);
	end
   ps= EditFeat(ps,i,v(i),Nind,lim(:,i));
end


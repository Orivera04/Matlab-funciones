function m= addfactors(m,f);
% MODEL/ADDFACTORS add factors to model
%
% m= addfactors(m,f);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:21 $

nnewf=length(f);
nf=length(m.code);
% Add new factors to end, then reorder

for i= (1:nnewf)
   xsym{i}= sprintf('X%1d',i+nf);
end
m.code(end+1:end+nnewf)=struct('min',-1,'max',1,'g','','mid',0,'range',2);
m.Xinfo.Names(end+1:end+nnewf)=xsym;
m.Xinfo.Units(end+1:end+nnewf)={''};
m.Xinfo.Symbols(end+1:end+nnewf)=xsym;

f=sort(f);
ord=1:length(m.code);
for n=nnewf:-1:1
   ord=[ord(1:(f(n)-1)) ord(end) ord(f(n):end-1)];
end
m=reorderx(m, ord);

try
	% construct a new model with the right number of factors
	m2= feval(class(m),'nfactors',length(m.code));
catch
	% this will always work
	m2= xregcubic('nfactors',length(m.code));
end
m= copymodel(m,m2);
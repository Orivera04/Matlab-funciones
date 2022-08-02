function [psi,smod,X]=gcalc(smod,ReCalc,Method,NumPts)
% DES_LINEARMOD/GCALC  G-optimal value
%   PSI=GCALC(D) returns the g-optimality value for the
%   design object D.
%   See also: DCALC,VCAlC

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:32 $

% Created 8/11/99

if ~rankcheck(smod)
   psi=[];
   return
end

if nargin < 2
   ReCalc= 0;
end

s= store(smod);

% search store for a valid copy
if ~ReCalc & isfield(s,'gpsi')
   % psi depends on design and candidate sets
   if (s.gpsi.designstate==designstate(smod)) & (s.gpsi.candstate==candstate(smod)) & ...
         (s.gpsi.modelstate==modelstate(smod))
      psi= s.gpsi.data;
      X=[];
      return
   end
end

if nargin<3
   Method='Sample';
end
switch lower(Method)
case 'sample'
	% sample from candidate set and optimise
   if nargin<4
      NumPts=[4 10];
   elseif length(NumPts)<2
      % number of groups
      NumPts= [NumPts(1) 10];
   end
   if nargout==3
      [psi,X]= i_samp(smod,NumPts(1),NumPts(2));
   else
      psi= i_samp(smod,NumPts(1),NumPts(2));
   end
case 'full'
	% ful candidate set
   [psi,X]= i_fullg(smod,1);
end   

% store result
s.gpsi.data=psi;
s.gpsi.designstate=designstate(smod);
s.gpsi.candstate=candstate(smod);
s.gpsi.modelstate=modelstate(smod);

smod= store(smod,s);

nm=inputname(1);
if ~isempty(nm)
   assignin('caller',nm,smod);
end



function [psi,Xmax]= i_fullg(smod,NumPts)
% find G over full candidate set 

smod = InitStore(smod);

nc=ncand(smod);
if isinf(nc)
   % choose suitably large number
   nc=300000;
end

% number of points to do simultaneously
% 10,000 points equates to about 1.5Mb peak memory usage
np=10000;

niter=floor(nc./np);
nover=rem(nc,np);
if NumPts==1
   maxg=0;
   gvect=zeros(np,1);
else
   maxg=[];
   Xmax=[];
end
for n=1:niter
   lns=indexcand(smod,((1:np)+(n-1).*np));
	gvect= evalpev(smod,lns);
	
   if NumPts==1
      if max(gvect)>maxg
         [maxg,ind]=max(gvect);
         Xmax= lns(ind,:);
      end  
   else
      X= [lns;Xmax];
      P= [gvect;maxg];
      [dum,ind]= sort(P);
      maxg= P(ind(end:-1:end-NumPts+1));
      Xmax= X(ind(end:-1:end-NumPts+1),:);
   end
end
if nover
   % last load of points (<10000)
   lns=indexcand(smod,((1:nover)+(niter).*np));
	gvect= evalpev(smod,lns);
   if NumPts==1
      if max(gvect)>maxg
         [maxg,ind]=max(gvect);
         Xmax= lns(ind,:);
      end
   else
      X= [lns;Xmax];
      P= [gvect;maxg];
      [dum,ind]= sort(P);
      maxg= P(ind(end:-1:end-NumPts+1));
      Xmax= X(ind(end:-1:end-NumPts+1),:);
   end   
end
psi=maxg;

return




function [psi,G]= i_samp(smod,NumPts,nGroups)

m= model(smod);
smod = InitStore(smod);

nc= ncand(smod);
if nc> nGroups*1e4
   % make sure design points are used
   X=factorsettings(smod);
   P= evalpev(smod,X);
   [dum,ind]= sort(P);
   Y= P(ind(end:-1:end-NumPts+1));
   % try nGroups of 10000
   for i= 1:nGroups
      % take random sample from candidate space
      j=unidrnd(fix(nc/1e4));
      sind= j:fix(nc/1e4):nc;
      x=indexcand(smod,sind);
      X= [x; X];
      P= [evalpev(smod,x); Y];
      [dum,ind]= sort(P);
      Y= P(ind(end:-1:end-NumPts+1));
      X= X(ind(end:-1:end-NumPts+1),:);
   end   
else
   % do a full search if small candidate set
   [psi,X]=i_fullg(smod,NumPts);
end

% oprimise on best 'NumPts' values
fopts= optimset('fmincon');
fopts= optimset(fopts,'largescale','off','display','none');
Tgt= gettarget(m);

[Ncons,A,b]= numConstraints(smod);
% non linear constraint functions
Ncons= Ncons-size(A,1);
if Ncons
   ConsFcn='optConstr';
else
   ConsFcn='';
end
for i=1:size(X,1)
	% perform nonlinear optimisations to search for 
   x0= X(i,:);
   [xopt,f,exitflag]=fmincon('gopt',x0,A,b,[],[],Tgt(:,1),Tgt(:,2),ConsFcn,fopts,smod);
   y=evalpev(smod,xopt);
   X(i,:)=xopt;
   Y(i)=y;
end
psi= max(Y);
if nargout==2
	% determine bigist NumPts pevs
   [X,ind]=unique(X,'rows');
   Y= Y(ind);
   [Y,ind]= sort(Y);
   Y= Y(end:-1:1);
   X= X(ind(end:-1:1),:);
   j=[];
   for i=2:length(Y);
      if norm(X(i-1,:)-X(i,:))<1e-4
         j=[j i];
      end
   end
   if ~isempty(j)
      Y(j)=[];
      X(j,:)=[];
   end
   G= [Y(:) X];
end
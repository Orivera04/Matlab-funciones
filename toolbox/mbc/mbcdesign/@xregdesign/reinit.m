function [des,okout]=reinit(des,p,opt)
%REINIT Initialise design object
%
%  D=REINIT(D,N) Reinitialises the design object D with N lines. The lines
%  are generated according to the current settings for the design point
%  generation.  Alternatively, N may be a numeric matrix of points to
%  replace the current one.
%
%  D=REINIT(D,N,OPT) forces recognition of the intialisation option:
%  OPT='random'/'defined'
%
%  Note that a numeric matrix must have the correct number of  factors for
%  the current model, but will reset the number of test points as needed.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:07:37 $

if nargin==1
   p=des.npoints;
end

dorand=0;
if nargin<3
   if length(p(:))<=1
      dorand=1;
   end
else
   if strcmpi(opt,'random')
      dorand=1;
   end
end


if ~dorand
   % Assume input is a matrix of factor levels 
   % Take first 'nfactors' columns of design, or pad with zero columns
   s=size(p,2);
   if s<des.nfactors
      warning('Design has too few factors.  Padding with zeros...');
      p=[p,zeros(size(p,1),nfactors(des)-s)];      
   elseif s>des.nfactors
      warning('Design has too many factors and has been cropped');
      p=p(:,1:des.nfactors);      
   end
   des.design=p;
   des.npoints=size(p,1);
   des.designindex=zeros(des.npoints,1);
   % rankcheck
   okout=rankcheck(des);
else
   if p==0
      des=clear(des);
      okout=1;
   else
      
      % generate new random points
      % check we have enough candidate points to support this many points
      rankok=0;
      count=0;
      while (~rankok & count<10)
         des.design=[];
         des.designindex=[];
         des.npoints=0;
         [des.design des.designindex]=randcand(des,p);
         des.npoints=p;
         des.designstate=des.designstate+1;
         rankok=rankcheck(des);
         count=count+1;
      end
      if rankok
         des.npoints=p;
         okout=1;
      else
         des.design=zeros(0, des.nfactors);
         des.designindex=[];
         des.npoints=0;
         okout=0;
      end
   end
end

des.designpointflags = uint8(zeros(des.npoints, 1));
des.designstate=des.designstate+1;
des=DesignType(des,0,[]);
des=timestamp(des,'stamp');

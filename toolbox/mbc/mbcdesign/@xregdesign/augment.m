function des=augment(des,numlines,opt)
%AUGMENT  dd lines to current design
%  D=AUGMENT(D,P) adds p lines to the design object D, using the current
%  settings for the design generation.  Alternatively, P may be a matrix
%  containing new design points to be added.
%  D=AUGMENT(D,POINTS,'points') forces the recognition that  a specified
%  point is being added - this is useful if you are trying to add a point
%  on a 1D design and the function is choosing P random points instead.
%  D=AUGMENT(D,IND,'index') adds the lines that are generated using the
%  indices in IND.
%  D=AUGMENT(D,IND,'absindex') adds the lines that are generated using the
%  indices in IND from the main candidate  definition.  No constraints, no
%  replacing, no quibbles.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.3 $  $Date: 2004/02/09 07:06:10 $

if nargin<3
   if length(numlines(:))>1
      opt='points';
   else
      opt='random';
   end
end

switch lower(opt)
case 'index'
   [pts,ind]=indexcand(des,numlines);
   numlines=length(ind);
case 'indexnorep'
   [pts,ind]=indexcand(des,numlines,'noreplacement');
   numlines=length(ind);
case 'absindex'
   [pts,ind]=indexcand(des,numlines,'unconstrained');
   numlines=length(ind);
case 'points'
   pts=numlines;
   numlines=size(numlines,1);
   ind=zeros(numlines,1);
case 'random'
   if ~des.replicatedpoints & numlines>ncandleft(des)
      numlines=ncandleft(des);
   end
   [pts ind]=randcand(des,numlines);
end

if numlines
   des.design=[des.design;pts];
   des.designindex=[des.designindex;ind(:)];
   des.npoints=des.npoints+numlines;
   des.designpointflags(des.npoints, 1) = 0;
   des=DesignType(des,0,[]);
   des=timestamp(des,'stamp');
   des.designstate=des.designstate+1;
end

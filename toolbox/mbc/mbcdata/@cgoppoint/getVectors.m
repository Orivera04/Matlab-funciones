function varargout = getVectors(p)
%A function to return in a cell array the X,Y,... vectors which
%should be used to plot any surface data against.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:48 $

Ptrs = get(p , 'ptrlist');

vecs = cell(1,1);
Used = [];
UsedN = [];
out = [];

count = 1;
for i = 1:length(Ptrs)
    if isvalid(Ptrs(i))
      if isa(Ptrs(i).info , 'cgvariable') & ~ismember(double(Ptrs(i)) , Used)
   dat = Ptrs(i).eval;
   
   if length(dat) >= 1
         out = [out;Ptrs(i)];
         vecs{count} = dat;
         count = count + 1;
         Used = [Used double(Ptrs(i))];
         UsedN = [UsedN double(Ptrs(i))];
      end
   end
end
end

%varargout{1}=vecs;
varargout{1}=out;
if nargout>1
   varargout{2}=Used;
end
if nargout>2
   varargout{3}=UsedN;
end


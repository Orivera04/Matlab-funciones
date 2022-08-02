function des = sort(des,varargin)
%SORT Reorder design points
%  D=SORT(D,COL) sorts the points in D in ascending order, based on the
%  columns specified in the optional COL.
%  D=SORT(D,'-') sorts in descending order.
%  D=SORT(D,COL,'-') sorts in descending ordre, using the columns in COL.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:07:48 $

% sort out input arguments
flipdes=false;
srtord=[1:nfactors(des)];
if nargin>1
   if ischar(varargin{1})
      if strcmp(varargin{1},'-')
         flipdes=true;
      end
   else
      srtord=varargin{1};
   end
   
   if nargin>2
      if strcmp(varargin{2},'-')
         flipdes=true;
      end
   end
end

[des.design,i]=sortrows(des.design,srtord);

% flip?
if flipdes
   des.design=des.design(end:-1:1,:);
   i=i(end:-1:1);   
end

% reorder index and fixed vectors
des.designindex = des.designindex(i);
des.designpointflags = des.designpointflags(i);

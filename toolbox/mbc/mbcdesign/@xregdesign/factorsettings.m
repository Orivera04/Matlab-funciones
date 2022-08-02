function fs=factorsettings(des,varargin)
%FACTORSETTINGS Return the current factor settings
%
%  FS=FACTORSETTINGS(D) returns the matrix of factor settings currently
%  held in the design object D.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:06:33 $


if nargin==1
   fs=des.design;
else
   if ischar(varargin{1})
      if strcmp(varargin{1},'changeable')
         fs=des.design;
         fs=fs(~pGetFlags(des, 'FIXED'),:);
      end
   else
      %set factor levels
      % must have right number of factors
      fs=reinit(des,varargin{1},'specified');
   end
end

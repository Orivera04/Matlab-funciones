function varargout=cgresload(varargin)
% CGRESLOAD  GUI resource loader
%
%  CGRESLOAD(FILE) loads data from the mat file specified.  The
%  data will be assigned into the calling workspace.
%  s=CGRESLOAD(FILE) will return the data as fields in a structure. 
%  
%  X=CGRESLOAD(FILE,'BMP') loads data from a bitmap.
%  [X,MAP]=CGRESLOAD(FILE,'BMP') loads data and colormap from a bitmap.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:39:41 $


if nargin<2
   TP='MAT';
else
   TP=upper(varargin{2});
end
FILE=varargin{1};
pthfl=cgrespath(FILE);
switch TP   
case 'MAT'
   if ~nargout
      s=load(pthfl,'-mat');
      nms=fieldnames(s);
      sref=struct('type','.','subs','');
      for n=1:length(nms)
         sref.subs=nms{n};
         assignin('caller',nms{n},subsref(s,sref));
      end
   else
      varargout{1}=load(pthfl,'-mat');
   end
case 'BMP'
   [varargout{1},varargout{2}]=imread(pthfl,'bmp');
end
function varargout=xregCheckIsNum(varargin)
% XREGISCHECKISNUM      Callback routine to check if input is a number
%   varargout= xregCheckIsNum
%
% Description
%   callback routine to check if input is a number
%   assumes that previous number stored in gcbo UserData
%   It is not intended for use from the MATLAB Command Line
% 
% Outputs IsNum (0,1)
%
%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:34:13 $


Num= get(gcbo,'UserData');
Str= get(gcbo,'String');
NewNum=str2num(Str);

IsNum= ~isempty(NewNum);
for i=1:2:nargin-1
   Prop= varargin{i};
   Val = varargin{i+1};
   switch lower(Prop)
   case 'int'
      if strcmp(lower(Val),'on')
         IsNum= fix(NewNum)==NewNum;
      end   
   case 'range'
      if isa(Val,'double') & length(Val)==2
         IsNum= NewNum>=Val(1) & NewNum<=Val(2);
      end   
   end
end
if IsNum
   set(gcbo,'UserData',NewNum);
else
   set(gcbo,'string',num2str(Num));
end
if nargout==1
   varargout{1}=IsNum;
end

   

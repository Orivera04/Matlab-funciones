function [out,Color]= SweepNotes(mdev,SNo,NewNotes,NewColor)
%SWEEPNOTES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:04:13 $

if size(mdev.Notes,2)==1
   mdev= i_MakeColors(mdev);
end
if nargin== 1
   if isempty(mdev.Notes)
      mdev.Notes= cell(size(mdev.AllModels,2),2);
      [mdev.Notes{:,2}]= deal([0 0 0]);
      pointer(mdev);
   end
   
   out= mdev.Notes(:,1);
   Color= mdev.Notes(:,2);
elseif nargin < 3
   if ~isempty(mdev.Notes)
      out= mdev.Notes{SNo,1};
      Color= mdev.Notes{SNo,2};
   else
      out='';
      Color= [0 0 0];
   end
else
   mdev.Notes{SNo,1}= NewNotes;
   if nargin>3
      mdev.Notes{SNo,2}= NewColor;
   end
   if ~isempty(NewNotes) & all(mdev.Notes{SNo,2}==0);
      % default colours to orange
      mdev.Notes{SNo,2} = [1 0.5 0];
   elseif isempty(NewNotes) & all(mdev.Notes{SNo,2}==[1 0.5 0])
      mdev.Notes{SNo,2} = [0 0 0];
   end
   pointer(mdev);
   out=mdev;
end


function mdev= i_MakeColors(mdev);

col= zeros(length(mdev.Notes),3);
ci= ~cellfun('isempty',mdev.Notes);
col(ci,:)= repmat([1 0.5 0],sum(ci),1);

mdev.Notes = [mdev.Notes num2cell(col,2)];
pointer(mdev);

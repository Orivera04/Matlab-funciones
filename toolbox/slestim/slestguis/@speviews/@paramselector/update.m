function update(this,varargin)
%UPDATE  Updates parameter selector GUI.

%   Copyright 1986-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:41:28 $

% RE: Behavior mimics two independent listboxes containing the row & column names
H = this.Handles;

% Dot color
for i=1:this.Size(1)
   if this.RowSelection(i)
      DotColor = this.Style.OnColor;
   else
      DotColor = this.Style.OffColor;
   end
   set(H.Dots(i),'Color',DotColor,'MarkerFaceColor',DotColor);
end

% Text color
set([H.AllText;H.RowText;H.ColText],'Color',[0 0 0])  % reset
if all(this.RowSelection==isEstimatedParam(this.Parent))
   set(H.AllText,'Color',[1 0 0])
end

% Hightlight selected rows and columns in red
set(H.RowText(this.RowSelection),'Color',[1 0 0])   

% Row names
set(H.RowText,{'String'},this.RowName)

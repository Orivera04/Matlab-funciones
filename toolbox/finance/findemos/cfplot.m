function hout = cfplot(varargin)
%CFPLOT Visualize the cash flow dates of a series of financial instruments.
%   cfplot(CFlowDates, CFlowAmounts) plots a cash flow diagram where each
%   instrument is a horizontal line decorated with vertical arrows at the 
%   cash flow times.  The size and orientation of each arrow correspond 
%   to the cash flow amount.
% 
%   Inputs:
%     CFlowDates : Matrix of serial date numbers for cash flows.  Each row
%     represents an instrument so that CFlowDates(k,:) is the vector of cash
%     flow dates for the k'th instrument.  Rows are padded with trailing 
%     NaN's if the number of cash flows is not the same for all instruments.
%
%     CFlowAmounts : (optional) Matrix the same size as CFlowDates specifying
%     the amount of each cash flow.  Uniform cash flows of 1 are used if
%     CFlowAmounts is not entered.
% 
%     CFPLOT optionally takes additional string arguments
%       'Dates'   : label x axis with dates
%       'NoLine'  : suppress horizontal lines
%       'NoArrow' : suppress arrowheads
%
%   Outputs:
%     If CFPLOT is called with an output argument, it returns a matrix of
%     handles to line objects.  Each row of handles corresponds to an
%     instrument. 
%
%   See also CFAMOUNTS, CFDATES.

% Demo function 03/21/98 by J. Akao
% Copyright 1995-2002 The MathWorks, Inc.  
% $Revision: 1.7 $ $Date: 2002/04/14 21:42:26 $

%---------------------------------------------------------------------
% Process arguments
%
% CFDates   [Nbonds by MaxNumCFs]
% CFAmounts [Nbonds by MaxNumCFs]
% NumBonds  [scalar]
% MaxNumCFs [scalar]
%
% HLFlag    [scalar] plot horizontal lines
% ARFlag    [scalar] plot arrow heads
% SYFlag    [scalar] plot symbols
% SYType    [char]   symbol
%---------------------------------------------------------------------

CFDates = varargin{1};
[NumBonds, MaxNumCFs] = size(CFDates);

if ( nargin>=2 & ~ischar(varargin{2}) )
  CFAmounts = varargin{2};
  jvarg = 2;
else
  % use unit cash flows
  CFAmounts = ~isnan(CFDates);
  jvarg = 1;
end
  
HLFlag = logical(1);
ARFlag = logical(1);
SYFlag = logical(0);
DXFlag = logical(0);
SYType = 'o';

while ( jvarg < nargin )
  jvarg = jvarg + 1;
  switch varargin{jvarg}
    case 'NoArrow'
      ARFlag = logical(0);
    case 'NoLine'
      HLFlag = logical(0);
    case 'Dates'
      DXFlag = logical(1); 
    case 'Symbol'
      SYFlag = logical(1);
    otherwise 
      SYType = varargin{jvarg};
  end
end

% Flip the matrices up/down to plot 1st on top and last on bottom
CFDates   =   CFDates(end:-1:1, :);
CFAmounts = CFAmounts(end:-1:1, :);
%---------------------------------------------------------------------
% Compute the vertical dimensions for each bond line
% Ylines [NumBonds by 1] base line position
% CFsize [NumBounds by MaxNumCFs] scaled magnitude of each CF
% CFsign [NumBounds by MaxNumCFs] direction of each CF
%
% Yaxis  [1 by 2] limits of axis drawing
% MarkerSize : point size of the marker
%----------------------------------------------------------------------
magmap = inline('log(1+abs(x))'); % map of cf magnitude to ht on screen

CFsize = magmap(CFAmounts);
CFsign = sign(CFAmounts);

% Ydtop  [NumBonds by 1] distance from base to top of pane 
% Ydbot  [NumBonds by 1] distance from base to bottom of pane
% Ypane  [NumBonds by 1] size of plot in pane
% Ydsep  [scalar] space below each pane
Ydtop = max( CFsize.* ( CFsign > 0 ) ,[],2);
Ydbot = max( CFsize.* ( CFsign < 0 ) ,[],2);
Ypane = Ydtop + Ydbot;

% heuristic for separation
Ydsep = (0.5 * Ypane/log(5+NumBonds)); 

% y level for each bond line
Ylines = cumsum(Ypane + Ydsep) - Ydtop; 

% set axis limits
Yaxis = [0, Ylines(end)+Ydtop(end)+Ydsep(end)]; 

% heuristic for MarkerSize
MarkerSize = ceil(interp1([1 5 10 20 30 realmax],...
                          [6 5  4  3 2        2], NumBonds));
%---------------------------------------------------------------------
% Construct the X and Y data matrices
% XCF : [NumBonds by Ndata] x data points
% YCF : [NumBonds by Ndata] y data points
%
% For each entry, 
%     Point | Vert. Line    | down | Point if extending line
% X : D       D               D      D
% Y : Yline   Yline + Yinc    NaN    Yline
%
% XAU, YAU : up arrow locations
% XAD, YAD : up arrow locations
% XSY, YSY : symbol locations
%----------------------------------------------------------------------

% create indices from Ndata to the points
if (HLFlag)
  % connect vertical line segments with horizontal lines
  NDperCF = 4;
else
  NDperCF = 3;
end
Ndata = MaxNumCFs*NDperCF;
CFind = repmat( 1:MaxNumCFs , NDperCF , 1 );
CFind = reshape(CFind,1,Ndata);

% expand X points
XCF = CFDates(:,CFind); % NaN's here mask points beyond NumCfs

% expand Y points and then adjust points inside
YCF = Ylines(:,ones(1,Ndata));
% 2nd point moves up
YCF(:,2:NDperCF:Ndata) = YCF(:,2:NDperCF:Ndata) + CFsize.*CFsign;
% 3rd point is a break
YCF(:,3:NDperCF:Ndata) = NaN; 

if (SYFlag)
  % Symbol locations
  XSY = CFDates;
  YSY = Ylines(:,ones(1,MaxNumCFs));
end

if (ARFlag)
  % Arrow locations
  XAU = CFDates;
  YAU = Ylines(:,ones(1,MaxNumCFs)) + CFsize;
  YAU(CFsign<=0) = NaN;

  XAD = CFDates;
  YAD = Ylines(:,ones(1,MaxNumCFs)) - CFsize;
  YAD(CFsign>=0) = NaN;
end
%---------------------------------------------------------------------
% plot the lines
%---------------------------------------------------------------------
% plot the lines with a graded color order
ha = newplot;
set(ha,'colororder',hsv(min(NumBonds,32)));

% plot lines
hlines = line(XCF',YCF');

if (SYFlag)
  % plot symbols
  hsymbol = line(XSY',YSY','LineStyle','none','Marker',SYType, ...
      'MarkerSize',MarkerSize);
  setmarkerfilled(hsymbol);
else
  hsymbol = [];
end

if (ARFlag)
  % plot symbols
  harrowu = line(XAU'  ,YAU'  ,'LineStyle','none','Marker','^', ...
      'MarkerSize',MarkerSize);
  harrowd = line(XAD',YAD','LineStyle','none','Marker','v', ...
      'MarkerSize',MarkerSize);
  setmarkerfilled(harrowu);
  setmarkerfilled(harrowd);
else
  harrowu = [];
  harrowd = [];
end
  
if nargout==1
  hout = [hlines, hsymbol, harrowu, harrowd];
end

%---------------------------------------------------------------------
% set the y axis limits and ticks 
%---------------------------------------------------------------------
set(gca,'YLim',Yaxis);

% I may only be able to label a subset of the bonds
TickBondInc = ceil(NumBonds/15);
if (TickBondInc==1)
  TickSet = (1:NumBonds)';
else
  TickSet = (TickBondInc:TickBondInc:NumBonds)';
end

% the tick numbers are reversed from the TickSet order
TickSet = TickSet(end:-1:1);
TickSetMap = (NumBonds:-1:1);
set(gca,'YTick',Ylines(TickSetMap(TickSet)) );
set(gca,'YTickLabel', num2str(TickSet));

%---------------------------------------------------------------------
% set the x axis limits and ticks
%---------------------------------------------------------------------
if (DXFlag)
  Xaxis = get(gca,'Xlim');
  % guess with dtaxis JHA 3/21/98
  dtaxis('x',2);
  set(gca,'Xlim',Xaxis);
end

%---------------------------------------------------------------------
% End of function cfplot
%---------------------------------------------------------------------

function setmarkerfilled(Handles)
% SETMARKERFILLED fills markers with the line color
% 'MarkerFaceColor','auto' makes the background show through

% list of the handles
Handles = Handles(:);
NumHandles = length(Handles);

if (NumHandles==1)
  LineColor = get(Handles,'Color');
  set(Handles,'MarkerFaceColor',LineColor);
else
  % loop over handles
  LineColors = get(Handles,'Color'); % cell array of colorspecs

  for i=1:NumHandles,
    set(Handles(i),'MarkerFaceColor',LineColors{i});
  end
end


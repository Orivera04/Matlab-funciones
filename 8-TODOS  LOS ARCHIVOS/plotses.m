function [hlines,haxes] = plotses(x,Y,varargin)
% PLOTS   Plot the columns of a matrix vs a common vector.
%   [HLINES,HAXES] = PLOTSES(VECTOR,MATRIX) Plots each column of the MATRIX
%   vs the VECTOR, each of the columns with their own axes, but the VECTOR
%   has a unique axis. The axes will be distance within each other. HLINE
%   and HAXES are the handles.
%
%   [HLINES,HAXES] = PLOTSES(VECTOR,MATRIX,...,LABELS) puts the LABELS of 
%   the axis, where LABELS is a string matrix with the same number of 
%   columns, the first column is the label of the VECTOR-axe, the 
%   second for the column one of the MATRIX, and so on. Default (without 
%   labels): [' '; ' '; ...;  ' '].
%
%   [HLINES,HAXIS] = PLOTSES(VECTOR,MATRIX,...,LOCATION) puts the axis of
%   the matrix at the specified LOCATION: 'top', 'bottom', 'right', 'left' 
%   (default).
%
%   [HLINES,HAXIS] = PLOTSES(VECTOR,MATRIX,...,DISTANCE) sets the distance
%   between the axes, in a DISTANCE percent the figure size. Default 10%.
%
%   [HLINES,HAXIS] = PLOTSES(VECTOR,MATRIX,...,FEDGE) moves each axis away
%   from the edge of the figure, in units of the DISTANCE, where FEDGE is a
%   vector integer, where zero means that graphic will be stick on the 
%   edge. Default (zig-zag): [0 1 0 1 0 ...]. Note: the first element must 
%   be zero.
%
%   [HLINES,HAXIS] = PLOTSES(VECTOR,MATRIX,...,AEDGE) moves each axes away
%   from the fixed axis, where AEDGE is a vector of ascending points less 
%   than one and begining with zero, and tells the axis of the first column
%   to meet the fixed axis, 1/4 (for example) tells the axis to be put a
%   25% distance away from the fixed axis, and so on. Default (zig-zag):
%   (0:N-1)*3./(1-3*N) where N is the number of columns. Note: the size of
%   the moved axes are define by the last element: (1-AEDGE(end))*100% from
%   the width of the figure.
%
%   Example:
%      x = [-10:0.1:10]';
%      Y = [x, x.^2, x.^3, cos(x)];
%      lab = strjust(strvcat('x-axis','x','x^2','x^3','cos(x)'),'center');
%      fedge = [0 1 2 0];
%      aedge = [0 25 50 80]/100;
%      [hl,he] = plotses(x,Y,'left',lab,fedge,aedge); 
%       stylel = strvcat('--','-.','-',':');
%       colorl = get(gcf,'DefaultAxesColorOrder');
%       for i = 1:size(Y,2)
%        set(hl(i),'LineStyle',stylel(i,:),'Color',colorl(i,:))
%        set(he(i),'YColor',colorl(i,:))
%       end
%
%   See also PLOTS, PLOTYY

%   Written by
%   Lic. on Physics Carlos Adrián Vargas Aguilera
%   Physical Oceanography MS candidate
%   UNIVERSIDAD DE GUADALAJARA 
%   Mexico, february 2006
%
%   nubeobscura@hotmail.com

% Number of lines:
N = size(Y,2); 

% Entries:
[lab,loc,k,FE,EE] = check_entries(varargin,nargin-2,N);
k = k/100;

% Moved white background [left down width height]:
newplot
c_gray = get(gcf,'Color');                      % Back color (gray)    
set(gca,'Visible','off')                        % No axes
upordown = ~isempty(strfind('tb',loc));       % Up or down
dim = 3 + upordown;                             % Width or height
ori = isempty(strfind('tr',loc));             % Horizontal or vertical
pos0 = get(gca,'Position');                     % Default position
MFE = max(FE);                                  % Maximum mov vs. axis
                                                                   
% Limits of fixed axis:
lim_fix = [min(x) max(x)];      

% Dimention of the traslation
mov = 3 + (dim==3);

% Plots lines (first at the ends):
[temp, FEorder] = sort(FE); clear temp
FEorder = FEorder(end:-1:1);
hlines = ones(N,1);
haxes  = ones(N,1);
for n = FEorder              
 
 % Compress and move the fixed axis:
 pox_new = pos0;                                % Default position
 pox_new(dim) = pox_new(dim)*(1-(MFE-FE(n))*k); % Compress N-FE times
                                                % the width or the eight
 pox_new(dim-2) = pox_new(dim-2) +...           % Moves them horizontal
  ori*(pos0(dim)-pox_new(dim));                 % or vertically
 
 % Compress and move the othes axes:
 pox_new(mov) = pox_new(mov)*(1-EE(end));       % Compress width or height
 pox_new(mov-2) = pox_new(mov-2) +...           % Vertical or horizontal
  EE(n)*pos0(mov);                              % traslation
                                               
 % New limits of the axes fitted the the fixed axis:
 lim_new = lim_fix - [ori (ori-1)]*diff(lim_fix)*FE(n)*k/(1-MFE*k);
 
 % Axes with transparent back:
 haxes(n) = axes('Position',pox_new,'Box','off','Color','none');
 
 % Black fixed axis:
 if n == 1     
  c_gray2 = c_gray;
  c_gray = 'k';
 end 
  
 if upordown   % lines vs. y
  set(haxes(n),'YColor',c_gray,'YLim',lim_new,'XAxisLocation',loc);
  hlines(n) = line(Y(:,n),x,'Parent',haxes(n));
  xlabel(lab(n+1,:))
  if n == 1, ylabel(lab(1,:)),
  else set(haxes(n),'YTick',[])
  end
  
 else          % lines vs. x
  set(haxes(n),'XColor',c_gray,'XLim',lim_new,'YAxisLocation',loc);
  hlines(n) = line(x,Y(:,n),'Parent',haxes(n));
  ylabel(lab(n+1,:))
  if n == 1, xlabel(lab(1,:))
  else set(haxes(n),'XTick',[])
  end
 end
 
 % Back to gray color:
 if n == 1     
  c_gray = c_gray2;
 end 
 
 % Handles:
 haxes(n) = gca;
   
end

% - - - - - - - - - - - - - - - - - - - - - - - - - - - FIN

function [lab,loc,k,FE,EE] = check_entries(argopc,Nargopc,N)
% Check entries
%
% Carlos Adrián Vargas Aguilera. nubeobscura@hotmail.com


lab = repmat(' ',N+1,1);
loc = 'l';    
k = 10;       
a = 4;     % Partitions for each axes 
b = 3;     % Movements
Ns = 0:N-1;
FE = rem(Ns,2);          
EE = Ns*b./(a+(N-1)*b); 
                        

for n = 1:Nargopc
  arg = argopc{n};
  if ~isa(arg,'char')
    if length(arg) == 1
      k = arg;
    elseif arg(arg~=0) < 1
      EE = arg;
    else
      FE = arg;
   end
  elseif size(arg(:,1)) == 1 
    loc = arg;    
  else 
    lab = arg;
  end
end

loc = lower(loc);


% Carlos Adrián Vargas Aguilera. nubeobscura@hotmail.com
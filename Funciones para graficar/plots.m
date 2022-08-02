function [hlines,haxes] = plots(x,Y,varargin)
% PLOTS   Plot the columns of a matrix vs a common vector.
%   [HLINES,HAXES] = PLOTS(VECTOR,MATRIX) Plots each column of the MATRIX
%   vs the VECTOR, each of the columns with their own axis, but the VECTOR
%   has a unique axis. HLINES and HAXIS are the handles.
%
%   [HLINES,HAXES] = PLOTS(VECTOR,MATRIX,...,LABELS) puts the LABELS of the
%   axes, where LABELS is a string matrix with the same number of columns,
%   with the first column for the label of the VECTOR-axis, the second for 
%   the column one of the MATRIX, and so on. Default (without labels): 
%   [' '; ' '; ...;  ' '].
%
%   [HLINES,HAXES] = PLOTS(VECTOR,MATRIX,...,LOCATION) puts the axes of the
%   matrix at the specified LOCATION: 'top', 'bottom', 'right', 'left' 
%   (default).
%
%   [HLINES,HAXES] = PLOTS(VECTOR,MATRIX,...,DISTANCE) sets the distance
%   between the axes, in a DISTANCE percent the figure size. Default 10%.
%
%   Example:
%      x = [-10:0.1:10]';
%      Y = [x, x.^2, x.^3, cos(x)];
%      lab = strjust(strvcat('x-axis','x','x^2','x^3','cos(x)'),'center');
%      [hl,he] = plots(x,Y,'top',lab); 
%       stylel = strvcat('--','-.','-',':');
%       colorl = get(gcf,'DefaultAxesColorOrder');
%       for i = 1:size(Y,2)
%        set(hl(i),'LineStyle',stylel(i,:),'Color',colorl(i,:))
%        set(he(i),'XColor',colorl(i,:))
%       end
%
%   See also PLOTSES, PLOTYY 

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
[lab,loc,k] = check_entries(varargin,nargin-2,N);
k = k/100;
 
% Moved white background [left down width height]:
newplot
c_gray = get(gcf,'Color');                    % Back. color (gray)    
set(gca,'Box','off','XTick',[],'YTick',[],... % No axes, only back.
 'Xcolor',c_gray,'Ycolor',c_gray) 
upordown = ~isempty(strfind('tb',loc));     % Top or bottom
dim = 3 + upordown;                           % Width or height
ori = isempty(strfind('tr',loc));           % Horizontal or vertical
pos0 = get(gca,'Position');                   % Default position 
pos_fix = pos0;                               % New coordinates
pos_fix(dim) = pos_fix(dim)*(1-(N-1)*k);      % Compress width or height
pos_fix(dim-2) = pos_fix(dim-2) + ...         % Horizontal or vertical
 ori*(pos0(dim)-pos_fix(dim));                % movement
set(gca,'Position',pos_fix);                  % New position 
                                                                   
% Limits of fixed axis:
lim_fix = [min(x) max(x)];                                                                    
      
% Plots lines (first at the ends):
hlines = ones(N,1);
haxes  = ones(N,1);
for n = N:-1:1              
 
 % New axis position:
 pos_new = pos0;                             % Default position
 pos_new(dim) = pos_new(dim)*(1-(N-n)*k);    % Compress N-n times the
                                             % width or the heigth
 pos_new(dim-2) = pos_new(dim-2) +...        % Moves them horizontal or
  ori*(pos0(dim)-pos_new(dim));              % vertically, N-n times
                                              
 % New limits fixed to the common axis:
 lim_new = lim_fix - [ori (ori-1)]*diff(lim_fix)*(n-1)*k/(1-(N-1)*k);
 
 % Transparent back:
 haxes(n) = axes('Position',pos_new,'Box','off','Color','none');
 
 % Black common axis:
 if n == 1               
  c_gray = 'k';
 end 
  
 if upordown  % lines vs. y?
  set(haxes(n),'YColor',c_gray,'YLim',lim_new,'XAxisLocation',loc);
  hlines(n) = line(Y(:,n),x,'Parent',haxes(n));
  xlabel(lab(n+1,:))
  if n == 1, ylabel(lab(1,:)),
  else set(haxes(n),'YTick',[]) 
  end
  
 else         % lines vs. x?
  set(haxes(n),'XColor',c_gray,'XLim',lim_new,'YAxisLocation',loc);
  hlines(n) = line(x,Y(:,n),'Parent',haxes(n));
  ylabel(lab(n+1,:))
  if n == 1, xlabel(lab(1,:))
  else set(haxes(n),'XTick',[]) 
  end
 end
 
 % Handles:
 haxes(n) = gca;
   
end


function [lab,loc,k] = check_entries(argopc,Nargopc,N)
% Check entries.

lab = repmat(' ',N+1,1);
loc = 'l';    
k = 10;              

for n = 1:Nargopc
  opc = argopc{n};
  if ~isa(opc,'char')
    k = opc;
  elseif size(opc(:,1)) == 1 
    loc = opc(1);    
  else 
    lab = opc;
  end
end

loc = lower(loc);


% Carlos Adrián Vargas Aguilera. nubeobscura@hotmail.com
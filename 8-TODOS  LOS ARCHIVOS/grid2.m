function grid2(varargin)
%GRID2 Grid Lines for 2D and 3D plots.
% GRID2 includes all features of the GRID command and more.
% Features from GRID:
% GRID2 ON adds major grid lines to the current axes.
% GRID2 OFF removes major and minor grid lines from the current axes. 
% GRID2 MINOR toggles the minor grid lines of the current axes.
% GRID2, by itself, toggles the major grid lines of the current axes.
% GRID2(Hax,...) uses axes Hax instead of the current axes.
%
% Added features:
%
% GRID2 Command Axes Command Axes ...
%
% For example:
% GRID2 ON X Z OFF Y adds major grid lines to the X and Y axes, and
% removes major grid lines from the Y axis.
%
% GRID2 OFF X ON YM removes major grid lines from the X axis and adds
% minor grid lines to the Y axis.
%
% GRID2 ON X Y Z adds major grid lines to all axes.
%
% GRID2 ON XD adds grid lines at decade intervals to the X axis when the X
% axis is log scaled. GRID2 OFF XD removes these grid lines.
%
% GRID2 ON Y125 adds grid lines at 1, 2, 5 intervals to the Y axis when
% the Y axis is log scaled. GRID2 OFF Y125 removes these grid lines.
%
% GRID2 ON X125 YD Z adds grid lines at 1,2,5 intervals on the X axis, grid
% lines at decade intervals on the Y axis, and standard grid lines to the
% Z axis.
%
% See also GRID

% D.C. Hanselman, University of Maine, Orono, ME 04469
% Mastering MATLAB 7
% 2005-03-08

%--------------------------------------------------------------------------
Hcf=get(0,'CurrentFigure');
Hca=get(Hcf,'CurrentAxes');

ni=nargin;

if ni==0 && ~isempty(Hca) % toggle request
   if (strcmp(get(Hca,'XGrid'),'off'))
      set(Hca,'XGrid','on');
   else
      set(Hca,'XGrid','off');
   end
   if (strcmp(get(Hca,'YGrid'),'off'))
      set(Hca,'YGrid','on');
   else
      set(Hca,'YGrid','off');
   end
   if (strcmp(get(Hca,'ZGrid'),'off'))
      set(Hca,'ZGrid','on');
   else
      set(Hca,'ZGrid','off');
   end
   return
elseif ishandle(varargin{1})
   if strcmp(get(varargin{1},'Type'),'axes') % Axes handle given
      Hca=varargin{1}; % strip off handle provided
      ni=ni-1;
      varargin(1)=[];
   else
      error('Input Not an Axes Handle.')
   end
elseif ~ischar(varargin{1})
   error('Unknown Command Option.')
end
if isempty(Hca) % sdo nothing if there is no axes
   return
end
xyzh={findall(Hca,'Tag','xdgrid2') findall(Hca,'Tag','ydgrid2')...
      findall(Hca,'Tag','zdgrid2')};
if ni==1  % default grid command
   cmd=varargin{1};
   if strcmpi(cmd,'on')
      set(Hca,'XGrid','on',...
              'YGrid','on',...
              'ZGrid','on')
   elseif strcmpi(cmd,'off')
      set(Hca,'XGrid','off',...
              'YGrid','off',...
              'ZGrid','off',...
              'XMinorGrid','off',...
              'YMinorGrid','off',...
              'ZMinorGrid','off')
      delete(xyzh{1})
      delete(xyzh{2})
      delete(xyzh{3})
   elseif strcmpi(cmd,'minor')
      set(Hca,'XMinorGrid','on',...
              'YMinorGrid','on',...
              'ZMinorGrid','on')
   else
      error('Unknown Command Option.')
   end
   return
end
%--------------------------------------------------------------------------
% now handle new functionality

xyzl=get(Hca,{'XLim' 'YLim' 'ZLim'});
xyzs=get(Hca,{'XScale' 'YScale' 'ZScale'});
xyzc=get(Hca,{'XColor' 'YColor' 'ZColor'});
xyzg=get(Hca,'GridLineStyle');
x=1;
y=2;
z=3;
cmd='on'; % default command

for k=1:ni % process input arguments
   next=lower(varargin{k});
   switch next
   case 'on'
      cmd='on';
   case 'off'
      cmd='off';
   case 'x'
      set(Hca,'XGrid',cmd)
   case 'y'
      set(Hca,'YGrid',cmd)
   case 'z'
      set(Hca,'ZGrid',cmd)
   case 'xm'
      set(Hca,'XMinorGrid',cmd)
   case 'ym'
      set(Hca,'YMinorGrid',cmd)
   case 'zm'
      set(Hca,'ZMinorGrid',cmd)
   case {'xd' 'x125'}
      if strcmp(xyzs{x},'log')
         if strcmp(cmd,'on')
            tmp=log10(xyzl{x});
            ll=10.^(ceil(tmp(1)):floor(tmp(2)));
            if strcmp(next,'x125')
               ll=[ll;2*ll;5*ll];
               ll=ll(:)';
            end
            ll=ll(ll>xyzl{x}(1) & ll<xyzl{x}(2));
            num=length(ll);
            xg=[repmat(ll,3,1);repmat(nan,1,num)];
            xg=xg(:)';
            yg=repmat([xyzl{y} xyzl{y}(2) nan],1,num);
            zg=repmat([xyzl{z}(1) xyzl{z} nan],1,num);
            if isempty(xyzh{x})
               line('Parent',Hca,'XData',xg,'YData',yg,'ZData',zg,...
                  'LineStyle',xyzg,'Color',xyzc{x},...
                  'HitTest','off','HandleVisibility','off','Tag','xdgrid2');
            else
               set(xyzh{x},'XData',xg,'YData',yg,'ZData',zg)
            end
         else
            delete(xyzh{x})
         end
      else
         warning('Log X-axis Required for XD and X125 Commands.')
      end         
   case {'yd' 'y125'}
      if strcmp(xyzs{y},'log')
         if strcmp(cmd,'on')
            tmp=log10(xyzl{y});
            ll=10.^(ceil(tmp(1)):floor(tmp(2)));
            if strcmp(next,'y125')
               ll=[ll;2*ll;5*ll];
               ll=ll(:)';
            end
            ll=ll(ll>xyzl{y}(1) & ll<xyzl{y}(2));
            num=length(ll);
            yg=[repmat(ll,3,1);repmat(nan,1,num)];
            yg=yg(:)';
            xg=repmat([xyzl{x} xyzl{x}(2) nan],1,num);
            zg=repmat([xyzl{z}(1) xyzl{z} nan],1,num);
            if isempty(xyzh{y})
               line('Parent',Hca,'XData',xg,'YData',yg,'ZData',zg,...
                  'LineStyle',xyzg,'Color',xyzc{y},...
                  'HitTest','off','HandleVisibility','off','Tag','ydgrid2');
            else
               set(xyzh{y},'XData',xg,'YData',yg,'ZData',zg)
            end
         else
            delete(xyzh{y})
         end
      else
         warning('Log Y-axis Required for YD and Y125 Commands.')
      end         
   case {'zd' 'z125'}
      if strcmp(xyzs{z},'log')
         if strcmp(cmd,'on')
            tmp=log10(xyzl{z});
            ll=10.^(ceil(tmp(1)):floor(tmp(2)));
            if strcmp(next,'z125')
               ll=[ll;2*ll;5*ll];
               ll=ll(:)';
            end
            ll=ll(ll>xyzl{z}(1) & ll<xyzl{z}(2));
            num=length(ll);
            zg=[repmat(ll,3,1);repmat(nan,1,num)];
            zg=zg(:)';
            xg=repmat([xyzl{x} xyzl{x}(2) nan],1,num);
            yg=repmat([xyzl{y}(2) xyzl{y}(2) xyzl{y}(1) nan],1,num);
            if isempty(xyzh{z})
               line('Parent',Hca,'XData',xg,'YData',yg,'ZData',zg,...
                  'LineStyle',xyzg,'Color',xyzc{z},...
                  'HitTest','off','HandleVisibility','off','Tag','zdgrid2');
            else
               set(xyzh{z},'XData',xg,'YData',yg,'ZData',zg)
            end
         else
            delete(xyzh{z})
         end
      else
         warning('Log Z-axis Required for ZD and Z125 Commands.')
      end         
   otherwise
      error('Unknown Command Option.')
   end
end
function mmgui(varargin)
%MMGUI Double-Click Activation of Plotting GUIs. (MM)
% MMGUI or MMGUI on  enables double-click activation of the functions
% MMSAXES, MMSLINE, MMSMAP, MMSSURF, and MMSTEXT in the current figure.
% Double-clicking on a axes activates MMSAXES.
% Double-clicking on a line activates MMSLINE.
% Double-clicking on the figure background activates MMSMAP.
% Double-clicking on a surface or patch activates MMSSURF.
% Double-clicking on a text object activates MMSTEXT.
%
% MMGUI off        disables all double-click activation in the current figure.
% MMGUI default    enables double-clicking on all new plots.
% MMGUI defaultoff disables double-clicking on all new plots.
% MMGUI all        enables double-clicking on ALL objects in all figures.
% MMGUI alloff     disables all double-click activation on All objects.
% MMGUI axes       enables double-click activation of MMSAXES
%                   in the current figure.
% MMGUI line       enables double-click activation of MMSLINE
%                   in the current figure.
% MMGUI map        enables double-click activation of MMSMAP
%                   in the current figure.
% MMGUI surf       enables double-click activation of MMSSURF
%                   in the current figure.
% MMGUI text       enables double-click activation of MMSTEXT
%                   in the current figure.
% MMGUI(H)         enables double-clicking of all functions 
%                  on the figure having handle H.
%
% Multiple inputs are accepted, e.g.,
% MMGUI off axes map  enables just MMSAXES and MMSMAP in the current figure.
%
% Warning: MMGUI overwrites the ButtonDownFcn of graphics objects.

% Calls: mmgcf

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 12/2/96, v5: 1/14/97, 6/2/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

bdf='ButtonDownFcn';
fbdf='mmgui MMSMAP';
abdf='mmgui MMSAXES';
lbdf='mmgui MMSLINE';
sbdf='mmgui MMSSURF';
tbdf='mmgui MMSTEXT';
zip='';
flag=1;

if nargin==0
   mmgui on
   return
end
for i=1:nargin
   arg=varargin{i};
   if ~ischar(arg) % handle input
      tp=get(arg,'type');
      if strcmp(tp,'figure')
         set(arg,bdf,fbdf)
         Ha=mmgca(Hf,flag);
         set(Ha,bdf,abdf)
         Hl=findobj(Ha,'Type','line');
         set(Hl,bdf,lbdf)
         Hs=[findobj(Ha,'Type','surface'); findobj(Ha,'Type','patch')];
         set(Hs,bdf,sbdf)
         Ht=findall(Ha,'Type','text');
         set(Ht,bdf,tbdf)
      else
         error('Handle Must Point to a Figure.')
      end
      
   else % ischar(arg)
      switch arg
      case 'on'
         Hf=mmgcf(flag);
         
         set(Hf,bdf,fbdf)
         Ha=findobj(Hf,'Type','axes');
         set(Ha,bdf,abdf)
         set(findobj(Ha,'Type','line'),bdf,lbdf)
         Hs=[findobj(Ha,'Type','surface'); findobj(Ha,'Type','patch')];
         set(Hs,bdf,sbdf)
         Ht=findall(Ha,'Type','text');
         set(Ht,bdf,tbdf)
         
      case 'off'
         Hf=mmgcf(flag);
         set(Hf,bdf,zip)
         Ha=findobj(Hf,'Type','axes');
         set(Ha,bdf,zip)
         set(findobj(Ha,'Type','line'),bdf,zip)
         Hs=[findobj(Ha,'Type','surface'); findobj(Ha,'Type','patch')];
         set(Hs,bdf,zip)
         Ht=findall(Ha,'Type','text');
         set(Ht,bdf,zip)
         
      case 'default'
         set(0,'DefaultFigureButtonDownFcn',fbdf,...
            'DefaultAxesButtonDownFcn',abdf,...
            'DefaultLineButtonDownFcn',lbdf,...
            'DefaultSurfaceButtonDownFcn',sbdf,...
            'DefaultPatchButtonDownFcn',sbdf,...
            'DefaultTextButtonDownFcn',tcbf)
         
      case 'defaultoff'
         set(0,'DefaultFigureButtonDownFcn',zip,...
            'DefaultAxesButtonDownFcn',zip,...
            'DefaultLineButtonDownFcn',zip,...
            'DefaultSurfaceButtonDownFcn',zip,...
            'DefaultPatchButtonDownFcn',zip,...
            'DefaultTextButtonDownFcn',zip)
         
      case 'all'
         set(findobj('Type','figure'),bdf,fbdf)
         set(findobj('Type','axes'),bdf,abdf)
         set(findobj('Type','line'),bdf,lbdf)
         set(findobj('Type','surface'),bdf,sbdf)
         set(findobj('Type','patch'),bdf,sbdf)
         set(findall('Type','text'),bdf,tbdf)
         
      case 'alloff'
         set(findobj('Type','figure'),bdf,zip)
         set(findobj('Type','axes'),bdf,zip)
         set(findobj('Type','line'),bdf,zip)
         set(findobj('Type','surface'),bdf,zip)
         set(findobj('Type','patch'),bdf,zip)
         set(findall('Type','text'),bdf,zip)
         
      case 'axes'
         Hf=mmgcf(flag);
         Ha=findobj(Hf,'Type','axes');
         if isempty(Ha)
            error('No Axes Exists in the Current Figure.')
         end
         set(Ha,bdf,abdf)
         
      case 'line'
         Hf=mmgcf(flag);
         Ha=findobj(Hf,'Type','axes');
         if isempty(Ha)
            error('No Axes Exists in the Current Figure.')
         end
         Hl=findobj(Ha,'Type','line');
         set(Hl,bdf,lbdf)
         
      case 'map'
         Hf=mmgcf(flag);
         set(Hf,bdf,fbdf)
         
      case 'surf'
         Hf=mmgcf(flag);
         Ha=findobj(Hf,'Type','axes');
         if isempty(Ha)
            error('No Axes Exists in the Current Figure.')
         end
         Hs=[findobj(Ha,'Type','surface'); findobj(Ha,'Type','patch')];
         set(Hs,bdf,sbdf)
         
      case 'text'
         Hf=mmgcf(flag);
         Ha=findobj(Hf,'Type','axes');
         if isempty(Ha)
            error('No Axes Exists in the Current Figure.')
         end
         Ht=findall(Ha,'Type','text');
         set(Ht,bdf,tbdf)
         
      case 'MMSAXES'
         if strcmp(get(gcf,'SelectionType'),'open')
            h=findobj('Type','figure','Tag','MMSAXES');
            if isempty(h), mmsaxes
            else,          figure(h(1))
            end 
         end
      case 'MMSLINE'
         if strcmp(get(gcf,'SelectionType'),'open')
            h=findobj('Type','figure','Tag','MMSLINE');
            if isempty(h), mmsline
            else,          figure(h(1))
            end
         end 
      case 'MMSMAP'
         if strcmp(get(gcf,'SelectionType'),'open')
            h=findobj('Type','figure','Tag','MMSMAP');
            if isempty(h), mmsmap
            else,          figure(h(1))
            end
         end 
      case 'MMSSURF'
         if strcmp(get(gcf,'SelectionType'),'open')
            h=findobj('Type','figure','Tag','MMSSURF');
            if isempty(h), mmssurf
            else,          figure(h(1))
            end
         end
      case 'MMSTEXT'
         if strcmp(get(gcf,'SelectionType'),'open')
            h=findobj('Type','figure','Tag','MMSTEXT');
            if isempty(h), mmstext
            else,          figure(h(1))
            end
         end
         
      otherwise
         error(sprintf('Unknown Input Argument: ''%s''',arg))
      end
   end
end

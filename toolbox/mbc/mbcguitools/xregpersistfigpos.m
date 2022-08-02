function xregpersistfigpos(h,varargin)
%XREGPERSISTFIGPOS  Enable persistence of figure position across sessions
%
%  xregpersistfigpos(figH) enable figure position saving across MATLAB sessions.
%  This is achieved by saving the position on deletion into a database of positions
%  and persistence keys which is held in the preferences.  The next time this function
%  is called on the same persistence key, it will search for a saved position and use it
%  to initialise the figure.
%
%  Usage:
%  xregpersistfigpos(figH) sets up persistence, using the current position as the 
%  default, and the current tag as the persistence key.
%
%  xregpersistfigpos(figH,'key','KEYSTRING','DEFAULTPOS',POSITION) will use the given
%  key and default position instead.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:34:33 $

key='';
defpos=[];

if nargin>1
   for n=1:2:length(varargin)
      switch varargin{n}
      case 'key'
         key=varargin{n+1};
      case 'defaultpos'
         defpos=varargin{n+1};
      end
   end
end

if isempty(key)
   key=get(h,'tag');
end
if isempty(defpos)
   defpos=get(h,'position');
end

prfs=mbcprefs('mbc');
dbase=getpref(prfs,'WindowPositionPersistence');

if isempty(key)
   error('You must supply a non-empty key for the figure position database');
end

persistedpos=strmatch(key,dbase(:,1),'exact');
if isempty(persistedpos)
   dbase=[dbase; {key,defpos}];   
   setpref(prfs,'WindowPositionPersistence',dbase);
   set(h,'position',defpos);
else
   set(h,'position',dbase{persistedpos,2});
end

% attach a listener for the window closure
h=handle(h);
p=schema.prop(h, 'PersistenceListener', 'handle');  % callback listener for peristence function
h.PersistenceListener=handle.listener(h,'ObjectBeingDestroyed',{@i_saveposition,key});
return



function i_saveposition(h,evt,key)
persistpos=get(h,'position');

prfs=mbcprefs('mbc');
dbase=getpref(prfs,'WindowPositionPersistence');

keyindx=strmatch(key,dbase(:,1),'exact');
if isempty(keyindx)
   dbase=[dbase; {key,persistpos}];   
else
   dbase{keyindx,2}=persistpos;
end
setpref(prfs,'WindowPositionPersistence',dbase);
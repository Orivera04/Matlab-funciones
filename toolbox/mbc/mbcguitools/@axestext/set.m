function varargout = set(varargin)
%AXESTEXT Set axextext object properties
%   Classic set function for the axestext object
%   properties are:
%
%      Position      :     4-element position vector
%      Userdata
%      
%   All other properties are passed through to the wrapped
%   object.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.4 $  $Date: 2004/02/09 07:17:54 $



% Bail if we've not been given a axestext object
objfind=1;
while objfind
   if isa( varargin{objfind}, 'axestext' )
      at(objfind)=varargin(objfind);
      objfind=objfind+1;
   else
      varargin=varargin(objfind:end);
      objfind=0;
   end   
end


if ~iscell(at)
   at={at};
end

for k=1:length(at)
   wrkat=at{k};
   
   % loop over varargin
   for n=1:2:(nargin-2)
      switch lower(varargin{n})
      case 'position'
         ud=get(wrkat.wrappedobject,'userdata');
         % compare with old to see what has changed.
         if ud.position(3)==varargin{n+1}(3)
            doClip=0;
         else
            doClip=1;
         end
         ud.position=varargin{n+1};
         set(wrkat.wrappedobject,'userdata',ud);
         i_reposition(wrkat);
         if ud.clipping & doClip
            ud=get(wrkat.wrappedobject,'userdata');
            ud.stringext=[];
            set(wrkat.wrappedobject,'userdata',ud);
            i_clip(wrkat);
         end
      case 'userdata'
         ud=get(wrkat.wrappedobject,'userdata');
         ud.userdata=varargin{n+1};
         set(wrkat.wrappedobject,'userdata',ud);
      case 'verticalalignment'
         vr=get(wrkat,'verticalalignment');
         if ~strcmpi(vr,varargin{n+1})
            set(wrkat.wrappedobject,'verticalalignment',varargin{n+1});
            i_reposition(wrkat);
         end
      case 'horizontalalignment'
         hr=get(wrkat,'horizontalalignment');
         if ~strcmpi(hr,varargin{n+1})
            set(wrkat.wrappedobject,'horizontalalignment',varargin{n+1});
            i_reposition(wrkat);
         end
      case 'clipping'
         i_setclip(wrkat,varargin{n+1});
      case 'string'
         i_setstring(wrkat,varargin{n+1});
      case 'shortstring'
         ud=get(wrkat.wrappedobject,'userdata');
         ud.altstring=varargin{n+1};
         ud.altstringext=[];
         set(wrkat.wrappedobject,'userdata',ud);
         if ud.clipping
            i_clip(wrkat);
         end
      case 'parent'
         % reparent to another figureaxes
         if ishandle(varargin{n+1})
            ax=getaxes(xregGui.figureaxes,varargin{n+1});
            set(wrkat.wrappedobject,'parent',ax);
         end
      otherwise
         set(wrkat.wrappedobject,varargin{n},varargin{n+1});
      end
   end
   at{k}=wrkat;
end
% resurrect outputs
nargout=length(at);
varargout=at;
return



function i_reposition(at)

ud=get(at.wrappedobject,'userdata');
pos=ud.position;
hr=get(at,'horizontalalignment');
vr=get(at,'verticalalignment');

newpos=[0 0 0];
switch lower(hr)
case 'left'
   newpos(1)= pos(1);
case 'right'
   newpos(1)= pos(1)+pos(3);
case 'center'
   newpos(1)= pos(1)+(pos(3)-1).*0.5;
end
switch lower(vr)
case {'bottom','baseline'}
   newpos(2)= pos(2);
case 'middle'
   newpos(2)= pos(2)+(pos(4)-1).*0.5;
case {'top','caps'}
   newpos(2)= pos(2)+pos(4)-1;
end
set(at.wrappedobject,'position',newpos);
return



function i_setclip(at,clip)
ud=get(at.wrappedobject,'userdata');

val=strmatch(lower(clip),['off';'on '])-1;
if ~isempty(val) & val~=ud.clipping
   ud.clipping=val;
   if val
      % clipping on
      ud.string=get(at.wrappedobject,'string');
      ud.stringext=get(at.wrappedobject,'extent');
      set(at.wrappedobject,'userdata',ud);
      i_clip(at);
   else
      % clipping off
      set(at.wrappedobject,'string',ud.string);
      ud.string='';
      ud.stringext=[];
      set(at.wrappedobject,'userdata',ud);
   end
end
return



function i_setstring(at,str)
ud=get(at.wrappedobject,'userdata');

if ud.clipping
   ud.string=str;
   % set the extent.
   ud.stringext=[];
   set(at.wrappedobject,'userdata',ud);
   i_clip(at);
else
   set(at.wrappedobject,'string',str);
end
return



function i_clip(at)
ud=get(at.wrappedobject,'userdata');

% clip horizontally
if isempty(ud.stringext)
   set(at.wrappedobject,'string',ud.string);
   ud.stringext=get(at.wrappedobject,'extent');
end

% form first guess
if ud.stringext(3)>ud.position(3)
   if ~isempty(ud.altstring)
      set(at.wrappedobject,'string',ud.altstring);
      if isempty(ud.altstringext)
         ud.altstringext=get(at.wrappedobject,'extent');
      end
      strext=ud.altstringext(3);
      workstr=ud.altstring;
   else
      strext=ud.stringext(3);
      workstr=ud.string;
   end
   if strext>ud.position(3)
      if strcmp(get(at.wrappedobject,'interpreter'),'tex')
         % remove all tex characters 
         keepind=true(1,length(workstr));
         keepind(findstr(workstr,'_'))=0;
         keepind(findstr(workstr,'^'))=0;
         keepind(findstr(workstr,'{'))=0;
         keepind(findstr(workstr,'}'))=0; 
         keepind(findstr(workstr,'\'))=0;
         ind=findstr(workstr,'\bf');
         if ~isempty(ind)
            ind=[ind ind+1 ind+2];
            keepind(ind)=0;
         end
         ind=findstr(workstr,'\rm');
         if ~isempty(ind)
            ind=[ind ind+1 ind+2];
            keepind(ind)=0;
         end
         ind=findstr(workstr,'\it');
         if ~isempty(ind)
            ind=[ind ind+1 ind+2];
            keepind(ind)=0;
         end
         ind=findstr(workstr,'\sl');
         if ~isempty(ind)
            ind=[ind ind+1 ind+2];
            keepind(ind)=0;
         end
         ind=findstr(workstr,'\fontsize');
         if ~isempty(ind)
            ind=[ind ind+1 ind+2 ind+3 ind+4 ind+5 ind+6 ind+7 ind+8 ind+9];
            keepind(ind)=0;
         end
         
         nchar=floor(length(workstr(keepind)).*ud.position(3)./strext);
         
         % check the break location for potential tex breakers:
         if nchar
            ind=find(keepind);
            nchar=ind(nchar);
            if any(strcmp(workstr(nchar),{'_','^','\'}))
               nchar=nchar-1;
               %str=str(1:(end-1));
            elseif nchar>1 & strcmp(workstr(nchar-1),'\')
               % there are very few tex modifiers of \(SINGLE LETTER)
               nchar=nchar-2;
               %str=str(1:(end-2));
            else
               % check for \phi
               len= length(workstr);
               ind= findstr(workstr(max(1,nchar-2):min(nchar+3,len)),'\phi');
               if ~isempty(ind)
                  nchar=nchar-4+ind;
               else
                  % check for \fontsize{
                  ind= findstr(workstr(max(1,nchar-10):min(nchar+9,len)),'\fontsize{');
                  if ~isempty(ind)
                     closeb=findstr(workstr(ind:nchar),'}');
                     if isempty(closeb)
                        nchar=nchar-12+ind;
                     end           
                  end
               end
               
            end
            str=ud.string(1:nchar);
            nopenb=length(findstr(str,'{'));
            ncloseb=length(findstr(str,'}'));
            if nopenb>ncloseb
               str=[str,repmat('}',1,nopenb-ncloseb)];
            end
         else
            str=workstr;
         end
      else
         nchar=floor(length(workstr).*ud.position(3)./strext);
         str=workstr(1:nchar);
      end
      set(at.wrappedobject,'string',str);
   end
end
set(at.wrappedobject,'userdata',ud);
return


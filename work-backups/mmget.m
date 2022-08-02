function varargout=mmget(H,varargin)
%MMGET Get Multiple Object Properties. (MM)
% [A,B,C,...]=MMGET(H,'PName') where H is a VECTOR of handles gets the
% Property Value associated with the Property Name 'PName' for each of
% the handles in H and returns them in individual output variables.
%
% [A,B,C,...]=MMGET(H,'PName1','PName2',...) and
% [A,B,C,...]=MMGET(H,{'PName1','PName2',...}) where H is a SINGLE handle,
% gets the Property Values associated with Property Names 'PName1','PName2',
% etc. and returns them in individual output variables.
%
% S=MMGET(H,'PName1','PName2',...) and S=MMGET(H,{'PName1','PName2',...})
% where H is a single handle, gets the Property Values associated with 
% Property Names 'PName1','PName2', etc. and returns them in the
% structure S whose fieldnames are 'PName1', 'PName2', etc.
%
% Examples:
% [A,B,C,D,E]=MMGET(H,'UserData') returns the user data from five objects.
% [Xl,Yl,T]=MMGET(gca,'xlabel','ylabel','title') returns the axis labels
% and title for the current axis in the associated variables Xl,Yl and T.
% S=MMGET(gca,'xlabel','ylabel','title') returns the structure S
% having the fieldnames S.xlabel, S.ylabel, and S.title.

% D.C. Hanselman, University of Maine, Orono, ME  04469-5708
% 8/26/96, revised 9/8/96, v5: 1/14/97, 2/23/97, 3/13/97, 5/8/97, 1/5/00
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

Hlen=length(H);
if nargin==1
   error('Object Property Name String(s) Required.')
end
s=[];
if nargout<=1 & (nargin>2|(nargin==2&iscell(varargin{1}))) % struct output
   if Hlen>1
      error('Only a Single Handle is Allowed for Structure Output.')
   end
   if nargin>2
      Pnames=varargin;
   else
      Pnames=varargin{1};
   end
   for i=1:nargin-1
      s=setfield(s,Pnames{i},get(H,Pnames{i}));
   end
   varargout{1}=s;
else	% individual variable output requested
   
   if Hlen>1         % multiple objects, one property
      prop=varargin{1};
      if ~ischar(prop), error('Object Property Name String Required.'), end
      varargout=get(H,prop);
      
   elseif nargin==2 & iscell(varargin{1})  % single object, cell array input
      varargout=get(H,varargin{1})
      
   elseif nargin==2 % simple scalar get
      varargout{1}=get(H,varargin{1});
      
   else              % single object, mulitple properties
      varargout=get(H,varargin);
   end
end

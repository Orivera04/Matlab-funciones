function h = plt(varargin)

%PLT Same as plot but without the box.

% Ref: Edward Tufte, "The Display of Quantatative Information".

% Andrew Knight, May 1994
% Updated Nov 1997: use cell array varargin

if nargin==0
  error('Not enough input arguments')
else
  Hndl = plot(varargin{:});
  set(gca,'box','off')
end

if nargout==1
  h = Hndl;
end



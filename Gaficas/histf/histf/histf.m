function[varargout] = histf(x,varargin)
% HISTF    'Flexible' univariate histogram
% INPUTS  : x    - data vector
%           opt  - (optional) display options structure, with  fields 
%           pmin - lower cut-off percentile (1 by default)
%           pmax - upper cut-off percentile (99 by default)
%           ymax - upper limit of y-axis ('tight' by default)
%           xmin - lower limit of x-axis (none by default)
%           xmax - upper limit of x-axis (none shown by default)
%           dx   - bin size ((q(pmax)-q(pmin))/10 by default)
%           xmrk - position of vertical marker line (none by default)
% OUTPUTS : h    - (optional) vector of barseries handles
% EXAMPLE : See HISTFDEMO
% AUTHOR  : Dimitri Shvorob, dimitri.shvorob@vanderbilt.edu, 4/10/07
if nargin < 1
   error('Input argument "x" is undefined')
end
x = squeeze(x);
if ~isvector(x)
   error('Input argument "x" must be a vector')
end 
if nargin > 1
   opt = varargin{1};
   if ~isstruct(opt)
      error('Input "opt" must be a structure')
   end
   if ~isset('xmin'), opt.xmin = -Inf; end
   if ~isset('xmax'), opt.xmax = Inf;  end
   if ~isset('pmin'), opt.pmin = 1;    end
   if ~isset('pmax'), opt.pmax = 99;   end
   if opt.pmin < 0 || opt.pmin > 100
      error('Lower cut-off percentile out of [0,100] range')
   end 
   if opt.pmax < 0 || opt.pmax > 100
      error('Upper cut-off percentile out of [0,100] range')
   end 
   if opt.pmin > opt.pmax
      error('Lower cut-off percentile exceeds upper cut-off percentile')
   end
   if opt.xmin > opt.xmax
      error('Lower x-axis limit exceeds upper x-axis limit')
   end
else
   opt.xmin = -Inf;
   opt.xmax = Inf;
   opt.pmin = 0;
   opt.pmax = 100;
end

try
   q = prctile(x,[opt.pmin opt.pmax]);
catch
   error('Invalid percentiles supplied')
end
x = x(isfinite(x));
n = length(x);
x = x(x >= q(1) & x <= q(2));

if (nargin > 0 && ~isset('dx'))||(nargin == 0)
    opt.dx = (q(2) - q(1))/10;
    if opt.dx == 0
       opt.dx = 1;
    end   
end

xmin = opt.xmin; if ~isfinite(xmin), xmin = q(1); end
xmax = opt.xmax; if ~isfinite(xmax), xmax = q(2); end
e = (xmin - opt.dx):opt.dx:(xmax + opt.dx);
f = histc(x,e)/n;  
h = bar(e,f,'histc');
if nargout > 0
   varargout(i) = {h};
end
hold on

if (nargin > 0 && ~isset('ymax'))||(nargin == 0)
   opt.ymax = min(.01 + 1.1*max(f),1);
end

if nargin > 0 && isset('xmrk')
   line([opt.xmrk opt.xmrk],[0 opt.ymax])
end
hold off

axis([opt.xmin opt.xmax 0 opt.ymax])

    function[y] = isset(field)
    if ~isfield(opt,field)
        y = false;
    else
        f = opt.(field);
        if ~isscalar(f)
           error([field ' must be a scalar'])
        end 
        if isempty(f)||~isfinite(f)
           y = false;
        else
           y = true;
        end 
    end  
    end

end
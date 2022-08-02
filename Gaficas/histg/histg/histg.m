function[varargout] = histg(x,c,varargin)
% HISTG    'Grouped' univariate histogram
% INPUTS  : x   - n*1 data vector
%           c   - n*1 group-assignment vector
%           opt - (optional) display options structure, with fields 
%             pmin - lower cut-off percentile (1 by default)
%             pmax - upper cut-off percentile (99 by default)
%             ymax - upper limit of y-axis ('tight' be default)
%             xmin - lower limit of x-axis (none by default)
%             xmax - upper limit of x-axis (none by default)
%             dx   - bin size ((q(pmax)-q(pmin))/10 by default)
%             xmrk - position of  vertical marker line (none by default)
% OUTPUTS : h   - (optional) vector of barseries handles
% EXAMPLE : See HISTGDEMO
% AUTHOR  : Dimitri Shvorob, dimitri.shvorob@vanderbilt.edu, 4/10/07

if nargin < 1
   error('Input argument "x" is undefined')
end
if nargin < 2
   error('Input argument "c" is undefined')
end
x = squeeze(x);
if ~isvector(x)
   error('Input argument "x" must be a vector')
end 
if ~isvector(c)
   error('Input argument "c" must be a vector')
end 
if length(x) ~= length(c)
   error('Input arguments "x" and "c" must be vectors of common length')
end 
if nargin > 2
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
i = isfinite(x) & isfinite(c) & x >= q(1) & x <= q(2);
x = x(i);
c = c(i);
n = length(x);

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

u = unique(c);
m = length(u);
b = length(e);
F = zeros(b,m);

for i = 1:m
    xi = x(c == u(i));
    F(:,i) = histc(xi,e)/n;  
end    
h = bar(e + opt.dx/2,F,1,'stacked');   

if nargout > 0
   varargout(1) = {h};
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
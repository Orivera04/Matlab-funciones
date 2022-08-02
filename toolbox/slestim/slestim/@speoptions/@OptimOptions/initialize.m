function initialize(this, options)
% INITIALIZE Initializes optimization options.
%
%  this.initialize('fmincon')
%  this.initialize( optimset('fmincon') )

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ $Date: 2004/01/03 12:26:59 $

if ischar(options)
  % Get options from method name
  options = optimset(options);
end

props = intersect(fieldnames(this), fieldnames(options));

for ct = 1:length(props)
  f = props{ct};
  this.(f) = options.(f);
end

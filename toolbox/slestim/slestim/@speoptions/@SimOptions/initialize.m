function initialize(this, options)
% INITIALIZE Initializes simulation options
%
%  this.initialize('f14')
%  this.initialize( simget('f14') )

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ $Date: 2004/01/03 12:27:03 $

if ischar(options)
  % Get options from model name
  options = simget(options);
end

props = intersect(fieldnames(this), fieldnames(options));

for ct = 1:length(props)
  f = props{ct};
  this.(f) = options.(f);
end

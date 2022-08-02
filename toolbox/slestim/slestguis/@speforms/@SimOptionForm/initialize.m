function initialize(this, options)
% INITIALIZE Initializes simulation options
%
%  this.initialize('f14')
%  this.initialize( simget('f14') )
%  this.initialize( h ), where h = speoptions.simoptions

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ $Date: 2004/01/03 12:25:45 $

if ischar(options)
  % Get options from model name
  options = simget(options);
end

props = intersect(fieldnames(this), fieldnames(options));

for ct = 1:length(props)
  f = props{ct};
  
  if isa(options.(f), 'char')
    this.(f) = options.(f);
  elseif ~isempty( options.(f) )
    this.(f) = num2str(options.(f), 8);
  end
end

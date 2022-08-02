function this = estimsource(Estimation, varargin)
% Constructor

% Author(s): Bora Eryilmaz
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:41:00 $
this = speviews.estimsource;
if nargin>0
   % Link to estimation object
   this.Estimation = Estimation;
   this.Parameters = get(Estimation.Parameters,{'Name'});

   % Add listeners
   addlisteners(this)

   % Set additional parameters in varargin
   if ~isempty(varargin)
      set( this, varargin{:} );
   end
end

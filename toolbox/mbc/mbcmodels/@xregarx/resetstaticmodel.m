function varargout = resetstaticmodel( m, cl )
%XREGARX/RESETSTATICMODEL   Reset the static model embedded in an ARX dynamic model.
%   RESETSTATICMODEL(M) resets the static model embedded in the ARX dynamic 
%   model M. The new static model will have the same class as the current 
%   static model but the number of inputs to the new model may be different.
%   RESETSTATICMODEL(M,CL) sets the new static model as model of class CL.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:45:32 $

StaticList = staticlist( m );

% get the persistent options
PersistentOptions = get( m.StaticModel, 'PersistentOptions' );

if nargin < 2,
    cl = class( m.StaticModel );
elseif ~ismember( cl, { StaticList.Class } ),
    error( [ 'Invalid input: requested static model is not an approved ', ...
            'class. See XREGARX/STATICLIST.' ] );
end

% setup the new static model
staticmodel = feval( cl, [ m.DynamicOrder; m.Delay ] );

% set the correct symbols, etc, for the new static model
staticxinfo = expandxinfo( xinfo( m ), yinfo( m ), m.DynamicOrder, m.Delay );
staticmodel = xinfo( staticmodel, staticxinfo );

% set the persistent options
staticmodel = set( staticmodel, 'PersistentOptions', PersistentOptions );

% update the static model
m.StaticModel = staticmodel;

% finish
if nargout == 1
    varargout{1} = m;
elseif isvarname( inputname(1) ),
    assignin( 'caller', inputname(1), m );
end

return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

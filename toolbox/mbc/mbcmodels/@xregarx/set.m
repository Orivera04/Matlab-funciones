function varargout = set( m, property, value )
%XREGARX/SET   Implements the SET method for the XREGARX object.
%   SET(M,'<property>','<value>') sets the value of property for the 
%   XREGARX model M.
%
%   Properties:
%     Frequency
%     StaticModel
%        SET(M,'StaticModel','xreg<..>')
%        SET(M,'StaticModel',SM)
%
%     DynamicOrder
%     Delay
%     OrderAndDelay  (delmat)
%
%   and those XREGMODEL properties that are SET'able.
%
%   See also XREGMODEL/SET.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:45:35 $


error( nargchk( 3, 3, nargin ) );

switch lower( property ),
case 'frequency',
    if length( value ) ~= 1,
        error( 'Frequency must be a scalar' );
    elseif value <= 0,
        error( 'Frequency must be greater than zero' );
    end
    m.Frequency = value(1);
    
case 'staticmodel',
    StaticList = staticlist( m );
    if ischar( value ),
        if ~ismember( value, { StaticList.Class } ),
            error( [ 'Invalid input: requested static model is not an ', ...
                    'approved class. See XREGARX/STATICLIST.' ] );
        end
        % only reset static model if new class is different to old class
        if ~strcmp( value, class( m.StaticModel ) ),
            m = resetstaticmodel( m, value );
        end
    else
        if ~ismember( class( value ), { StaticList.Class } ),
            error( [ 'Invalid input: static model is not an approved ', ...
                    'class. See XREGARX/STATICLIST.' ] );
        elseif nfactors( value ) ~= nfactors( m.StaticModel ),
            error( [ 'Invalid input: static model has the wrong number  ', ...
                    'of inputs for this ARX model.' ] );
        end
        m.StaticModel = value;
    end
    
case 'dynamicorder',
    value = floor( value(:)' );
    if numel( value ) ~= nfactors( m ) + 1,
        error( 'Invalid input: dynamic order has wrong number of terms.' );
    elseif any( value < 0 ),
        error( 'Invalid input: dynamic order must be non-negative.' );
    elseif all( value < 1 ),
        error( [ 'Invalid input: at least one dynamic order must be ', ...
                'greater than zero.' ] );
    else
        m.DynamicOrder = value;
    end
    resetstaticmodel( m );
    
case 'delay',
    value = floor( value(:)' );
    if numel( value ) ~= nfactors( m ) + 1,
        error( 'Invalid input: delay has wrong number of terms.' );
    elseif any( value < 0 ),
        error( 'Invalid input: delay must be non-negative.' );
    elseif value(end) < 1,
        error( 'Invalid input: feedback delay must be greater than 0.' );
    else
        m.Delay = value(:)';
    end
    resetstaticmodel( m );

case {'orderanddelay', 'delmat'},
    if all( size( value ) ~= [2,  nfactors( m ) + 1] ),
        error( [ 'Invalid input: order and delay matrix (delmat) is the ' ...
                'wrong size.' ] );
    elseif any( value < 0 ),
        error( 'Invalid input: dynamic order and delay must be non-negative.' );
    elseif value(2,end) < 1,
        error( 'Invalid input: feedback delay must be greater than 0.' );
    else
        m.DynamicOrder = value(1,:);
        m.Delay = value(2,:);
    end
    resetstaticmodel( m );
case 'initialconditions'
    delmat = get( m, 'OrderAndDelay' );
    md = max( sum( delmat, 1 ) ) - 1;
    y0 = repmat(double(value(1)),md,1) ;   
    m.StaticModel= set( m.StaticModel, 'InitialConditions' ,y0);
case 'ycode'
    sm= m.StaticModel;
    yord= m.DynamicOrder(end);
    if yord
        y= double(value);
        % work out scaling for the ouput terms in the static model
        r= [min(y) max(y)];
        if r(2)-r(1)< eps
            % handle constant inputs gracefully
            r(2)= r(1) + 1;
        end
        [Bnds,g,Tgt]= getcode(sm);
        Bnds(end-yord+1:end,1)= r(1);
        Bnds(end-yord+1:end,2)= r(2);
        sm= setcode(sm,Bnds,g,Tgt);
        m.StaticModel= sm;
    end
    
otherwise,
    try,
        m.xregmodel = set( m.xregmodel, property, value );
    catch,
        error( lasterr );
    end
end

if nargout == 1
    varargout{1} = m;
elseif isvarname( inputname(1) ),
    assignin( 'caller', inputname(1), m );
end

return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

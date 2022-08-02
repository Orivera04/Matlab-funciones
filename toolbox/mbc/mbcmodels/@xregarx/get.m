function value = get( m, property )
%XREGARX/GET   Implements the GET method for the XREGARX object.
%   GET(M,'<property>') returns the value of the property for the XREGARX 
%   model M. GET(M) returns a cell array of GET'able properties.
%
%   The following properties are specific to XREGARX
%       Frequency      - sampling frequency
%       StaticModel    - returns the embedded static model
%       StaticModelClass - the object class of of the embedded static model
%       NStaticModelFactors - number of input factors to the embedded static 
%                         model
%       DynamicOrder   - the dyanmic order of the inputs and feedback
%       Delay          - the delay on the inputs and feedback
%       OrderAndDelay  - get the dynamic order and delay as a signle matrix: 
%                        the first row is the order vector and the second the 
%                        delay
%       delmat         - same as OrderAndDelay
%       DynamicSymbols - inputs to the dynamic model
%       StaticSymbols  - inputs to the embedded static model
%   There are also properties inherited from XREGMODEL.
%
%   See also XREGMODEL/GET.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:44:53 $


error( nargchk( 1, 2, nargin ) );

if nargin == 1,
    modelprop = get( m.xregmodel );
    value = { ...
            'Frequency', ...
            'StaticModel', ...
            'StaticModelClass', ...
            'NStaticModelFactors', ...
            'DynamicOrder', ...
            'Delay', ...
            'OrderAndDelay', ...
            'DynamicSymbols', ...
            'StaticSymbols', ...
            modelprop{:} }';
        return
end

switch lower( property ),
    case 'frequency',
    value = m.Frequency;
    
case 'staticmodel',
    value = m.StaticModel;
    
case 'staticmodelclass',
    value = class( m.StaticModel );
    
case 'nstaticmodelfactors',
    value = nfactors( m.StaticModel );
    
case 'dynamicorder',
    value = m.DynamicOrder;
    
case 'delay',
    value = m.Delay;
    
case {'orderanddelay', 'delmat'},
    order = m.DynamicOrder;
    delay = m.Delay;
    %% delay(order==0) = 0; % does anything rely on this?
    value = [ order; delay ];
    
case 'dynamicsymbols',
    value = get( m.xregmodel, 'Symbols' );
    
case 'staticsymbols',
    value = get( m.StaticModel, 'Symbols' );
    
otherwise,
    try,
        value = get( m.xregmodel, property );
    catch,
        error( lasterr );
    end
end

return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

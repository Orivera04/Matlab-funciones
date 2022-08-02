function m = check_degree( m, action )
%CHECK_DEGREE check the polynomial degree of an interpolating rbf
%   M = CHECK_DEGREE(M) or M = CHECK_DEGREE(M,'Soft') sets the degree of 
%   the polynomial part of the rbf to the minimum allowable if the current 
%   degree is lower than that value. If the current degree is the same or 
%   higher than the lowest allowed, this has no effect. 
%   M = CHECK_DEGREE(M,'Hard') sets the degree of the polynomial to the 
%   lowest allowed regardless of the current settings.
%   CHECK_DEGREE(M,Kernel) returns the degree of the lowest allowed 
%   polynomial for the given kernel. Note that (-1) denotes that no 
%   polynomial is required.
%
%   ------------------------+------------------+------------------
%   Kernel name               Function name       Req'd Poly
%   ------------------------+------------------+------------------
%   thin-plate spline         THINPLATE           Linear
%   linear                    LINEARRBF           Constant
%   cubic                     CUBICRBF            Linear
%   multiquadric              MULTIQUADRIC        Constant
%   reciprocal multiquadric   RECMULTIQUADRIC     None
%   Gaussian                  GAUSSIAN            None
%   Wendland (see below)      WENDlALD            None
%   Logistic                  LOGISTICRBF         ?? (Not SCPD?)
%   ------------------------+------------------+------------------
%
%   See also CUBICRBF, GAUSSIAN, MULTIQUADRIC, RECMULTIQUADRIC, LOGISTICRBF, 
%   THINPLATE, WENDLAND, LINEARRBF.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 07:48:38 $ 

if nargin == 1,
    action = 'Soft';
elseif isa( action, 'function_handle' ),
    action = func2str( action );
end

if strcmpi( 'Soft', action ) | strcmpi( 'Hard', action ),
    rbf = get( m, 'RbfPart' );
    poly = get( m, 'LinearModPart' );
    
    % get the kernel name/handle
    kernel = get( rbf, 'kernel' );
    
    % get degree req'd by this kerenl
    reqd_deg  = i_kernel2degree( kernel );
    
    % get degree of current poly
    current_deg = get( poly, 'order' );
    
    if strcmpi( 'Hard', action ),
        % reset the polynomial degree
        if reqd_deg < 0,
            poly = setstatus( poly, ':', 2 );
        else
            poly = set( poly, 'order', ...
                repmat( reqd_deg, size(current_deg) ) );
        end
        m = set( m, 'LinearModPart', poly );
%         if reqd_deg < 0
%             m = setstatus( m, 1:size(poly,1), 2 );
%         end
    else
        ind = find( current_deg < reqd_deg );
        if ~isempty( ind ),
            % reset some/all of the polynomail degree
            new_deg = current_deg;
            new_deg(ind) = repmat( reqd_deg, size(ind) );
            poly = set( poly, 'order', new_deg );
        end
        m = set( m, 'LinearModPart', poly );
    end


else
    m = i_kernel2degree( action );
end

% -------------------------------------------------------------------------|
function m = i_kernel2degree( kernel )

% if isa( kernel, 'function_handle' ),
%     kernel = func2str( kernel );
% end

switch lower( kernel ),
case { 'gaussian', 'recmultiquadric', 'wendland' },
    % none required
    m = -1;
case {'multiquadric', 'linearrbf'}
    % constant required
    m = 0;
case {'thinplate','cubicrbf'}
    % linear required
    m = 1;
case 'logisticrbf'
    % ? Not SCPD?
    %% warning( 'The logisticrbf may not be SCPD.' );
    m = -1;
otherwise,
    error( sprintf( 'Unknown kernel %s', kernel ) );
end

% EOF

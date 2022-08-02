function ptr = cgparseswitch(b,blockname,lines, PLIST)	
%CGPARSESWITCH A CAGE Simulink parse function
%
%  PTR = CGPARSESWITCH(blockHandle, blockName, lines, pPointerList)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%  $Revision: 1.3.6.3 $    $Date: 2004/04/04 03:27:53 $

ptr = cgsl2exprcheckname( blockname, PLIST );
if ~isvalid( ptr )
    [handles,newlines] = cgsl2exprsrcblocks( b );
    U1 = cgsl2exprgetprior( handles(1), '', get_param(b,'handle'), newlines(1), PLIST );
    U2 = cgsl2exprgetprior( handles(2), '', get_param(b,'handle'), newlines(2), PLIST );
    U3 = cgsl2exprgetprior( handles(3), '', get_param(b,'handle'), newlines(3), PLIST );
    THRESHOLD = str2num( get_param( b,'threshold' ) );
    CRITERIA = get_param( b, 'Criteria' );
    if ~strcmp( CRITERIA, 'u2 >= Threshold')
        % we only support this one switching criteria since we represent
        % the switch with an ifexpr
        error('Switch blocks "Crieria for passing first input" must be set to "u2 >= Threshold" ');
    end

    pThreshold = xregpointer( cgconstant( 'Threshold', THRESHOLD ) );
    % SWITCH BLOCK
    % if U2>=THRESHOLD
    %  out = U1
    % else
    %  out = U3
    % end
    
    % IF BLOCK
    % if A<B
    %   out = C;
    % else
    %   out = D;
    % end
    ptr = xregpointer(...
        cgifexpr( blockname,...
        U2,...
        pThreshold,...
        U3,...
        U1 ) );
    
    PLIST.info = [PLIST.info; ptr; pThreshold];
end
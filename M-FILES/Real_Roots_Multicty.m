function [Real_Rts, Real_Rts_Mult] = ...
    Real_Roots_Multicty ( Poly_Rts_Real, mplcity_fctr )
%
% Sundar Krishnan (sundark100@yahoo.com)
% Release  : R14, R13, R12
% Date     : June-July 2005
%
% Functional Description :
% ------------------------
% This Helper function was initially developed to COUNT the multiplicity
% of Real Roots.
% However, this function can be used to get the multiplicity of
% ANY apriori SORTED Real List - in Normal (absolute-ascending)
% or in Reverse (absolute-descending) order.
%
% As the no of roots increases, the Programme automatically alters
% mplcity_fctr, an empirically derived value.
% This automatic adaption of mplcity_fctr is the default case
% when the no of args is 1.
% However, this function can be run at a specific given mplcity_fctr
% as is done by supplying values of mplcity_fctr in cmplx_roots_sort_Det.m
%
% If this suite of Programmes (in this zip file) don't work for you
% directly when downloaded into an independent directory, you could
% try loading these files in the Matlab dir : ...\toolbox\matlab\specfun
%
%                               &&&&&&&&&&&&&&&&&
%
% Author's Legal Disclaimer :
% ---------------------------
% I share my code, developed with lots of efforts, and often based
% on lots of studies, in good faith.
% Everyone is free to use this code at their own risk provided
% they include my name for this part in their works.
% I am NOT responsible for any technical or legal complications
% directly or indirectly, arising out of any direct or indirect use
% of my codes or my interpretations.
% Any apparent TECHNICAL fault in interpreting any external references, 
% or others' replies in any Public User Group Forums, is my own, 
% not theirs. However, I am NOT LEGALLY responsible for any of my
% technical or other interpretation of others' comments in ANY Forum.
%
%                               &&&&&&&&&&&&&&&&&
%
% % Usage Egs :
% % Case 1 :
% Poly_Rts_Real = [ 0.11, 0.11,   -1.618,  1.9276,   2.323, 2.323,  ...
% 3.247, 3.247, 3.247,   -9.23 ] 
% [Real_Rts, Real_Rts_Mult] = Real_Roots_Multicty ( Poly_Rts_Real )
%
% % Case 2 :
% Poly_Rts_Real = fliplr ( Poly_Rts_Real ) 
% % Poly_Rts_Real = [  -9.2300    3.2470    3.2470    3.2470   ...
% % 2.3230    2.3230    1.9276   -1.6180    0.1100    0.1100 ] ;
% [Real_Rts, Real_Rts_Mult] = Real_Roots_Multicty ( Poly_Rts_Real )
%
%                              *******************

% fprintf ( '\nSTART of Real_Roots_Multicty \n' ) ;    % for TESTing

% 1) Inits :
if all ( isreal ( Poly_Rts_Real ) ) ~= 1
    error ( 'Inputs must be REAL only.' ) ;
end

no_Real_Rts = length ( Poly_Rts_Real ) ;

Real_Rts      = [ ] ;
Real_Rts_Mult = [ ] ;

if no_Real_Rts >= 1
    Real_Rts = [ ] ;
    Real_Rts_Mult = [ ] ;
end

% Adjust mplcity_fctr as a function of the length of the Input Real Roots.
% In cmplx_roots_sort_Det.m, we call Real_Roots_Multicty about 8 times ;
% 4 times by supplying empirically calculated pure_real_fctr,
% and 4 times by supplying empirically calculated mplcity_fctr
% for angles' calculation.
if nargin < 2

    mplcity_fctr = 5e-4 ;    % 0.0001 for lower powers

    if no_Real_Rts > 6

        if no_Real_Rts <= 10
            mplcity_fctr = 7.5e-4 ;

        elseif no_Real_Rts <= 15
            mplcity_fctr = 0.001 ;

        elseif no_Real_Rts <= 20
            mplcity_fctr = 0.005 ;

        elseif no_Real_Rts <= 25
            mplcity_fctr = 0.01 ;

        elseif no_Real_Rts <= 30
            mplcity_fctr = 0.025 ;

        elseif no_Real_Rts <= 35
            mplcity_fctr = 0.05 ;

        else
            mplcity_fctr = 0.1 ;
        end
    end    % if no_Real_Rts > 10

end    % if nargin < 2

%                               &&&&&&&&&&&&&&&&&

% 2) The Kernel part of the Programme which finds the multiplicity.
chk  = 1 ;
strt = chk + 1 ;

while chk <= no_Real_Rts

    % If the Real Root is the last single Real Root :
    if chk == no_Real_Rts
        
        Real_Rts = [ Real_Rts, Poly_Rts_Real(chk) ] ;
        
        Real_Rts_Mult ( end + 1 ) = 1 ;
        
    else

        Real_Rts = [ Real_Rts, Poly_Rts_Real(chk) ] ;
        
        len_Real_Rts = length (Real_Rts) ;

        len_Real_Rts_Mult = length ( Real_Rts_Mult ) ;
        
        Real_Rts_Mult ( len_Real_Rts_Mult + 1 ) = 1 ;

        for kR = strt : no_Real_Rts
            
            % Note that here, it is necessary to assign
            % zero (values < eps) as eps unlike the code
            % in cmplx_roots_sort_Det for identifying pure real parts.
            % Moreover, here, the result is accumulated in Real_Rts
            % not in Poly_Rts_Real.
            if abs ( Poly_Rts_Real (chk) ) < eps
                Poly_Rts_Real (chk) = eps ;
            end

            if abs ( Poly_Rts_Real (kR) ) < eps
                Poly_Rts_Real (kR) = eps ;
            end
            
            if abs ( Poly_Rts_Real (chk) - Poly_Rts_Real (kR) ) / ...
                abs ( Poly_Rts_Real (chk) ) < mplcity_fctr
                
                Real_Rts_Mult ( end ) = ...
                    Real_Rts_Mult ( end ) + 1 ;

            else
                break    % break out of for
            end

        end    % for kR = strt : no_Real_Rts

    end    % if chk == no_Real_Rts

    chk = sum ( Real_Rts_Mult ) + 1 ;
    strt = chk + 1 ;

end    % while strt < no_Real_Rts

% fprintf ( '\nEND of Real_Roots_Multicty \n' ) ;    % for TESTing

%                              *******************

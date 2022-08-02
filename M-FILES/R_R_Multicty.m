function [R_R, R_R_Mult] = ...
    R_R_Multicty ( P_R_R, mplcity_fctr )

% % Usage Egs :
% % Case 1 :
% P_R_R = [ 0.11, 0.11,   -1.618,  1.9276,   2.323, 2.323,  ...
% 3.247, 3.247, 3.247,   -9.23 ] 
% [R_R, R_R_Mult] = R_R_Multicty ( P_R_R )
%
% % Case 2 :
% P_R_R = fliplr ( P_R_R ) 
% % P_R_R = [  -9.2300    3.2470    3.2470    3.2470   ...
% % 2.3230    2.3230    1.9276   -1.6180    0.1100    0.1100 ] ;
% [R_R, R_R_Mult] = R_R_Multicty ( P_R_ )
%
%                              *******************

% fprintf ( '\nSTART of Real_Roots_Multicty \n' ) ;    % for TESTing

% 1) Inits :
if all ( isreal ( P_R_R ) ) ~= 1
    error ( 'Inputs must be REAL only.' ) ;
end

no_Real_Rts = length ( P_R_R ) ;

R_R      = [ ] ;
R_R_Mult = [ ] ;

if no_Real_Rts >= 1
    R_R = [ ] ;
    R_R_Mult = [ ] ;
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
        
        Real_Rts = [ R_R, P_R_R(chk) ] ;
        
        R_R_Mult ( end + 1 ) = 1 ;
        
    else

        R_R = [ R_R, P_R_R(chk) ] ;
        
        len_R_R = length (R_R) ;

        len_R_R_Mult = length ( R_R_Mult ) ;
        
        R_R_Mult ( len_R_R_Mult + 1 ) = 1 ;

        for kR = strt : no_Real_Rts
            
            % Note that here, it is necessary to assign
            % zero (values < eps) as eps unlike the code
            % in cmplx_roots_sort_Det for identifying pure real parts.
            % Moreover, here, the result is accumulated in Real_Rts
            % not in Poly_Rts_Real.
            if abs ( P_R_R (chk) ) < eps
                P_R_R (chk) = eps ;
            end

            if abs ( P_R_R (kR) ) < eps
                P_R_R (kR) = eps ;
            end
            
            if abs ( P_R_R (chk) - P_R_R (kR) ) / ...
                abs ( P_R_R (chk) ) < mplcity_fctr
                
                R_R_Mult ( end ) = ...
                    R_R_Mult ( end ) + 1 ;

            else
                break    % break out of for
            end

        end    % for kR = strt : no_Real_Rts

    end    % if chk == no_Real_Rts

    chk = sum ( R_R_Mult ) + 1 ;
    strt = chk + 1 ;

end    % while strt < no_Real_Rts

% fprintf ( '\nEND of Real_Roots_Multicty \n' ) ;    % for TESTing

%                              *******************

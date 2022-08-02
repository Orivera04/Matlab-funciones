function [val, frec] = vecfrec( vecval, fctr )

%Programa para calcular frecuencia de valores en un vector real.

if all ( isreal ( vecval ) ) ~= 1
    error ( 'Inputs must be REAL only.' ) ;
end

no = length ( vecval ) ;

val      = [ ] ;
frec = [ ] ;

if no >= 1
     val= [ ] ;
    frec = [ ] ;
end

if nargin < 2

    fctr = 5e-4 ;    % 0.0001 for lower powers

    if no > 6

        if no <= 10
            fctr = 7.5e-4 ;

        elseif no <= 15
            fctr = 0.001 ;

        elseif no <= 20
            fctr = 0.005 ;

        elseif no <= 25
            fctr = 0.01 ;

        elseif no <= 30
            fctr = 0.025 ;

        elseif no <= 35
            fctr = 0.05 ;

        else
            fctr = 0.1 ;
        end
    end    % if no > 10

end    % if nargin < 2

%                               &&&&&&&&&&&&&&&&&


chk  = 1 ;
strt = chk + 1 ;

while chk <= no

    % 
    if chk == no
        
         val = [ val, vecval(chk) ] ;
        
         frec( end + 1 ) = 1 ;
        
    else

         val= [ val, vecval(chk) ] ;
        
        len_val= length (val) ;

        len_frec = length ( frec ) ;
        
        frec( len_frec + 1 ) = 1 ;

        for kR = strt : no
            
            if abs ( vecval (chk) ) < eps
                vecval (chk) = eps ;
            end

            if abs ( vecval (kR) ) < eps
                 vecval(kR) = eps ;
            end
            
            if abs ( vecval (chk) - vecval (kR) ) / ...
                abs ( vecval (chk) ) < fctr
                
                 frec( end ) = ...
                    frec ( end ) + 1 ;

            else
                break    % break out of for
            end

        end    % for kR = strt : no

    end    % if chk == no

    chk = sum ( frec ) + 1 ;
    strt = chk + 1 ;

end    


%                              *******************

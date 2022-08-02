% cap3_try_exemplo ()
% resolve multiplicar a * b
function x = cap3_try_exemplo (a,b)
try
    x=a*b;
catch
    errordlg('Dimensoes incompativeis');
end 
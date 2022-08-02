im =imread('../../illustre/danse.tif'); % lecture d'une image 199x150
profile on
[ic, mo, ar]=contif(double(im));
%profile report contif
%profile on
[ic, mo, ar]=cont(double(im));
profile report ex_profile

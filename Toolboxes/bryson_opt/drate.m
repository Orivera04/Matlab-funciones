function dr=drate(al,alm,eta)
dr=eta*(al^2+alm^2)/(al^2+eta^2*(al^2+alm^2)^2)^(3/4);


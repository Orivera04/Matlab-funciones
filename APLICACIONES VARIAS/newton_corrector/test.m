%/// The Dirac Equation for Hydrogen like atom without ele.-ele.
%interaction whose Z=20 n=3 kappa=-1 (l=0)                      \\\\
Z=20;c=137;kappa=-1;n_core=380;
y=newton_corrector(@dirac,[Z/c, kappa+sqrt(kappa^2-Z^2/c^2)],n_core,10);
figure;r=2*exp(0.03*([1:n_core]-361));plot(r,y)
%\\\  Dirac Equation ///
%/// for y''=-0.01y case \\\\
y=newton_corrector(@t_sin,[1 0],361,10);
figure;plot([0:360]/(20*pi),y);
%\\\ for y''=-0.01y case ////
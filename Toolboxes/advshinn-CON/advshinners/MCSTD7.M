clc; 
disp('A frequently used method to convert between the discrete and continous time');
disp('domain is Tustin''s method, also known as the Bi-Linear Transformation.  Since');
disp('this is merely a substitution of variables, polysbst will easily accomodate it.');
help polysbst;
disp('The Control Toolbox accomodates many types of conversions:');
disp('  C2DM (or C2D) allows conversion from continuous to discrete domain.');
disp('  D2CM (or D2C) allows conversion from discrete to continuous domain.');
pause;
%
clc; disp('An example is given in my textbook from Equations 10.154 to 10.157');
disp(' '); disp('Using G(z) = (T^2/2)*(z+1)/(z-1)^2 , and T = 0.26');
disp('This converts to G(w) = (1-w/7.69)/w^2');
disp(' '); disp('t = 0.26; num = (t^2/2)*[1 1]; den = conv([1 -1],[1 -1]);');
t = 0.26; num = (t^2/2)*[1 1]; den = conv([1 -1],[1 -1]); disp(' ');
disp('Using Tustin''s Bi-Linear Transformation: z = (1+(t/2)w)/(1-(t/2)w)');
disp(' '); disp('[numw,denw] = polysbst(num,den,[t/2 1],[-t/2 1])');
[numw,denw] = polysbst(num,den,[t/2 1],[-t/2 1])
disp('Which simplifies to G(w) = (1-w/7.69)/w^2'); pause;
clc; disp('With the Control Toolbox this would be accomplished using D2CM');
disp(' '); disp('[numw,denw] = d2cm(num,den,t,''tustin'')');
if exist('d2cm')
  eval('[numw,denw] = d2cm(num,den,t,''tustin'')');
else
  disp('Control Toolbox required. Output would be:');
  numw = [0 -0.13+eps/2 1-2.5*eps], denw = [1 0 -4*eps]
end;
disp('This simplifies to G(w) = (1-w/7.69)/w^2'); pause;
clear t num den numw denw;
%
clc;
disp('Another method used is partial fraction expansion, followed by using');
disp('a look-up table for the various parts.  MATLAB has a function called');
disp('"residue" to accomplish the partial fraction expansion.  From there,');
disp('it is easy for the reader to use a look-up table in my book.');
disp('Implementing the look-up table would be redundant with the Control Toolbox');
disp('features in D2C, D2CM, C2D and C2DM.');
disp(' '); disp('Press any key to see the help file on residue.'); pause;
help residue; disp('Press any key to continue'); pause;
%
clc;
disp('A general z-transform can be done using the Symbolic Toolbox.');
disp('The transformation is done using your specific transfer function and the'); 
disp('z-transform definition.  The general form of this is :');
disp(' '); disp('E(Z) = sum(e(nT)*z^-n), where n goes from -Inf to +Inf.');
disp(' '); disp('If e(t) = 0, for t < 0, then n need only go from 0 to +Inf.');
disp(' '); disp('Using e(t) = t as an example, and the Symbolic toolbox as follows:');
disp(' '); disp('symsum(''(n*T)*z^(-n)'',''n'',0,Inf)');
if exist('symsum');
  eval('symsum(''(n*T)*z^(-n)'',''n'',0,Inf)');
else
  disp(' '); disp('Symbolic Toolbox required.  Output would have been:');
  disp(' '); disp('ans = '); disp(' '); disp('T*z/(-1+z)'); disp(' ');
end;
disp('Press any key to continue.'); pause;
%
clc;
disp('Power Series Expansion is also a very popular method of converting from');
disp('discrete transfer function and a specified input (such as a unit impulse)');
disp('to a limited number of continuous time output values at the discrete times.');
disp('The principle is described in my book.  MATLAB has a polynomial division');
disp('utility called deconv, but you must fool it into giving you the results');
disp('you desire.  The help for deconv is:'); help deconv;
disp('As you may see, it only returns positive powers of the polynomial in the');
disp('quotient, and leaves the rest as a remainder.  Multiplying the numerator');
disp('by some z^n, where n is a large integer, and interpreting the quotient and');
disp('remainder as having a z^-n attached accomplishes your goal!  Don''t forget');
disp('that MATLAB may remove the leading zero coefficients of a polynomial, since');
disp('it may interfere with other toolbox utility proper operation.'); disp(' ');
disp('Press any key to see an example (figure 9.21)'); pause;
clc;
disp('The input is a Unit Ramp, R(z) = z/(z-1)^2');
disp('The transfer function is G12(z) = 0.63/(z-0.37)');
disp('Therefore, C(z) = R(z)*G12(z) = 0.63*z/((z-1)^2*(z-0.37))');
disp('In MATLAB notation for C(z):');
disp(' '); disp('num = [0.63  0];'); num = [0.63 0];
disp('den = conv([1 -2 1],[1 -0.37]);'); den = conv([1 -2 1],[1 -0.37]);
disp('Getting the first 7 terms (t=0, and n=6 more) for C(z):'); 
disp('t = 1:6;'); t = 1:6;
disp('[c,xtra] = deconv([num 0*t],den); disp(c);');
[c,xtra] = deconv([num 0*t],den); disp(c);
disp('Don''t forget that leading terms in c are 0 (e.g., C(0)=0, ...).');
disp('This is easily corrected automatically by doing:');
disp('c = [zeros(1,length(t)-length(c)+1), c]; disp(c);');
c = [zeros(1,length(t)-length(c)+1), c]; disp(c);
disp('t = [length(t)-length(c)+1:0, t]; disp(t)');
t = [length(t)-length(c)+1:0, t]; disp(t)
disp('C(Z) is easily plotted by doing: "stairs(t,c);"');
disp('C*(Z) is easily plotted by doing: "plot([1;1]*t,[0;1]*c,''-'');"');
disp('Press any key to display the plots (for t going from 0 to 10).'); pause;
t = 1:10; [c,xtra] = deconv([num 0*t],den);
c = [zeros(1,length(t)-length(c)+1), c];
t = [length(t)-length(c)+1:0, t];
sbplot(211);
stairs(t,c); grid; title('C(Z)');
xlabel('Time'); ylabel('Amplitude');
sbplot(212);
plot([1;1]*t,[0;1]*c,'-r',t,c,'*'); grid; title('C*(Z)');
xlabel('Time'); ylabel('Amplitude');
% meta demo7;
pause; clear num den c xtra t; sbplot(111); clg;
%
disp('If you have Simulink installed, you can check this against the');
disp('simulation of figure 9.21 in the figures directory.');
disp(' '); disp('Press any key to continue.'); pause;

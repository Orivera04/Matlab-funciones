sec  = (0:399)/400;
seconds = (0:799)/600;
psvb1 = 5 - 1.4*exp(-2*sec).*sin(20*sec);
psvb2 = repmat([1 0 1 0 1 0]+3.5,100,1); psvb2 = psvb2(:)';
f = (0:.15:25)-12.5; f = sin(f)./f;
psvb2 = filter(f,sum(f),psvb2); psvb2(1:200) = [];
psvb3 = 3 * sec .* cos(5*pi*(1-sec).^3) + 3;
s = struct('psvb4',2.2 - 2*exp(-1.4*sec).*sin(10*pi*sec.^5),...
           'psvb5',humps(sec),'notnumber','abcd','tooshort',[3 4]);
long_variable_name = 1.2 * [psvb1; psvb2; psvb3];
sec =   (sec+.08) * 1e-5;;
seconds = (seconds+.08) * 1e-5;;
b2catb4 = 1.1 * [psvb2 s.psvb4];
b1catb3 = .9  * [psvb1 psvb3];
vb2rep =  1.3 * [psvb2 psvb2];
plt;

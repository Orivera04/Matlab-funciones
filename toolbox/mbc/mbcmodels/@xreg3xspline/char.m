function c=char(m,hg)
% xreg3xspline/CHAR char display of model
%
% c=char(m,hg)
% 
% Inputs
%   m      model object
%   TeX    (0/1) Produce TeX expression. (Optional, default is no TeX)      

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:43:23 $



if nargin < 2 
   hg=0;
end
   


coeffs= double(m);

% Remove zero coefficients from dispay
TermsIn= Terms(m) & coeffs~=0;
TermsIn= TermsIn(termorder(m));
coeffs= coeffs(termorder(m));

lab=labels(m,hg);
c= [cellstr(num2str(abs(coeffs(TermsIn)),'%10.4g'))  lab(TermsIn)]';

% produce single line string
c= sprintf(' %s*%s +',c{:});
% remove excess spaces
c= strrep(c,' ','');
c= strrep(c,'+',' + ');
c= strrep(c,'e + ','e+');


% Remove Constant Term
c=strrep(c,'*1','');

% Replace \phi_ with F to get non-TeX expression
if ~hg
   c=strrep(c,'\phi_{','F');
   c=strrep(c,'}','');
end

% Remove ' +' at end of string
c=c(1:end-2);

% deal with coeff sign
tc= find(TermsIn);
if isempty(tc) 
   c= '0';
	return
end

if coeffs(tc(1))< 0
   % first term different
   c=['-' c];
end
tc= tc(2:end);
if isempty(tc) 
	return
end

f= findstr(c,'+');
c(f(coeffs(tc)<0))='-';

% convert display to 80 chars/line 
cout={};
while length(c)>80
   c1 =fliplr(c(1:80));
   f= sort([findstr(c1,'+') findstr(c1,'-')]);
   % each line should end with '+' or '-'
   if ~isempty(f)
      c1= fliplr(c1(f(1):end));
      c = c(length(c1)+1:end);
      if c1(1)==' ';
         c1= c1(2:end);
      end
      cout = [cout ; {c1}];
   else
      if c(1)==' ';
         c= c(2:end);
      end
      cout = [cout ; {c}];
   end
end
if ~isempty(c) & c(1)==' ';
   c= c(2:end);
end
kstr= sprintf('%.4g,',get(m,'naturalknots'));
cout = [cout ; {c}; {['where knots = [',kstr(1:end-1),']']} ];
% convert cell to char array

c= char(cout);

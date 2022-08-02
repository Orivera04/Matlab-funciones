function c=char(m,hg);
% xregcubic/CHAR character representation of xregcubic for display
%
% c=char(m)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:45:19 $

if nargin<2
   hg=1;
end

coeffs= double(m);
% Remove zero coefficients from dispay
TermsIn= Terms(m) & coeffs~=0;
TermsIn= TermsIn(termorder(m));
coeffs= coeffs(termorder(m));

lab=labels(m,hg,1);
% Remove zero coefficients
% This arrangement 
c= [cellstr(num2str(abs(coeffs(TermsIn))))  lab(TermsIn)]';

% Make initial character Sum (c(p)*lab(p) )
c= sprintf(' %s*%s +',c{:});

% Remove Constant Term display
c=strrep(c,'*1','');
% remove excess spaces
c= strrep(c,' ','');
c= strrep(c,'+',' + ');
c= strrep(c,'e + ','e+');

% delete last ' +' made by sprintf
c=c(1:end-2);
% deal with coeff sign
tc= find(TermsIn);
if isempty(tc) 
   c= '0';
   return
end

if coeffs(1)< 0
   % first term different
   c=['-' c];
end
tc= tc(2:end);
if isempty(tc) 
	return
end

f= findstr(c,'+');
c(f(coeffs(tc)<0))='-';


% divide string into lines of 80 characters
cout={};
while length(c)>80
   c1 =fliplr(c(1:80));
   % line should end with '+'
   f= sort([findstr(c1,'+') findstr(c1,'-')]);
   if ~isempty(f)
      c1= fliplr(c1(f(1):end));
      c = c(length(c1)+1:end);
      if c1(1)==' ';
         c1= c1(2:end);
      end
      cout = [cout ; {c1}];
      % remainder of string
   else
      cout = [cout ; {c}];
   end
end
if c(1)==' ';
   c= c(2:end);
end
cout = [cout ; {c}];
c= char(cout);

   

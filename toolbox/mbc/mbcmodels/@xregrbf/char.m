function str = char( r, hg )
%XREGRBF/CHAR  Convert RBF to string
%  CHAR(M) converts the RBF model M to its string representation. CHAR accepts 
%  a second argument but does nothing with it.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.2.2 $  $Date: 2004/02/09 07:54:27 $

% Created 4/10/2000
% gives details of model

coeffs= double(r);
% Remove zero coefficients from dispay
TermsIn= Terms(r) & coeffs~=0;

ncenters = size(r.centers(TermsIn),1);
kernel = func2str(r.kernel);
width = r.width;
lambda = get(r,'lambda');

if strcmp(lower(kernel), 'wendland') 
   cont = get(r,'cont');
   str1 =['A radial basis function network using Wendlands C' num2str(cont) ...
           ' continuous kernel with ' num2str(ncenters) ' centers'];
else
   str1 = ['A radial basis function network using a ' kernel ...
           ' kernel with ' num2str(ncenters) ' centers'];
   
end

siz_width = size( width );
if all( siz_width == 1 ),
    str2 = ['and a global width of ' num2str( width ) '.'];
elseif siz_width(1) == 1
    str2 = strvcat('and a width per dimension:', num2str(width));
elseif siz_width(2) == 1
    str2 = ['and a width per center.'];
else,
    str2 = ['and a width per dimension per center.'];
end    

if length(lambda) == 1
    str3 = ['The regularization parameter, lambda, is ' num2str(lambda) '.'];
else
    str3 = ['There are several local regularisation parameters.'];
end    
str = strvcat(str1,str2,str3);

return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

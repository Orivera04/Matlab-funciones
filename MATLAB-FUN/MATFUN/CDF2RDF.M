function [vv,dd] = cdf2rdf(v,d)
%CDF2RDF Complex diagonal form to real block diagonal form.
%	[V,D] = CDF2RDF(V,D) transforms the outputs of EIG from complex
%	diagonal form to a real diagonal form.  In complex diagonal form,
%	D has complex eigenvalues down the diagonal.  In real diagonal
%	form, the complex eigenvalues are in 2-by-2 blocks on the
%	diagonal.  Complex eigenvalue pairs are assumed to be next
%	to one another.

%	J.N. Little 4-27-87
%	Based upon M-file from M. Steinbuch, N.V.KEMA & Delft Univ. of Tech.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

j = sqrt(-1);
t = eye(length(d));
twobytwo = [1 1;j -j];
i = find(imag(diag(d))');
index = i(1:2:length(i));
for i=index
    t(i:i+1,i:i+1) = twobytwo;
end	
vv=v/t; dd=t*d/t;

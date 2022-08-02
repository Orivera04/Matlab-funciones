% % merge two sorted vectors 'a' and 'b' into a sorted vector 'c'
% % 'a' and 'b' can be column or row vectors, 'c' is column vector. 

function c=mergesorted(a,b)

lena = length(a);
lenb = length(b);
c=zeros(1,lena+lenb);

inda = 1;      % index to move along vector 'a'
indb = 1;      % index to move along vector 'b'
indc = 1;      % index to move along vector 'c'
while ((inda <= lena) && (indb <= lenb))
 if a(inda) < b(indb)
    c(indc) = a(inda);
    inda = inda + 1;
 else
    c(indc) = b(indb);
    indb = indb + 1;
 end
 indc = indc + 1;
end

% copy any remaining elements of the 'a' into 'c'
while (inda <= lena)
  c(indc) = a(inda);
  indc = indc + 1;
  inda = inda + 1;
end
% copy any remaining elements of the 'b' into 'c'
while (indb <= lenb)
  c(indc) = b(indb);
  indc = indc + 1;
  indb = indb + 1;
end


function [d,r,anull,ortho,aplus,x,norma]=svdprogm(A,b)
% © Stoyan Gisbert 1998; program a Linearis algebra c. reszhez
[U S V]=svd(full(A));
d=diag(S);               % Ezek a szingularis ertekek.
r=0;
z=eps*max(max(abs(A)));  % eps a gep relativ pontossaga.
[m,n]=size(A);
for i=1:min(m,n)         % Varhato, hogy a \ML\ pinv ill.
   if abs(d(i))>z        % null utasitasaban ennel bonyolul-,
     d(i)=1/d(i);        % tabb modon hatarozzak meg azt,
     r=r+1;              % hogy mikortol tekints"unk valamit
   end                   % nullanak.
end
r                        % Most r a matrix rangja es
anull=V(:,r+1:n)         % anull a magter bazisa.
ortho=orth=U(:,1:r);     % Itt van a kepter bazisa.
aplus=V*diag(d)*U';      % Ez a pszeudoinverz matrix,
x=aplus*b                % ez Ax=b-nek az x_+ megoldasa;
norma=norm(b-A*x)        % a maradekvektor euklideszi 
                         % normajat itt kapjuk.
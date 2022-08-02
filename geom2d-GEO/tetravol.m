function V=tetravol(A,B,C,O)
%V=tetravol(A,B,C,O) V1.0
%
%   returns the volume of a tetraeder element defined by 4 vertices.
%   the vertices are given by three dimensional coordinate vectors 
%
%   Attention: tetravol does not check for degenerated nodes !
%
%   The nodes can be arranged in any order
%
%   example:        
%
%   A=[0 0 0]';B=[1 0 0.5]';C=[0.5 1 1]';O=[0.5 0.5 5]';
%   V=tetravol(A,B,C,O)
%
%   V is now 0.72916666666667
%
%   (c) 2002, Siemens AG, A&D MC RD 3, Guido Stoeppler, 
%                                      Liverpool John Moores University
%
%   guido.stoeppler@siemens.com

A=A(:);B=B(:);C=C(:);O=O(:);                    % asure column vectors
if ~(size(A,1)==3 & size(B,1)==3 & size(C,1)==3 & size(O,1)==3)
    fprintf('\n\n error using tetravol: wrong format of input vectors\n');
    help tetravol;
    return;
end

r=sqrt(sum((A(1:3)-B(1:3)).^2));                % determine side lengths
p=sqrt(sum((B(1:3)-C(1:3)).^2));
q=sqrt(sum((C(1:3)-A(1:3)).^2));
a=sqrt(sum((A(1:3)-O(1:3)).^2));
b=sqrt(sum((B(1:3)-O(1:3)).^2));
c=sqrt(sum((C(1:3)-O(1:3)).^2));

Vmat=[0 r q a 1;...
      r 0 p b 1;...
      q p 0 c 1;...
      a b c 0 1;...
      1 1 1 1 0];

V=sqrt(det(Vmat.^2)/288);
    
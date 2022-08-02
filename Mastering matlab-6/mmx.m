function y=mmx(a,b)
%MMX Expand Singleton Dimensions. (MM)
% MMX(A,B) expands A by replication to match the size of B so that
% arithmetic and logical operations between A and B are defined.
%
% All nonsingleton dimensions of A must match those of B.
% All singleton dimensions of A are replicated to match those of B.
%
% Examples:
% MMX( [1 2], EYE(2) ) produces [1 2;1 2]
% MMX( [1;2], EYE(2) ) produces [1 1;2 2]
% MMX( [1 2], CAT(3,EYE(2),ONES(2)) ) produces
% ans(:,:,1) =
%     1     2
%     1     2
% ans(:,:,2) =
%     1     2
%     1     2

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 4/1/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8

asiz=[size(a) ones(1,ndims(b)-ndims(a))]; % try to make A look as big as B
bsiz=size(b);

if length(asiz)>length(bsiz)
    error('A Cannot Have More Dimensions than B.')
end

ns=(asiz>1);              % nonsingleton dims of A
sd=(~ns);                 % singleton dims of A
if all(asiz==bsiz)        % no work to do, A is already as big as B
    y=a;

elseif all(ns==0)         % A is a scalar (protect next test from emptys)
    y=repmat(a,bsiz);     % expand scalar A to the size of B
    
elseif any(asiz(ns)~=bsiz(ns))
    error('All NonSingleton Dimensions of A Must Match Those of B.')
    
else                      % finally, do it
    rep=ones(size(bsiz)); % start with single replication of all dimensions
    rep(sd)=bsiz(sd);     % poke in replications of A required to match B
    y=repmat(a,rep);      % let repmat do the nitty-gritty work
end

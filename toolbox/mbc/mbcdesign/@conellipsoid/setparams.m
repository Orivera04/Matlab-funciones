function [c,msg]=setparams(c,varargin)
%SETPARAMS  Set constraint parameters
%
%  C=SETPARAMS(C,PARAMLIST)  where PARAMLIST is a list
%  of parameter-value pairs.  Valid parameters for the
%  conellipsoid object are :
%
%     xc:  vector, length nfactors (center of ellipsoid
%     W:  symmetric matrix, nfactors-by-nfactors
%     model:  a model to use as a basis for default settings
%     scalefactor: 1 or -1 for normal or inverse ellipsoids
%
%  where  (x-xc)'*W*(x-xc) < 1
%
%  C=SETPARAMS(C,B) allows for all the parameters to be passed in as a
%  single vector, B. In this vector, the first nfactors elements are the
%  center and rest of the vector stores the diagonals of the matrix W. For
%  example, if nfactors==3, then 
%                  W = [ B(7), B(5), B(4);  
%                        B(5), B(8), B(6);  
%                        B(4), B(6), B(9) ]

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.6.2.2 $  $Date: 2004/02/09 06:58:11 $

msg={};
if nargin == 2,
    % C = SETPARAMS(C,B)
    beta = varargin{1};
    beta = beta(:)'; % make beta a row vector
    d = length( c.xc );
    
    % extract matrix from beta
    W = zeros( d );

    i = find( triu( ones( d ) ) );
    W(i) = beta((d+1):end);

    W = W'*W;
    
    % set model parameters
    c.xc = beta(1:d);
    c.W = W;
    c.scalefactor = 1;
    % Test for pos. def. not required as we are using the Cholesky
    % decomposition as the response fatures.
    %     lam = eig( W );
    %     if ~isreal( lam ) | min( lam ) <  0,
    %         msg = {'W must be positive semi-definite'};
    %     else
    %         c.W = W;
    %     end

else
    % C = SETPARAMS(C,PARAMLIST) 
    for n=1:2:length(varargin)
        val=varargin{n+1};
        switch lower(varargin{n})
            case 'xc'
                if length(val(:))==length(c.xc)
                    c.xc=val(:)';
                else
                    msg(end+1)={'Centre point has too many components'};
                end
            case 'w'
                lam= eig(val);
                if ~isreal(lam) | min(lam) <  0 | norm(val-val')>max(lam)*1e-8
                    msg(end+1)={'W must be positive semi-definite'};
                elseif all(size(val)==length(c.xc))
                    c.W=val;
                else
                    msg(end+1)={'Incorrect size for W'}; 
                end
            case 'model'
                lims=gettarget(val);
                c.xc=(lims(:,1)+(lims(:,2)-lims(:,1))./2)';
                c.W=eye(size(c.W)).*repmat(1./(((lims(:,2)-lims(:,1))./2).^2),1,size(c.W,2));
            case 'scalefactor'
                c.scalefactor = val;
        end
    end
end
function [m,OK,Stats,B]=stepwise(m,StepTerms)
%STEPWISE Perform stepwise term reduction on the model
%
%  [M, OK, STATS, B] = STEPWISE(M, STEPTERMS) performs a stepwise operation
%  on the model.  If STEPTERMS is a list of term indices, those terms will
%  be toggled in/out of the current model state in as optimal a fashion as
%  possible.  If STEPTERMS is a logical vector the same size as the number
%  of terms in the model, the model will have all of its terms "stepped"
%  out as indicated.  Terms that have been set as being forced in or out of
%  the model will retain these settings.
%
%  The model store values (eg a new Q and R) and the model coefficients are
%  all updated during a stepwise operation.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.4.3 $  $Date: 2004/02/09 07:50:15 $

OK= 1;
Stats=[];
B=[];
Nobs = size(m.Store.y,1);
if nargin >= 2
    X = m.Store.X;
    StepTerms= StepTerms(:);
    
    % Flag that indicates that a full QR decomposition needs to be
    % performed
    FULL_REFRESH = false;
    
    if islogical(StepTerms) && length(StepTerms) == length(m.TermsOut)
        % StepTerms specifies terms to be excluded
        StepTerms = m.TermStatus==3 & StepTerms;
        m.TermsOut = StepTerms;
        StepTerms = find(StepTerms);
        FULL_REFRESH = true;
    else
        % Toggle state of specified terms
        m.TermsOut(StepTerms)= ~m.TermsOut(StepTerms);
        
        if islogical(StepTerms)
            % An edge usage case is a logical vector not the length of the
            % term vector.
            StepTerms = find(StepTerms);
        end
        
        if numel(StepTerms)~=1 || any(~m.TermsOut(StepTerms))
            FULL_REFRESH = true;
        end
    end


    m.TermsOut(m.TermStatus==1)= false;
    m.TermsOut(m.TermStatus==2)= true;
    X(:,m.TermsOut)=[];

    if ~FULL_REFRESH && Nobs>100
        % the problem is large enough and we are just removing a single term

        % find term being deleted
        pos= sum(~m.TermsOut(1:StepTerms-1))+1;
        [Q,R,df,ri]= qrdelete(m,pos);
    else
        % need to compute the new Q and R
        [Q,R,OK,df,ri]= qrdecomp(m,X);
    end

    if ~OK
        return
    end

    % recalc coeffs
    m.Beta= zeros(size(m.Store.X,2),1);
    % pad the y (only has an effect for ridge)
    y = [m.Store.y; zeros(size(Q,1) - Nobs,1)];
    if ~all(m.TermsOut)
        m.Beta(~m.TermsOut)= R\(Q'*y);
    end
    % Store qr for use by stats and further stepwise
    m.Store.Q=Q;
    m.Store.R=R;
    if ~all(m.TermsOut)
        H = sum(Q.*Q,2);
        %truncate H for ridge
        % residuals
        r= y- Q*(Q'*y);
    else
        H= zeros(size(Q,1),1);
        r= y;
    end
    m.Store.H= H(1:Nobs,1);
    % truncate for ridge
    r = r(1:Nobs, 1);
    % calculate MSE
    if df>0
        mse = sum(r.*r)/df;
    else
        mse= 0;
    end

    if OK
        % store variance info
        m= var(m,ri*sqrt(mse),mse,df);
    else
        m= var(m,[],0,Inf);
    end
else
    Q= m.Store.Q;
    R= m.Store.R;
end

if nargout>2
    % Get Stepwise Stats
    [Stats,Bstd]=stats(m,'stepwise');
end
if nargout>3
    % find next terms

    beta  = m.Beta;
    NextPress= repmat(NaN,size(beta));

    % pad the y (only has an effect for ridge)
    y = [m.Store.y; zeros(size(Q,1) - Nobs,1)];
    FX= m.Store.X;

    % R2x = collinear(m);

    df= Stats(2,2)*ones(size(beta));    % df(SSE)= n-p

    TempTermsOut= m.TermsOut;
    % Add/Delete Terms to Model one at a time
    TermsIn= Terms(m);
    ChangeLam=  length(m.lambda)==length(beta);

    for i = find(m.TermStatus==3)'
        % toggle term 'i' in or out of model
        TermsIn(i) = ~TermsIn(i);
        if ChangeLam
            % need to change termsout so diag(lam)-FX'*FX works
            m.TermsOut(i)= ~TermsIn(i);
        end
        if ~TermsIn(i) && Nobs>100
            % use qrdelete for 'large' problems
            j= sum(TermsIn(1:i-1))+1;
            [q,r,dfi]= qrdelete(m,j);
            qrok= true;
        elseif TermsIn(i)
            % recalculate qr with rinv for insert terms
            Xt= FX(:,TermsIn);
            [q,r,qrok,dfi]= qrdecomp(m,Xt);
        else
            % recalculate qr is quicker for small problems
            Xt= FX(:,TermsIn);
            [q,r,qrok,dfi]= qrdecomp(m,Xt);
        end
        % Check for rank deficient cases
        if qrok
            if ~isempty(q);
                H= sum(q.*q,2);
                % truncate H for ridge
                H = H(1:Nobs,1);
            else
                H= 0;
            end

            res= y - q*(q'*y);
            % truncate res for ridge
            res = res(1:Nobs,1);
            if any(H==1)
                NextPress(i)= NaN;
            else
                NextPress(i) = sum( (res./(1-H)).^2 );
            end
            if TermsIn(i)
                % i.e. term was out and we are adding it back

                % Calculate STD of coeff.

                Xpos= find(TermsIn)==i;
                if Xpos>100
                    b = r(Xpos:end,Xpos:end)\(q(:,Xpos:end)'*y);
                    beta(i) = b(1);
                else
                    b = r\(q'*y);
                    beta(i) = b(Xpos);
                end

                df(i) = dfi;

                ei= zeros(1,size(r,1));
                ei(Xpos)= 1;
                if strcmp(m.qr,'ols')
                    r1= ei/r;
                else
                    r1= ((ei/r)/r')*Xt';
                end

                if df(i)
                    s2 = sum(res.*res)/df(i);
                    Bstd(i) = sqrt( s2 * r1*r1' );
                else
                    Bstd(i)= NaN;
                end

            end
        else
            % Rank deficient X matrix
            beta(i)     = NaN;
            Bstd(i)     = NaN;
            NextPress(i) = NaN;
        end
        % return term 'i' to starting state
        TermsIn(i) = ~TermsIn(i);
        if ChangeLam
            m.TermsOut(i)= ~TermsIn(i);
        end
    end

    B= [beta,Bstd,df,NextPress];
    m.TermsOut= TempTermsOut;
end

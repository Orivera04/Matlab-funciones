%
%     SOR Algorithm for Tridiagonal Matrix
%      
      function [u, m, w] =sorfin(n,a,b,c,d)
      maxm = 500;   % maximum iterations
      numi = 0; % counter for nodes satisfying error
      eps = .01; % error tolerance
      w = 1.65; % SOR parameter
      m = 1;
      for i = 1:n
            u(i) = 160.;    % initial guess
      end
      while ((numi<n)*(m<maxm)) % begin SOR loop
            numi = 0;
            utemp = (d(1) -c(1)*u(2))/a(1); % do left node
            utemp = (1.0-w)*u(1) + w*utemp;
            error = abs(utemp - u(1)) ;
            u(1) = utemp;
            if (error<eps) 
                numi = numi +1;
            end
            for i=2:n-1 % do interior nodes
                utemp = (d(i) -b(i)*u(i-1) - c(i)*u(i+1))/a(i); 
                utemp = (1.-w)*u(i) + w*utemp;
                error = abs(utemp - u(i)); 
                u(i) = utemp;
                if (error<eps) 
                    numi = numi +1;
                end
            end
            utemp = (d(n) -b(n)*u(n-1))/a(n);   % do right node
            utemp = (1.-w)*u(n) + w*utemp;
            error = abs(utemp - u(n)) ;
            u(n) = utemp ;
            if (error<eps) 
                numi = numi +1; % exit if all nodes "converged"
            end
            m = m+1;
      end
       
                        

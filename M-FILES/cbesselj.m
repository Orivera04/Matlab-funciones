function Jnu = cbesselj(nu,x)
%  -----   Calculate gamma function with a complex order   ----

kMax = 100;
tol = 1e-2;
Np = length(x);
x = x(:);

for m =1 :length(x)
    if isreal(nu)
        Jnu = besselj(nu, x);
    else
        Jnu(m) = 0.0;
        for k = 0:kMax
            JnuLast(m) = Jnu(m);
            Jnu(m) = Jnu(m) + (-0.25*x(m)*x(m))^k/(gamma(k+1)*cgamma(nu+k+1));
            if real(Jnu(m))~=0
                Rerr = abs((real(Jnu(m)) - real(JnuLast(m)))./real(Jnu(m)));
            end
            if imag(Jnu(m))~=0
                Ierr = abs((imag(Jnu(m)) - imag(JnuLast(m)))./imag(Jnu(m)));
            end
            if exist('Ierr') && exist('Rerr')
                if max(Rerr) <= tol && max(Ierr) <= tol
                    break;
                end
            elseif exist ('Rerr')
                if max(Rerr) <= tol
                    break;
                end
            end
        end
        Jnu(m) = Jnu(m)*(0.5*x(m)).^nu;
        if k == kMax
            disp('Algorithm does not converge in the calculation of bessel function. Maximum concurence number arrived!');
        end
    end
end
Jnu=Jnu(:);


% if isreal(nu)
%     Jnu = besselj(nu, x);
% else
%     Jnu = zeros(Np,1);
%     for k = 0:kMax
%         JnuLast = Jnu;
%         Jnu = Jnu + (-0.25.*x.*x).^k/(gamma(k+1)*cgamma(nu+k+1));
%         if real(Jnu)~=0
%             Rerr = abs((real(Jnu) - real(JnuLast))./real(Jnu));
%         end
%         if imag(Jnu)~=0
%             Ierr = abs((imag(Jnu) - imag(JnuLast))./imag(Jnu));
%         end
%         if exist('Ierr') && exist('Rerr')           
%             if max(Rerr) <= tol && max(Ierr) <= tol
%                 break;
%             end
%         elseif exist ('Rerr')
%             if max(Rerr) <= tol
%                 break;
%             end 
%         end
%     end
%     Jnu = Jnu.*(0.5*x).^nu;
%     if k == kMax
%         disp('Algorithm does not converge in the calculation of bessel function. Maximum concurence number arrived!');
%     end
% end    

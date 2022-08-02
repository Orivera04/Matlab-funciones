function new_eta = adjeta(eta, rmse)
% ADJETA Adjust learning rate eta in SD according to history of RMSE.

inc_rate = 1.01;
dec_rate = 0.99;
leng = length(rmse);
if leng < 5,
	new_eta = eta;
	return;
end

diff_rmse = diff(rmse(leng-4:leng));

% Four consecute downs
if all(diff_rmse<0)
	new_eta = eta*inc_rate;
% Four consecute ups
%elseif all(diff_rmse>0)
%	new_eta = eta*dec_rate;
% down, up, down, up
%elseif diff_rmse(1)<0 & diff_rmse(2)>0 & diff_rmse(3)<0 & diff_rmse(4)>0,
%	new_eta = eta*dec_rate;
% up, down, up, down
elseif diff_rmse(1)>0 & diff_rmse(2)<0 & diff_rmse(3)>0 & diff_rmse(4)<0,
	new_eta = eta*dec_rate;
else
	new_eta = eta;
end

%this function converts the data into a single row and plots it wtith the relevant information
function stocks = processInflationData(data)
[row cols] = size(data)
stck = zeros((row-1)*(cols-1),1)
counter = 1 
for i = 1:row
    for j = 2:cols
        if isnan(data(row-i+1,j)) == 1
            data(row-i+1,j) = 0
        end    
      stck(counter,1) =  data(row-i+1,j)+0.001
      counter = counter + 1
    end
end    
        


%plot(stck)

%Thoroughout the paper, the in?ation trend is de?ned as the low-frequency component of the data (?uctua-
%tions longer than 32 quarters) extracted using the band pass ?lter approximation of Christiano and Fitzgerald
%(2003). Similar results are obtained if the data are detrended using the Hodrick-Prescott ?lter with a smoothing
%parameter of 1600.    14400 for monthly data
%6Another commonly-used measure of persistence is the sum of the autoregressive coe¢ cients in a univariate
%regression. In the case of an AR(2) with coe¢ cients 1 and 2; we have Corr (t; t?1) = 1= (1 ? 2) : Thus,
%both measures of persistence are increasing in 1 and 2:

%detrend data odrick-Prescott ?lter
%stck = log(stck)
%plot data
[stck] = hpfilter(stck',14400)
%plot(stck)
%Autocorrelation coefficient, rolling 20 years 
%Volatility is measured by the 20-year rolling standard deviation
skew = skewness(stck)
kurto = kurtosis(stck)
%Over the full sample, U.S. in?ation exhibits positive skewness and excess kurtosis,
%particularly in the detrended data. Overall, the time-varying and non-Gaussian features of
%the data indicate the presence of nonlinearities in the law of motion for U.S. in?ation.


%Estimation of inflation model
%start with nkpc: new keynesian phillips curve

%The driving variable can be interpreted as either the output gap (often measured by de-
%trended real GDP) or the representative ?rm?s real marginal cost (often measured by labor?s
%share of income)


%pi_t = log difference
%beta = represent. agent. subjective time discount factor
%epsilon = iid markup shck motivated by variable tax rate
%E^ is the subjective expectation, ocnditional on driving variable and markup shock
%y (stable AR1) is either driving variable y_t = ro * y_t-1 + ut.


pi_t = beta * E^t pi_t+1  + lambda*y_t + epsilon_t
beta E (0,1)
lambda >0
epsilon~ N(),sigma^2)
U_t~ N(),sigmaU^2)








end
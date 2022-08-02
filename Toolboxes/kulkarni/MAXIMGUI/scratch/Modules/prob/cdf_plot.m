function cdf_plot(title_bar, title, std_state, scalar)

% Plots CDF
global Scale
title = [title ' - CDF'] ;

plotfig = figure('Name', title_bar, ...
                 'Color',[0.8 0.8 0.8], ...
                 'Units', 'normalized', ...
	              'Position', [.45 .1 .54 .75], ...
                 'Menubar', 'none', ...
                 'NumberTitle', 'off', ...
	              'Tag','plotfig');

% Menu options for this figure
exit = uimenu(plotfig, ...
              'Label', 'Close Figure',...
              'Tag','CloseFig', ...
              'Callback','close') ;
prnt = uimenu(plotfig, ...
              'Label', 'Print Graph', ...
              'Tag', 'PrintGraph', ...
              'Callback', [sprintf('title(''%s'');', title), ...
                           'print -dwin -v']) ;

% Titles
uicontrol('Parent',plotfig, ...
          'Units','normalized', ...
          'Position',[.25 .93 .5 .07], ...
          'BackgroundColor',[0.8 0.8 0.8], ...
          'Fontsize', Scale*14, ...
          'Style','text', ...
          'String', title, ...
          'Tag','Title');

switch std_state

  % Binomial
  case 1
    k = scalar(1);
    p = scalar(2) ;
    stairs([0:k], bincdf(k,p))
   
  % Erlang
  case 2
    k = scalar(1) ;
    l = scalar(2) ;
    kmax = (k/l)+5*sqrt(k/l^2);
    kmin = max(0,(k/l) - 5*sqrt(k/l^2));
    x = [kmin:((kmax-kmin)/50):kmax];
    plot(x,erlangcdf(k,l,x))

  % Exponential
  case 3
    l = scalar(1) ;
    k = -log(0.0001)/l ;
    x = [0:(k/50):k];
    plot(x,(1-exp(-l*x)))

  % Geometric
  case 4    
    p = scalar(1) ;
    k = ceil(log(.00001)/log(1-p)) ;
    temp = geometriccdf(p,k);
    stairs([0:k-1], temp)

  % Negative Binomial
  case 5    
    r = scalar(1) ;
    p = scalar(2) ;
    k = ceil(r/p + 5*sqrt(r*(1-p)/p^2)) ;
    temp = negbincdf(r,p,k);
    temp(1:(r-1)) = [];
    stairs([r:(r+k)], temp);

  % Normal
  case 6
    mu = scalar(1) ;
    sigma = scalar(2) ;
    k = 5*sqrt(sigma);  
    x = [-k+mu:(k/25):k+mu];
    plot(x,normalcdf(mu,sigma,x))

  % Poisson
  case 7
    l = scalar(1) ;
    k = round(max(10, l + 5*sqrt(l)));
    temp = poissoncdf(l,k);
    temp(1) = [];
    stairs([1:k], temp)
   
end % switch std_state

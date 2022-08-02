%ticDistance=eticdis ( axesLength,maxTics)
% compute tic distance for axes
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function ticDistance=eticdis(axesLength,maxTics)

  % test parameter
  if (nargin~=2)
    eusage('ticDistance=eticdis(axesLength,maxTics)');
  end
  if maxTics<2
    maxTics=2;
  end
  if axesLength<0
    axesLength=axesLength*(-1.0);
  end

  % get exponent
  factor=[0.5 2 1];
  exponent=1; 
  while axesLength>=1.0
    axesLength=axesLength/10;
    exponent=exponent*10;
  end

  % get distance factor
  ticDistance=factor(3);
  i=1; 
  currentTics=axesLength/factor(i); 
  while currentTics<=maxTics
    ticDistance=factor(i);
    i=i+1;
    if i>3
      i=1;
    end
    factor(i)=factor(i)/10;
    currentTics=axesLength/factor(i);
  end

  ticDistance=ticDistance*exponent;

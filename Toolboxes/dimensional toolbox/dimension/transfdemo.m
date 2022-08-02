function varargout = transfdemo()
% SPHEREDEMO2 DA demo with data transformation

% Steffen Brueckner, 2002-02-07

% define variable names
N     = {'q'    ,'d','u'  ,'nu'  ,'D'};
% define units of the variables
u     = {'kg/m2','m','m/s','m2/s','kg'};

% select base variables
bvars = {'q','d','u'};

% transform to SI units
[Dimension,Factor] = unit2si(u);

% create relevance list
RL                 = rlist(N,Dimension,Factor);

% determin piset (do the dimensional analysis)
piset              = diman(RL,bvars);

% load data
% MyFilename = mfilename;
% MyPath = fileparts(which(MyFilename));
dbs = dbstack;
MyPath = fileparts(dbs(1).name);

FNAME = fullfile(MyPath,'demodata','spheredata');
FData = load(FNAME);
spheredata = FData.Kugel';

% transform to SI units
spheredata = data2si(spheredata,RL);

% transform the data
pidata = dtrans(spheredata,piset);

% now plot the dimensionless data
figure
semilogx(1./pidata(1,:),pidata(2,:),'+')
xlabel('Re'), ylabel('c_W'), title('dimensionless plot');

if nargout >= 1
    varargout{1} = pidata;
end
if nargout == 2
    varargout{2} = piset;
end
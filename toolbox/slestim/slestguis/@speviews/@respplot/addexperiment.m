function addexperiment(this,Experiment)
% Adds new experiment and resizes plot

% Author(s): P. Gahinet
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:21:08 $
ExpName = Experiment.Description;
if any(strcmp(ExpName,this.InputName))
   return
end

% Update list of experiments
NewInputs = [this.InputName {ExpName}];
this.TimeFocus = [this.TimeFocus getfocus(this,Experiment)];

% Update list of ports
[NewPorts,NewPortSizes] = getPortHandles(Experiment);
NewPorts = [this.OutputPort ; NewPorts];
NewPortSizes = [this.OutputPortSize ; NewPortSizes];
[this.OutputPort,iu] = unique(NewPorts);
this.OutputPortSize = NewPortSizes(iu);

% Resize plot
this.resize(utGetPortName(this.OutputPort),NewInputs)

% Redraw
draw(this)

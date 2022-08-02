function [Result, Output] = quadg (fun,a,b,opts,varargin)
%QUADG  Numerical quadrature using open methods.
%   Q = QUADG(fun,a,b) approximates the integral of fun
%   from a to b using some type of Gaussian quadrature.
%
%   The default type is a Gauss-Kronrod, 7(15) order.
%
%   Q = QUADG(fun,a,b,options) allows integrations option to
%   be specified.  
%
%   Q = QUADG(fun,a,b,options,p1,p2,...) will pass the extra 
%   parameters p1, p2, ... to fun.
%
%   Options is a structure specifying any of the following options:
%
%       Field name              Parameter           Possibilites and {Default}
%
%       options.tol             Tolerance           [{1e-6}, any fractional number]
%       options.diplay          Display on/off      [{'off'}, 'on']
%       options.nodes           nodes               [vector, {Gauss-Kronrod nodes}]
%       options.weights         weights             [matrix, {Gauss-Kronrod weights}]
%
%   Using options=[] will use the default options.
%
%   Tolerance is based on the relative error.  With double-precision  
%   arithmetic, feasible values for this parameter range 
%   from 1e-15 to 1.  The default is 1e-6.  
%
%   Setting the display on shows the integrand samples and a histogram
%   of their distribution, as well as a table reporting the progress of 
%   the integration as it proceeds.  Note that the display will slow down 
%   the performance of the quadrature.
%
%   The nodes and weights parameters are discussed in the 
%   "Advanced Features" section in the source code just after
%   the help entry.  Type 'edit quadg' to see this note.  There's 
%   no need to use this option unless you like playing with other 
%   people's source code and know what you're doing (and can 
%   figure out what I was doing).
%
%   Example:
%
%      f = inline('cos(x).*sin(x.*x)');
%      options.display = 'on';
%      quadg(f,-2*pi,2*pi,options)
%    
%      Increasing the range of this quadrature will cause most recursive 
%      to slow dramatically and run out of stack space.
%
%   See the source code for additional comments.  
%
%   See also QUADL, QUAD, DBLQUAD, INLINE, @.

%   ========================================================
%   ADVANCED FEATURES -- DEFINING YOUR OWN WEIGHTS AND NODES
%   --------------------------------------------------------
%   You can also provide your own nodes and weights to this
%   function, allowing you to use this code as a harness for
%   any integration method you like.  Your weights and nodes 
%   should be defined for an integration over [-1,+1]
%
%   This is an advanced feature.  Unless you're really interested
%   in using your own quadrature, there's no need to worry about this.
%
%   The QUADG function has two alternate algorithms which you can 
%   access in this way.  For example:
%
%       [options.nodes options.weights] = quadg('gausskronrod')
%
%   returns values for a Gauss-Kronrod 7(15) order quadrature,
%
%       [options.nodes options.weights] = quadg('gausslegendre',p)
%
%   returns values for a p-th order Gauss-Legendre quadrature.  Then:
%
%       quadg(f,a,b,options)
%
%   will integrate f using the algorithm specified.
%
%   options.nodes and options.weights should be defined as a one
%   column vector and a two row matrix, respectively, so that:
%
%       2*options.weights*feval(fun,a)
%
%   returns a 2 by 1 vector of the lower and higher order estimates 
%   for an integration over [-1,+1].  For example:
%
%       >> [opts.nodes opts.weights] = quadg('gausslegendre',2);
%
%       >> opts.nodes
%        ans =
%           -0.5774
%            0.5774
%           -0.7746
%                 0
%            0.7746
%
%       >> opts.weights
%        ans =
%            0.5000    0.5000         0         0         0
%                 0         0    0.2778    0.4444    0.2778
% 
%       >> 2*opts.weights*cos(opts.nodes)
%        ans =
%           1.6758
%           1.6830
%     
%   These are the 2-nd and 3-rd order estimates for the integral of cosine
%   taken over the range [-1,+1]

%   =============================================
%   MISCELLANEOUS COMMENTS
%   ---------------------------------------------
%   IMO, the iterative imlementation here is interesting to see; it's what 
%   makes this code fast.  
%
%   One way to test the accuracy of this code is to use the Symbolic Toolbox
%   to compute analytical results for some representative test integrands, 
%   and compare those to the results this code produces.
%
%   Pros of this code:
%       - fast and accurate (esp the default Gauss-Kronrod algorithm)
%       - nice graphical display
%       - can use your own nodes and weights 
%       - interesting iterative implementation (contrasts with the
%         typical recursive implementations often used)
%
%   Cons:
%       - though they works well in practice, the stopping criteria 
%         are simple (see QUADL for better ideas)
%
%   I have not compared this to the quadrature functions in MATLAB, but the more tools
%   you have in your quadrature collection the better off you'll be.  
%
%   If someone wants to clean up this code, please feel free to do so and
%   let me know; I'll gladly accept any useful modifications and incorporate them
%   into this file.  It's sloppy in some places, and there are other places where I'm
%   using KRON and SPDIAGS when I shouldn't.
%
%   Another more sophisticated enhancement would be to add code calculating 
%   the Kronrod extension nodes for any order quadrature.  I'm not sure if 
%   these extended nodes can be derived in a straightforward way, however. 
%
%   This function hasn't been extensively tested, and I haven't put in any "tweaks"
%   to account for bad inputs or any type of error checking.  
%
%   Please note that this file is *not* officially supported by The MathWorks. 
%
%   Nabeel Azar
%   nabeel@mathworks.com
%   nabeel@ieee.org
%
%   $Revision: 0.1 $  $Date: 1998 $

%______________________________________________________________
%  Input checking:

%   Are they calling it to just obtain nodes and weights?
%   If so, calculate them and then return
if isa(fun,'char')
    switch(lower(fun))
    case 'gausslegendre'
        if nargin>1; order = a; else; order = 7; end
        [Result Output] = gausslegendre(order);
        return
    case 'gausskronrod'
        [Result Output] = gausskronrod(7);
        return
    otherwise
        %   Do nothing and keep going
        msg = sprintf(['Assuming your first input is the name of\n',...
                'the function you want to integrate.  If you are\n',...
                'using MATLAB 6.0 or later, you should use\n',...
                'function handles to specify the function.']);
        warning(msg)
    end
end

%   If we're here, we're performing a quadrature.
%   We need at least 3 inputs
msg = nargchk(3,Inf,nargin);
if msg
    error(msg)
end

switch nargin
case 3; 
    %  Only 3 inputs, no options, no params
    Options = optionscheck([]); 
otherwise
    %   Options given, 
    Options = optionscheck(opts);
end
ExtraParameters = varargin;

%  End input checking
%--------------------------------------------------------------

%   Dynamically set MaxIter so no interval can 
%   be narrower than EPS.  The algorithm
%   typically stops well below MaxIter,
%   and throws a warning if it hits it.  
MaxIter = floor(log2(abs(b-a)/eps));
MaxIter = min(MaxIter,1024);

%   Set loop parameters and orient a and b as columns
Iter = 0;
Result = 0;
Tol = abs(Options.tol);
OutputOn = (nargout>=2);
a = a(:); b = b(:);

%  If verbosity is on, setup the figure window
if strcmp(Options.display,'on')
   %  Using verbose display also stored the information
   %  found in the second output argument.
   OutputOn = 1;
   %  Predefine storage for the data sets
   AllNodes = [];  AllIntegrand = [];  
   verbosity = 1;
   [Fig Axis Listbox HistogramAxis Spaces] = initializefigure(Options,fun,a,b);
   %  Start runtime counter
   t0 = cputime;
elseif OutputOn==1
   %  Predefine storage for the data sets
   AllNodes = [];  AllIntegrand = [];  
   verbosity = 0;
   t0 = cputime;
else
   verbosity = 0;
end


%______________________________________________________________
%  3)  Get the integration nodes and weights
%      for the first level and the second level
%      of checks.
X = Options.nodes;
W = Options.weights;
%--------------------------------------------------------------

%______________________________________________________________
%  4)  Begin the WHILE loop over which the integrand
%      is estimated.
%
%      This is where the real work takes place.  The code in this
%      loop isn't too difficult to follow.  Everything
%      up to the "if OutputOn" part is the actual quadrature;
%      the rest of the loop is just for options.
while ~isempty(a) & Iter<=MaxIter
   %  Increment iteration
   Iter = Iter + 1;

   %  Obtain nodes for the integration
   Nodes = scalex(X,a,b);
               
   %  Evaluate the integrand
   Integrand = feval(fun,Nodes,ExtraParameters{:});

   %  Scale integrand and compute the estimates.
   Estimates = W*Integrand*spdiags((b-a).',0,length(a),length(a));

   %  Find where the estimates are close and 
   %  remove the regions that had good estimates.
   %  This tolerance checking is simple, but works ok in practice.
   GoodRegions = abs((Estimates(1,:) - Estimates(2,:))./Estimates(2,:)) <=Tol;
   a(GoodRegions) = []; b(GoodRegions) = [];

   %  Update the integral to include the good regions.
   Result = Result + Estimates(2,:)*GoodRegions(:);

   %  Halve the remaining intervals
   %  Keep the a and b as row vectors.
   Middle_Terms = (a+b)/2;
   a = [a Middle_Terms].'; a = a(:).';
   b = [Middle_Terms b].'; b = b(:).';

   %  End of the "real work".  The code below is
   %  for the graphical and optional output.
   
   %  Check verbosity and output storage
   if OutputOn
      %  Store the Nodes and Integrand Values
      AllNodes =  [AllNodes; Nodes(:)];
      AllIntegrand =  [AllIntegrand; Integrand(:)];
      if verbosity
          % Update the listbox
          updatefigure(Listbox,Axis,Iter,Nodes,GoodRegions,Integrand)          
      end   
   end  %   End of verbose output section

end 
%  End of the main while loop
%--------------------------------------------------------------

if Iter>=MaxIter
   warning('Reached maximum iterations; result may be inaccurate')
end 

%______________________________________________________________
%  Define output structure and update display if necessary
%--------------------------------------------------------------
if OutputOn
   ElapsedTime              = cputime - t0;
   Output.Iterations        = Iter;
   Output.FunctionSamples   = length(AllNodes);
   [Output.Nodes idx]       = sort(AllNodes);
   Output.Integrand         = AllIntegrand(idx);
   Output.Time              = ElapsedTime;
   Output.basicNodes        = Options.nodes;
   Output.basicWeights      = Options.weights;
   if verbosity
      axes(Axis)
         %  Plot the points of the integrand used to compute the result
         AllNodes = Output.Nodes; AllIntegrand = Output.Integrand;
         plot(AllNodes,AllIntegrand,'Linewidth',1.5,'Color','r')

         %  Update the title
         Title = get(Axis,'title');
         title([get(Title,'String') ' = ' num2str(Result)])
         set(Title,'Fontweight','bold')

         %  Plot a histogram of the samples
      axes(HistogramAxis)
         if round(length(AllNodes)/15)>1
            bins = min(round(length(AllNodes)/15),length(AllNodes));
         else
            bins = length(AllNodes);
         end
         hist(AllNodes,linspace(min(AllNodes),max(AllNodes),bins))
         xlim([min(AllNodes) max(AllNodes)])
         ylabel('Count')
         Tstring = [num2str(length(AllIntegrand)) ' fcn samples, ',...
                    num2str(ElapsedTime) ' seconds.'];
         title(Tstring,'Fontweight','Bold','Fontname','FixedWidth');

      setptr(Fig,'arrow')
      drawnow
   end
end
%--------------------------------------------------------------


%*********************************************************
%  End of main function, subfunctions are below
%  First the computationally relevant subfunctions, 
%  followed by the graphical and interface related 
%  functions.
%*********************************************************


%*********************************************************
function ScaledX = scalex(X,a,b);
%  This function scales the abscissae to the proper values, 
%  in a vectorized fashion.
%
%   I used KRON, but this should probably be rewritten to 
%   avoid this.
a = a(:); b = b(:);
Node_Scale  = (b-a)/2;
ScaledX = kron(Node_Scale.',X) + repmat((Node_Scale+a).',length(X),1);


%*********************************************************
function [X, W] = gausslegendre(order)
%   This function generates the nodes and weights
%   for a Gauss Legendre quadrature over [-1,1].
%   Note that the weights and nodes for both the lower
%   order and higher order accuracy check are created, so:
%   
%   X(:,1:?) = nodes for lower order quadrature
%   X(:,?:end) = nodes for higher order quadrature
%       and
%   W(1,:) = weights for lower order quadrature
%   W(2,:) = weights for higher order quadrature
%
%       and
%
%   Q = W*feval(X.')*span_of_integration
%   where Q(1,:) = quadrature estimate from lower order method
%   and   Q(2,:) = quadrature estimate from higher order method.

%  Generate the weights and the abscissa for the first pass
vector =(1:order-1)./sqrt((2*(1:order-1)).^2-1);
[w1,xi1]=eig(diag(vector,-1)+diag(vector,1));
xi1 = diag(xi1);
w1=w1(1,:)'.^2;

%  Now generate the weights and abscissae for the second
%  pass.  Append that to the first pass values, so that
%  W*X gives [first_pass_quadrature; second_pass_quadrature];
vector =(1:order)./sqrt((2*(1:order)).^2-1);
[w2,xi2]=eig(diag(vector,-1)+diag(vector,1));
xi2 = diag(xi2);
w2=w2(1,:)'.^2;

X = [xi1; xi2];

First_w  = [w1(:).' zeros(1,order+1)];
Second_w = [zeros(1,order) w2(:).'];
W = [First_w; Second_w];

%  Normalize the weights - depending on how you scale various values,
%  this may not be necessary.
%  I'm doing this just to be careful about things...
W = diag(1./sum(W,2))*W;
%*********************************************************


%*********************************************************
function [X, W] = gausskronrod(order)
%   This function generates the nodes and weights
%   for a Gauss Kronrod quadrature over [-1,1].
%
%   See gausslegendre for an explanation of how the
%   outputs are specified.

if order~=7
    error('Only 7(15) order available for Gauss-Kronrod')
    return
end

%  First get the Gauss-Legendre weights
[GX GW] = gausslegendre(order);

%  Get the weights and abscissae I need and
%  sort them to make later work easier
GW = GW(1,1:order); GX = GX(1:order,1);
[GX idx] = sort(GX);
GW = GW(idx);
%  Now add on the new abscissae and form the 
%  new weights to make up the Kronrod extension.
Positive_Kronrod_Additional_Nodes = [...
        0.9914553711208126392068546; 0.8648644233597690727897127;
        0.5860872354676911302941448; 0.2077849550078984676006894];
Kronrod_Weights = [...
        0.0229353220105292249637320, 0.0630920926299785532907006,...
        0.1047900103222501838398763, 0.1406532597155259187451895,...
        0.1690047266392679028265834, 0.1903505780647854099132564,...
        0.2044329400752988924141619, 0.2094821410847278280129991];
Kronrod_Weights_for_Original_Nodes = Kronrod_Weights(2:2:end);
Kronrod_Weights_for_Additional_Nodes = Kronrod_Weights(1:2:end);

%  Put all the nodes together and sort them
X = [   GX(:);...
        Positive_Kronrod_Additional_Nodes;...
        -Positive_Kronrod_Additional_Nodes];
Kronrod_Weights = Kronrod_Weights(idx);

W = [   GW(:).' zeros(1,order+1);
        Kronrod_Weights_for_Original_Nodes,...
        Kronrod_Weights_for_Original_Nodes((end-1):-1:1),...
        Kronrod_Weights_for_Additional_Nodes,...
        Kronrod_Weights_for_Additional_Nodes];

%  Normalize the weights
W = diag(1./sum(W,2))*W;
%*********************************************************






%*********************************************************
%  Graphics and interface subroutines below.
%*********************************************************
function updatefigure(Listbox,Axis,Iter,Nodes,GoodRegions,Integrand)
%  Update the listbox
Str = sprintf('Iteration %2.1i %4.1i (%4.3g%%) %8.1i %9.1i',...
    Iter,...
    full(sum(GoodRegions)),...
    full(100*sum(GoodRegions)/length(GoodRegions)),...
    full(sum(~GoodRegions)),...
    prod(size(Integrand)));

Current_String = get(Listbox,'String');
set(Listbox,'String',[Current_String(1);{Str};Current_String(2:end)])

%  Update the plot
axes(Axis)
stem(Nodes(:),Integrand(:));
drawnow

%  Pause to so that the animation can be seen
pause(.25)
%*********************************************************



%*********************************************************
function [Fig, Axis, Listbox, HistogramAxis, Spaces] = ...
         initializefigure(Options,fun,a,b);
   %  Initialize figure window display
   if isa(fun,'function_handle');
       fun = func2str(fun);
   else
       fun = char(fun);
   end
   Fig = figure('Name',[' Integration of ' fun],...
                       'Doublebuffer','on',...
                       'NumberTitle','off',...
                       'Units','normalized','Position',[.15 .2 .6 .7]);
         setptr(Fig,'watch')
   Axis = subplot(3,1,1);
      set(Axis,'units','normalized','xlim',[min(a,b) max(a,b)])
      AxPos = get(Axis,'position');
   TexTitle = ['_{' num2str(a) '}^{' num2str(b) '}' texlabel(fun) ];

   Title = title(['\int' TexTitle]);
      ylabel('Integrand')
   hold on

   Spaces = blanks(4);
   S = [    'Iteration #' Spaces 'Successes' Spaces ...
            'Failures' Spaces 'Samples'];

   Listbox = uicontrol('Style','Listbox','Units','Normalized',...
            'Position',[AxPos(1) .05 AxPos(3) .3],'Back',[1 1 1],...
            'Fore',[0 0 0],'String',{S},'Fontname','FixedWidth');

   HistogramAxis = subplot(3,1,2);
      set(HistogramAxis,'units','normalized','xlim',[min(a,b) max(a,b)])
%*********************************************************


%*********************************************************
function Options = optionscheck(opts)
%  This function checks options and
%  returns a structure of options along with the 
%  extra parameters the user wants to pass to the 
%  integrand function.

%  Set the defaults here:
Options.tol = 1e-6;
Options.display = 'off';
[Options.nodes Options.weights] = feval(@gausskronrod,7);

if isempty(opts); return; end

%  Loop through the fields of Options and
%  set the defaults as appropriate
Fields   = {'tol','display','nodes','weights'};
for i = 1:length(Fields)
    f = Fields{i};
    if isfield(opts,f) & ~isempty(getfield(opts,f))
        Options = setfield(Options,f,getfield(opts,f));
    end
end


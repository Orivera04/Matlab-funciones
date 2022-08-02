function list = staticlist( m )
%XREGARX/STATICLIST   List of static models avalible for use with XREGARX
%   LIST = STATICLIST(M) is a list of static models avalible for use with ARX 
%   dynamic modeling. LIST ois a structure array with the following fields:
%     Class - object class.
%     Name  - string, model type identification.
%
%   Required properties
%   -------------------
%   'delmat' - Dynamic order and delay matrix. It is only required that this be 
%              set by the constructor. Because a change in the dynamic order 
%              means a change in the number of inputs to the embedded model, 
%              when the dynamic order changes a new model is created. Before 
%              deleting the old model, the PersistentOptions are saved and then 
%              set when the new model has been created. This deletion and 
%              creation is handled by RESETSTATICMODEL, which also handles the 
%              naming of input factors, etc.
%
%   'InitialConditions' - Initial values of outputs for evaluation.
%
%   'Mode'   - Can be set to either 'Series-Parallel' or 'Parallel'. This 
%              determines how the model evaluation and operations like X2FX 
%              should be performed during model fitting. In 'Series-Parallel' 
%              mode there is no feedback of the model outputs to the input. 
%              Instead these inputs are taken from the measured values. In 
%              'Parallel' mode the model outputs from previous evaluations are 
%              used rather than measured inputs. 'Series-Parallel' will in 
%              general have faster fitting times but 'Parall' should lead to 
%              better models for simulation.
%
%   'PersistentOptions' - These are options that are independent of the number 
%              of input factor to the static model that might be set by the 
%              user. These are options are got before deletion of an old model 
%              and set after creation of a new model. This means that these 
%              options will not be lost when the user changes the dynamic order 
%              or delay. These options can take the form of any sort of object 
%              but the SET method should expect as input exactly what the GET 
%              methods gives as output.
%
%   Required methods
%   ----------------
%   These models are usually minor extensions to existing XREGLINEAR models. As 
%   such they should support all the functionality of an XREGLINEAR model plus 
%   the functionality described below.
%
%   XREG<..>  - Constructor should support the syntax SM = XREG<..>(DELMAT), 
%              where DELMAT is a dynamic order and delay matrix.
%
%   GET/SET  - Should support the gettting and setting of all parent model 
%              properties as well as 'Mode', 'PersistentOptions' and 
%              'InitialConditions'. It should be possible to GET 'delmat', but 
%              it should not be SET'able.
%
%   EVAL     - Redirect to EVAL if Mode == 'Series-Parallel' or to FEEDBACKEVAL 
%              if Mode == 'Parallel'.
%
%   DYNEVAL  - This method must explictly call DYNEVAL on the parent model, e.g.,
%                 [varargout{1:nargout}] = dyneval( m.parent, varargin{:} );
%              The EVAL method for static models assumes that it has been called 
%              from a method written for the non-dynamic case. As such, it 
%              performs a redirection to some more appropriate evaluation 
%              routine. So that XREGMODEL/DYNEVAL calls the correct, i.e., 
%              non-dynamic, EVAL method, it must get called with a pure static 
%              model, i.e., no dynamic knowledge at.
%
%   X2FX     - Redirect to X2FX if Mode == 'Series-Parallel' or to FEEDBACKX2FX 
%              if Mode == 'Parallel'.
%  
%   GLOBALBUTTONS - Supplies the toolbar buttons and utilities menu items that 
%              the XREGARX model can inherit from the embedded static model. 
%              Callbacks from these buttons and menu items must remember that 
%              the current node on model browser tree has an XREGARX model and 
%              not a model of their own type.
%
%   See also XREGARX/RESETSTATICMODEL
% 
%   Current static models 
%      XREGDYNLOLIMOT   Extension of XREGLOLIMOT
%      XREGDYNRBF   Extension of XREGRBF

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:45:39 $


list(1).Class = 'xregdynlolimot';
list(1).Name = 'LOLIMOT';

% list(2).Class = 'xregdynrbf';
% list(2).Name = 'Radial Basis Function';

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

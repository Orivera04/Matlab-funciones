%XREGARX/ABOUT_CODING   Help on how coding is implemented for XREGARX models
%   All models operate in two modes: fitting (training) and evaluation 
%   (simulation).
%
%     Fitting:
%                      +------------+
%       inputs (x) --->| XREGMODEL/ |---> model (m)
%       outputs (y) -->|   FITMODEL |
%                      +------------+
%     Evaluation:
%                      +------------+
%       inputs (x) --->| XREGMODEL/ |---> predictions (yhat)
%       model (m) ---->|  EVALMODEL |
%                      +------------+
%
%   If there is no feedback inside the XREGARX model, then coding is trival: it 
%   only effects the genuine inputs and is all handled by the XREGMODEL 
%   inherited by the XREGARX model.
%
%   In the case that there is feedback, things get a little more complicated. 
%   The XREGMODEL inherited by the XREGARX model handles the coding of the 
%   genuine inputs but the embedded static model needs to be told the ranges of 
%   of the feedback inputs. This is done in XREGARX/RUNFIT. The input to the 
%   static model fitting method, i.e., FITMODEL, is the genuine model inputs in 
%   coded units and the feedback outputs in natural units. FITMODEL will then 
%   encode this data: the genuine inputs will be unaffected as the static model 
%   will have [-1,1] as the range of those terms and the feedback outputs will 
%   be correctly coded.
%
%   During fitting the model must evaluate itself and use these predictions as 
%   inputs at subsequent timesteps. Because these feedback inputs must be in 
%   coded units, the outputs (y) to the static model fitting process get coded 
%   first. Thus the predictions made by the static model are in coded units and 
%   suitable to be feed back in as inputs. It also means that in evaluation 
%   mode that output of the static model must be uncoded before output from the 
%   XREGARX model. This uncoding is done in XREGARX/EVAL.
%
%   See also XREGMODEL, XREGMODEL/FITMODEL, XREGARX, XREGARX/RUNFIT, 
%       XREGARX/EVAL
%
%   Routines for handling coding
%      XREGMODEL/CODE   Perform input (x) coding
%      XREGMODEL/INVCODE   Invert input (x) coding
%      XREGMODEL/SETCODE
%      XREGMODEL/GETCODE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:44:37 $

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|


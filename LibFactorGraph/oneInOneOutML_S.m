function oneInOneOutML_S(block)
%SourceBlockS Level-2 MATLAB S-Function for SourceBlock
%%
%% The setup method is used to set up the basic attributes of the
%% S-function such as ports, parameters, etc. Do not add any other
%% calls to the main body of the function.
%%
setup(block);

%endfunction

%% Function: setup ===================================================
%% Abstract:
%%   Set up the basic characteristics of the S-function block such as:
%%   - Input ports
%%   - Output ports
%%   - Dialog parameters
%%   - Options
%%
%%   Required         : Yes
%%   C-Mex counterpart: mdlInitializeSizes
%%
function setup(block)

% Register number of ports
block.NumInputPorts  = 5;
block.NumOutputPorts = 3;

% Register parameters
%block.NumDialogPrms     = 3;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;

% Override input port properties - fX
% Override input port properties.
% d; used for indexing
block.InputPort(1).DimensionsMode = 'Inherit';
block.InputPort(1).Complexity = 'Real';
block.InputPort(1).DirectFeedthrough = true;

% Override input port properties - bY
block.InputPort(2).DimensionsMode = 'Inherit';
block.InputPort(2).Complexity = 'Real';
block.InputPort(2).DirectFeedthrough = true;

% Override input port properties - L
block.InputPort(3).DimensionsMode = 'Inherit';
block.InputPort(3).Complexity = 'Real';
block.InputPort(3).DirectFeedthrough = true;

% Override input port properties - Hin
block.InputPort(4).DimensionsMode = 'Inherit';
block.InputPort(4).Complexity = 'Real';
block.InputPort(4).DirectFeedthrough = true;

% Override input port properties - Nit
block.InputPort(5).DimensionsMode = 'Inherit';
block.InputPort(5).Complexity = 'Real';
block.InputPort(5).DirectFeedthrough = true;
% 
% % Override output port properties - bX
block.OutputPort(1).Complexity  = 'Real';
block.OutputPort(1).DimensionsMode = 'Fixed';

% Override output port properties - fY
block.OutputPort(2).Complexity  = 'Real';
block.OutputPort(2).DimensionsMode = 'Fixed';

% Override output port properties - H
block.OutputPort(3).Complexity  = 'Real';
block.OutputPort(3).DimensionsMode = 'Fixed';
% Register sample times
%  [0 offset]            : Continuous sample time
%  [positive_num offset] : Discrete sample time
%
%  [-1, 0]               : Inherited sample time
%  [-2, 0]               : Variable sample time
block.SampleTimes = [-1 0];

% Specify the block simStateCompliance. The allowed values are:
%    'UnknownSimState', < The default setting; warn and assume DefaultSimState
%    'DefaultSimState', < Same sim state as a built-in block
%    'HasNoSimState',   < No sim state
%    'CustomSimState',  < Has GetSimState and SetSimState methods
%    'DisallowSimState' < Error out when saving or restoring the model sim state
block.SimStateCompliance = 'DefaultSimState';

%% -----------------------------------------------------------------
%% Options
%% -----------------------------------------------------------------
% Specify if Accelerator should use TLC or call back into
% MATLAB file
block.SetAccelRunOnTLC(false);

%% -----------------------------------------------------------------
%% The MATLAB S-function uses an internal registry for all
%% block methods. You should register all relevant methods
%% (optional and required) as illustrated below. You may choose
%% any suitable name for the methods and implement these methods
%% as local functions within the same file. See comments
%% provided for each function for more information.
%% -----------------------------------------------------------------

block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
block.RegBlockMethod('InitializeConditions', @InitializeConditions);
block.RegBlockMethod('Start', @Start);
block.RegBlockMethod('Outputs', @Outputs);     % Required
block.RegBlockMethod('Terminate', @Terminate); % Required
block.RegBlockMethod('SetInputPortSamplingMode', @SetInputPortSamplingMode);
block.RegBlockMethod('SetInputPortDimensionsMode', @SetInputPortDimensionsMode);
block.RegBlockMethod('SetInputPortDimensions', @SetInpPortDims);
block.RegBlockMethod('SetOutputPortDimensions', @SetOutPortDims);
%end setup

%%
%% PostPropagationSetup:
%%   Functionality    : Setup work areas and state variables. Can
%%                      also register run-time methods here
%%   Required         : No
%%   C-Mex counterpart: mdlSetWorkWidths
%%
function DoPostPropSetup(block)
% end function  
%%
%% InitializeConditions:
%%   Functionality    : Called at the start of simulation and if it is 
%%                      present in an enabled subsystem configured to reset 
%%                      states, it will be called when the enabled subsystem
%%                      restarts execution to reset the states.
%%   Required         : No
%%   C-MEX counterpart: mdlInitializeConditions
%%
%block.AddOutputDimsDependencyRules(1, [1], @setOutputVarDims);
%block.AddOutputDimsDependencyRules(2, [2], @setOutputVarDims);;

function InitializeConditions(block)
%end InitializeConditions


%%
%% Start:
%%   Functionality    : Called once at start of model execution. If you
%%                      have states that should be initialized once, this 
%%                      is the place to do it.
%%   Required         : No
%%   C-MEX counterpart: mdlStart
%%
function Start(block)


%endfunction

%%
%% Outputs:
%%   Functionality    : Called to generate block outputs in
%%                      simulation step
%%   Required         : Yes
%%   C-MEX counterpart: mdlOutputs
%%
function Outputs(block)

    
    fX = block.InputPort(1).Data;
    
    L = block.InputPort(3).Data;
    Hin = block.InputPort(4).Data;
   
    nX = size(Hin,1);
    nY = size(Hin,2);
    nT = length(L);
    
    bY = block.InputPort(2).Data;
    
    % Init with uniform distribution 
    if (size(bY,2) ~= nY)       
        disp('Correction');
        bY = ones(nT,nY) ./ nY;    
        %block.InputPort(2).Dimensions = size(bY);
    end
    
    Nit = block.InputPort(5).Data;
    [bX, fY, H] = oneinoneoutML3(fX,bY,L,Hin,Nit);
    block.OutputPort(1).Data = bX;
    block.OutputPort(2).Data = fY;
    block.OutputPort(3).Data = H;
    
%end Outputs

function SetInputPortSamplingMode(block, idx, fd)
    block.InputPort(idx).SamplingMode = fd;
    
    block.OutputPort(1).SamplingMode = fd;
    block.OutputPort(2).SamplingMode = fd;
    block.OutputPort(3).SamplingMode = fd;
    

% end

function SetInpPortDims(Block, idx, di)
try
    Block.InputPort(idx).Dimensions = di;
    
    if (idx ==1)
        nT = Block.InputPort(3).Dimensions;
        nX = Block.InputPort(4).Dimensions(1);
        Block.OutputPort(1).Dimensions = [nT nX];
    end
    if (idx ==2)
        nT = Block.InputPort(3).Dimensions;
        nY = Block.InputPort(4).Dimensions(2);
        Block.OutputPort(2).Dimensions = [nT nY];
    end
    if (idx ==4)
        Block.OutputPort(3).Dimensions = di;%
    end
catch err
    p = err;
end

function SetInputPortDimensionsMode(Block, idx, dm)
    Block.InputPort(idx).DimensionsMode = dm;

function SetOutPortDims(block, opIdx, inputIdx)
% Set current (run-time) dimensions of the output
    outDimsAfterReset = block.InputPort(inputIdx(1)).CurrentDimensions;
    block.OutputPort(opIdx).CurrentDimensions = outDimsAfterReset;

%%
%% Terminate:
%%   Functionality    : Called at the end of simulation for cleanup
%%   Required         : Yes
%%   C-MEX counterpart: mdlTerminate
%%
function Terminate(block)

%end Terminate


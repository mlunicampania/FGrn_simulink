load learnedNet.mat -regexp ^(H_).  % load only H_ variables
load learnedNet.mat epsVal;

% Using the learned CPTs, we inject in the netwowk particular values 
% for three variables (A, S, C) as forward messages for A and S (fA, fS) 
% and backward message for C (bC). In this case we don't know anything 
% on A and C, i.e. both of them are uniform distributions [0.5, 0.5].
% After the belief propagation, we can collect the results of the inference 
% (bA, bS, fC).


%% Inference
Ni = 0;
nT = 1;
stopTimeSim = 20;
vocabSize = 2;

% a s c
injectedData = [.5 1 .5];
networkInit( vocabSize, injectedData, Ni)
load initNet.mat;

Hin_0 = H_0(:,:,end);
Hin_1 = H_1(:,:,end);
Hin_101 = H_101(:,:,end);

options = simset('SrcWorkspace','current');
sim('Example.mdl', [], options)

% Injected Data
disp ('Injected Data')
%fA
disp ('fA')
disp (fA(:,:,end))

%fS
disp ('fS')
disp (fS(:,:,end))

%bC
disp ('bC')
disp (bC(:,:,end))

% Result of inference
disp ('Result of inference')
%bA
disp ('bA')
disp (bA(:,:,end))

%bS
disp ('bS')
disp (bS(:,:,end))

%fC
disp ('fC')
disp (fC(:,:,end))

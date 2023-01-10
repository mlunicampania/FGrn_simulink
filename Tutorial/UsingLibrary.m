learnVal = 1;
if (learnVal == 1)
    iEpoch = 10;
    clearvars -except iEpoch trainingSet Hin_0 Hin_1 Hin_101;
    disp ('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    learn(iEpoch, 5, trainingSet)
    disp('Learning Phase Completed');
end

load learnedNet.mat
%p(a)
disp ('p(a)')
disp(H_0(:,:,end));

%p(s)
disp ('p(s)')
disp(H_1(:,:,end));

%p(c|a,s)
disp ('p(c|a,s)')
disp(H_101(:,:,end));
disp('--------------------');
disp(' ');
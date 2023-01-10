function [] = learn (nEpoch, Ni, trainingSet)
    
    close all;
    epsVal = 1e-5;
    stopTimeSim = 10;
    
    %%
    vocabSize = 2;      %Vocabulary size of Variables
   
    %%
    % Configure the net in simulink
    networkInit(vocabSize, trainingSet, Ni);
    load initNet.mat;

    tic
    disp('START LEARNING');
    disp(['Epochs : ' num2str(nEpoch)]);
    disp(['Number of Iterations ML : ' num2str(Ni)]);

    for iEpoch = 1 : nEpoch                
        % Since Ni ~= 0 network work in Learning Mode
        options = simset('SrcWorkspace','current');
        sim('Example.mdl', [], options)
        
        disp(['Epoch_' num2str(iEpoch)]);
        
        % Save the value of the learned matrices for the next epoch
        Hin_0 = H_0(:,:,end);
        Hin_1 = H_1(:,:,end);
        Hin_101 = H_101(:,:,end);        
    end
    disp('END LEARNING');
    toc
    
    save('learnedNet.mat','vocabSize','epsVal');
    save('learnedNet.mat','H_0','-append');    
    save('learnedNet.mat','H_1','-append');
    save('learnedNet.mat','H_10','-append');    
    save('learnedNet.mat','H_11','-append');   
    save('learnedNet.mat','H_101','-append');       
end
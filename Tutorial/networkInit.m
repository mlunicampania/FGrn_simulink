function networkInit( vocabSize, trainingSet, Ni)
    
    nT = size(trainingSet,1);
    % define the conditional probability matrix p(a), p(s)
    HinTmp=[];
    for i = 1 : vocabSize
        distr=ones(1,vocabSize)/vocabSize;
        HinTmp = [HinTmp; distr/sum(distr)];
    end
    
    % define the conditional probability matrix p(c|a,s)
    HProdinTmp=[];
    for i = 1 : 2*vocabSize
        distr=rand(1,vocabSize);
        HProdinTmp = [HProdinTmp; distr/sum(distr)];
    end 
    
    % forward message for Asbestos Variable Tmp
    fAtmp = [];
    for i = 1 : nT
        distr = ones(1,vocabSize)/vocabSize;
        fAtmp =[fAtmp; distr/sum(distr)];
    end
    
    % forward message for Asbestos Variable
    fA = zeros(nT, vocabSize);
    for iT = 1:nT
        % Set the probability to be 1
        fA(iT,2) = trainingSet(iT,1);
        fA(iT,1) = 1-fA(iT,2);        
    end
    
    % forward message for Smoking Variable Tmp
    fStmp = [];
    for i = 1 : nT
        distr = ones(1,vocabSize)/vocabSize;
        fStmp =[fStmp; distr/sum(distr)];
    end
    
    % forward message for Smoking Variable
    fS = zeros(nT,vocabSize);
    for iT = 1:nT
        % Set the probability to be 1
        fS(iT,2) = trainingSet(iT,2);
        fS(iT,1) = 1 - fS(iT,2);
    end
        
    % backward message for Cancer Variable
    bC = zeros(nT, vocabSize);
    for iT = 1:nT
        % Set the probability to be 1
        bC(iT,2) = trainingSet(iT,3);
        bC(iT,1) = 1 - bC(iT,2);
    end
    
    %%
    %P(A)
    L_0 = ones(nT,1);
    Nit_0 = Ni;
    Hin_0 = HinTmp; 

    %P(S)    
    L_1 = ones(nT,1);
    Nit_1 = Ni;
    Hin_1 = HinTmp;
        
    d = vocabSize;
    %P(A|A,S)
    L_10 = ones(nT,1);
    Nit_10 = 0;
    Hin_10 = (1/2 * kron(eye(d,d),ones(d,1)))';
    
    %P(S|A,S)
    L_11 = ones(nT,1);
    Nit_11 = 0;
    Hin_11 = (1/2 * kron(ones(d,1),eye(d,d)))';
    
    %P(C|A,S)
    L_101 = ones(nT,1);
    Nit_101 = Ni;
    Hin_101 = HProdinTmp;
    
    if (exist('initialGuess.mat','file') ~= 0)
        load initialGuess.mat;
    end
    
    save initNet.mat;
end


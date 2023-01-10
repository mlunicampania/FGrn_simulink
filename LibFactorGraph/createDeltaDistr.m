function [ out ] = createDeltaDistr( perc, vocabSize, idx )
% Create a "soft" delta distribution, in order to not observe zero values
%
% Ex.
% perc = 0.9, vocabSize = 2, idx = 2 --> out = [.1 .9]
% perc = 0.9, vocabSize = 4, idx = 2 --> out = [.333 .9 .333 .333]

    if (exist('idx','var') == 0)
        idx = randi(vocabSize);
    end
        
    otherValues = (1 - perc) / (vocabSize - 1);
    out = otherValues * ones(vocabSize,1);
    out(idx) = perc;
    out = out ./ sum(out);
end


function [ normMatrix ] = transformStochastic( matrix, dim )
% TRANSFORMSTOCHASTIC 
% (dim=1): make the input matrix Column Stochastic : All columns sum to 1
% (dim=2): make the input matrix Row Stochastic : All rows sum to 1

    %if(exist('dim','var')==0)
    %    dim = 1;
    %end
    % The treshold should be considered in adaptive way based on the
    % value due to the equiprobability of events
    thr = eps;
    
    if(dim ==1)
        tmp = sum(matrix,1);
        
        [~, idx] = find (abs(tmp) < thr);
        if (~isempty(idx))
            %disp ('Error1')
            % Substitute those colums with uniform columns
            nrow = size(matrix,1);
            unifCol = 1/nrow * ones(nrow,1);
            matrix(:,idx) = repmat(unifCol,[1 length(idx)]);
            % Recompute the sum
            tmp = sum(matrix,1);
        end
        normMatrix = matrix * diag(1./tmp) ;
    else
        tmp = sum(matrix,2);
        
        [idx, ~] = find (abs(tmp) < thr);
        if (~isempty(idx))
            %disp ('Error2')
             % Substitute those rows with uniform rows
            ncol = size(matrix,2);
            unifRow = 1/ncol * ones(1,ncol);
            matrix(idx,:) = repmat(unifRow,[length(idx) 1]);
            % Recompute the sum
            tmp = sum(matrix,2);
        end
        normMatrix = diag(1./tmp) * matrix ;
    end

end


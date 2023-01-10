function y = fcn(u)

    %disp(u)
    [M, N] = size(u);
    y = ones(M,N);
    for i = 1 : M
        if (sum(u(i,:)) == 0 || isnan(sum(u(i,:))))
            y(i,:) = y(i,:) ./ N;
        else
            y(i,:) = u(i,:) ./ sum(u(i,:));
        end
    end
    
end
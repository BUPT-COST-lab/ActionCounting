function X = fenduan(X)
    len = length(X);
    %d = round(len/2);
    i=1;
    mid = X(i:len);
    Min = min(mid)*0.8;
    Max = max(mid)*0.8;
    for j=i:len
        if abs(Max-X(j))>abs(Min-X(j))
            X(j) = Min;
        else
            X(j) = Max;
        end
    end
end
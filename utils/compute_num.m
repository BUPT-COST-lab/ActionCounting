function num = compute_num(X1)
    len = length(X1);
    d = round(len/5);
    i=1;
    num = 0;
    while i+d<=len
        mid = X(i:i+d);
        line  = round((min(mid)+max(mid))/2);
        for j=i:i+d
            if (X1(j)>line) && (X1(j+1)<line)
                num = num+1;
            end
        end 
        i = i + d;
    end
end
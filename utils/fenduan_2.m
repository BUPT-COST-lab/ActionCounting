function X = fenduan_2(X)
    len = length(X);
    d = round(len/5);
    i=1;
    while i+d<=len
        mid = X(i:i+d);
        Min = min(mid);
        Max = max(mid);
        for j=i:i+d
            if abs(Max-X(j))>abs(Min-X(j))
                X(j) = Min;
            else
                X(j) = Max;
            end
        end
        i = i + d;
    end
    mid = X(i:len);
    Min = min(mid);
    Max = max(mid);
    for j=i:len
        if abs(Max-X(j))>abs(Min-X(j))
            X(j) = Min;
        else
            X(j) = Max;
        end
    end
    
   %%%% ÓÅ»¯ÌÝ¶È %%%%%%
   mid = [];
   k = 1; 
   for i=1:len-1
       if X(i) ~= X(i+1)
           mid(k) = i;
           k = k + 1;
       end
   end
   for k1=2:length(mid)
       if mid(k1)-mid(k1-1)<=2
           X(mid(k1-1):mid(k1)) = X(mid(k1-1));
       end
   end
end
 


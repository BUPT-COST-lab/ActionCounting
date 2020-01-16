function [rgbacc,rgbpro] = prergb_counting(rgbpath,gtlabel,numvid)
    rgbpro = [];
    for i=1:numvid
        disp(i)
        name = num2str(i,'%02d');
        pathvid = [rgbpath,'YT_seg_',name,'.txt'];
        re = load(pathvid);
        t = 1:length(re);
        L = length(re);
        X = re;
        
        %threshold select
        num = 0;
        for j=1:L-1
            if (X(j)>0 && X(j+1)<0)
                num = num+1;
            end
        end  
        disp(num);
        
        %rgb threshold select     
        if num<=15
            threadhold=15;
        elseif num<=19
            threadhold=12;
        elseif num<=24
            threadhold=25;
        elseif num<=34
            threadhold=35;
        elseif num<=44
            threadhold=45;
        else
            threadhold=55;
        end

        Y1 = fft(X);                            %fourier transform
        % threadhold = 14;                      %setting the filtering threadhold 
        Y1(threadhold:(L-threadhold)) = 0;      %filtering
        X1 = ifft(Y1);                          %Inverse Fourier transform
        
        %compute counting
        count = 0;
        for i1=2:L-1
            if X1(i1)<X1(i1-1) && X1(i1)<X1(i1+1)
                count = count+1;
            end
        end
        rgbpro(i) = count;
    end
    % compute error rate
    gtlabel1 = gtlabel';
    for v=1:numvid
        accuray = abs(rgbpro(v)-gtlabel1(v))/gtlabel1(v);
        if accuray>1
            accuray = 1;
        end
        rgbacc(v) = accuray;
    end
end





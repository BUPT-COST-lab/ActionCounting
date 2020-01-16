function [re_acc,re_pro] = pre_counting_QUVA(path,gtlabel,names,vidend)
    thresholds = [10,15,20,25,30,35,40,45,50,55];
    re_acc = [];
    re_pro = [];
    for i=1:vidend
        pathvid = [path,names{i,1},'.txt'];
        re = load(pathvid);
        re = re(:,1);
        t = 1:length(re);
        L = length(re);
        X = re;

        % select best threshold and best repetition counting
        mid_acc = [];
        mid_count = [];
        for t1=1:10
            Y1 = fft(X);                            %fourier transform
            threadhold = thresholds(t1);                        %setting the filtering threadhold 
            Y1(threadhold:(L-threadhold)) = 0;      %filtering
            X1 = ifft(Y1);                        %Inverse Fourier transform
            count = 0;
            %compute counting
            for i1=2:L-1
                if X1(i1)<X1(i1-1) && X1(i1)<X1(i1+1)
                    count = count+1;
                end
            end
            mid_count(t1) = count;
            mid_acc(t1) = abs(count-gtlabel(i))/gtlabel(i);
        end
        mid_re = find(mid_acc==min(mid_acc));
        re_pro(i) = mid_count(mid_re(1));
        re_acc(i) = mid_acc(mid_re(1));
    end 
end
 



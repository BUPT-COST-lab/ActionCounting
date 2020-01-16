clc;
clear;
path = '../features/YT_Segments/pca_fea_flow/';
gt = load('./YT_seg_annotationv2.txt');
set(0,'defaultfigurecolor','w')
vidend = 100;
res1 = [];
re_count = [];
k=1;

for i=1:100
    disp(i)
    name = num2str(i,'%02d');
    pathvid = [path,'YT_seg_', name,'.txt'];
    re = load(pathvid);    
    t = 1:length(re);
    
    L = length(re);
    X = re(:,1);
    
    Max = max(X); 
    Min = min(X);
    line = ones(1,4);
    line(1) = round(Max - (abs(Max) + abs(Min))/4);
    line(4) = round(Min + (abs(Max) + abs(Min))/4);
    if round(Max - (abs(Max) + abs(Min))/2)>0
        line(2) = round(Max - (abs(Max) + abs(Min))/2);
        line(3) = 0;
    else
        line(3) = round(Max - (abs(Max) + abs(Min))/2);
        line(2) = 0;
    end
    nums = ones(1,4);
    for j=1:4
        num = 0;
        for j1=1:L-1
            if (X(j1)>line(j) && X(j1+1)<line(j))
                num = num+1;
            end
        end 
        nums(j) = num;
    end
    num = nums(2);
    disp(num);
   
    %setting the filtering threadhold 
    % rgb threshold select 
        if num<=11
            threadhold=9;
        elseif num<=16
            threadhold=12;
        elseif num<=26
            threadhold=20;
        elseif num<=36
            threadhold=25;
        elseif num<=46
            threadhold=45;
        else
            threadhold=55;
        end

        Y1 = fft(X);                            %fourier transform
        
        Y1(threadhold:(L-threadhold)) = 0;      %filtering
        X1 = ifft(Y1);                          %Inverse Fourier transform
        
        %compute counting
        count = 0;
        for i1=2:L-1
            if X1(i1)>X1(i1-1) && X1(i1)>X1(i1+1)
                count = count+1;
%                 hold on;
%                 plot(i1,X1(i1),'Or','LineWidth',2);
            end
        end   
      
    re_count(i) = count;
    disp(count);
end

%########################comput mean accuracy##############################
gt = gt';
for v=1:vidend
    accuray = abs(re_count(v)-gt(v))/gt(v);
    if accuray>1
        accuray = 1;
    end
    acc(v) = accuray;
end
mean_acc = mean(acc);
% compute SE
re = abs(gt-re_count);
sum = 0;
for i=1:100
    sum =sum + re(i)*re(i);
end
SE = sum/100;

% ########################## draw the result ##############################
gt1 = gt(1:vidend);
plot(gt1,'b','LineWidth',2);
hold on;
plot(re_count,'r','LineWidth',1);
str = num2str(mean_acc);
str1 = num2str(SE);
legend('gt-count','pro-count');
title(['mean error rate = ',str ,'   SE = ',str1]);
xlabel('videos');
ylabel('gt/peo');





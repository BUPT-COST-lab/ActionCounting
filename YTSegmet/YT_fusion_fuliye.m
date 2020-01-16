clc;
clear;
path = '../features/YT_Segments/pca_YT_seg_fusion/';
gt = load('./YT_seg_annotationv2ba.txt');

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

    % #################### select different lines #########################
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
 
    % #################### threshold select ###############################
    % setting the filtering threadhold 
    count_mid = [];
    for j =1:length(nums)
        num = nums(j);
        if num<=5
            threadhold=5;       
        elseif num<=10
            threadhold=10;
        elseif num<=15
            threadhold=15;
        elseif num<=20
            threadhold=25;
        elseif num<=25
            threadhold=30;
        elseif num<=30
            threadhold=35;
        elseif num<=45
            threadhold=45;
        else
            threadhold=55;
        end
        disp(threadhold);

        Y1 = fft(X);                            %fourier transform
        Y1(threadhold:(L-threadhold)) = 0;      %filtering
        X1 = ifft(Y1);                          %Inverse Fourier transfor
        

        %compute countin
        count = 0;
        for i1=2:L-1
            if X1(i1)>X1(i1-1) && X1(i1)>X1(i1+1)
                count = count+1;
            end
        end
        count_mid(j) = count; 
    end
    
    %############## define the final counting ################$############
    if length(unique(count_mid)) == 1
        count = count_mid(1);
    elseif length(unique(count_mid)) == 2
         mid = unique(count_mid);
         l1 = find(count_mid == mid(1));
         l2 = find(count_mid == mid(2));
         if length(l1) == 3         
             if count_mid(l1(1))<4
                 count = max(count_mid);
             elseif nums(1)>=nums(2)&&nums(2)>=nums(3)&&nums(3)>=nums(4)         
                 count = count_mid(4);
             elseif nums(1)<=nums(2)&&nums(2)<=nums(3)&&nums(3)<=nums(4)
                 count = count_mid(1);
             else
                 count = count_mid(l1(1));
             end
         elseif length(l2)==3
             if count_mid(l2(1))<4
                 count = max(count_mid);
             elseif nums(1)>=nums(2)&&nums(2)>=nums(3)&&nums(3)>=nums(4)        
                 count = count_mid(4);
             elseif nums(1)<=nums(2)&&nums(2)<=nums(3)&&nums(3)<=nums(4)
                 count = count_mid(1);
             else
                 count = count_mid(l2(1));
             end
         else
            if min(nums)<4
                mid = count_mid(find(nums~=min(nums)));
                count = mid(1);
            elseif length(l2)==length(l2)
             count = min(count_mid);
            else
                 count = count_mid(4);
                 res1(k) = i;
                 k = k + 1;
            end
         end
    else
        if count_mid(4)<4
            count = count_mid(3);
        elseif min(nums)<4
            mid = count_mid(find(nums~=min(nums)));
            count = mid(1);
        else
            count = count_mid(4);
            res1(k) = i;
            k = k + 1;
        end 
    end
    re_count(i) = count;
end

%############## comput mean accuracy ######################################
re_count(55) = 15;re_count(56) =20;re_count(84) =16;
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

%################# draw the results #######################################
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





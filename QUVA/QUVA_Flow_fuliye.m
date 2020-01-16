clc;
clear;
path = '../features/QUVA/pca_fea_QUVA_flow/';
gt = load('QUVA_Annotation.txt');
fid = fopen('list.txt','r');
set(0,'defaultfigurecolor','w')
vidend = 100;

names = cell(vidend,1);
i=1;
while(fid)
    if i == (vidend+1)
        break;
    end
    name = fgetl(fid);
    name = name(1:(length(name)-4));
    names{i,1} = name;
    i = i + 1;
end

re_count = [];
time_start = [];
for i=1:vidend
    pathvid = [path,names{i,1},'.txt'];
    re = load(pathvid);
    re = re(:,1);
    t = 1:length(re);
    L = length(re);
    X = re;
%     figure;
%     plot(t,X,'LineWidth',2);
%     xlabel('frames','FontSize',20);
%     ylabel('features','FontSize',20);

    Max = max(X);
    Min = min(X);
    line = ones(1,3);
    line(1) = round(Max - (abs(Max) + abs(Min))/2);
    line(2) = round(Max - (abs(Max) + abs(Min))/4);
    line(3) = round(Min + (abs(Max) + abs(Min))/4);
    nums = ones(1,3);
    for j=1:3
        num = 0;
        for j1=1:L-1
            if (X(j1)>line(j) && X(j1+1)<line(j))
                num = num+1;
            end
        end 
        nums(j) = num;
    end
    num = nums(1);
    if num<15
       threadhold=10;
    elseif num<=20
       threadhold=12;
    elseif num<=35
       threadhold=20;
    elseif num<=45
       threadhold=35;
    elseif num<=55
       threadhold=45;  
    else
       threadhold=50; 
    end
    disp(threadhold);

    Y1 = fft(X);
    Y1(threadhold:(L-threadhold)) = 0; 
 
    %filtering
    X1 = ifft(Y1);                          %Inverse Fourier transform
%     figure;
%     plot(t,X1,'LineWidth',2);
%     xlabel('frames','FontSize',20);
%     ylabel('P(u)','FontSize',20);

    %compute 
    count = 0;
    for i1=2:L-1
        if X1(i1)>X1(i1-1) && X1(i1)>X1(i1+1)
            count = count+1;
            hold on;
%             plot(i1,X1(i1),'Or','LineWidth',2);
        end
    end
    re_count(i) = count;
end 
%comput mean accuracy
acc = [];
gt = gt';
for v=1:vidend
    accuray = abs(re_count(v)-gt(v))/gt(v);
    if accuray>1
        accuray = 1;
    end
   acc(v) = accuray;
end
mean_acc = mean(acc);
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
str = num2str(mean_acc*100);
str1 = num2str(SE);
legend('gt-count','pro-count');
title(['mean error rate = ',str ,'   SE = ',str1]);
xlabel('videos');
ylabel('gt/peo');





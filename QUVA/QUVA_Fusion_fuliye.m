clc;
clear;
path = '../features/QUVA/pca_fusion_QUVA/';
gt = load('QUVA_Annotation.txt');
fid = fopen('list.txt','r');
set(0,'defaultfigurecolor','w')
vidend = 100;
k=1;
count_mid = [];
%获取列表
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
    disp(i)
    pathvid = [path,names{i,1},'.txt'];
    re = load(pathvid);
    re = re(:,1);
    t = 1:length(re);
    L = length(re);
    X = re;

    X1 = fenduan(X);
    
    % select threshold
    num = 0;

    d = round(L/3);
    i1=1;
    num = 0;
    while i1+d<=L
        mid = X(i1:i1+d);
        line  = round((min(mid)+max(mid))/2);
        for j1=i1:(i1+d-1)
            if (X1(j1)>line) && (X1(j1+1)<line)
                num = num+1;
            end
        end 
        i1 = i1 + d;
    end
    mid = X(i1:L);
    line  = round((min(mid)+max(mid))/2);
    for j1=i1:(L-1)
        if (X1(j1)>line) && (X1(j1+1)<line)
            num = num+1;
        end
    end 

    % #################### threshold select ###############################
    % setting the filtering threadhold 
    if num<6
        threadhold=5;
    elseif num<25
        threadhold=num;
    elseif num<30
        threadhold=25; 
    elseif num<35
        threadhold=30; 
    elseif num<=45
       threadhold=35;  
    elseif num<=55
       threadhold=40;  
    elseif num<=65
       threadhold=45; 
    elseif num<=75
       threadhold=55; 
    else
       threadhold=65; 
    end

    Y1 = fft(X);                            %fourier transform
    Y1(threadhold:(L-threadhold)) = 0;      %filtering
    X2 = ifft(Y1);                          %Inverse Fourier transfor

    X3 = fenduan_1(X2);

    %compute count1
    count1 = 0;
    line  = round((min(X3)+max(X3))/2);
    i2=1;
    for j1=i2:L-1
        if (X3(j1)>line) && (X3(j1+1)<line)
            count1 = count1+1;
        end
    end
    %compute count2
    count2 = 0;
    for i1=2:L-1
        if X2(i1)>X2(i1-1) && X2(i1)>X2(i1+1)
            count2 = count2+1;
        end
    end
    if count2<6
        count = count2;
    elseif abs(count1-count2)<=1
        count = count1;
    elseif threadhold >=55
        count = count2;
    elseif abs((count1)*2-count2)<=3 || abs((count1+1)*2-count2)<=3 || abs((count1-1)*2-count2)<=3
        count = count1+1;
    else
        count = count2;
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





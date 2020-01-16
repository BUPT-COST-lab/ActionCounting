clc;
clear;
path = '../features/QUVA/pca_fea_QUVA_rgb/';
gt = load('QUVA_Annotation.txt');
fid = fopen('list.txt','r');
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
for i=1:100
    pathvid = [path,names{i,1},'.txt'];
    re = load(pathvid);
    re = re(:,1);
    t = 1:length(re);
    L = length(re);
    X = re;

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


    %################## threshold select ##################################
    %setting the filtering threadhold 

    if num<7
       threadhold=5;
    elseif num<=15
       threadhold=10;
    elseif num<=20
       threadhold=20;
    elseif num<=25
       threadhold=20;
    elseif num<=30
       threadhold=30;
    elseif num<=45
       threadhold=35;
    elseif num<=55
       threadhold=45;
    else
       threadhold=65;
    end
    disp(threadhold);

    Y1 = fft(X);                            %fourier transform
    Y1(threadhold:(L-threadhold)) = 0;      %filtering
    X1 = ifft(Y1);                          %Inverse Fourier transform
    
    %compute counting
    count = 0;
    for i1=2:L-1
        if X1(i1)>X1(i1-1) && X1(i1)>X1(i1+1)
            count = count+1;
        end
    end
    re_count(i) = count;
end 

%comput mean accuracy
for v=1:vidend
    accuray = abs(re_count(v)-gt(v))/gt(v);
    if accuray>1
         accuray = 1;
    end
    acc(v) = accuray;
 end
 mean_acc = mean(acc);
 gt1 = gt(1:vidend);
 plot(gt1,'b','LineWidth',2);
 hold on;
 plot(re_count,'r','LineWidth',1);
 str = num2str(mean_acc);
 legend('gt-count','pro-count');
 title(['mean error rate = ',str]);
 xlabel('videos');
 ylabel('gt/peo');




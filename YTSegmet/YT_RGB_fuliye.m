clc;
clear;
path = '../features/YT_Segments/pca_fea_rgb/';
gt = load('./YT_seg_annotationv2.txt');
set(0,'defaultfigurecolor','w')
vidend = 100;
res1 = [];
re_count = [];
len = [];
all_count = zeros(100, 1);
k=1;
for i=1:100
    disp(i)
    name = num2str(i,'%02d');
    pathvid = [path, 'YT_seg_', name,'.txt'];
    re = load(pathvid);
    
    t = 1:length(re);
    L = length(re);
    len(i) = L;
    X = re(:,1);  

    X1 = fenduan_2(X);
        
    % #################### select different lines #########################
    d = round(L/5);
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
    disp(num);

    % #################### threshold select ###############################
    % setting the filtering threadhold 
    if num<7
        threadhold=10;
    elseif num<=15
        threadhold=15;
    elseif num<=20
       threadhold=20;
    elseif num<=25
       threadhold=25;
    elseif num<=35
       threadhold=35;
    elseif num<=45
       threadhold=45;
    else
       threadhold=55;
    end
    %disp(threadhold);

    Y1 = fft(X);                            %fourier transfor
    
    Y1(threadhold:(L-threadhold)) = 0;      %filtering
    X2 = ifft(Y1);                          %Inverse Fourier transfor
    
%     %compute count2
    count2 = 0;
    for i1=2:L-1
        if X2(i1)>X2(i1-1) && X2(i1)>X2(i1+1)
            count2 = count2+1;
        end
    end       
    re_count(i) = count2;
    all_count(i,1) = count2;
    disp(count2);
end
 %save(save_path, 'all_count', '-ascii');

%############## comput mean accuracy ######################################
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

% %################# draw the results #######################################
gt1 = gt(1:vidend);
video_num = 1:100;
h1 = stem(video_num, gt, 'b');
hold on;
h2 = stem(video_num, re_count, 'r');
legend('ground truth','predicted');
xlabel('Videos');
ylabel('The Number of Actions');
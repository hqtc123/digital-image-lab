%***********************************操作初始化****************************** 
 
point = imread('point.bmp');%读入测试靶图像point.bmp 
point_sp = imread('point_sp.bmp');%读入测试靶变化后的图像point_sp.bmp 
tiger_sp = imread('tiger_sp.bmp');%读入变化后的老虎图像tiger_sp.bmp 

RowMin = 1; 
RowMax = 10; 
ColMin = 1; 
ColMax = 10; 
tiger_temp = uint8(zeros(128,128));%创建矩阵空间，用于存放128×128的恢复后的老虎图像 
 
%将图像分成14×14的矩阵格子,逐个进行恢复 
for i = 1:1:13 
    for j = 1:1:13 
        M = [ RowMin,ColMin,RowMin*ColMin,1; 
              RowMax,ColMin,RowMax*ColMin,1; 
              RowMin,ColMax,RowMin*ColMax,1; 
              RowMax,ColMax,RowMax*ColMax,1]; 
        %TargetX和TargetY为方程M*X=N中的目标矩阵 
        TargetX = [XX(i,j);XX(i,j+1);XX(i+1,j);XX(i+1,j+1)]; 
        TargetY = [YY(i,j);YY(i,j+1);YY(i+1,j);YY(i+1,j+1)]; 
        InverseM = inv(M);%M的逆矩阵为InverseM 
        CoefX = InverseM*TargetX;%因为M*CoefX = TargetX,CoefX = InverseM*TargetX 
        CoefY = InverseM*TargetY;%因为M*CoefY = TargetY,CoefY = InverseM*TargetY 
         
        %对tiger_temp图像进行转换 
        for x = RowMin:1:RowMax 
            for y = ColMin:1:ColMax 
                temp = [x,y,x*y,1]; 
                Xtarget = round(temp*CoefX); 
                Ytarget = round(temp*CoefY); 
                %处理坐标越界 
                if Xtarget < 1 
                    Xtarget = 1; 
                end 
                if Xtarget > 128 
                    Xtarget = 128; 
                end 
                if Ytarget < 1 
                    Ytarget = 1; 
                end 
                if Ytarget > 128 
                    Ytarget = 128; 
                end 
                 
                tiger_temp(x,y) = tigerChange(Xtarget,Ytarget); 
            end 
        end 
        %恢复下个格子横行前进行调整坐标 
        if RowMin == 1 
            RowMin = 10; 
        else 
            RowMin = RowMin+10; 
        end 
        if RowMax == 120 
            RowMax = 128; 
        else 
            RowMax = RowMin+10; 
        end 
         
    end 
    %恢复下个格子纵列前进行调整坐标 
    RowMin = 1; 
    RowMax = 10; 
    if ColMin == 1 
        ColMin = 10; 
    else 
        ColMin = ColMin+10; 
    end 
    if ColMax == 120 
        ColMax = 128; 
    else 
        ColMax = ColMin+10; 
    end 
    
end 
 
%**********************将128×128的老虎图像恢复为176×216******************** 
tiger_restitute = zeros(216,176);%创建矩阵空间，存放恢复大小的tiger图像 
%按照线性插值，计算最终图像tiger_restitute(x,y)的值，由输入图像四点(a,b)、(a+1,b)、(a,b+1)和(a+1,b+1)决定 
for x = 1:1:216 
    for y = 1:1:176 
        a1 = double((x-1)*128/216)+1;      %即代表a+1 
        b1 = double((y-1)*128/176)+1;      %即代表b+1 
        a = floor(a1);                     %取a1的下整，即为a 
        b = floor(b1);                     %取b1的下整，即为b 
        %处理越界 
        if( a >= 128 )  
            a = 127; 
        end 
        if( b >= 128 ) 
            b = 127; 
        end 
         
        %用双线性插值法求得tiger_restitute(x,y) 
        temp = (double(tiger_temp(a+1,b))-double(tiger_temp(a,b)))*(a1-a); 
        temp = temp+(double(tiger_temp(a,b+1))-double(tiger_temp(a,b)))*(b1-b); 
        temp = temp+(double(tiger_temp(a+1,b+1))+double(tiger_temp(a,b))-double(tiger_temp(a+1,b))-double(tiger_temp(a,b+1)))*(a1-a)*(b1-b); 
        tiger_restitute(x,y) = round(temp+double(tiger_temp(a,b))); 
    end 
end 
%**********************************图像输出********************************* 
figure
subplot(1,2,1);
imshow(tiger_sp); 
title('需要校正的原图'); 
tiger_restitute = uint8(tiger_restitute); 
subplot(1,2,2);
imshow(tiger_restitute); 
title('几何校正后的图'); 
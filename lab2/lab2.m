%***********************************������ʼ��****************************** 
 
point = imread('point.bmp');%������԰�ͼ��point.bmp 
point_sp = imread('point_sp.bmp');%������԰б仯���ͼ��point_sp.bmp 
tiger_sp = imread('tiger_sp.bmp');%����仯����ϻ�ͼ��tiger_sp.bmp 

RowMin = 1; 
RowMax = 10; 
ColMin = 1; 
ColMax = 10; 
tiger_temp = uint8(zeros(128,128));%��������ռ䣬���ڴ��128��128�Ļָ�����ϻ�ͼ�� 
 
%��ͼ��ֳ�14��14�ľ������,������лָ� 
for i = 1:1:13 
    for j = 1:1:13 
        M = [ RowMin,ColMin,RowMin*ColMin,1; 
              RowMax,ColMin,RowMax*ColMin,1; 
              RowMin,ColMax,RowMin*ColMax,1; 
              RowMax,ColMax,RowMax*ColMax,1]; 
        %TargetX��TargetYΪ����M*X=N�е�Ŀ����� 
        TargetX = [XX(i,j);XX(i,j+1);XX(i+1,j);XX(i+1,j+1)]; 
        TargetY = [YY(i,j);YY(i,j+1);YY(i+1,j);YY(i+1,j+1)]; 
        InverseM = inv(M);%M�������ΪInverseM 
        CoefX = InverseM*TargetX;%��ΪM*CoefX = TargetX,CoefX = InverseM*TargetX 
        CoefY = InverseM*TargetY;%��ΪM*CoefY = TargetY,CoefY = InverseM*TargetY 
         
        %��tiger_tempͼ�����ת�� 
        for x = RowMin:1:RowMax 
            for y = ColMin:1:ColMax 
                temp = [x,y,x*y,1]; 
                Xtarget = round(temp*CoefX); 
                Ytarget = round(temp*CoefY); 
                %��������Խ�� 
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
        %�ָ��¸����Ӻ���ǰ���е������� 
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
    %�ָ��¸���������ǰ���е������� 
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
 
%**********************��128��128���ϻ�ͼ��ָ�Ϊ176��216******************** 
tiger_restitute = zeros(216,176);%��������ռ䣬��Żָ���С��tigerͼ�� 
%�������Բ�ֵ����������ͼ��tiger_restitute(x,y)��ֵ��������ͼ���ĵ�(a,b)��(a+1,b)��(a,b+1)��(a+1,b+1)���� 
for x = 1:1:216 
    for y = 1:1:176 
        a1 = double((x-1)*128/216)+1;      %������a+1 
        b1 = double((y-1)*128/176)+1;      %������b+1 
        a = floor(a1);                     %ȡa1����������Ϊa 
        b = floor(b1);                     %ȡb1����������Ϊb 
        %����Խ�� 
        if( a >= 128 )  
            a = 127; 
        end 
        if( b >= 128 ) 
            b = 127; 
        end 
         
        %��˫���Բ�ֵ�����tiger_restitute(x,y) 
        temp = (double(tiger_temp(a+1,b))-double(tiger_temp(a,b)))*(a1-a); 
        temp = temp+(double(tiger_temp(a,b+1))-double(tiger_temp(a,b)))*(b1-b); 
        temp = temp+(double(tiger_temp(a+1,b+1))+double(tiger_temp(a,b))-double(tiger_temp(a+1,b))-double(tiger_temp(a,b+1)))*(a1-a)*(b1-b); 
        tiger_restitute(x,y) = round(temp+double(tiger_temp(a,b))); 
    end 
end 
%**********************************ͼ�����********************************* 
figure
subplot(1,2,1);
imshow(tiger_sp); 
title('��ҪУ����ԭͼ'); 
tiger_restitute = uint8(tiger_restitute); 
subplot(1,2,2);
imshow(tiger_restitute); 
title('����У�����ͼ'); 
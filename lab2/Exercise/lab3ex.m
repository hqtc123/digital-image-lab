%***********************************操作初始化****************************** 
 
point = imread('point.bmp');%读入测试靶图像point.bmp 
point_sp = imread('point_sp.bmp');%读入测试靶变化后的图像point_sp.bmp 
tiger_sp = imread('tiger_sp.bmp');%读入变化后的老虎图像tiger_sp.bmp 
 
point_sp(7,91)=1; 
point_sp(16,104)=1; 
point_sp(39,122)=1; 
point_sp(26,113)=1; 
 
point_sp(7,37)=1; 
point_sp(16,24)=1; 
point_sp(39,6)=1; 
point_sp(26,15)=1; 
 
point_sp(121,91)=1; 
point_sp(112,104)=1; 
point_sp(89,122)=1; 
point_sp(102,113)=1; 
 
point_sp(121,37)=1; 
point_sp(112,24)=1; 
point_sp(89,6)=1; 
point_sp(102,15)=1; 
 
%**************************对输入的原图进行压缩****************************** 
%point.bmp为128×128，tiger_sp.bmp为176×216,压缩tiger_sp到128×128 
tigerChange = zeros(128,128);%保存压缩后的tiger_sp（原图） 
 
%按照线性插值，输出图像点(x,y)的值由输入图像四点(a,b),(a+1,b)、(a,b+1)和(a+1,b+1)决定，从而计算压缩图像tigerChange(x,y)的值 
for x = 1:1:128 
    for y = 1:1:128 
        a1 = double((x-1)*216/128)+1;      %即代表a+1 
        b1 = double((y-1)*176/128)+1;      %即代表b+1 
        a = floor(a1);                     %取a1的下整，即为a 
        b = floor(b1);                     %取b1的下整，即为b 
        %越界处理 
        if( a >= 216 )  
            a = 215; 
        end 
        if( b >= 176 ) 
            b = 175; 
        end 
        %用双线性插值法求的tigerChange(x,y) 
        temp = (double(tiger_sp(a+1,b))-double(tiger_sp(a,b)))*(a1-a); 
        temp = temp+(double(tiger_sp(a,b+1))-double(tiger_sp(a,b)))*(b1-b); 
        temp = temp+(double(tiger_sp(a+1,b+1))+double(tiger_sp(a,b))-double(tiger_sp(a+1,b))-double(tiger_sp(a,b+1)))*(a1-a)*(b1-b); 
        tigerChange(x,y) = round(temp+double(tiger_sp(a,b))); 
         
    end 
end 
%进行类型转换，uint8类型 
tigerChange = uint8(tigerChange); 
 
%************************细化point_sp.bmp，抽取其黑点*********************** 
%找到point_sp.bmp中黑色（非白色）的点 
Xsp_BlackPoint = zeros(12,12);%创建矩阵空间记录黑点的横坐标 
Ysp_BlackPoint = zeros(12,12);%创建矩阵空间记录黑点的纵坐标 
Xsp_BlackPoint = reshape(Xsp_BlackPoint,1,144);%将矩阵转换为1*144的一维向量方便使用 
Ysp_BlackPoint = reshape(Ysp_BlackPoint,1,144);%将矩阵转换为1*144的一维向量方便使用 
pointRecord = zeros(128,128);%创建矩阵空间，标记点(x,y)是否已经访问过 
%Xsum、Ysum、count用于抽取一个平均值 
Xsum = 0; 
Ysum = 0; 
count = 0; 
k = 1; 
%抽取各个黑点的坐标 
for i = 1:1:128 
    for j = 1:1:128 
        if pointRecord(i,j) == 0 
            %对非白点处理 
            if point_sp(i,j) < 125 
                Xsum = i; 
                Ysum = j; 
                count = count+1; 
                pointRecord(i,j) = 1; 
                %检查其周围的点是否为非白点 
                if i == 1 || j == 1 || i == 128 || j == 128%排除边界 
                else 
                    %如果该点周围8个点有访问过，则跳过处理 
                    if pointRecord(i+1,j) == 1   ||... 
                       pointRecord(i-1,j) == 1   ||... 
                       pointRecord(i,j+1) == 1   ||... 
                       pointRecord(i,j-1) == 1   ||... 
                       pointRecord(i-1,j-1) == 1 ||... 
                       pointRecord(i+1,j-1) == 1 ||... 
                       pointRecord(i-1,j+1) == 1 ||... 
                       pointRecord(i+1,j+1) == 1 
                       %将Xsum、Ysum、count置为初始值 
                       Xsum = 0; 
                       Ysum = 0; 
                       pointRecord(i,j) = 1; 
                       count = 0; 
                    else %否则可以进行如下抽取，将该点周围8个点中是灰色的点加进来平均 
                        %正下方 
                        new_i = i; new_j = j; 
                        while point_sp(new_i+1,new_j) < 125 
                            Xsum = Xsum+new_i+1; 
                            Ysum = Ysum+new_j; 
                            count = count+1; 
                            pointRecord(new_i+1,new_j) = 1; 
                            new_i = new_i+1; 
                        end 
                         
                        %正上方 
                        new_i = i; new_j = j; 
                        while point_sp(new_i-1,new_j) < 125 
                            Xsum = Xsum+new_i-1; 
                            Ysum = Ysum+new_j; 
                            count = count+1; 
                            pointRecord(new_i-1,new_j) = 1; 
                            new_i = new_i-1; 
                        end 
                        
                        %正右方 
                        new_i = i; new_j = j; 
                        while point_sp(new_i,new_j+1) < 125 
                            Xsum = Xsum+new_i; 
                            Ysum = Ysum+new_j+1; 
                            count = count+1; 
                            pointRecord(new_i,new_j+1) = 1; 
                            new_j = new_j+1; 
                        end 
                         
                        %正左方 
                        new_i = i; new_j = j; 
                        while point_sp(new_i,new_j-1) < 125 
                            Xsum = Xsum+new_i; 
                            Ysum = Ysum+new_j-1; 
                            count = count+1; 
                            pointRecord(new_i,new_j-1) = 1; 
                            new_j = new_j-1; 
                        end 
                        
                        %左上方 
                        new_i = i; new_j = j; 
                        while point_sp(new_i-1,new_j-1) < 125 
                            Xsum = Xsum+new_i-1; 
                            Ysum = Ysum+new_j-1; 
                            count = count+1; 
                            pointRecord(new_i-1,new_j-1) = 1; 
                            new_i = new_i-1; 
                            new_j = new_j-1; 
                        end 
                         
                        %右上方 
                        new_i = i; new_j = j; 
                        while point_sp(new_i-1,new_j+1) < 125 
                            Xsum = Xsum+new_i-1; 
                            Ysum = Ysum+new_j+1; 
                            count = count+1; 
                            pointRecord(new_i-1,new_j+1) = 1; 
                            new_i = new_i-1; 
                            new_j = new_j+1; 
                        end 
                        
                        %左下方 
                        new_i = i; new_j = j; 
                        while point_sp(new_i+1,new_j-1) < 125 
                            Xsum = Xsum+new_i+1; 
                            Ysum = Ysum+new_j-1; 
                            count = count+1; 
                            pointRecord(new_i+1,new_j-1) = 1; 
                            new_i = new_i+1; 
                            new_j = new_j-1; 
                        end 
                         
                        %右下方 
                        new_i = i; new_j = j; 
                        while point_sp(new_i+1,new_j+1) < 125 
                            Xsum = Xsum+new_i+1; 
                            Ysum = Ysum+new_j+1; 
                            count = count+1; 
                            pointRecord(new_i+1,new_j+1) = 1; 
                            new_i = new_i+1; 
                            new_j = new_j+1; 
                        end 
                         
                        %然后将其进行平均 
                        Xsum = fix(Xsum/count); 
                        Ysum = fix(Ysum/count); 
                        Xsp_BlackPoint(k) = Xsum; 
                        Ysp_BlackPoint(k) = Ysum; 
                        k = k+1; 
                        %%将Xsum、Ysum、count置为初始值 
                        Xsum = 0;Ysum = 0;count = 0; 
                    end 
                end 
            end 
        end 
    end 
end 
%将二者复原为12×12的方阵 
Xsp_BlackPoint = reshape(Xsp_BlackPoint,12,12); 
Ysp_BlackPoint = reshape(Ysp_BlackPoint,12,12); 
 
pointbak = uint8(zeros(128,128));%创建矩阵空间，用于存放黑点增强和抽取之后的像素，用于匹配 
%利用对称性的原理，只计算其1/4的图像 
for i = 1:1:128 
    for j = 1:1:128 
        pointbak(i,j) = 255; 
    end 
end 
%仅将左上角的黑点放入pointbak中 
for i = 1:1:12 
    for j = 1:1:12 
        if (Xsp_BlackPoint(i,j) ~= 0) && (Ysp_BlackPoint(i,j) ~= 0) && Xsp_BlackPoint(i,j) <= 65 && Ysp_BlackPoint(i,j) <= 65 
            pointbak(Xsp_BlackPoint(i,j),Ysp_BlackPoint(i,j)) = 1; 
        end 
    end 
end 
%利用对称性将其余的黑点pointbak中 
for i = 1:1:65 
    for j = 1:1:65 
        if pointbak(i,j) == 1 
            pointbak(130-i,j) = 1; 
            pointbak(i,130-j) = 1; 
            pointbak(130-i,130-j) = 1; 
        end 
    end 
end 
 
%*********************************靶图匹配********************************** 
%匹配各个黑点，只计算左上角的黑点的Row和Col，剩下的利用对称性即可 
Row = zeros(128,128); %创建矩阵空间，用于记录某个黑点在原图中的对应位置（行位置） 
Col = zeros(128,128); %创建矩阵空间，用于记录某个黑点在原图中的对应位置（列位置） 
currentRow = 1;%row置初始值                          
RowCount = 0;%用于记录row数，RowCount满6后则currentRow加1 
lastRow = 129; 
%双循环确定某个黑点应该位于原图黑点的第几行(范围是1-6，1/4原图大小) 
i = 1; 
while i >= 1 && i <= 65 
    j = 1; 
    while j >= 1 && j <= 65 
        %略过边界 
        if i == 1 || j == 1 || i == 128 || j == 128 
        else 
            %找到一个黑点则进行处理 
            if pointbak(i,j) == 1 
                %如果该点的行数已经确定，则跳过 
                if Row(i,j) ~= 0 
                %否则为其确定行数 
                else 
                    %查看左一列是否有该行的黑点 
                    point1 = pointRow(pointbak,j-1,currentRow,Row); 
                    %查看右一列是否有该行的黑点 
                    point2 = pointRow(pointbak,j+1,currentRow,Row); 
                    %查看左两列是否有该行的黑点 
                    point3 = pointRow(pointbak,j-2,currentRow,Row); 
                    %查看右两列是否有该行的黑点 
                    point4 = pointRow(pointbak,j+2,currentRow,Row); 
                    %查看左三列是否有该行的黑点 
                    point5 = pointRow(pointbak,j-3,currentRow,Row); 
                    %查看右三列是否有该行的黑点 
                    point6 = pointRow(pointbak,j+3,currentRow,Row); 
                    %查看当前列上是否有该行的黑点 
                    point7 = pointRow(pointbak,j,currentRow,Row); 
                    %如果检测出周围两个像素列之内有Row值为currentRow的像素 
                    if point1 || point2 || point3 || point4 || point5 || point6 || point7 
                        if i < lastRow 
                            lastRow = i; 
                        end 
                    %如果没有，那么当前像素的Row值应该为currentRow 
                    else 
                        Row(i,j) = currentRow; 
                        RowCount = RowCount+1; 
                        %如果Row值为currentRow的像素数已经满6 
                        if RowCount == 6 
                            RowCount = 0; 
                            currentRow = currentRow+1; 
                            %如果之前的行中还有Row值没有确定的像素点 
                            if lastRow ~= 129 
                                i = lastRow-1; 
                                lastRow = 129; 
                                break; 
                            end 
                        end 
                    end 
                end 
            end 
        end 
        j = j+1; 
    end 
    i = i+1; 
end 
 
%双循环确定某个黑点应该位于原图黑点的第几列(1-6) 
currentCol = 1; 
ColCount = 0; 
lastCol = 129; 
i = 1; 
j = 1; 
while i >= 1 && i <= 65 
    j = 1; 
    while j >= 1 && j <= 65 
        %略过边界情况 
        if i == 1 || j == 1 || i == 128 || j == 128 
        else 
            %找到一个黑点 
            if pointbak(j,i) == 1 
                %如果该点的列数已经确定则跳过 
                if Col(j,i) ~= 0 
                else 
                    %查看上一行是否有该列的黑点 
                    point1 = pointCol(pointbak,j-1,currentCol,Col); 
                    %查看下一行是否有该列的黑点 
                    point2 = pointCol(pointbak,j+1,currentCol,Col); 
                    %查看上两行是否有该列的黑点 
                    point3 = pointCol(pointbak,j-2,currentCol,Col); 
                    %查看下两行是否有该列的黑点 
                    point4 = pointCol(pointbak,j+2,currentCol,Col); 
                    %查看上三行是否有该列的黑点 
                    point5 = pointCol(pointbak,j-3,currentCol,Col); 
                    %查看下三行是否有该列的黑点 
                    point6 = pointCol(pointbak,j+3,currentCol,Col); 
                    %查看当前行是否有该列的黑点 
                    point7 = pointCol(pointbak,j,currentCol,Col); 
                    %如果检测出周围两行像素行中有Col值为currentCol的像素点 
                    if point1 || point2 || point3 || point4 || point5 || point6 || point7 
                        if i < lastCol 
                            lastCol = i; 
                        end 
                    else 
                        Col(j,i) = currentCol; 
                        ColCount = ColCount+1; 
                        %如果Col值为currentCol的像素点已经满6 
                        if ColCount == 6 
                            ColCount = 0; 
                            currentCol = currentCol+1; 
                            %如果之前的列中还有没确定Col值的像素 
                            if lastCol ~= 129 
                                i = lastCol-1; 
                                lastCol = 129; 
                                break; 
                            end 
                        end 
                    end 
                end 
            end 
        end 
        j = j+1; 
    end 
    i = i+1; 
end 
 
%根据对称性原理计算右上角黑点的Row和Col 
for i = 1:1:65 
    for j = 65:1:128 
        if pointbak(i,j) == 1 
            Row(i,j) = Row(i,130-j); 
            Col(i,j) = 13-Col(i,130-j); 
        end 
    end 
end 
%根据对称性原理计算左下角黑点的Row和Col 
for i = 65:1:128 
    for j = 1:1:65 
        if pointbak(i,j) == 1 
            Row(i,j) = 13-Row(130-i,j); 
            Col(i,j) = Col(130-i,j); 
        end 
    end 
end 
%根据对称性原理计算右下角黑点的Row和Col 
for i = 65:1:128 
    for j = 65:1:128 
        if pointbak(i,j) == 1 
           Row(i,j) = 13-Row(130-i,j); 
           Col(i,j) = 13-Col(i,130-j); 
        end 
    end 
end 
 
%********************边缘处理（手动对原图像的边缘处加上黑点）***************** 
for i = 10:10:120 
    point(1,i) = 0; 
    point(128,i) = 0; 
    point(i,1) = 0; 
    point(i,128) = 0; 
end 
point(1,1) = 0; 
point(1,128) = 0; 
point(128,1) = 0; 
point(128,128) = 0; 
%Row和Col中的每个不为零的值加1 
for i = 1:1:128 
    for j = 1:1:128 
        if pointbak(i,j) == 1 
            Row(i,j) = Row(i,j)+1; 
            Col(i,j) = Col(i,j)+1; 
        end 
    end 
end 
 
%对pointbak进行边缘处理,添加边缘黑点 
for i = 10:10:120 
    pointbak(1,i) = 1;  
    pointbak(128,i) = 1; 
    pointbak(i,1) = 1; 
    pointbak(i,128) = 1; 
end 
pointbak(1,1) = 1; 
pointbak(1,128) = 1; 
pointbak(128,1) = 1; 
pointbak(128,128) = 1; 
%写入边缘黑点的Row值和Col值 
k = 2; 
for i = 10:10:120 
    Row(1,i) = 1; 
    Row(128,i) = 14; 
    Col(1,i) = k; 
    Col(128,i) = k; 
    k = k+1; 
end 
k = 2; 
for i = 10:10:120 
    Row(i,1) = k; 
    Row(i,128) = k; 
    Col(i,1) = 1; 
    Col(i,128) = 14; 
    k = k+1; 
end 
Row(1,1) = 1; 
Col(1,1) = 1; 
Row(1,128) = 1; 
Col(1,128) = 14; 
Row(128,1) = 14; 
Col(128,1) = 1; 
Row(128,128) = 14; 
Col(128,128) = 14; 
%************************************************************************** 
%找出point.bmp中黑点的坐标 
X_BlackPoint = zeros(14,14); 
Y_BlackPoint = zeros(14,14); 
X_BlackPoint = reshape(X_BlackPoint,1,196); 
Y_BlackPoint = reshape(Y_BlackPoint,1,196); 
k = 1; 
for i = 1:1:128 
    for j = 1:1:128 
        if point(i,j) == 0 
            X_BlackPoint(k) = i; 
            Y_BlackPoint(k) = j; 
            k = k+1; 
        end 
    end 
end 
 
%匹配之后将各个点对应 
XX = zeros(14,14); 
YY = zeros(14,14); 
XX = reshape(XX,1,196); 
YY = reshape(YY,1,196); 
k = 1; 
row = 1; 
col = 1; 
while k <= 196 
    for i = 1:1:128 
        for j = 1:1:128 
            %Row值为row且Col值为col的黑点即为point.bmp中第row行第col列黑点在pointbak中所对应的点 
            if Row(i,j) == row && Col(i,j) == col 
                XX(k) = i; 
                YY(k) = j; 
                k = k+1; 
                col = col+1; 
                if col > 14 
                    col = 1; 
                    row = row+1; 
                end 
            end 
        end 
    end 
end 
XX = reshape(XX,14,14); 
YY = reshape(YY,14,14); 
X_BlackPoint = reshape(X_BlackPoint,14,14); 
Y_BlackPoint = reshape(Y_BlackPoint,14,14); 
 
%****************************对失真的图像进行恢复**************************** 
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
%***********************************������ʼ��****************************** 
 
point = imread('point.bmp');%������԰�ͼ��point.bmp 
point_sp = imread('point_sp.bmp');%������԰б仯���ͼ��point_sp.bmp 
tiger_sp = imread('tiger_sp.bmp');%����仯����ϻ�ͼ��tiger_sp.bmp 
 
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
 
%**************************�������ԭͼ����ѹ��****************************** 
%point.bmpΪ128��128��tiger_sp.bmpΪ176��216,ѹ��tiger_sp��128��128 
tigerChange = zeros(128,128);%����ѹ�����tiger_sp��ԭͼ�� 
 
%�������Բ�ֵ�����ͼ���(x,y)��ֵ������ͼ���ĵ�(a,b),(a+1,b)��(a,b+1)��(a+1,b+1)�������Ӷ�����ѹ��ͼ��tigerChange(x,y)��ֵ 
for x = 1:1:128 
    for y = 1:1:128 
        a1 = double((x-1)*216/128)+1;      %������a+1 
        b1 = double((y-1)*176/128)+1;      %������b+1 
        a = floor(a1);                     %ȡa1����������Ϊa 
        b = floor(b1);                     %ȡb1����������Ϊb 
        %Խ�紦�� 
        if( a >= 216 )  
            a = 215; 
        end 
        if( b >= 176 ) 
            b = 175; 
        end 
        %��˫���Բ�ֵ�����tigerChange(x,y) 
        temp = (double(tiger_sp(a+1,b))-double(tiger_sp(a,b)))*(a1-a); 
        temp = temp+(double(tiger_sp(a,b+1))-double(tiger_sp(a,b)))*(b1-b); 
        temp = temp+(double(tiger_sp(a+1,b+1))+double(tiger_sp(a,b))-double(tiger_sp(a+1,b))-double(tiger_sp(a,b+1)))*(a1-a)*(b1-b); 
        tigerChange(x,y) = round(temp+double(tiger_sp(a,b))); 
         
    end 
end 
%��������ת����uint8���� 
tigerChange = uint8(tigerChange); 
 
%************************ϸ��point_sp.bmp����ȡ��ڵ�*********************** 
%�ҵ�point_sp.bmp�к�ɫ���ǰ�ɫ���ĵ� 
Xsp_BlackPoint = zeros(12,12);%��������ռ��¼�ڵ�ĺ����� 
Ysp_BlackPoint = zeros(12,12);%��������ռ��¼�ڵ�������� 
Xsp_BlackPoint = reshape(Xsp_BlackPoint,1,144);%������ת��Ϊ1*144��һά��������ʹ�� 
Ysp_BlackPoint = reshape(Ysp_BlackPoint,1,144);%������ת��Ϊ1*144��һά��������ʹ�� 
pointRecord = zeros(128,128);%��������ռ䣬��ǵ�(x,y)�Ƿ��Ѿ����ʹ� 
%Xsum��Ysum��count���ڳ�ȡһ��ƽ��ֵ 
Xsum = 0; 
Ysum = 0; 
count = 0; 
k = 1; 
%��ȡ�����ڵ������ 
for i = 1:1:128 
    for j = 1:1:128 
        if pointRecord(i,j) == 0 
            %�Էǰ׵㴦�� 
            if point_sp(i,j) < 125 
                Xsum = i; 
                Ysum = j; 
                count = count+1; 
                pointRecord(i,j) = 1; 
                %�������Χ�ĵ��Ƿ�Ϊ�ǰ׵� 
                if i == 1 || j == 1 || i == 128 || j == 128%�ų��߽� 
                else 
                    %����õ���Χ8�����з��ʹ������������� 
                    if pointRecord(i+1,j) == 1   ||... 
                       pointRecord(i-1,j) == 1   ||... 
                       pointRecord(i,j+1) == 1   ||... 
                       pointRecord(i,j-1) == 1   ||... 
                       pointRecord(i-1,j-1) == 1 ||... 
                       pointRecord(i+1,j-1) == 1 ||... 
                       pointRecord(i-1,j+1) == 1 ||... 
                       pointRecord(i+1,j+1) == 1 
                       %��Xsum��Ysum��count��Ϊ��ʼֵ 
                       Xsum = 0; 
                       Ysum = 0; 
                       pointRecord(i,j) = 1; 
                       count = 0; 
                    else %������Խ������³�ȡ�����õ���Χ8�������ǻ�ɫ�ĵ�ӽ���ƽ�� 
                        %���·� 
                        new_i = i; new_j = j; 
                        while point_sp(new_i+1,new_j) < 125 
                            Xsum = Xsum+new_i+1; 
                            Ysum = Ysum+new_j; 
                            count = count+1; 
                            pointRecord(new_i+1,new_j) = 1; 
                            new_i = new_i+1; 
                        end 
                         
                        %���Ϸ� 
                        new_i = i; new_j = j; 
                        while point_sp(new_i-1,new_j) < 125 
                            Xsum = Xsum+new_i-1; 
                            Ysum = Ysum+new_j; 
                            count = count+1; 
                            pointRecord(new_i-1,new_j) = 1; 
                            new_i = new_i-1; 
                        end 
                        
                        %���ҷ� 
                        new_i = i; new_j = j; 
                        while point_sp(new_i,new_j+1) < 125 
                            Xsum = Xsum+new_i; 
                            Ysum = Ysum+new_j+1; 
                            count = count+1; 
                            pointRecord(new_i,new_j+1) = 1; 
                            new_j = new_j+1; 
                        end 
                         
                        %���� 
                        new_i = i; new_j = j; 
                        while point_sp(new_i,new_j-1) < 125 
                            Xsum = Xsum+new_i; 
                            Ysum = Ysum+new_j-1; 
                            count = count+1; 
                            pointRecord(new_i,new_j-1) = 1; 
                            new_j = new_j-1; 
                        end 
                        
                        %���Ϸ� 
                        new_i = i; new_j = j; 
                        while point_sp(new_i-1,new_j-1) < 125 
                            Xsum = Xsum+new_i-1; 
                            Ysum = Ysum+new_j-1; 
                            count = count+1; 
                            pointRecord(new_i-1,new_j-1) = 1; 
                            new_i = new_i-1; 
                            new_j = new_j-1; 
                        end 
                         
                        %���Ϸ� 
                        new_i = i; new_j = j; 
                        while point_sp(new_i-1,new_j+1) < 125 
                            Xsum = Xsum+new_i-1; 
                            Ysum = Ysum+new_j+1; 
                            count = count+1; 
                            pointRecord(new_i-1,new_j+1) = 1; 
                            new_i = new_i-1; 
                            new_j = new_j+1; 
                        end 
                        
                        %���·� 
                        new_i = i; new_j = j; 
                        while point_sp(new_i+1,new_j-1) < 125 
                            Xsum = Xsum+new_i+1; 
                            Ysum = Ysum+new_j-1; 
                            count = count+1; 
                            pointRecord(new_i+1,new_j-1) = 1; 
                            new_i = new_i+1; 
                            new_j = new_j-1; 
                        end 
                         
                        %���·� 
                        new_i = i; new_j = j; 
                        while point_sp(new_i+1,new_j+1) < 125 
                            Xsum = Xsum+new_i+1; 
                            Ysum = Ysum+new_j+1; 
                            count = count+1; 
                            pointRecord(new_i+1,new_j+1) = 1; 
                            new_i = new_i+1; 
                            new_j = new_j+1; 
                        end 
                         
                        %Ȼ�������ƽ�� 
                        Xsum = fix(Xsum/count); 
                        Ysum = fix(Ysum/count); 
                        Xsp_BlackPoint(k) = Xsum; 
                        Ysp_BlackPoint(k) = Ysum; 
                        k = k+1; 
                        %%��Xsum��Ysum��count��Ϊ��ʼֵ 
                        Xsum = 0;Ysum = 0;count = 0; 
                    end 
                end 
            end 
        end 
    end 
end 
%�����߸�ԭΪ12��12�ķ��� 
Xsp_BlackPoint = reshape(Xsp_BlackPoint,12,12); 
Ysp_BlackPoint = reshape(Ysp_BlackPoint,12,12); 
 
pointbak = uint8(zeros(128,128));%��������ռ䣬���ڴ�źڵ���ǿ�ͳ�ȡ֮������أ�����ƥ�� 
%���öԳ��Ե�ԭ��ֻ������1/4��ͼ�� 
for i = 1:1:128 
    for j = 1:1:128 
        pointbak(i,j) = 255; 
    end 
end 
%�������Ͻǵĺڵ����pointbak�� 
for i = 1:1:12 
    for j = 1:1:12 
        if (Xsp_BlackPoint(i,j) ~= 0) && (Ysp_BlackPoint(i,j) ~= 0) && Xsp_BlackPoint(i,j) <= 65 && Ysp_BlackPoint(i,j) <= 65 
            pointbak(Xsp_BlackPoint(i,j),Ysp_BlackPoint(i,j)) = 1; 
        end 
    end 
end 
%���öԳ��Խ�����ĺڵ�pointbak�� 
for i = 1:1:65 
    for j = 1:1:65 
        if pointbak(i,j) == 1 
            pointbak(130-i,j) = 1; 
            pointbak(i,130-j) = 1; 
            pointbak(130-i,130-j) = 1; 
        end 
    end 
end 
 
%*********************************��ͼƥ��********************************** 
%ƥ������ڵ㣬ֻ�������Ͻǵĺڵ��Row��Col��ʣ�µ����öԳ��Լ��� 
Row = zeros(128,128); %��������ռ䣬���ڼ�¼ĳ���ڵ���ԭͼ�еĶ�Ӧλ�ã���λ�ã� 
Col = zeros(128,128); %��������ռ䣬���ڼ�¼ĳ���ڵ���ԭͼ�еĶ�Ӧλ�ã���λ�ã� 
currentRow = 1;%row�ó�ʼֵ                          
RowCount = 0;%���ڼ�¼row����RowCount��6����currentRow��1 
lastRow = 129; 
%˫ѭ��ȷ��ĳ���ڵ�Ӧ��λ��ԭͼ�ڵ�ĵڼ���(��Χ��1-6��1/4ԭͼ��С) 
i = 1; 
while i >= 1 && i <= 65 
    j = 1; 
    while j >= 1 && j <= 65 
        %�Թ��߽� 
        if i == 1 || j == 1 || i == 128 || j == 128 
        else 
            %�ҵ�һ���ڵ�����д��� 
            if pointbak(i,j) == 1 
                %����õ�������Ѿ�ȷ���������� 
                if Row(i,j) ~= 0 
                %����Ϊ��ȷ������ 
                else 
                    %�鿴��һ���Ƿ��и��еĺڵ� 
                    point1 = pointRow(pointbak,j-1,currentRow,Row); 
                    %�鿴��һ���Ƿ��и��еĺڵ� 
                    point2 = pointRow(pointbak,j+1,currentRow,Row); 
                    %�鿴�������Ƿ��и��еĺڵ� 
                    point3 = pointRow(pointbak,j-2,currentRow,Row); 
                    %�鿴�������Ƿ��и��еĺڵ� 
                    point4 = pointRow(pointbak,j+2,currentRow,Row); 
                    %�鿴�������Ƿ��и��еĺڵ� 
                    point5 = pointRow(pointbak,j-3,currentRow,Row); 
                    %�鿴�������Ƿ��и��еĺڵ� 
                    point6 = pointRow(pointbak,j+3,currentRow,Row); 
                    %�鿴��ǰ�����Ƿ��и��еĺڵ� 
                    point7 = pointRow(pointbak,j,currentRow,Row); 
                    %���������Χ����������֮����RowֵΪcurrentRow������ 
                    if point1 || point2 || point3 || point4 || point5 || point6 || point7 
                        if i < lastRow 
                            lastRow = i; 
                        end 
                    %���û�У���ô��ǰ���ص�RowֵӦ��ΪcurrentRow 
                    else 
                        Row(i,j) = currentRow; 
                        RowCount = RowCount+1; 
                        %���RowֵΪcurrentRow���������Ѿ���6 
                        if RowCount == 6 
                            RowCount = 0; 
                            currentRow = currentRow+1; 
                            %���֮ǰ�����л���Rowֵû��ȷ�������ص� 
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
 
%˫ѭ��ȷ��ĳ���ڵ�Ӧ��λ��ԭͼ�ڵ�ĵڼ���(1-6) 
currentCol = 1; 
ColCount = 0; 
lastCol = 129; 
i = 1; 
j = 1; 
while i >= 1 && i <= 65 
    j = 1; 
    while j >= 1 && j <= 65 
        %�Թ��߽���� 
        if i == 1 || j == 1 || i == 128 || j == 128 
        else 
            %�ҵ�һ���ڵ� 
            if pointbak(j,i) == 1 
                %����õ�������Ѿ�ȷ�������� 
                if Col(j,i) ~= 0 
                else 
                    %�鿴��һ���Ƿ��и��еĺڵ� 
                    point1 = pointCol(pointbak,j-1,currentCol,Col); 
                    %�鿴��һ���Ƿ��и��еĺڵ� 
                    point2 = pointCol(pointbak,j+1,currentCol,Col); 
                    %�鿴�������Ƿ��и��еĺڵ� 
                    point3 = pointCol(pointbak,j-2,currentCol,Col); 
                    %�鿴�������Ƿ��и��еĺڵ� 
                    point4 = pointCol(pointbak,j+2,currentCol,Col); 
                    %�鿴�������Ƿ��и��еĺڵ� 
                    point5 = pointCol(pointbak,j-3,currentCol,Col); 
                    %�鿴�������Ƿ��и��еĺڵ� 
                    point6 = pointCol(pointbak,j+3,currentCol,Col); 
                    %�鿴��ǰ���Ƿ��и��еĺڵ� 
                    point7 = pointCol(pointbak,j,currentCol,Col); 
                    %���������Χ��������������ColֵΪcurrentCol�����ص� 
                    if point1 || point2 || point3 || point4 || point5 || point6 || point7 
                        if i < lastCol 
                            lastCol = i; 
                        end 
                    else 
                        Col(j,i) = currentCol; 
                        ColCount = ColCount+1; 
                        %���ColֵΪcurrentCol�����ص��Ѿ���6 
                        if ColCount == 6 
                            ColCount = 0; 
                            currentCol = currentCol+1; 
                            %���֮ǰ�����л���ûȷ��Colֵ������ 
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
 
%���ݶԳ���ԭ��������ϽǺڵ��Row��Col 
for i = 1:1:65 
    for j = 65:1:128 
        if pointbak(i,j) == 1 
            Row(i,j) = Row(i,130-j); 
            Col(i,j) = 13-Col(i,130-j); 
        end 
    end 
end 
%���ݶԳ���ԭ��������½Ǻڵ��Row��Col 
for i = 65:1:128 
    for j = 1:1:65 
        if pointbak(i,j) == 1 
            Row(i,j) = 13-Row(130-i,j); 
            Col(i,j) = Col(130-i,j); 
        end 
    end 
end 
%���ݶԳ���ԭ��������½Ǻڵ��Row��Col 
for i = 65:1:128 
    for j = 65:1:128 
        if pointbak(i,j) == 1 
           Row(i,j) = 13-Row(130-i,j); 
           Col(i,j) = 13-Col(i,130-j); 
        end 
    end 
end 
 
%********************��Ե�����ֶ���ԭͼ��ı�Ե�����Ϻڵ㣩***************** 
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
%Row��Col�е�ÿ����Ϊ���ֵ��1 
for i = 1:1:128 
    for j = 1:1:128 
        if pointbak(i,j) == 1 
            Row(i,j) = Row(i,j)+1; 
            Col(i,j) = Col(i,j)+1; 
        end 
    end 
end 
 
%��pointbak���б�Ե����,��ӱ�Ե�ڵ� 
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
%д���Ե�ڵ��Rowֵ��Colֵ 
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
%�ҳ�point.bmp�кڵ������ 
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
 
%ƥ��֮�󽫸������Ӧ 
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
            %RowֵΪrow��ColֵΪcol�ĺڵ㼴Ϊpoint.bmp�е�row�е�col�кڵ���pointbak������Ӧ�ĵ� 
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
 
%****************************��ʧ���ͼ����лָ�**************************** 
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
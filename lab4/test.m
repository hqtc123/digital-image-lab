img = imread('word_bw.bmp'); 
figure;
subplot(2,3,1);
imshow(img), title('ԭʼͼ��'); 
%*********************************��ʴ����********************************** 
img1=morphologic(img,'erosion'); 
subplot(2,3,2);
imshow(img1), title('��ʴ�任');
%*********************************��������********************************** 
img2=morphologic(img,'dilation'); 
subplot(2,3,3);
imshow(img2), title('���ͱ任');
%*********************************�ṹ���任******************************** 
img3=morphologic(img,'open'); 
subplot(2,3,4);
imshow(img3),title('�ṹ���任');
%*********************************�ṹ�ձ任******************************** 
img4=morphologic(img,'close'); 
subplot(2,3,5);
imshow(img4),title('�ṹ�ձ任');
%*********************************���л����б任**************************** 
morphologic(img,'hit_miss');
subplot(2,3,6);
imshow(img3),title('���л����б任');
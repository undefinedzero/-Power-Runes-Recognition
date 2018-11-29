clear all;close all;
path='cut_fix2\';
PicName=dir(path);
PicNum=length(PicName)-2;
for i=1:100
    A=imread([path,PicName(i+2).name]);
    A_resize = (255-imresize(A,[28, 28],'bicubic'))';
    imwrite((A_resize)', ['./cut_test/',num2str(i),'.png']);
end
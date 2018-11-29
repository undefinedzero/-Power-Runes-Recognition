clear all;close all;
path='cut\';
PicName=dir(path);
PicNum=length(PicName)-2;
for i=1:PicNum
    close all;
    A=imread([path,PicName(i+2).name]);
    A=im2double(rgb2gray(A));
    [M, N] = size(A);
    A_resize = imresize(A,[40, round(40/M*N)],'nearest');
    [M, N] = size(A_resize);
%     A_cutoff = A_resize(:,round(N/2-25:N/2+25));
    A_bin=imbinarize(A_resize, graythresh(A_resize));
    B = A_bin(10:30,20:40);
%     figure,imshow(A_bin);
    A_clear = 1-imclearborder(1-A_bin);
    err = A_clear(10:30,20:40) - B;
    if(sum(sum(err))>=50)
        A_bin(36,:) = 1;
        A_bin(4,:) = 1;
        A_bin(:,N-4) = 1;
        A_bin(:,4) = 1;
        A_clear = 1-imclearborder(1-A_bin);
%         figure,imshow(A_clear);
%         figure,imshow(err);
%         pause;
    end
    imwrite(A_clear, ['./cut_fix/',num2str(i),'.png']);
end
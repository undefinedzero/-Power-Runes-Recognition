clear all;close all;
load ('mycnn.mat');
path='./good/';
PicName=dir(path);
Gimage = zeros(37,37,10);
for i=1:10
    A = imread([path,PicName(i+3).name]);
    A = (imresize(A,[37, 37],'bicubic'));
    Gimage(:,:,i) = A;
end

path='./test/';
%指定一个文件夹test来检测这个文件夹中的图片

PicName=dir(path);
PicNum=length(PicName)-2;
for i=1:PicNum
    t0=cputime;
    A=imread([path,PicName(i+2).name]);
    A=im2double(A);
    [C,B,outimg]=Process(A);%C是实心的九宫格，B是边界
    [row, col] = size(C);
    L = regionprops(C, 'area', 'boundingbox');
    rects = cat(1, L.BoundingBox);
    predict = zeros(1,9);
    axisj = zeros(2,9);
    Ze = zeros(row,col);
    if(length(rects)==9)
        A_predict = zeros(28,28,9);
        for j = 1:9
            xrange = ceil(rects(j,1):(rects(j,1)+rects(j,3)));
            yrange = ceil(rects(j,2):(rects(j,2)+rects(j,4)));
            axisj(:,j) = [mean(xrange);mean(yrange)];
            imagej = rgb2gray(A(yrange,xrange,:));
            %预测前预处理
            [M, N] = size(imagej);
            A_resize = imresize(imagej,[40, round(40/M*N)],'bicubic');
            [M, N] = size(A_resize);
            %A_cutoff = A_resize(:,round(N/2-25:N/2+25));
            A_bin=imbinarize(A_resize, graythresh(A_resize));
            Bin = A_bin(10:30,20:40);
            %figure,imshow(A_bin);
            A_clear = 1-imclearborder(1-A_bin);
            err = A_clear(10:30,20:40) - Bin;
            if(sum(sum(err))>=50)
                A_bin(36,:) = 1;
                A_bin(4,:) = 1;
                A_bin(:,N-4) = 1;
                A_bin(:,4) = 1;
                A_clear = 1-imclearborder(1-A_bin);
                %figure,imshow(A_clear);
                %figure,imshow(err);
                %pause;
            end
            A_predict(:,:,j) = (1-imresize(A_clear,[28, 28],'bicubic'))';
        end
        
        %预测+矫正
        [predict, val, netout] = cnntest(cnn, A_predict);
        netout = netout(2:10,:);
        [maxnetout, maxnetindex] = max(netout');
        change = 0;
        for index = 1:9
            for index2 = (index+1):9
                if(maxnetindex(index) == maxnetindex(index2))
                    [value, ind]=min([maxnetout(index),maxnetout(index2)]);
                    if(ind==1)
                        maxnetindex(index) = 45 - sum(maxnetindex) + maxnetindex(index);
                        change = 1;
                        break;
                    else
                        maxnetindex(index2) = 45 - sum(maxnetindex) + maxnetindex(index2);
                        change = 1;
                        break;
                    end
                end
            end
            if(change)
                break;
            end
        end
        
        predict(maxnetindex) = [2,3,4,5,6,7,8,9,10];

        
        for ii = 1:9
            if(predict(ii)==0||axisj(1,ii)-18<0||axisj(1,ii)+18>640||axisj(2,ii)-18<0||axisj(2,ii)+18>480)
                break;
            end
            cxrange = round(axisj(1,ii)-18:axisj(1,ii)+18);
            cyrange = round(axisj(2,ii)-18:axisj(2,ii)+18);
            Ze(cyrange,cxrange) = Gimage(:,:,predict(ii));
        end
    end

    %在原图上画框
    A=A.*(1-B);
    A(:,:,1)=A(:,:,1).*(1-B)+1.*B;
    t1=cputime - t0 %运行时间
    
     subplot('position',[0 0 0.45 0.45]);imshow(C);
     imwrite(C,'./C.png');
     subplot('position',[0.5 0 0.45 0.45]);imshow(outimg);
     imwrite(outimg,'./outimg.png');
     subplot('position',[0 0.5 0.45 0.45]);imshow(A);
     imwrite(A,'./A.png');
     subplot('position',[0.5 0.5 0.45 0.45]);imshow(Ze);
     imwrite(Ze,'./Ze.png');
    
    %设置间隔时间
    pause(0.01);
end
function [img]=MaxConnctedArea(I)  
%用于找出一个二值图像中面积最大的连通分量

imLabel = bwlabel(I);                %对各连通域进行标记  
stats = regionprops(imLabel,'Area');    %求各连通域的大小  
area = cat(1,stats.Area);  
index = find(area == max(area));        %求最大连通域的索引  
img = ismember(imLabel,index);          %获取最大连通域图像  

end
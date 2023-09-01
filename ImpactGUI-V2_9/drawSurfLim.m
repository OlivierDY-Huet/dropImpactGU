function [imgsRGB]=drawSurfLim(imgsRGB,limPxList,colorLine) % Draw the surface limit
%imgsRGB: image RGB
%limPxList: table list (n,x,y) of pixel belonging to the surface limit
%colorLine: color RGB

s=size(imgsRGB{1});
h=height(limPxList);

limPxList2=cat(1,limPxList.(1),limPxList.(1)+s(1)*s(2),limPxList.(1)+2*s(1)*s(2));
colorLine2=uint8(reshape(colorLine.*ones(h,3),h*3,1));

for n=1:length(imgsRGB)
    imgsRGB{n}(limPxList2)=colorLine2;
end


end






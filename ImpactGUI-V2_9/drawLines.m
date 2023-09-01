function [imgsRGB]=drawLines(imgsRGB,posi,colorLine,thickness) % Draw a line
%imgsRGB: image RGB
%posi: position of the line extremities [x1,y1;...;xn,yn]
%colorLine: color RGB

pix2color=cell(length(posi),1);
colorVal=cell(length(posi),1);
s=size(imgsRGB{1});
[X,Y]=meshgrid(1:s(2),1:s(1));
for n=length(posi)
    imgBW=false(s(1),s(2));
    D=cell(1,3);
    for k=1:length(posi{n})-1
        D{1}=and(X<=max([posi{n}(k,1),posi{n}(k+1,1)]),X>=min([posi{n}(k,1),posi{n}(k+1,1)])); % Inside x limite
        D{2}=and(Y<=max([posi{n}(k,2),posi{n}(k+1,2)]),Y>=min([posi{n}(k,2),posi{n}(k+1,2)])); % Inside y limite
        D{3}=(abs((posi{n}(k+1,1)-posi{n}(k,1))*(Y-posi{n}(k,2))-(posi{n}(k+1,2)-posi{n}(k,2))*(X-posi{n}(k,1)))/sqrt((posi{n}(k+1,2)-posi{n}(k,2))^2+(posi{n}(k+1,1)-posi{n}(k,1))^2))<(sqrt(2)*thickness/2); % Short distance from the line
        imgBW=or(imgBW,and(and(D{1},D{2}),D{3}));
    end
    rp=regionprops('table',imgBW,'PixelIdxList');
    if size(rp,1)>1
        for r=size(rp,1):-1:2
            rp.PixelIdxList{1,1}=cat(1,rp.PixelIdxList{1,1},rp.PixelIdxList{r,1});
            rp(r,:)=[];
        end
    end
    pxList=rp.PixelIdxList{1,1};
    h=length(pxList);
    
    pix2color{n}=cat(1,pxList,pxList+s(1)*s(2),pxList+2*s(1)*s(2));
    colorVal{n}=uint8(reshape(colorLine.*ones(h,3),h*3,1));

end

if length(posi)<size(imgsRGB,1)
    pix2color=repmat(pix2color,size(imgsRGB));
    colorVal=repmat(colorVal,size(imgsRGB));
end

for n=1:length(imgsRGB)
    imgsRGB{n}(pix2color{n})=colorVal{n};
end


end
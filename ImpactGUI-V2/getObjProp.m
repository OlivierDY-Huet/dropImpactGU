function [r,imgsL]=getObjProp(imgsB,imgS)

r=cell(1,length(imgsB));
imgsL=cell(length(imgsB),1);
for n=1:length(imgsB)
    
    %Basic information
    r{n}=regionprops(imgsB{n},'Area','BoundingBox','Centroid','Eccentricity','EquivDiameter','MajorAxisLength','MinorAxisLength','Orientation','Perimeter','PixelIdxList','PixelList');
    
    %+ contact surface
    for m=1:length(r{n})
        imgFuse=not(imgS);
        imgFuse(r{n}(m).PixelIdxList)=true(length(r{n}(m).PixelIdxList),1); %figure,imshow(imgFuse)
        [~,num]=bwlabel(imgFuse);
        r{n}(m).SurfContact=(num==1);
        
        r{n}(m).deltaPos=NaN;
        r{n}(m).Ang=NaN;
        r{n}(m).dropID=NaN;
    end
    %Other method (same time of processing)
    %     imgFuse=or(imgsB{n},not(imgS)); %figure,imshow(imgFuse)
    %     [L,num]=bwlabel(imgFuse); %figure,subplot(2,1,1),imshow(L),subplot(2,1,2),imshow(label2rgb(L))
    %     numSurf=unique(L.*not(imgS));
    %     numSurf(numSurf==0)=[];
    %     for m=1:length(r{n})
    %         r{n}(m).SurfContact=(sum(L(r{n}(m).PixelIdxList(1))==numSurf)>0);
    %     end
    
    % 
    imgsL{n}=bwlabel(imgsB{n});
end

end
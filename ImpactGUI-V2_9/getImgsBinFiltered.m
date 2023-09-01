function [imgsB]=getImgsBinFiltered(imgsB,imgS,surfDist,minDetec)

if surfDist>0
    s=size(imgS);
    imgMask=~cat(1,imgS(surfDist+1:end,:),false(surfDist,s(2))); %figure,imshow(imgMask)
end

for n=1:length(imgsB)
    
    % Prevent noise from small surface deformation
    if surfDist>0
        cond=false(2,s(2));
        
        %Target zone
        imgSurNoise=imgsB{n}.*imgMask; %figure,imshow(imgSurNoise)
        
        % condition 1: thickness
        count=sum(imgSurNoise);
        cond(1,:)=(count>=surfDist);
        
        % condition 2: increasing
        topVal=ones(1,s(2))*s(1);
        for c=1:s(2)
            newVal=find(imgSurNoise(:,c)==1,1);
            if isempty(newVal)==0
                topVal(c)=newVal;
            end
        end
        cond(2,:)=false(1,s(2));
        for c=2:s(2)-1
            if or(topVal(c-1)>topVal(c),topVal(c+1)>topVal(c))
                cond(2,c)=true;
            end
        end
        
        % Keep pixels that respect condition 1 and condition 2 if in contact with pixels that respect condition 1
        fuse=or(cond(1,:),cond(2,:));
        r=regionprops(fuse,'PixelIdxList');
        for t=1:length(r)
            r(t).delPx=1;
            for p=1:length(r(t).PixelIdxList)
                if cond(1,r(t).PixelIdxList(p))==1
                    r(t).delPx=0;
                    break
                end
            end
            if r(t).delPx==0
                for p=1:length(r(t).PixelIdxList)
                    imgSurNoise(:,r(t).PixelIdxList(p))=false;
                end
            end
        end
        imgsB{n}=imgsB{n}.*not(imgSurNoise);
        
    end
    
    % Erase small elements
    if minDetec>0
        imgsB{n}=bwareaopen(imgsB{n},minDetec);
    end
    
    
end

end
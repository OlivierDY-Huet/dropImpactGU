function [pxList]=transfoCoord2PixelList(imgsR,type,posi,thickness)

% Type: Point/Line/Box
T=0;
switch type
    case 'Point'
        T=1;
    case 'Box'
        T=2;
    case 'Line'
        T=3;
    case 'Tracking'
        T=4;
end

% Initialisation
pxList=cell(1,length(posi));
s=size(imgsR{1});
[X,Y]=meshgrid(1:s(2),1:s(1));
imgBW0=false(s(1),s(2));

% Information into px
for n=1:length(posi)
    
    imgBW=imgBW0;
    
    % Create a binary image and add separated info
     
    switch T
        case 1
            [posi2]=splitArray(posi{n},0); %Split if NaN 
            for c=1:size(posi2,1)
                for k=1:size(posi2{c},1)
                    [imgBW]=addPoint(imgBW,X,Y,posi2{c}(k,:),thickness);
                end
            end     
            [pxList{n}]=makePxList(imgBW);
            
        case 2
            [posi2]=splitArray(posi{n},0); %Split if NaN 
            for c=1:size(posi2,1)
                posi2{c}(end+1,:)=posi2{c}(1,:); %Close the box
                for k=1:size(posi2{c},1)-1
                    [imgBW]=addLine(imgBW,X,Y,posi2{c}(k,:),posi2{c}(k+1,:),thickness);
                end
            end
            [pxList{n}]=makePxList(imgBW);
        case 3
            [posi2]=splitArray(posi{n},0); %Split if NaN 
            for c=1:size(posi2,1)            
                for k=1:size(posi2{c},1)-1
                    [imgBW]=addLine(imgBW,X,Y,posi2{c}(k,:),posi2{c}(k+1,:),thickness);
                end
            end
            [pxList{n}]=makePxList(imgBW);    
        case 4
            [posi2]=splitArray(posi{n},1); %Split if NaN 
            for c=1:size(posi2,1)
                if size(posi2{c},1)>1
                    for k=1:size(posi2{c},1)-1
                        [imgBW]=addLine(imgBW,X,Y,posi2{c}(k,:),posi2{c}(k+1,:),thickness);
                    end
                end
                [pxList{c,n}]=makePxList(imgBW); 
                if n>1
                    pxList{c,n}=cat(1,pxList{c,n-1},pxList{c,n});
                end
                imgBW=imgBW0;
            end      
    end
end


end



function [BW]=addPoint(BW,X,Y,pt,thickness)

Cond=(sqrt((X-pt(1)).^2+(Y-pt(2)).^2)<=thickness+sqrt(2)-1); % Short distance from the line

BW=or(BW,Cond);
end

function [BW]=addLine(BW,X,Y,pt1,pt2,thickness)
Cond=cell(2,1);

m=(pt2(2)-pt1(2))/(pt2(1)-pt1(1));
if (abs(m)<=1)
    b=pt1(2)-m*pt1(1);
    Cond{1}=and(X<=max([pt1(1),pt2(1)]),X>=min([pt1(1),pt2(1)])); % Inside x limite
    Cond{2}=(abs(Y-(m.*X+b))<((sqrt(2)-1)+thickness)/2); % Close to the line
else
    invm=1/m;
    invb=pt1(1)-invm*pt1(2);
    Cond{1}=and(Y<=max([pt1(2),pt2(2)]),Y>=min([pt1(2),pt2(2)])); % Inside y limite
    Cond{2}=(abs(X-(invm.*Y+invb))<((sqrt(2)-1)+thickness)/2); % Close to the line
end
BW=or(BW,and(Cond{1},Cond{2})); %figure,imshow(BW)

end

function [C]=splitArray(M,emptyCell)

if emptyCell==0 %Split wihout empty cells
    index=find(~isnan(M(:,1)));
    idx=find(diff(index)~=1);
    if ~isempty(idx)
        A=[idx(1);diff(idx);numel(index)-idx(end)];
        C=mat2cell(M(~isnan(M(:,1)),:),A,size(M,2));
    else
        C{1}=M;
    end
else %Split with empty cells
    index=find(isnan(M(:,1)));
    index=cat(1,0,index);
    A=diff(index)-1;
    C=mat2cell(M(~isnan(M(:,1)),:),A,size(M,2));
end
end

function [pixelList]=makePxList(BW)

rp=regionprops('table',BW,'PixelIdxList');

if ~isempty(rp)
    pixelList=rp.PixelIdxList{1,1};
    if size(rp,1)>1
        for r=2:size(rp,1)
            pixelList=cat(1,pixelList,rp.PixelIdxList{r,1});
        end
    end
else
    pixelList=[];
end

end
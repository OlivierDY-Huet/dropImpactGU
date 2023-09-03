% myName=mfilename;
% D=dir;
% idx=false(length(D),1);
% for k=1:length(D)
%     if length(D(k).name)>2
%         if strcmp(D(k).name(end-1:end),'.m')
%             if ~strcmp(D(k).name,[myName '.m'])
%                 idx(k)=true;
%             end
%         end
%     end 
% end
% list={D(idx).name};

mcc -m ImpactDropGUI_V2_20_dev.m

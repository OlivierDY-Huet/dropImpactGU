%Impact Drop GUI V2.0

% Copyright  The MathWorks Ltd.


%==========================================================================
%========================== Main function =================================
%==========================================================================

function [] = ImpactDropGUI_V2()


disp('GUI is opening ...')

% Open the window
S.window = figure( 'Name', 'Droplet Impaction GUI V2.0', ...
    'MenuBar', 'none', ...
    'Toolbar', 'none', ...
    'NumberTitle', 'off', ...
    'Position',round(get(0,'ScreenSize')*4/5));

%##########################################################################
% Structures that will store the data which is not dislay on the GUI 
I=struct; %Struture to gather the images

I.img.type.Raw=cell(1,1);
I.img.type.R=cell(1,1);
I.img.type.M=cell(1,1);
I.img.type.Mu=cell(1,1);
I.img.type.BG=cell(1,1);
I.img.type.BGu=cell(1,1);
I.img.type.E=cell(1,1);
I.img.type.Eu=cell(1,1);
I.img.type.S=cell(1,1);
I.img.type.Su=cell(1,1);
I.img.type.B=cell(1,1);
I.img.type.Bu=cell(1,1);
I.img.type.L=cell(1,1);
I.img.type.P=cell(1,1);
I.img.type.img2show=cell(1,1);

I.img.type.Raw={uint8(zeros(100,200,1))};
I.img.type.R=I.img.type.Raw;
I.img.type.img2show=I.img.type.R;

I.img.info.nbr=1;
I.img.info.size=size(I.img.type.Raw);
I.img.display.nbr=[1,1,1];
I.img.display.type=1; %1:Frames, 2:Single image, 3: Pinning images
I.img.display.analysisLvl=1;

I.img.view=1;

varCol={'enable','zone'};
varRow={'zoom';'clear';'crop'}; 
I.img.modi=cell2table(cell(length(varRow),length(varCol)),'VariableNames',varCol,'RowNames',varRow);
I.img.modi.enable{'zoom'}=0;
I.img.modi.enable{'clear'}=0;
I.img.modi.enable{'crop'}=0;
I.img.modi.zone{'zoom'}=[1,I.img.info.size(2),1,I.img.info.size(1)];



I.img.options={'Raw images',...
    'Modified images',...
    'Modified images 2',...
    'Background',...
    'Background 2',...
    'Enhanced images',...
    'Enhanced images 2',...
    'Binary surface',...
    'Binary surface 2',...
    'Binary images',...
    'Binary images 2',...
    'Pinned drops'};

varCol={'color','shape','positions','pxList'};
varRow={'addLines';'limitSurface';'centroid';'boundingBox';'contactAngle';'tracking';'drops';'class';'pinning';'underneath'};    
I.img.features0=cell2table(cell(length(varRow),length(varCol)),'VariableNames',varCol,'RowNames',varRow);
I.img.features0.color{'addLines'}=[0 200 0];
I.img.features0.color{'limitSurface'}=[255 0 0];
I.img.features0.color{'centroid'}=[0 0 255];
I.img.features0.color{'boundingBox'}=[255 0 255];
I.img.features0.color{'contactAngle'}=[255 140 0];
I.img.features0.color{'tracking'}='jet';
I.img.features0.color{'drops'}=[200 230 255];
I.img.features0.color{'underneath'}=[255 100 0];
I.img.features0.color{'class'}=[255,0,0;204,255,0;0,255,102;0,102,255;204,0,255];
I.img.features0.color{'pinning'}=[255,50,50;50,255,50;50,50,255];
I.img.features0.shape{'addLines'}=1;
I.img.features0.shape{'limitSurface'}=1;
I.img.features0.shape{'centroid'}=3;
I.img.features0.shape{'boundingBox'}=3;
I.img.features0.shape{'contactAngle'}=[2,50];
I.img.features0.shape{'tracking'}=2;
I.img.features0.shape{'underneath'}=1;
I.img.features0.shape{'class'}=1;
I.img.features0.shape{'pinning'}=1;
I.img.features0.positions{'addLines'}=cell(1,1);
I.img.features=I.img.features0;

varCol={'Path','Surface','Liquid','Camera','AddInfo','Lvl','Setting','Output'};
I.file.tab.mty=cell2table(cell(1,length(varCol)),'VariableNames',varCol);  
I.file.tab.full=I.file.tab.mty;
I.file.name='';

I.track.ori=cell(1,1);

I.obs.behaviours=[];
I.obs.mainDrop=[];

varCol={'Frame','Obj','Frame0','Obj0','Action'};
I.track.mty=array2table(zeros(0,length(varCol)),'VariableNames',varCol);
I.track.mod=I.track.mty;
I.track.new=[];
I.track.new2=[];
I.track.drops=[];
I.track.frames='all';

varCol={'Sattelite','OnSurf','AboveSurf','Upwards','Ignore'};
I.class.drops.tab0=array2table(false(0,length(varCol)),'VariableNames',varCol);
I.class.drops.tab=I.class.drops.tab0;
I.class.drops.text={'Sattelite drop','Drop formed on the surface','Drop formed above the surface','Drop bouncing','Ignored drop'};

varCol={'Frame','PinnedDrops','Limits','Type','volMethod','CalculatedShape','RelVol'};
I.class.pinning.tab0=array2table(cell(0,length(varCol)),'VariableNames',varCol);
I.class.pinning.tab=I.class.pinning.tab0;

%##########################################################################
% Interface creation

%==========================================================================
%Main panels

S.W_V=uix.VBoxFlex('Parent',S.window);
S.W_V1=uix.Panel('Parent',S.W_V);
S.W_V2=uix.Panel('Parent',S.W_V);
        S.W_V2_H=uix.HBoxFlex('Parent',S.W_V2);
        S.W_V2_H1=uix.Panel('Title','DATA','Parent',S.W_V2_H);
            S.W_V2_H1_V=uix.VBoxFlex('Parent',S.W_V2_H1);
            S.W_V2_H1_V1=uix.Panel('Title','Files','Parent',S.W_V2_H1_V);
                S.W_V2_H1_V1_T=uix.TabPanel('Parent',S.W_V2_H1_V1);
                S.W_V2_H1_V1_T1=uix.Panel('Title','New entry','Parent',S.W_V2_H1_V1_T);
                S.W_V2_H1_V1_T2=uix.Panel('Title','Pre-made list','Parent',S.W_V2_H1_V1_T);
                S.W_V2_H1_V1_T.TabTitles={'New','List'};
                %S.W_V2_H1_V1_T.TabWidth=150;
                S.W_V2_H1_V1_T.Selection=1;
            S.W_V2_H1_V2=uix.Panel('Title','Experiment','Parent',S.W_V2_H1_V);
            %set(S.W_V2_H1_V,'Heights',[-3 -3])
        S.W_V2_H2=uix.Panel('Title','ANALYSIS','Parent',S.W_V2_H);
            S.W_V2_H2_V=uix.VBoxFlex('Parent',S.W_V2_H2);
            S.W_V2_H2_V1=uix.Panel('Title','Image controller','Parent',S.W_V2_H2_V);
            S.W_V2_H2_V2=uix.Panel('Title','Analysis level','Parent',S.W_V2_H2_V);
            S.W_V2_H2_V3=uix.Panel('Title','Analysis settings','Parent',S.W_V2_H2_V);
                S.W_V2_H2_V3_T=uix.TabPanel('Parent',S.W_V2_H2_V3);
                S.W_V2_H2_V3_T1=uix.Panel('Title','Image dimension','Parent',S.W_V2_H2_V3_T);
                S.W_V2_H2_V3_T2=uix.Panel('Title','Filters','Parent',S.W_V2_H2_V3_T);
                S.W_V2_H2_V3_T3=uix.Panel('Title','Background','Parent',S.W_V2_H2_V3_T);
                S.W_V2_H2_V3_T4=uix.Panel('Title','Surface limit','Parent',S.W_V2_H2_V3_T);
                S.W_V2_H2_V3_T5=uix.Panel('Title','Light focus','Parent',[]);
                S.W_V2_H2_V3_T6=uix.Panel('Title','Binarisation','Parent',S.W_V2_H2_V3_T);
                S.W_V2_H2_V3_T7=uix.Panel('Title','Binarisation','Parent',[]);
                S.W_V2_H2_V3_T8=uix.Panel('Title','Contact angle','Parent',S.W_V2_H2_V3_T);
                S.W_V2_H2_V3_T9=uix.Panel('Title','Underneath','Parent',[]);
                S.W_V2_H2_V3_T.TabTitles={'lvl 1','lvl 2','lvl 3','lvl 4','lvl 5','lvl 7'};
                %S.W_V2_H2_V3_T.TabTitles={'lvl 1','lvl 2','lvl 3','lvl 4','lvl 4U','lvl 5','lvl 5U','lvl 7','lvl 7U'};
                %S.W_V2_H2_V3_T.TabWidth=150;
                S.W_V2_H2_V3_T.Selection=1;
            set(S.W_V2_H2_V,'Heights',[-2.5 -1 -3.5])
        S.W_V2_H3=uix.Panel('Title','OUTPUTS','Parent',S.W_V2_H);
            S.W_V2_H3_V=uix.VBoxFlex('Parent',S.W_V2_H3);
            S.W_V2_H3_V1=uix.Panel('Title','Direct measurement','Parent',S.W_V2_H3_V);
            S.W_V2_H3_V2=uix.Panel('Title','Analysis outputs','Parent',S.W_V2_H3_V);
                S.W_V2_H3_V2_T=uix.TabPanel('Parent',S.W_V2_H3_V2);
                S.W_V2_H3_V2_T1=uix.Panel('Title','Falling drop properties','Parent',S.W_V2_H3_V2_T);
                S.W_V2_H3_V2_T2=uix.Panel('Title','Contact line','Parent',S.W_V2_H3_V2_T);
                S.W_V2_H3_V2_T3=uix.Panel('Title','Pinning','Parent',S.W_V2_H3_V2_T);
                S.W_V2_H3_V2_T4=uix.Panel('Title','Impact observation','Parent',S.W_V2_H3_V2_T);
                S.W_V2_H3_V2_T5=uix.Panel('Title','Save the outputs','Parent',S.W_V2_H3_V2_T);
                S.W_V2_H3_V2_T.TabTitles={'Props','CL','Pinning','Obs','Save'};
                %S.W_V2_H3_V2_T.TabWidth=150;
                S.W_V2_H3_V2_T.Selection=1;
            set(S.W_V2_H3_V,'Heights',[-2 -3])
        set(S.W_V2_H,'Widths',[-1 -1 -1]);
set(S.W_V,'Heights',[-3 -2])
    

%==========================================================================
% DATA

%--------------------------------------------------------------------------
% Files, tab: New

S.W_V2_H1_V1_T1_V=uix.VBox('Parent',S.W_V2_H1_V1_T1);
S.W_V2_H1_V1_T1_V1=uix.Panel('BorderType','none','Parent',S.W_V2_H1_V1_T1_V);
    S.W_V2_H1_V1_T1_V1_H=uix.HBox('Parent',S.W_V2_H1_V1_T1_V1);
    uicontrol('Style','text','HorizontalAlignment','left','String','Data location','Parent',S.W_V2_H1_V1_T1_V1_H);
    uicontrol('Style','text','HorizontalAlignment','left','String','Root','Parent',S.W_V2_H1_V1_T1_V1_H);
    S.W_V2_H1_V1_T1_V1_H_edit(1)=uicontrol('Style','edit','String',['C:' filesep],'Parent',S.W_V2_H1_V1_T1_V1_H);
    S.W_V2_H1_V1_T1_V1_H_push(1)=uicontrol('Style','pushbutton','String','Browse','Parent',S.W_V2_H1_V1_T1_V1_H);
    uix.Empty('Parent',S.W_V2_H1_V1_T1_V1_H)
    uicontrol('Style','text','HorizontalAlignment','left','String','Relative','Parent',S.W_V2_H1_V1_T1_V1_H);
    S.W_V2_H1_V1_T1_V1_H_edit(2)=uicontrol('Style','edit','String','','Parent',S.W_V2_H1_V1_T1_V1_H);
    S.W_V2_H1_V1_T1_V1_H_push(2)=uicontrol('Style','pushbutton','String','Browse','Parent',S.W_V2_H1_V1_T1_V1_H);
    set(S.W_V2_H1_V1_T1_V1_H,'Widths',[-2 -1 -2 -1 -0.5 -1 -2 -1]);
S.W_V2_H1_V1_T1_V2=uix.Panel('BorderType','none','Parent',S.W_V2_H1_V1_T1_V);
    S.W_V2_H1_V1_T1_V2_H=uix.HBox('Parent',S.W_V2_H1_V1_T1_V2);
    uicontrol('Style','text','HorizontalAlignment','left','String','Data information','Parent',S.W_V2_H1_V1_T1_V2_H);
    uicontrol('Style','text','HorizontalAlignment','left','String','Type','Parent',S.W_V2_H1_V1_T1_V2_H);
    S.W_V2_H1_V1_T1_V2_H_pop(1)=uicontrol('Style','pop','HorizontalAlignment','left','String',{'Images','Movie'},'value',1,'Parent',S.W_V2_H1_V1_T1_V2_H);
    uix.Empty('Parent',S.W_V2_H1_V1_T1_V2_H)
    uix.Empty('Parent',S.W_V2_H1_V1_T1_V2_H)
    uicontrol('Style','text','HorizontalAlignment','left','String','Format','Parent',S.W_V2_H1_V1_T1_V2_H);
    S.W_V2_H1_V1_T1_V2_H_pop(2)=uicontrol('Style','pop','HorizontalAlignment','left','String',{'tif','tiff','jpg','jpeg','png','bmp'},'value',1,'Parent',S.W_V2_H1_V1_T1_V2_H);
    uix.Empty('Parent',S.W_V2_H1_V1_T1_V2_H)
    set(S.W_V2_H1_V1_T1_V2_H,'Widths',[-2 -1 -2 -1 -0.5 -1 -2 -1]);            
S.W_V2_H1_V1_T1_V3=uix.Panel('BorderType','none','Parent',S.W_V2_H1_V1_T1_V);
    S.W_V2_H1_V1_T1_V3_H=uix.HBox('Parent',S.W_V2_H1_V1_T1_V3);
    uicontrol('Style','text','HorizontalAlignment','left','String','File name','Parent',S.W_V2_H1_V1_T1_V3_H);
    S.W_V2_H1_V1_T1_V3_H_pop=uicontrol('Style','pop','HorizontalAlignment','left','String',{'New file','Old file'},'value',1,'Parent',S.W_V2_H1_V1_T1_V3_H);
    S.W_V2_H1_V1_T1_V3_H_edit=uicontrol('Style','edit','String','','Parent',S.W_V2_H1_V1_T1_V3_H);
    S.W_V2_H1_V1_T1_V3_H_push(1)=uicontrol('Style','pushbutton','String','Browse','Parent',S.W_V2_H1_V1_T1_V3_H);
    uix.Empty('Parent',S.W_V2_H1_V1_T1_V3_H)
    S.W_V2_H1_V1_T1_V3_H_push(2)=uicontrol('Style','pushbutton','String','NEW','Parent',S.W_V2_H1_V1_T1_V3_H);
    set(S.W_V2_H1_V1_T1_V3_H,'Widths',[-2 -1 -2 -1 -1.5 -3]);
    
%--------------------------------------------------------------------------
% Files, tab: List

S.W_V2_H1_V1_T2_V=uix.VBox('Parent',S.W_V2_H1_V1_T2);
S.W_V2_H1_V1_T2_V1=uix.Panel('BorderType','none','Parent',S.W_V2_H1_V1_T2_V);
    S.W_V2_H1_V1_T2_V1_H=uix.HBox('Parent',S.W_V2_H1_V1_T2_V1);
    uicontrol('Style','text','HorizontalAlignment','left','String','Root folder','Parent',S.W_V2_H1_V1_T2_V1_H);
    S.W_V2_H1_V1_T2_V1_H_edit=uicontrol('Style','edit','String',['C:' filesep],'Parent',S.W_V2_H1_V1_T2_V1_H);
    S.W_V2_H1_V1_T2_V1_H_push=uicontrol('Style','pushbutton','String','Browse','Parent',S.W_V2_H1_V1_T2_V1_H);
    uix.Empty('Parent',S.W_V2_H1_V1_T2_V1_H)
    set(S.W_V2_H1_V1_T2_V1_H,'Widths',[-2 -3 -1 -4.5]);
S.W_V2_H1_V1_T2_V2=uix.Panel('BorderType','none','Parent',S.W_V2_H1_V1_T2_V);
    S.W_V2_H1_V1_T2_V2_H=uix.HBox('Parent',S.W_V2_H1_V1_T2_V2);
    uicontrol('Style','text','HorizontalAlignment','left','String','File name','Parent',S.W_V2_H1_V1_T2_V2_H);
    S.W_V2_H1_V1_T2_V2_H_edit=uicontrol('Style','edit','String','','Parent',S.W_V2_H1_V1_T2_V2_H);
    S.W_V2_H1_V1_T2_V2_H_push=uicontrol('Style','pushbutton','String','Browse','Parent',S.W_V2_H1_V1_T2_V2_H);
    uix.Empty('Parent',S.W_V2_H1_V1_T2_V2_H)
    set(S.W_V2_H1_V1_T2_V2_H,'Widths',[-2 -3 -1 -4.5]);
S.W_V2_H1_V1_T2_V3=uix.Panel('BorderType','none','Parent',S.W_V2_H1_V1_T2_V);
    S.W_V2_H1_V1_T2_V3_H=uix.HBox('Parent',S.W_V2_H1_V1_T2_V3);
    uix.Empty('Parent',S.W_V2_H1_V1_T2_V3_H)
    S.W_V2_H1_V1_T2_V3_H_push=uicontrol('Style','pushbutton','String','START','Parent',S.W_V2_H1_V1_T2_V3_H);
    set(S.W_V2_H1_V1_T2_V3_H,'Widths',[-7.5 -3]);
            
%--------------------------------------------------------------------------
% Experiments

S.W_V2_H1_V2_V=uix.VBox('Parent',S.W_V2_H1_V2);
S.W_V2_H1_V2_V1=uix.Panel('BorderType','none','Parent',S.W_V2_H1_V2_V);
    S.W_V2_H1_V2_V1_H=uix.HBox('Parent',S.W_V2_H1_V2_V1);
    uicontrol('Style','text','HorizontalAlignment','left','String','Data set number','Parent',S.W_V2_H1_V2_V1_H);
    S.W_V2_H1_V2_V1_H_edit=uicontrol('Style','edit','String','1','Parent',S.W_V2_H1_V2_V1_H);
    S.W_V2_H1_V2_V1_H_push(1)=uicontrol('Style','pushbutton','String','-','Parent',S.W_V2_H1_V2_V1_H);
    S.W_V2_H1_V2_V1_H_push(2)=uicontrol('Style','pushbutton','String','+','Parent',S.W_V2_H1_V2_V1_H);
    uix.Empty('Parent',S.W_V2_H1_V2_V1_H)
    S.W_V2_H1_V2_V1_H_push(3)=uicontrol('Style','pushbutton','String','Load','Parent',S.W_V2_H1_V2_V1_H);
    S.W_V2_H1_V2_V1_H_push(4)=uicontrol('Style','pushbutton','String','Reset','Parent',S.W_V2_H1_V2_V1_H);
    set(S.W_V2_H1_V2_V1_H,'Widths',[-1.2 -1 -1 -1 -1 -1 -1])
S.W_V2_H1_V2_V2=uix.Panel('BorderType','none','Parent',S.W_V2_H1_V2_V);
    S.W_V2_H1_V2_V2_H=uix.HBox('Parent',S.W_V2_H1_V2_V2);
    uicontrol('Style','text','HorizontalAlignment','left','String','Path','Parent',S.W_V2_H1_V2_V2_H);
    S.W_V2_H1_V2_V2_H_edit=uicontrol('Style','edit','String','Path','Parent',S.W_V2_H1_V2_V2_H);
    set(S.W_V2_H1_V2_V2_H,'Widths',[-1 -5])
    set(S.W_V2_H1_V2_V2_H_edit,'enable','off')
S.W_V2_H1_V2_V3=uix.Panel('BorderType','none','Parent',S.W_V2_H1_V2_V);
    S.W_V2_H1_V2_V3_H=uix.HBox('Parent',S.W_V2_H1_V2_V3);
    uicontrol('Style','text','HorizontalAlignment','left','String','Surface','Parent',S.W_V2_H1_V2_V3_H);
    S.W_V2_H1_V2_V3_H_edit(1)=uicontrol('Style','edit','String','Surface','Parent',S.W_V2_H1_V2_V3_H);
    uix.Empty('Parent',S.W_V2_H1_V2_V3_H)
    uicontrol('Style','text','HorizontalAlignment','left','String','Liquid','Parent',S.W_V2_H1_V2_V3_H);
    S.W_V2_H1_V2_V3_H_edit(2)=uicontrol('Style','edit','String','Liquid','Parent',S.W_V2_H1_V2_V3_H);
    uix.Empty('Parent',S.W_V2_H1_V2_V3_H)
S.W_V2_H1_V2_V4=uix.Panel('BorderType','none','Parent',S.W_V2_H1_V2_V);
    S.W_V2_H1_V2_V4_H=uix.HBox('Parent',S.W_V2_H1_V2_V4);
    uicontrol('Style','text','HorizontalAlignment','left','String','FPS','Parent',S.W_V2_H1_V2_V4_H);
    S.W_V2_H1_V2_V4_H_edit(1)=uicontrol('Style','edit','String',0,'Parent',S.W_V2_H1_V2_V4_H);
    uix.Empty('Parent',S.W_V2_H1_V2_V4_H)
    uicontrol('Style','text','HorizontalAlignment','left','String','Milimeter to pixel','Parent',S.W_V2_H1_V2_V4_H);
    S.W_V2_H1_V2_V4_H_edit(2)=uicontrol('Style','edit','String',0,'Parent',S.W_V2_H1_V2_V4_H);
    uicontrol('Style','text','HorizontalAlignment','left','String','px/mm','Parent',S.W_V2_H1_V2_V4_H);
S.W_V2_H1_V2_V5=uix.Panel('BorderType','none','Parent',S.W_V2_H1_V2_V);
    S.W_V2_H1_V2_V5_H=uix.HBox('Parent',S.W_V2_H1_V2_V5);
    uicontrol('Style','text','HorizontalAlignment','left','String','View(s)','Parent',S.W_V2_H1_V2_V5_H);
    S.W_V2_H1_V2_V5_H_pop=uicontrol('Style','pop','HorizontalAlignment','left','String',{'Side','Side + Underneath'},'value',1,'Parent',S.W_V2_H1_V2_V5_H);
    uix.Empty('Parent',S.W_V2_H1_V2_V5_H)
    uicontrol('Style','text','HorizontalAlignment','left','String','Separation','Parent',S.W_V2_H1_V2_V5_H);
    S.W_V2_H1_V2_V5_H_edit=uicontrol('Style','edit','String',0,'Parent',S.W_V2_H1_V2_V5_H);
    uicontrol('Style','text','HorizontalAlignment','left','String','px','Parent',S.W_V2_H1_V2_V5_H);
    set(S.W_V2_H1_V2_V5_H_edit,'Enable','off')
    
%==========================================================================
% ANALYSIS        
        
%--------------------------------------------------------------------------
% Image controller 

S.W_V2_H2_V1_V=uix.VBox('Parent',S.W_V2_H2_V1);
S.W_V2_H2_V1_V_V1=uix.Panel('BorderType','none','Parent',S.W_V2_H2_V1_V);
    S.W_V2_H2_V1_V_V1_H=uix.HBox('Parent',S.W_V2_H2_V1_V_V1);
    S.W_V2_H2_V1_V_V1_H_pop=uicontrol('Style','pop','HorizontalAlignment','left','String',{'-'},'value',1,'Parent',S.W_V2_H2_V1_V_V1_H); %list
    S.W_V2_H2_V1_V_V1_H_edit(1)=uicontrol('Style','edit','String','1','Parent',S.W_V2_H2_V1_V_V1_H);
    uicontrol('Style','text','HorizontalAlignment','left','String','/','Parent',S.W_V2_H2_V1_V_V1_H);
    S.W_V2_H2_V1_V_V1_H_edit(2)=uicontrol('Style','edit','String','100','Parent',S.W_V2_H2_V1_V_V1_H);
    S.W_V2_H2_V1_V_V1_H_H=uix.HButtonBox('Parent',S.W_V2_H2_V1_V_V1_H);
        S.W_V2_H2_V1_V_V1_H_H_push(1)=uicontrol('Style','pushbutton','String','-','Parent',S.W_V2_H2_V1_V_V1_H);
        S.W_V2_H2_V1_V_V1_H_H_push(2)=uicontrol('Style','pushbutton','String','+','Parent',S.W_V2_H2_V1_V_V1_H);
    S.W_V2_H2_V1_V_V1_H_slide=uicontrol('style','slide','min',1,'max',100,'val',50,'Parent',S.W_V2_H2_V1_V_V1_H);
    set(S.W_V2_H2_V1_V_V1_H,'Widths',[-2 -1 -0.1 -1 -1 -1 -1 -5]);
    

    
S.W_V2_H2_V1_V_V2=uix.Panel('BorderType','none','Parent',S.W_V2_H2_V1_V);
    S.W_V2_H2_V1_V_V2_T=uix.TabPanel('Parent',S.W_V2_H2_V1_V_V2);
    S.W_V2_H2_V1_V_V2_T1=uix.Panel('BorderType','none','Parent',S.W_V2_H2_V1_V_V2_T);
        S.W_V2_H2_V1_V_V2_T1_H=uix.HBox('Parent',S.W_V2_H2_V1_V_V2_T1);
        S.W_V2_H2_V1_V_V2_T1_H_toggle(1)=uicontrol('Style','toggle','String','Surface','Parent',S.W_V2_H2_V1_V_V2_T1_H);
        S.W_V2_H2_V1_V_V2_T1_H_toggle(2)=uicontrol('Style','toggle','String','Centroid','Parent',S.W_V2_H2_V1_V_V2_T1_H);
        S.W_V2_H2_V1_V_V2_T1_H_toggle(3)=uicontrol('Style','toggle','String','Bounding box','Parent',S.W_V2_H2_V1_V_V2_T1_H);
        S.W_V2_H2_V1_V_V2_T1_H_toggle(4)=uicontrol('Style','toggle','String','Track','Parent',S.W_V2_H2_V1_V_V2_T1_H);
        S.W_V2_H2_V1_V_V2_T1_H_toggle(5)=uicontrol('Style','toggle','String','Tracked drop','Parent',S.W_V2_H2_V1_V_V2_T1_H);
        S.W_V2_H2_V1_V_V2_T1_H_toggle(6)=uicontrol('Style','toggle','String','Contact line','Parent',S.W_V2_H2_V1_V_V2_T1_H);
        S.W_V2_H2_V1_V_V2_T1_H_toggle(7)=uicontrol('Style','toggle','String','Class','Parent',S.W_V2_H2_V1_V_V2_T1_H);
    S.W_V2_H2_V1_V_V2_T2=uix.Panel('BorderType','none','Parent',S.W_V2_H2_V1_V_V2_T);
        S.W_V2_H2_V1_V_V2_T2_H=uix.HBox('Parent',S.W_V2_H2_V1_V_V2_T2);
        S.W_V2_H2_V1_V_V2_T2_H_push(1)=uicontrol('Style','pushbutton','String','Color options','Parent',S.W_V2_H2_V1_V_V2_T2_H);
        S.W_V2_H2_V1_V_V2_T2_H_push(2)=uicontrol('Style','pushbutton','String','Shape options','Parent',S.W_V2_H2_V1_V_V2_T2_H);
    S.W_V2_H2_V1_V_V2_T3=uix.Panel('BorderType','none','Parent',S.W_V2_H2_V1_V_V2_T);
        S.W_V2_H2_V1_V_V2_T3_H=uix.HBox('Parent',S.W_V2_H2_V1_V_V2_T3);
        S.W_V2_H2_V1_V_V2_T3_H_push(1)=uicontrol('Style','pushbutton','String','Save image','Parent',S.W_V2_H2_V1_V_V2_T3_H);
        S.W_V2_H2_V1_V_V2_T3_H_push(2)=uicontrol('Style','pushbutton','String','Save movie','Parent',S.W_V2_H2_V1_V_V2_T3_H);
    S.W_V2_H2_V1_V_V2_T.TabTitles={'Features','Options','Save'};           
    S.W_V2_H2_V1_V_V2_T.Selection=1;
    

%--------------------------------------------------------------------------
% Analysis level 

S.W_V2_H2_V2_H=uix.HBox('Parent',S.W_V2_H2_V2);
S.W_V2_H2_V2_H_pop=uicontrol('Style','pop','HorizontalAlignment','left','String',{'Dimension','Filters','Enhancing','Surface limit','Binarisation','Main tracking','Main info','Full tracking','Classification','Pinning'},'value',1,'Parent',S.W_V2_H2_V2_H); %list
S.W_V2_H2_V2_H_edit=uicontrol('Style','edit','String','1','Parent',S.W_V2_H2_V2_H);
S.W_V2_H2_V2_H_H=uix.HButtonBox('Parent',S.W_V2_H2_V2_H);
    S.W_V2_H2_V2_H_H_push(1)=uicontrol('Style','pushbutton','String','Previous','Parent',S.W_V2_H2_V2_H_H);
    S.W_V2_H2_V2_H_H_push(2)=uicontrol('Style','pushbutton','String','Next','Parent',S.W_V2_H2_V2_H_H);
    S.W_V2_H2_V2_H_H_push(3)=uicontrol('Style','pushbutton','String','End','Parent',S.W_V2_H2_V2_H_H);

%--------------------------------------------------------------------------
% Analysis settings, tab: lvl 1: Dim

S.W_V2_H2_V3_T1_G=uix.Grid('Parent',S.W_V2_H2_V3_T1);
uicontrol('Style','text','HorizontalAlignment','center','String','x','Parent',S.W_V2_H2_V3_T1_G); %--
S.W_V2_H2_V3_T1_G_edit(1)=uicontrol('Style','edit','String','0','Parent',S.W_V2_H2_V3_T1_G);
S.W_V2_H2_V3_T1_G_edit(2)=uicontrol('Style','edit','String','0','Parent',S.W_V2_H2_V3_T1_G);
uicontrol('Style','text','HorizontalAlignment','center','String','y','Parent',S.W_V2_H2_V3_T1_G); %--
S.W_V2_H2_V3_T1_G_edit(3)=uicontrol('Style','edit','String','0','Parent',S.W_V2_H2_V3_T1_G);
S.W_V2_H2_V3_T1_G_edit(4)=uicontrol('Style','edit','String','0','Parent',S.W_V2_H2_V3_T1_G);
uix.Empty('Parent',S.W_V2_H2_V3_T1_G) %--
uicontrol('Style','text','HorizontalAlignment','left','String','px','Parent',S.W_V2_H2_V3_T1_G);
uicontrol('Style','text','HorizontalAlignment','left','String','px','Parent',S.W_V2_H2_V3_T1_G);
uix.Empty('Parent',S.W_V2_H2_V3_T1_G) %--
S.W_V2_H2_V3_T1_G_push(1)=uicontrol('Style','pushbutton','String','Crop','Parent',S.W_V2_H2_V3_T1_G);
S.W_V2_H2_V3_T1_G_push(2)=uicontrol('Style','pushbutton','String','Reset','Parent',S.W_V2_H2_V3_T1_G);
set(S.W_V2_H2_V3_T1_G,'Widths',[-1 -1 -1 -2],'Heights',[-1 -1 -1]);

%--------------------------------------------------------------------------
% Analysis settings, tab: lvl 2: Filters

S.W_V2_H2_V3_T2_G=uix.Grid('Parent',S.W_V2_H2_V3_T2);
S.W_V2_H2_V3_T2_G_check(1)=uicontrol('Style','checkbox','String','Median filter','value',0,'Parent',S.W_V2_H2_V3_T2_G); %--
uix.Empty('Parent',S.W_V2_H2_V3_T2_G);
S.W_V2_H2_V3_T2_G_check(2)=uicontrol('Style','checkbox','String','Sharpening filter','value',0,'Parent',S.W_V2_H2_V3_T2_G); %--
uix.Empty('Parent',S.W_V2_H2_V3_T2_G);

%--------------------------------------------------------------------------
% Analysis settings, tab: lvl 3: Background

S.W_V2_H2_V3_T3_H=uix.HBox('Parent',S.W_V2_H2_V3_T3);
uicontrol('Style','text','HorizontalAlignment','left','String','Number of images:','Parent',S.W_V2_H2_V3_T3_H);
S.W_V2_H2_V3_T3_H_edit=uicontrol('Style','edit','String','0','Parent',S.W_V2_H2_V3_T3_H);
S.W_V2_H2_V3_T3_H_push=uicontrol('Style','pushbutton','String','Default','Parent',S.W_V2_H2_V3_T3_H);

%--------------------------------------------------------------------------
% Analysis settings, tab: lvl 4: Surf

S.W_V2_H2_V3_T4_H=uix.HBox('Parent',S.W_V2_H2_V3_T4);        
S.W_V2_H2_V3_T4_H1=uix.Panel('BorderType','none','Parent',S.W_V2_H2_V3_T4_H); %--
    S.W_V2_H2_V3_T4_H1_V=uix.VBox('Parent',S.W_V2_H2_V3_T4_H1);
    uix.Empty('Parent',S.W_V2_H2_V3_T4_H1_V);
    uix.Empty('Parent',S.W_V2_H2_V3_T4_H1_V);              
S.W_V2_H2_V3_T4_H2=uix.Panel('BorderType','none','Parent',S.W_V2_H2_V3_T4_H); %--
    S.W_V2_H2_V3_T4_H2_V=uix.VBox('Parent',S.W_V2_H2_V3_T4_H2);
    S.W_V2_H2_V3_T4_H2_V_radio(1)=uicontrol('Style','radiobutton','HorizontalAlignment','center','String','Line','Value',1,'Parent',S.W_V2_H2_V3_T4_H2_V);
    S.W_V2_H2_V3_T4_H2_V_radio(2)=uicontrol('Style','radiobutton','HorizontalAlignment','center','String','Background','Value',0,'Parent',S.W_V2_H2_V3_T4_H2_V);      
S.W_V2_H2_V3_T4_H3=uix.Panel('BorderType','none','Parent',S.W_V2_H2_V3_T4_H); %--
    S.W_V2_H2_V3_T4_H3_V=uix.VBox('Parent',S.W_V2_H2_V3_T4_H3);
    S.W_V2_H2_V3_T4_H3_V1=uix.Panel('BorderType','none','Parent',S.W_V2_H2_V3_T4_H3_V);
        S.W_V2_H2_V3_T4_H3_V1_H=uix.HBox('Parent',S.W_V2_H2_V3_T4_H3_V1);
        S.W_V2_H2_V3_T4_H3_V1_H_edit(1)=uicontrol('Style','edit','String','0','Parent',S.W_V2_H2_V3_T4_H3_V1_H);
        S.W_V2_H2_V3_T4_H3_V1_H1=uix.HButtonBox('Parent',S.W_V2_H2_V3_T4_H3_V1_H); 
            S.W_V2_H2_V3_T4_H3_V1_H1_push(1)=uicontrol('Style','pushbutton','String','+','Parent',S.W_V2_H2_V3_T4_H3_V1_H1);
            S.W_V2_H2_V3_T4_H3_V1_H1_push(2)=uicontrol('Style','pushbutton','String','-','Parent',S.W_V2_H2_V3_T4_H3_V1_H1);
        S.W_V2_H2_V3_T4_H3_V1_H_edit(2)=uicontrol('Style','edit','String','0','Parent',S.W_V2_H2_V3_T4_H3_V1_H);
        S.W_V2_H2_V3_T4_H3_V1_H2=uix.HButtonBox('Parent',S.W_V2_H2_V3_T4_H3_V1_H);
            S.W_V2_H2_V3_T4_H3_V1_H2_push(1)=uicontrol('Style','pushbutton','String','+','Parent',S.W_V2_H2_V3_T4_H3_V1_H2);
            S.W_V2_H2_V3_T4_H3_V1_H2_push(2)=uicontrol('Style','pushbutton','String','-','Parent',S.W_V2_H2_V3_T4_H3_V1_H2);
    S.W_V2_H2_V3_T4_H3_V2=uix.Panel('BorderType','none','Parent',S.W_V2_H2_V3_T4_H3_V);
        S.W_V2_H2_V3_T4_H3_V2_H=uix.HBox('Parent',S.W_V2_H2_V3_T4_H3_V2);
        S.W_V2_H2_V3_T4_H3_V2_H_edit=uicontrol('Style','edit','String','0','Parent',S.W_V2_H2_V3_T4_H3_V2_H);
        uix.Empty('Parent',S.W_V2_H2_V3_T4_H3_V2_H)       
S.W_V2_H2_V3_T4_H4=uix.Panel('BorderType','none','Parent',S.W_V2_H2_V3_T4_H); %--
S.W_V2_H2_V3_T4_H4_V=uix.VBox('Parent',S.W_V2_H2_V3_T4_H4);
S.W_V2_H2_V3_T4_H3_V2_push(1)=uicontrol('Style','pushbutton','String','Reset','Parent',S.W_V2_H2_V3_T4_H4_V);
S.W_V2_H2_V3_T4_H3_V2_push(2)=uicontrol('Style','pushbutton','String','Reset','Parent',S.W_V2_H2_V3_T4_H4_V);

% Analysis settings, tab: lvl 4 U: Focus
S.W_V2_H2_V3_T5_G=uix.Grid('Parent',S.W_V2_H2_V3_T5);
S.W_V2_H2_V3_T5_G_pop=uicontrol('Style','pop','HorizontalAlignment','left','String',{'no','yes'},'value',2,'Parent',S.W_V2_H2_V3_T5_G);%--
uix.Empty('Parent',S.W_V2_H2_V3_T5_G)
uix.Empty('Parent',S.W_V2_H2_V3_T5_G)    
S.W_V2_H2_V3_T5_G_edit=uicontrol('Style','edit','String','0','Parent',S.W_V2_H2_V3_T5_G); %--
uix.Empty('Parent',S.W_V2_H2_V3_T5_G)
uix.Empty('Parent',S.W_V2_H2_V3_T5_G)    
uicontrol('Style','text','HorizontalAlignment','left','String','[uint8]','Parent',S.W_V2_H2_V3_T5_G);%--
uix.Empty('Parent',S.W_V2_H2_V3_T5_G) 
uix.Empty('Parent',S.W_V2_H2_V3_T5_G)
S.W_V2_H2_V3_T5_G_push=uicontrol('Style','pushbutton','String','Reset','Parent',S.W_V2_H2_V3_T5_G);%--
uix.Empty('Parent',S.W_V2_H2_V3_T5_G)
uix.Empty('Parent',S.W_V2_H2_V3_T5_G)
uix.Empty('Parent',S.W_V2_H2_V3_T5_G)%--
uix.Empty('Parent',S.W_V2_H2_V3_T5_G)
uix.Empty('Parent',S.W_V2_H2_V3_T5_G)
set(S.W_V2_H2_V3_T5_G,'Widths',[-1 -1 -0.5 1 -2],'Heights',[-1 -1 -1]);

%--------------------------------------------------------------------------
% Analysis settings, tab: lvl 5: Bin

S.W_V2_H2_V3_T6_G=uix.Grid('Parent',S.W_V2_H2_V3_T6);
uicontrol('Style','text','HorizontalAlignment','left','String','Threshold liq./air','Parent',S.W_V2_H2_V3_T6_G); %--
uicontrol('Style','text','HorizontalAlignment','left','String','Minimum detection','Parent',S.W_V2_H2_V3_T6_G);
uicontrol('Style','text','HorizontalAlignment','left','String','Surface correction','Parent',S.W_V2_H2_V3_T6_G);
S.W_V2_H2_V3_T6_G_edit(1)=uicontrol('Style','edit','String','0','Parent',S.W_V2_H2_V3_T6_G); %--
S.W_V2_H2_V3_T6_G_edit(2)=uicontrol('Style','edit','String','0','Parent',S.W_V2_H2_V3_T6_G);
S.W_V2_H2_V3_T6_G_edit(3)=uicontrol('Style','edit','String','0','Parent',S.W_V2_H2_V3_T6_G);
uicontrol('Style','text','HorizontalAlignment','left','String','[uint8]','Parent',S.W_V2_H2_V3_T6_G); %--
uicontrol('Style','text','HorizontalAlignment','left','String','[px]','Parent',S.W_V2_H2_V3_T6_G);
uicontrol('Style','text','HorizontalAlignment','left','String','[px]','Parent',S.W_V2_H2_V3_T6_G);
S.W_V2_H2_V3_T6_G_check(1)=uicontrol('Style','checkbox','String','Fill above surface','value',1,'Parent',S.W_V2_H2_V3_T6_G); %--
S.W_V2_H2_V3_T6_G_check(2)=uicontrol('Style','checkbox','String','Fill on surface','value',1,'Parent',S.W_V2_H2_V3_T6_G);
S.W_V2_H2_V3_T6_G_push=uicontrol('Style','pushbutton','String','Default','Parent',S.W_V2_H2_V3_T6_G);
set(S.W_V2_H2_V3_T6_G,'Widths',[-2 -1 -0.5 -2],'Heights',[-1 -1 -1]);


% Analysis settings, tab: lvl 5 U: Bin

S.W_V2_H2_V3_T7_G=uix.Grid('Parent',S.W_V2_H2_V3_T7);
S.W_V2_H2_V3_T7_G_pop=uicontrol('Style','pop','HorizontalAlignment','left','String',{'Dark','Dark + Bright'},'value',1,'Parent',S.W_V2_H2_V3_T7_G); %--
uix.Empty('Parent',S.W_V2_H2_V3_T7_G)
uix.Empty('Parent',S.W_V2_H2_V3_T7_G)
uix.Empty('Parent',S.W_V2_H2_V3_T7_G)%--
uix.Empty('Parent',S.W_V2_H2_V3_T7_G)
uix.Empty('Parent',S.W_V2_H2_V3_T7_G)
uicontrol('Style','text','HorizontalAlignment','left','String','Dark threshold','Parent',S.W_V2_H2_V3_T7_G); %--
uicontrol('Style','text','HorizontalAlignment','left','String','Bright threshold','Parent',S.W_V2_H2_V3_T7_G);
uicontrol('Style','text','HorizontalAlignment','left','String','Minimum detection','Parent',S.W_V2_H2_V3_T7_G);
S.W_V2_H2_V3_T7_G_edit(1)=uicontrol('Style','edit','String','0','Parent',S.W_V2_H2_V3_T7_G); %--
S.W_V2_H2_V3_T7_G_edit(2)=uicontrol('Style','edit','String','255','Parent',S.W_V2_H2_V3_T7_G);
set(S.W_V2_H2_V3_T7_G_edit(2),'enable','off')
S.W_V2_H2_V3_T7_G_edit(3)=uicontrol('Style','edit','String','0','Parent',S.W_V2_H2_V3_T7_G);
uicontrol('Style','text','HorizontalAlignment','left','String','[uint8]','Parent',S.W_V2_H2_V3_T7_G);%--
uicontrol('Style','text','HorizontalAlignment','left','String','[uint8]','Parent',S.W_V2_H2_V3_T7_G);
uicontrol('Style','text','HorizontalAlignment','left','String','[px]','Parent',S.W_V2_H2_V3_T7_G);
S.W_V2_H2_V3_T7_G_push=uicontrol('Style','pushbutton','String','Default','Parent',S.W_V2_H2_V3_T7_G);%--
uix.Empty('Parent',S.W_V2_H2_V3_T7_G)
uix.Empty('Parent',S.W_V2_H2_V3_T7_G)
set(S.W_V2_H2_V3_T7_G,'Widths',[-2 -0.5 -1.5 -1 -0.5 -1],'Heights',[-1 -1 -1]);

%--------------------------------------------------------------------------
% Analysis settings, tab: lvl 7: CA

S.W_V2_H2_V3_T8_G=uix.Grid('Parent',S.W_V2_H2_V3_T8);
uicontrol('Style','text','HorizontalAlignment','left','String','Method','Parent',S.W_V2_H2_V3_T8_G);  %--
uicontrol('Style','text','HorizontalAlignment','left','String','Zone','Parent',S.W_V2_H2_V3_T8_G);
uix.Empty('Parent',S.W_V2_H2_V3_T8_G)
S.W_V2_H2_V3_T8_G_pop=uicontrol('Style','pop','HorizontalAlignment','left','String',{'None','Poly2-Auto','Poly2','Spline','Gradient'},'value',1,'Parent',S.W_V2_H2_V3_T8_G); %--
S.W_V2_H2_V3_T8_G_edit(1)=uicontrol('Style','edit','String','0','Parent',S.W_V2_H2_V3_T8_G);
S.W_V2_H2_V3_T8_G_push=uicontrol('Style','pushbutton','String','Default','Parent',S.W_V2_H2_V3_T8_G);
uix.Empty('Parent',S.W_V2_H2_V3_T8_G)  %--
uicontrol('Style','text','HorizontalAlignment','left','String','[px]','Parent',S.W_V2_H2_V3_T8_G);
uix.Empty('Parent',S.W_V2_H2_V3_T8_G)
uicontrol('Style','text','HorizontalAlignment','left','String','Offset','Parent',S.W_V2_H2_V3_T8_G);  %--
uicontrol('Style','text','HorizontalAlignment','left','String','Smooth','Parent',S.W_V2_H2_V3_T8_G);
uicontrol('Style','text','HorizontalAlignment','left','String','Weight','Parent',S.W_V2_H2_V3_T8_G);
S.W_V2_H2_V3_T8_G_edit(2)=uicontrol('Style','edit','String','0','Parent',S.W_V2_H2_V3_T8_G);  %--
S.W_V2_H2_V3_T8_G_edit(3)=uicontrol('Style','edit','String','0','Parent',S.W_V2_H2_V3_T8_G);
S.W_V2_H2_V3_T8_G_edit(4)=uicontrol('Style','edit','String','0','Parent',S.W_V2_H2_V3_T8_G);
uicontrol('Style','text','HorizontalAlignment','left','String','[px]','Parent',S.W_V2_H2_V3_T8_G);  %--
uicontrol('Style','text','HorizontalAlignment','left','String','(0-1)','Parent',S.W_V2_H2_V3_T8_G);  %--
uix.Empty('Parent',S.W_V2_H2_V3_T8_G)

set(S.W_V2_H2_V3_T8_G,'Widths',[-1 -1 -0.5 -1 -1 -0.5],'Heights',[-1 -1 -1]);   

% Analysis settings, tab: lvl 7U: Under

S.W_V2_H2_V3_T9_G=uix.Grid('Parent',S.W_V2_H2_V3_T9);

S.W_V2_H2_V3_T9_G_check=uicontrol('Style','checkbox','String','Complete under','value',1,'Parent',S.W_V2_H2_V3_T9_G);%--
set(S.W_V2_H2_V3_T9_G_check,'Enable','off')
uix.Empty('Parent',S.W_V2_H2_V3_T9_G)
uix.Empty('Parent',S.W_V2_H2_V3_T9_G)
S.W_V2_H2_V3_T9_G_edit=uicontrol('Style','edit','String','0','Parent',S.W_V2_H2_V3_T9_G);%--
uix.Empty('Parent',S.W_V2_H2_V3_T9_G)
uix.Empty('Parent',S.W_V2_H2_V3_T9_G)
uix.Empty('Parent',S.W_V2_H2_V3_T9_G)%--
uix.Empty('Parent',S.W_V2_H2_V3_T9_G)
uix.Empty('Parent',S.W_V2_H2_V3_T9_G)

set(S.W_V2_H2_V3_T9_G,'Widths',[-2 -1 -3],'Heights',[-1 -1 -1]); 

%==========================================================================
% OutputS

%--------------------------------------------------------------------------
% Direct measurement

S.W_V2_H3_V1_V=uix.VBox('Parent',S.W_V2_H3_V1);
S.W_V2_H3_V1_V1=uix.Panel('BorderType','none','Parent',S.W_V2_H3_V1_V);
    S.W_V2_H3_V1_V1_H=uix.HBox('Parent',S.W_V2_H3_V1_V1);
    S.W_V2_H3_V1_V1_H_text(1)=uicontrol('Style','text','HorizontalAlignment','left','String','Pointer location:','Parent',S.W_V2_H3_V1_V1_H);
    S.W_V2_H3_V1_V1_H_text(2)=uicontrol('Style','text','HorizontalAlignment','left','String',num2str([0,0],2),'Parent',S.W_V2_H3_V1_V1_H);
    uix.Empty('Parent',S.W_V2_H3_V1_V1_H)
    uix.Empty('Parent',S.W_V2_H3_V1_V1_H)
    uix.Empty('Parent',S.W_V2_H3_V1_V1_H)
S.W_V2_H3_V1_V2=uix.Panel('BorderType','none','Parent',S.W_V2_H3_V1_V);
    S.W_V2_H3_V1_V2_G=uix.Grid('Parent',S.W_V2_H3_V1_V2);
    uix.Empty('Parent',S.W_V2_H3_V1_V2_G) %--
    uicontrol('Style','text','HorizontalAlignment','left','String','Point 1','Parent',S.W_V2_H3_V1_V2_G);
    uicontrol('Style','text','HorizontalAlignment','left','String','Point 2','Parent',S.W_V2_H3_V1_V2_G);
    uicontrol('Style','text','HorizontalAlignment','left','String','Delta','Parent',S.W_V2_H3_V1_V2_G);
    uicontrol('Style','text','HorizontalAlignment','center','String','x','Parent',S.W_V2_H3_V1_V2_G); %--
    S.W_V2_H3_V1_V2_G_edit(1)=uicontrol('Style','edit','String','1','Parent',S.W_V2_H3_V1_V2_G);
    S.W_V2_H3_V1_V2_G_edit(2)=uicontrol('Style','edit','String','1','Parent',S.W_V2_H3_V1_V2_G);
    S.W_V2_H3_V1_V2_G_text(1)=uicontrol('Style','text','String','0','Parent',S.W_V2_H3_V1_V2_G);
    uicontrol('Style','text','HorizontalAlignment','center','String','y','Parent',S.W_V2_H3_V1_V2_G); %--
    S.W_V2_H3_V1_V2_G_edit(3)=uicontrol('Style','edit','String','1','Parent',S.W_V2_H3_V1_V2_G);
    S.W_V2_H3_V1_V2_G_edit(4)=uicontrol('Style','edit','String','1','Parent',S.W_V2_H3_V1_V2_G);
    S.W_V2_H3_V1_V2_G_text(2)=uicontrol('Style','text','String','0','Parent',S.W_V2_H3_V1_V2_G);
    uix.Empty('Parent',S.W_V2_H3_V1_V2_G) %--
    uicontrol('Style','text','HorizontalAlignment','left','String','px','Parent',S.W_V2_H3_V1_V2_G);
    uicontrol('Style','text','HorizontalAlignment','left','String','px','Parent',S.W_V2_H3_V1_V2_G);
    uicontrol('Style','text','HorizontalAlignment','left','String','px','Parent',S.W_V2_H3_V1_V2_G);
    uix.Empty('Parent',S.W_V2_H3_V1_V2_G) %--
    uicontrol('Style','text','HorizontalAlignment','left','String','Distance','Parent',S.W_V2_H3_V1_V2_G);
    uix.Empty('Parent',S.W_V2_H3_V1_V2_G)
    uicontrol('Style','text','HorizontalAlignment','left','String','Angle','Parent',S.W_V2_H3_V1_V2_G);
    uix.Empty('Parent',S.W_V2_H3_V1_V2_G) %--
    S.W_V2_H3_V1_V2_G_text(3)=uicontrol('Style','text','String','0','Parent',S.W_V2_H3_V1_V2_G);
    S.W_V2_H3_V1_V2_G_text(4)=uicontrol('Style','text','String','0','Parent',S.W_V2_H3_V1_V2_G);
    S.W_V2_H3_V1_V2_G_text(5)=uicontrol('Style','text','String','0','Parent',S.W_V2_H3_V1_V2_G);
    uix.Empty('Parent',S.W_V2_H3_V1_V2_G) %--
    uicontrol('Style','text','HorizontalAlignment','left','String','[px]','Parent',S.W_V2_H3_V1_V2_G);
    uicontrol('Style','text','HorizontalAlignment','left','String',['[' char(181) 'm]'],'Parent',S.W_V2_H3_V1_V2_G);
    uicontrol('Style','text','HorizontalAlignment','left','String','[deg]','Parent',S.W_V2_H3_V1_V2_G);
    set(S.W_V2_H3_V1_V2_G,'Widths',[-1 -1 -1 -1 -1 -1 -1],'Heights',[-1 -1 -1 -1]);
S.W_V2_H3_V1_V3=uix.Panel('BorderType','none','Parent',S.W_V2_H3_V1_V);    
    S.W_V2_H3_V1_V3_H=uix.HBox('Parent',S.W_V2_H3_V1_V3); 
    S.W_V2_H3_V1_V3_H_push(1)=uicontrol('Style','pushbutton','String','Draw','Parent',S.W_V2_H3_V1_V3_H);
    S.W_V2_H3_V1_V3_H_push(2)=uicontrol('Style','pushbutton','String','Clear','Parent',S.W_V2_H3_V1_V3_H);
    uix.Empty('Parent',S.W_V2_H3_V1_V3_H)
    uix.Empty('Parent',S.W_V2_H3_V1_V3_H)
set(S.W_V2_H3_V1_V,'Heights',[-1 -4 -1]);   

%--------------------------------------------------------------------------
% Analysis outputs, tab: Props

S.W_V2_H3_V2_T1_G=uix.Grid('Parent',S.W_V2_H3_V2_T1);
uix.Empty('Parent',S.W_V2_H3_V2_T1_G) %--
uicontrol('Style','text','HorizontalAlignment','left','String','Impact frame','Parent',S.W_V2_H3_V2_T1_G);
S.W_V2_H3_V2_T1_G_edit(7)=uicontrol('Style','edit','String','0','Parent',S.W_V2_H3_V2_T1_G);
uix.Empty('Parent',S.W_V2_H3_V2_T1_G) %--
uicontrol('Style','text','HorizontalAlignment','left','String','Impact velocity','Parent',S.W_V2_H3_V2_T1_G);
S.W_V2_H3_V2_T1_G_push(1)=uicontrol('Style','pushbutton','String','Check','Parent',S.W_V2_H3_V2_T1_G);
uix.Empty('Parent',S.W_V2_H3_V2_T1_G) %--
uicontrol('Style','text','HorizontalAlignment','left','String','(V)','Parent',S.W_V2_H3_V2_T1_G);
uicontrol('Style','text','HorizontalAlignment','left','String','(H)','Parent',S.W_V2_H3_V2_T1_G);
uicontrol('Style','text','HorizontalAlignment','center','String','[px/frame]','Parent',S.W_V2_H3_V2_T1_G); %--
S.W_V2_H3_V2_T1_G_edit(1)=uicontrol('Style','edit','String',0,'Parent',S.W_V2_H3_V2_T1_G);
S.W_V2_H3_V2_T1_G_edit(2)=uicontrol('Style','edit','String',0,'Parent',S.W_V2_H3_V2_T1_G);
uicontrol('Style','text','HorizontalAlignment','center','String','[m/s]','Parent',S.W_V2_H3_V2_T1_G); %--
S.W_V2_H3_V2_T1_G_edit(3)=uicontrol('Style','edit','String',0,'Parent',S.W_V2_H3_V2_T1_G);
S.W_V2_H3_V2_T1_G_edit(4)=uicontrol('Style','edit','String',0,'Parent',S.W_V2_H3_V2_T1_G);
uix.Empty('Parent',S.W_V2_H3_V2_T1_G) %--
uix.Empty('Parent',S.W_V2_H3_V2_T1_G)
uix.Empty('Parent',S.W_V2_H3_V2_T1_G)
uix.Empty('Parent',S.W_V2_H3_V2_T1_G) %--
uicontrol('Style','text','HorizontalAlignment','left','String','Initial diameter','Parent',S.W_V2_H3_V2_T1_G);
S.W_V2_H3_V2_T1_G_push(2)=uicontrol('Style','pushbutton','String','Check','Parent',S.W_V2_H3_V2_T1_G);
uicontrol('Style','text','HorizontalAlignment','center','String','[px]','Parent',S.W_V2_H3_V2_T1_G); %--
S.W_V2_H3_V2_T1_G_edit(5)=uicontrol('Style','edit','String','0','Parent',S.W_V2_H3_V2_T1_G);
uix.Empty('Parent',S.W_V2_H3_V2_T1_G)
uicontrol('Style','text','HorizontalAlignment','center','String',['[' char(181) 'm]'],'Parent',S.W_V2_H3_V2_T1_G); %--
S.W_V2_H3_V2_T1_G_edit(6)=uicontrol('Style','edit','String','0','Parent',S.W_V2_H3_V2_T1_G);
uix.Empty('Parent',S.W_V2_H3_V2_T1_G)
set(S.W_V2_H3_V2_T1_G,'Widths',[-1 -1.5 -0.5 -1 -1 -0.2 -1.5 -1 -1],'Heights',[-1 -1 -1]);
set(S.W_V2_H3_V2_T1_G_edit(3),'enable','off')
set(S.W_V2_H3_V2_T1_G_edit(4),'enable','off')
set(S.W_V2_H3_V2_T1_G_edit(6),'enable','off')
set(S.W_V2_H3_V2_T1_G_edit(7),'enable','off')

%--------------------------------------------------------------------------
% Analysis outputs, tab: CL

S.W_V2_H3_V2_T2_G=uix.Grid('Parent',S.W_V2_H3_V2_T2);
uix.Empty('Parent',S.W_V2_H3_V2_T2_G) %--
uicontrol('Style','text','HorizontalAlignment','left','String','Beta wet','Parent',S.W_V2_H3_V2_T2_G);
uicontrol('Style','text','HorizontalAlignment','left','String','Beta edge','Parent',S.W_V2_H3_V2_T2_G);
S.W_V2_H3_V2_T2_G_push=uicontrol('Style','pushbutton','String','Check','Parent',S.W_V2_H3_V2_T2_G);
uicontrol('Style','text','HorizontalAlignment','center','String','Max','Parent',S.W_V2_H3_V2_T2_G);  %--
S.W_V2_H3_V2_T2_G_edit(1)=uicontrol('Style','edit','String','0','Parent',S.W_V2_H3_V2_T2_G);
S.W_V2_H3_V2_T2_G_edit(2)=uicontrol('Style','edit','String','0','Parent',S.W_V2_H3_V2_T2_G);
uix.Empty('Parent',S.W_V2_H3_V2_T2_G)
uicontrol('Style','text','HorizontalAlignment','center','String','Frame','Parent',S.W_V2_H3_V2_T2_G);  %--
S.W_V2_H3_V2_T2_G_edit(3)=uicontrol('Style','edit','String','0','Parent',S.W_V2_H3_V2_T2_G);
S.W_V2_H3_V2_T2_G_edit(4)=uicontrol('Style','edit','String','0','Parent',S.W_V2_H3_V2_T2_G);
uix.Empty('Parent',S.W_V2_H3_V2_T2_G)
set(S.W_V2_H3_V2_T2_G_edit(:),'Enable','off')  
set(S.W_V2_H3_V2_T2_G,'Widths',[-2 -1 -1],'Heights',[-1 -1 -1 -1]); 
    
%--------------------------------------------------------------------------
% Analysis outputs, tab: Pinning

%--------------------------------------------------------------------------
% Analysis outputs, tab: Obs

S.W_V2_H3_V2_T4_G=uix.Grid('Parent',S.W_V2_H3_V2_T4);
uicontrol('Style','text','HorizontalAlignment','left','String','Main drop behavior','Parent',S.W_V2_H3_V2_T4_G); %--
S.W_V2_H3_V2_T4_G_pop=uicontrol('Style','pop','HorizontalAlignment','left','String',{'Adhering','Bouncing post receding','Pancake Bouncing','Outwards shattering'},'value',1,'Parent',S.W_V2_H3_V2_T4_G); %list 
uicontrol('Style','text','HorizontalAlignment','left','String','Pinning','Parent',S.W_V2_H3_V2_T4_G);
S.W_V2_H3_V2_T4_G_check(1)=uicontrol('Style','check','String','Primary','Parent',S.W_V2_H3_V2_T4_G);
S.W_V2_H3_V2_T4_G_check(1)=uicontrol('Style','check','String','Secondary','Parent',S.W_V2_H3_V2_T4_G);
uix.Empty('Parent',S.W_V2_H3_V2_T4_G) %--
uix.Empty('Parent',S.W_V2_H3_V2_T4_G)
uix.Empty('Parent',S.W_V2_H3_V2_T4_G)
uix.Empty('Parent',S.W_V2_H3_V2_T4_G)
uix.Empty('Parent',S.W_V2_H3_V2_T4_G)
uicontrol('Style','text','HorizontalAlignment','left','String','Secondary droplets','Parent',S.W_V2_H3_V2_T4_G); %--
S.W_V2_H3_V2_T4_G_check(3)=uicontrol('Style','check','String','Sattelite droplets','Parent',S.W_V2_H3_V2_T4_G);
S.W_V2_H3_V2_T4_G_check(4)=uicontrol('Style','check','String','Receding upwards break','Parent',S.W_V2_H3_V2_T4_G);
S.W_V2_H3_V2_T4_G_check(5)=uicontrol('Style','check','String','Film breaking on the surface','Parent',S.W_V2_H3_V2_T4_G);
S.W_V2_H3_V2_T4_G_check(6)=uicontrol('Style','check','String','Film breaking above the surface','Parent',S.W_V2_H3_V2_T4_G);
set(S.W_V2_H3_V2_T4_G,'Widths',[-4 -1 -4],'Heights',[-1 -1 -1 -1 -1])

%--------------------------------------------------------------------------
% Analysis outputs, tab: Save

S.W_V2_H3_V2_T5_V=uix.VBox('Parent',S.W_V2_H3_V2_T5);
S.W_V2_H3_V2_T5_V1=uix.Panel('BorderType','none','Parent',S.W_V2_H3_V2_T5_V);
    S.W_V2_H3_V2_T5_V1_H=uix.HBox('Parent',S.W_V2_H3_V2_T5_V1);
    uicontrol('Style','text','HorizontalAlignment','left','String','Comments:','Parent',S.W_V2_H3_V2_T5_V1_H);
    S.W_V2_H3_V2_T5_V1_H_edit=uicontrol('Style','edit','HorizontalAlignment','left','String','','Parent',S.W_V2_H3_V2_T5_V1_H);
    set(S.W_V2_H3_V2_T5_V1_H,'Widths',[-1 -9]);
S.W_V2_H3_V2_T5_V2=uix.Panel('BorderType','none','Parent',S.W_V2_H3_V2_T5_V);
    S.W_V2_H3_V2_T5_V2_H=uix.HBox('Parent',S.W_V2_H3_V2_T5_V2);
    S.W_V2_H3_V2_T5_V2_H_push(1)=uicontrol('Style','pushbutton','String','ADD CASE','Parent',S.W_V2_H3_V2_T5_V2_H);
    S.W_V2_H3_V2_T5_V2_H_push(2)=uicontrol('Style','pushbutton','String','DISCARD','Parent',S.W_V2_H3_V2_T5_V2_H);
    uix.Empty('Parent',S.W_V2_H3_V2_T5_V2_H)
    S.W_V2_H3_V2_T5_V2_H_push(3)=uicontrol('Style','pushbutton','String','SAVE','Parent',S.W_V2_H3_V2_T5_V2_H);
set(S.W_V2_H3_V2_T5_V,'Heights',[-3 -1])
    

%==========================================================================
% IMG

S.axMain=axes('Parent',S.W_V1,'ActivePositionProperty','position'); % Option 'position': full screen
 
S.cm0=uicontextmenu; %Reserve
S.um(1)=uimenu('label','Pixel value','Parent',S.cm0);
S.um(2)=uimenu('label','Zoom','Parent',S.cm0);
    S.ums(1)=uimenu('label','IN','Parent',S.um(2));
    S.ums(2)=uimenu('label','OUT','Parent',S.um(2));
S.um(3)= uimenu('label','Image modification','Parent',S.cm0);
    S.ums(3)=uimenu('label','Clear noise','Parent',S.um(3));
    S.ums(4)=uimenu('label','Crop image','Parent',S.um(3));
    S.ums(5)=uimenu('label','Original image','Parent',S.um(3));
S.um(4)=uimenu('label','Set surface limit','Parent',S.cm0);    
S.um(5)=uimenu('label','Drop ID:','Parent',S.cm0);
S.um(6)=uimenu('label','Change tracking','Parent',S.cm0);
    S.ums(6)=uimenu('label','Last frame','Parent',S.um(6));
    S.ums(7)=uimenu('label','New drop','Parent',S.um(6));
    S.ums(8)=uimenu('label','Fuse drops','Parent',S.um(6));
    S.ums(9)=uimenu('label','Associate drops','Parent',S.um(6));
    S.ums(10)=uimenu('label','Undo last change','Parent',S.um(6));
S.um(7)=uimenu('label','Drop class: ','Parent',S.cm0);
S.um(8)=uimenu('label','Change class','Parent',S.cm0);
    S.ums(11)=uimenu('label',I.class.drops.text{1},'Parent',S.um(8));
    S.ums(12)=uimenu('label',I.class.drops.text{2},'Parent',S.um(8));
    S.ums(13)=uimenu('label',I.class.drops.text{3},'Parent',S.um(8));
    S.ums(14)=uimenu('label',I.class.drops.text{4},'Parent',S.um(8));
    S.ums(15)=uimenu('label',I.class.drops.text{5},'Parent',S.um(8));
S.um(9)=uimenu('label','Pinning options','Parent',S.cm0);
    S.ums(16)=uimenu('label','Add drop as pinned','Parent',S.um(9));
    S.ums(17)=uimenu('label','Erase last added drop','Parent',S.um(9));
S.um(10)=uimenu('label','Erase last added drop','Parent',S.cm0);
S.um(11)=uimenu('label','Drop ID:','Parent',S.cm0);
S.um(12)=uimenu('label','Change limit','Parent',S.cm0);
    S.ums(18)=uimenu('label','Unique','Parent',S.um(12));
    S.ums(19)=uimenu('label','Common','Parent',S.um(12));
    S.ums(20)=uimenu('label','Ignore','Parent',S.um(12));
S.um(13)=uimenu('label','Drop type:','Parent',S.cm0);
S.um(14)=uimenu('label','Change type','Parent',S.cm0);
    S.ums(21)=uimenu('label','Central','Parent',S.um(14));
    S.ums(22)=uimenu('label','Peripheral','Parent',S.um(14));
    S.ums(23)=uimenu('label','External','Parent',S.um(14));   
S.um(15)=uimenu('label','Volume method:','Parent',S.cm0);
S.um(16)=uimenu('label','Change method','Parent',S.cm0);
    S.ums(24)=uimenu('label','Spheroid','Parent',S.um(16));
    S.ums(25)=uimenu('label','Stacked cylinders','Parent',S.um(16));
S.um(17)=uimenu('label','Relative volume:','Parent',S.cm0);  

S.cm=uicontextmenu; %Visible
set(S.cm0,'UserData','Inactive')
set(S.cm,'UserData','Active')

%##########################################################################
%Call

%==========================================================================
% DATA

%--------------------------------------------------------------------------
% Files

set(S.W_V2_H1_V1_T,'SelectionChangedFcn',{@W_V2_H1_V1_T_tabCall,S});   
set([S.W_V2_H1_V1_T1_V1_H_edit(:);S.W_V2_H1_V1_T1_V1_H_push(:);S.W_V2_H1_V1_T2_V1_H_edit;S.W_V2_H1_V1_T2_V1_H_push],'Call',{@W_V2_H1_V1_T_shared1Call,S});
set([S.W_V2_H1_V1_T1_V2_H_pop(:)],'Call',{@W_V2_H1_V1_T1_V1_H_sharedCall,S});
set([S.W_V2_H1_V1_T1_V3_H_edit;S.W_V2_H1_V1_T1_V3_H_push(1);S.W_V2_H1_V1_T2_V2_H_edit;S.W_V2_H1_V1_T2_V2_H_push],'Call',{@W_V2_H1_V1_T_shared2Call,S}); 
set([S.W_V2_H1_V1_T1_V3_H_push(2);S.W_V2_H1_V1_T2_V3_H_push],'Call',{@W_V2_H1_V1_T_shared3Call,S});

%--------------------------------------------------------------------------
% Experiments
set([S.W_V2_H1_V2_V1_H_edit;S.W_V2_H1_V2_V1_H_push(1);S.W_V2_H1_V2_V1_H_push(2)],'Call',{@W_V2_H1_V2_V1_H_sharedCall,S});
set([S.W_V2_H1_V2_V1_H_push(3);S.W_V2_H1_V2_V1_H_push(4)],'Call',{@W_V2_H1_V2_V1_H_push_sharedCall,S});
set([S.W_V2_H1_V2_V4_H_edit(:)],'Call',{@W_V2_H1_V2_V4_H_edit_sharedCall,S});
set([S.W_V2_H1_V2_V5_H_pop;S.W_V2_H1_V2_V5_H_edit],'Call',{@W_V2_H1_V2_V5_H_sharedCall,S});



%==========================================================================
% ANALYSIS 

%--------------------------------------------------------------------------
% Image controller 
set(S.W_V2_H2_V1_V_V1_H_pop,'Callback',{@W_V2_H2_V1_V_V1_H_popCall,S});  
set([S.W_V2_H2_V1_V_V1_H_edit(:);S.W_V2_H2_V1_V_V1_H_H_push(:);S.W_V2_H2_V1_V_V1_H_slide],'Call',{@W_V2_H2_V1_V_V1_H_sharedCall,S});
set([S.W_V2_H2_V1_V_V2_T1_H_toggle(1:7)],'Call',{@W_V2_H2_V1_V_V2_T1_sharedCall,S});
set([S.W_V2_H2_V1_V_V2_T2_H_push(:)],'Call',{@W_V2_H2_V1_V_V2_T2_sharedCall,S});
set([S.W_V2_H2_V1_V_V2_T3_H_push(:)],'Call',{@W_V2_H2_V1_V_V2_T3_sharedCall,S}); 

%--------------------------------------------------------------------------
% Analysis level 
set([S.W_V2_H2_V2_H_pop;S.W_V2_H2_V2_H_edit;S.W_V2_H2_V2_H_H_push(:)],'Call',{@W_V2_H2_V2_H_sharedCall,S});

%--------------------------------------------------------------------------
% Analysis settings, tab: lvl 1: Dim
set([S.W_V2_H2_V3_T1_G_edit(:)],'Call',{@W_V2_H2_V3_T1_G_shared1Call,S});
set([S.W_V2_H2_V3_T1_G_push(:)],'Call',{@W_V2_H2_V3_T1_G_shared2Call,S});

%--------------------------------------------------------------------------
% Analysis settings, tab: lvl 2: Filters
set(S.W_V2_H2_V3_T2_G_check(:),'Callback',{@W_V2_H2_V3_T2_G_checkCall,S});  

%--------------------------------------------------------------------------
% Analysis settings, tab: lvl 2: Bg
set([S.W_V2_H2_V3_T3_H_edit;S.W_V2_H2_V3_T3_H_push],'Call',{@W_V2_H2_V3_T3_H_sharedCall,S}) % Shared Callback

%--------------------------------------------------------------------------
% Analysis settings, tab: lvl 3: Surf
set([S.W_V2_H2_V3_T4_H2_V_radio(:)],'Call',{@W_V2_H2_V3_T4_H2_V_radioCall,S})   
set([S.W_V2_H2_V3_T4_H3_V1_H_edit(:);S.W_V2_H2_V3_T4_H3_V1_H1_push(:);S.W_V2_H2_V3_T4_H3_V1_H2_push(:)],'Call',{@W_V2_H2_V3_T4_H3_V1_H_sharedCall,S});
set(S.W_V2_H2_V3_T4_H3_V2_H_edit,'Callback',{@W_V2_H2_V3_T4_H3_V2_H_editCall,S})
set([S.W_V2_H2_V3_T4_H3_V2_push(:)],'Call',{@W_V2_H2_V3_T4_H3_V2_H_sharedCall,S});

%  Analysis settings, tab: lvl 3: Focus
set([S.W_V2_H2_V3_T5_G_pop;S.W_V2_H2_V3_T5_G_edit;S.W_V2_H2_V3_T5_G_push],'Call',{@W_V2_H2_V3_T5_sharedCall,S});

%--------------------------------------------------------------------------
% Analysis settings, tab: lvl 4: Bin
set([S.W_V2_H2_V3_T6_G_edit(:);S.W_V2_H2_V3_T6_G_check(:);S.W_V2_H2_V3_T6_G_push],'Call',{@W_V2_H2_V3_T6_G_sharedCall,S});
set([S.W_V2_H2_V3_T7_G_pop;S.W_V2_H2_V3_T7_G_edit(:);S.W_V2_H2_V3_T7_G_push],'Call',{@W_V2_H2_V3_T7_G_sharedCall,S});

%--------------------------------------------------------------------------
% Analysis settings, tab: lvl 7: CA + underneath
set([S.W_V2_H2_V3_T8_G_pop;S.W_V2_H2_V3_T8_G_edit(:);S.W_V2_H2_V3_T8_G_push],'Call',{@W_V2_H2_V3_T8_G_sharedCall,S}) % Shared Callback
set([S.W_V2_H2_V3_T9_G_edit;S.W_V2_H2_V3_T9_G_check],'Call',{@W_V2_H2_V3_T9_G_sharedCall,S}) % Shared Callback

%==========================================================================
% OutputS

%--------------------------------------------------------------------------
% Direct measurement
set(S.W_V2_H3_V1_V2_G_edit(:),'Call',{@W_V2_H3_V1_V2_G_sharedCall,S});
set(S.W_V2_H3_V1_V3_H_push(:),'Call',{@W_V2_H3_V1_V3_H_sharedCall,S});

%--------------------------------------------------------------------------
% Analysis outputs, tab: Props
set([S.W_V2_H3_V2_T1_G_push(:)],'Call',{@W_V2_H3_V2_T1_G_push_sharedCall,S});
set([S.W_V2_H3_V2_T1_G_edit(1);S.W_V2_H3_V2_T1_G_edit(2);S.W_V2_H3_V2_T1_G_edit(5)],'Call',{@W_V2_H3_V2_T1_G_edit_sharedCall,S})

%--------------------------------------------------------------------------
% Analysis outputs, tab: CL
set(S.W_V2_H3_V2_T2_G_push(1),'Callback',{@W_V2_H3_V2_T2_G_pushCall,S})

%--------------------------------------------------------------------------
% Analysis outputs, tab: Pinning

%--------------------------------------------------------------------------
% Analysis outputs, tab: Obs

%--------------------------------------------------------------------------
% Analysis outputs, tab: Save

set([S.W_V2_H3_V2_T5_V2_H_push(:)],'Call',{@W_V2_H3_V2_T5_V2_H_push_sharedCall,S});

%==========================================================================
% IMG

set(S.window,'windowbuttonmotionfcn',{@wbmfcn,S}) % Set the motion detector
set(S.W_V2_H3_V1_V1_H_text(1),'UserData',1)

set(S.cm,'Callback',{@cm_call,S})
set(S.ums(1),'Callback',{@umZIn_call,S})
set(S.ums(2),'Callback',{@umZOut_call,S})
set(S.ums(3),'Callback',{@umClear_call,S})
set(S.ums(4),'Callback',{@umCrop_call,S})
set(S.ums(5),'Callback',{@umOri_call,S})
set(S.um(4),'Callback',{@umLine_call,S})
set([S.ums(6:10)],'Callback',{@umTrack,S});
set([S.ums(11:15)],'Callback',{@umClass,S});
set([S.um(10),S.ums(16:25)],'Callback',{@umPinning,S});


set(S.axMain.Children,'ButtonDownFcn',{@bdfcn,S},'uicontextmenu',S.cm) % Set click detector + assign contextmen

%--------------------------------------------------------------------------
% INITIALISATION

set(S.W_V2_H2_V1_V_V1_H_pop,'String',I.img.options{1}) %Should be included in a function
set(S.W_V1,'UserData',I)
setImgNbr(S) 

assignin('base','S',S) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
 
%==========================================================================
%========================= Call functions =================================
%==========================================================================
% Link to an object

%--------------------------------------------------------------------------
% Files

function []=W_V2_H1_V1_T_tabCall(varargin) % Inactive %%%%%%%%%%%%%%%%%%%%%  
% [h,S] = varargin{[1,3]};  % Get calling handle and structure
end
function []=W_V2_H1_V1_T_shared1Call(varargin) % Manage the file directory and name
[h,S] = varargin{[1,3]};  % Get calling handle and structure
switch h  % Who called?
    case {S.W_V2_H1_V1_T1_V1_H_edit(1),S.W_V2_H1_V1_T1_V1_H_edit(2),S.W_V2_H1_V1_T2_V1_H_edit}
        switch h
            case {S.W_V2_H1_V1_T1_V1_H_edit(1),S.W_V2_H1_V1_T2_V1_H_edit} %Root directory - text
                dirRoot=get(h,'string');
                if exist(dirRoot,'dir')~=7
                    dirRoot='Wrong directory';
                end
                set(S.W_V2_H1_V1_T1_V1_H_edit(1),'string',dirRoot)
                set(S.W_V2_H1_V1_T2_V1_H_edit,'string',dirRoot)
            case S.W_V2_H1_V1_T1_V1_H_edit(2) %Relative directory - text
                dirRoot=get(S.W_V2_H1_V1_T1_V1_H_edit(1),'string');
                dirFull=get(h,'string');
                dirFullJoin=join([dirRoot,filesep,dirFull]);
                if exist(dirFullJoin,'dir')~=7
                    set(h,'string','Wrong directory')
                end
        end
    case {S.W_V2_H1_V1_T1_V1_H_push(1),S.W_V2_H1_V1_T1_V1_H_push(2),S.W_V2_H1_V1_T2_V1_H_push} %Push buttons
        switch h
            case {S.W_V2_H1_V1_T1_V1_H_push(1),S.W_V2_H1_V1_T2_V1_H_push} %Root directory - push
                dirRoot=uigetdir(pwd,'Search root folder');
                if dirRoot==0
                    dirRoot='choose a directory';
                end
                set(S.W_V2_H1_V1_T1_V1_H_edit(1),'string',dirRoot)
                set(S.W_V2_H1_V1_T2_V1_H_edit,'string',dirRoot)
            case S.W_V2_H1_V1_T1_V1_H_push(2) %Relative directory push
                dirRoot=get(S.W_V2_H1_V1_T1_V1_H_edit(1),'string');
                dirFull=uigetdir(dirRoot,'Search image folder');
                if dirFull==0
                    dirFull='choose a directory';
                end
                if exist(join([dirRoot,erase(dirFull,dirRoot)]),'dir')~=7 %Check if the relative directory is part of the root one
                    dirFull='Wrong directory';
                end
                set(S.W_V2_H1_V1_T1_V1_H_edit(2),'string',erase(dirFull,dirRoot))
        end
end
end
function []=W_V2_H1_V1_T1_V1_H_sharedCall(varargin) %Select image/movie format
[h,S] = varargin{[1,3]};  % Get calling handle and structure
switch h  % Who called? 
    case S.W_V2_H1_V1_T1_V2_H_pop(1)
        P=get(h,{'string','val'});  % Get the users choice.
        if P{2}==1
            set(S.W_V2_H1_V1_T1_V2_H_pop(2),'string',{'tif','tiff','jpg','jpeg','png','bmp'},'val',1)
        else
            set(S.W_V2_H1_V1_T1_V2_H_pop(2),'string',{'mp4','mov','avi'},'val',1)
        end
    case S.W_V2_H1_V1_T1_V2_H_pop(2)
        %Nothing
end
end
function []=W_V2_H1_V1_T_shared2Call(varargin) %File name
[h,S] = varargin{[1,3]};  % Get calling handle and structure
dirRoot=get(S.W_V2_H1_V1_T1_V1_H_edit(1),'string');
switch h  % Who called? 
    case {S.W_V2_H1_V1_T1_V3_H_edit,S.W_V2_H1_V1_T2_V2_H_edit} %File name - text
        fileFull=get(h,'string');
        if ~contains(fileFull,'.mat') %Add .mat format
            fileFull=join([fileFull,'.mat']);
        end
        if ~contains(fileFull,filesep) %Add full path
            fileFull=join([dirRoot,fileFull]); 
        end        
        if get(S.W_V2_H1_V1_T1_V3_H_pop,'value')==1
            if exist(fileFull,'file')==2
                fileFull='File name already taken';
            end
        else
            if exist(fileFull,'file')~=2
                fileFull='Wrong file name';
            end
        end                       
    case {S.W_V2_H1_V1_T1_V3_H_push(1),S.W_V2_H1_V1_T2_V2_H_push} %File name - push
        switch h
            case S.W_V2_H1_V1_T2_V2_H_push
                set(S.W_V2_H1_V1_T1_V3_H_pop,'value',2)
        end
        if get(S.W_V2_H1_V1_T1_V3_H_pop,'value')==1
            [fileName,filePath]=uiputfile(join([dirRoot,filesep,'*.mat']), 'Give file name .mat');         
        else
            [fileName,filePath]=uigetfile(join([dirRoot,filesep,'*.mat']), 'Search .mat file to open');
        end
        if filePath==0
            fileFull='Insert a file name';
        else
            fileFull=join([filePath,fileName]);
        end
end
set(S.W_V2_H1_V1_T1_V3_H_edit,'string',fileFull)
set(S.W_V2_H1_V1_T2_V2_H_edit,'string',fileFull)
end
function []=W_V2_H1_V1_T_shared3Call(varargin) %Start the analysis
[h,S] = varargin{[1,3]};  % Get calling handle and structure
I=get(S.W_V1,'UserData');

% Load file?
on=1;
switch h  % Who called? 
    case S.W_V2_H1_V1_T1_V3_H_push(2)
        if get(S.W_V2_H1_V1_T1_V3_H_pop,'value')==1
            on=0;
        end
    case S.W_V2_H1_V1_T2_V3_H_push
        set(S.W_V2_H1_V1_T1_V3_H_pop,'value',2)           
end
if on==1 % Old file or list mode    
    if ~strcmp(I.file.name,get(S.W_V2_H1_V1_T1_V3_H_edit,'string'))       
        loadStruct=load(get(S.W_V2_H1_V1_T1_V3_H_edit,'string'));
        [~,varName,~]=fileparts(get(S.W_V2_H1_V1_T1_V3_H_edit,'string'));
        I.file.tab.full=loadStruct.dropImpactData.(varName);        
    end
else
    I.file.tab.full=I.file.tab.mty;
end
I.file.name=get(S.W_V2_H1_V1_T1_V3_H_edit,'string');
assignin('base','Data',I.file.tab.full) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update?
switch h  % Who called? 
    case S.W_V2_H1_V1_T1_V3_H_push(2) %New entry
        if get(S.W_V2_H1_V1_T1_V3_H_pop,'value')==1
            k=height(I.file.tab.full);     
        else %add new line
            k=height(I.file.tab.full)+1;
            set(S.W_V2_H1_V1_T1_V3_H_pop,'value',2)
        end
%         I.file.tab.full.Path{k}=get(S.W_V2_H1_V1_T1_V1_H_edit(2),'string');
%         P=get(S.W_V2_H1_V1_T1_V2_H_pop(1),{'string','val'});
        %I.file.tab.full.AddInfo{k}.type=P{1}{P{2}};
%         P=get(S.W_V2_H1_V1_T1_V2_H_pop(2),{'string','val'});
        %I.file.tab.full.AddInfo{k}.format=P{1}{P{2}};        
        set(S.W_V2_H1_V2_V1_H_edit,'string',k)
    case S.W_V2_H1_V1_T2_V3_H_push %List
        k=height(I.file.tab.full);
end
set(S.W_V2_H1_V2_V1_H_edit,'string',k)
set(S.W_V2_H1_V2_V2_H_edit,'string',get(S.W_V2_H1_V1_T1_V1_H_edit(2),'string'))

set(S.W_V1,'UserData',I);
initialisation(S)
end

%--------------------------------------------------------------------------
% Experiments

function []=W_V2_H1_V2_V1_H_sharedCall(varargin) %Select which set of images
[h,S] = varargin{[1,3]};  % Get calling handle and structure
I=get(S.W_V1,'UserData');
switch h  % Who called? 
    case S.W_V2_H1_V2_V1_H_edit
        dataNum=str2double(get(h,'string'));       
    case S.W_V2_H1_V2_V1_H_push(1)
        dataNum=str2double(get(S.W_V2_H1_V2_V1_H_edit,'string'))-1;        
    case S.W_V2_H1_V2_V1_H_push(2)
        dataNum=str2double(get(S.W_V2_H1_V2_V1_H_edit,'string'))+1;
end
if dataNum<1 % Check if the value is inside the range
    dataNum=1;
elseif dataNum>height(I.file.tab.full)
    dataNum=height(I.file.tab.full);
end

if dataNum<=height(I.file.tab.full)
    set(S.W_V2_H1_V2_V2_H_edit,'string',I.file.tab.full.Path{dataNum})
end

set(S.W_V2_H1_V2_V1_H_edit,'string',num2str(dataNum))
set(S.W_V2_H1_V1_T,'Selection',2)

set(S.W_V1,'UserData',I);
initialisation(S);
end

function []=W_V2_H1_V2_V1_H_push_sharedCall(varargin) %Load or reset case
[h,S] = varargin{[1,3]};  % Get calling handle and structure
I=get(S.W_V1,'UserData');

dataNum=str2double(get(S.W_V2_H1_V2_V1_H_edit,'string'));

switch h  % Who called?
    
    case S.W_V2_H1_V2_V1_H_push(3)
        
        %set(,'string',)
        %         set(S.W_V2_H1_V2_V2_H_edit,'string',I.file.tab.full.Path{dataNum})
        %         set(S.W_V2_H1_V2_V3_H_edit(1),'string',I.file.tab.full.Surface{dataNum})
        %         set(S.W_V2_H1_V2_V3_H_edit(2),'string',I.file.tab.full.Liquid{dataNum})
        %         set(S.W_V2_H1_V2_V4_H_edit(1),'string',I.file.tab.full.Camera{dataNum}.FPS)
        %         set(S.W_V2_H1_V2_V4_H_edit(2),'string',I.file.tab.full.Camera{dataNum}.mm2px)
        %         P=get(S.W_V2_H1_V1_T1_V2_H_pop(:),'String');
        %         set(S.W_V2_H1_V1_T1_V2_H_pop(1),'value',find(strcmp(I.file.tab.full.Camera{dataNum}.format{1},P{1})==1))
        %         set(S.W_V2_H1_V1_T1_V2_H_pop(2),'value',find(strcmp(I.file.tab.full.Camera{dataNum}.format{2},P{2})==1))
        
        % Analysis
        
        I.img.display.analysisLvl=I.file.tab.full.Lvl{dataNum};
        set(S.W_V2_H2_V2_H_pop,'val',I.img.display.analysisLvl);
        set(S.W_V2_H2_V2_H_edit,'string',I.img.display.analysisLvl)
        
        
%                  
%                      case 8
%                     I.file.tab.full.Setting{dataNum}.trackingMod=I.track.mod;
%                 case 9
%                     I.file.tab.full.Output{dataNum}.dropClass=I.class.drops.tab;
%                 case 10
%                     I.file.tab.full.Output{dataNum}.pinning=I.class.pinning.tab(:,[1:5,7]);
%             end
        
        for k=1:I.file.tab.full.Lvl{dataNum}
            switch k
                case 1
                    I.img.info.nbr=I.file.tab.full.Setting{dataNum}.imgNbr;
                    I.img.modi.zone{'clear'}=I.file.tab.full.Setting{dataNum}.clear;
                    set(S.W_V2_H2_V3_T1_G_edit(1),'string',I.file.tab.full.Setting{dataNum}.dimensions(1))
                    set(S.W_V2_H2_V3_T1_G_edit(2),'string',I.file.tab.full.Setting{dataNum}.dimensions(2))  
                case 2
                    set(S.W_V2_H2_V3_T2_G_check(1),'value',I.file.tab.full.Setting{dataNum}.filters.median)
                    set(S.W_V2_H2_V3_T2_G_check(2),'value',I.file.tab.full.Setting{dataNum}.filters.sharpening)               
                case 3
                    set(S.W_V2_H2_V3_T3_H_edit,'string',I.file.tab.full.Setting{dataNum}.backgroundNbr)
                case 4
                    if strcmp(S.W_V2_H2_V3_T4_H2_V_radio(1),I.file.tab.full.Setting{dataNum}.surface.type)
                        set(S.W_V2_H2_V3_T4_H2_V_radio(1),'value',1)
                        set(S.W_V2_H2_V3_T4_H2_V_radio(0),'value',1)
                        set(S.W_V2_H2_V3_T4_H3_V1_H_edit(1),'string',I.file.tab.full.Setting{dataNum}.surface.val(1))
                        set(S.W_V2_H2_V3_T4_H3_V1_H_edit(2),'string',I.file.tab.full.Setting{dataNum}.surface.val(2))
                    else
                        set(S.W_V2_H2_V3_T4_H2_V_radio(0),'value',1)
                        set(S.W_V2_H2_V3_T4_H2_V_radio(1),'value',1)
                        set(S.W_V2_H2_V3_T4_H3_V2_H_edit,'string',I.file.tab.full.Setting{dataNum}.surface.val)
                    end
                case 5
                    set(S.W_V2_H2_V3_T6_G_edit(1),'string',I.file.tab.full.Setting{dataNum}.binarisation.threshold)
                    set(S.W_V2_H2_V3_T6_G_edit(2),'string',I.file.tab.full.Setting{dataNum}.binarisation.minDetection)
                    set(S.W_V2_H2_V3_T6_G_edit(3),'string',I.file.tab.full.Setting{dataNum}.binarisation.surfCorrection)
                    set(S.W_V2_H2_V3_T6_G_check(1),'value',I.file.tab.full.Setting{dataNum}.binarisation.fill(1))
                    set(S.W_V2_H2_V3_T6_G_check(2),'value',I.file.tab.full.Setting{dataNum}.binarisation.fill(2))
                case 6
                    I.track.mod=I.file.tab.full.Setting{dataNum}.trackingMod;
                    set(S.W_V2_H3_V2_T1_G_edit(7),'string',I.file.tab.full.Output{dataNum}.mainDrop.startImpact)
                    set(S.W_V2_H3_V2_T1_G_edit(2),'string',I.file.tab.full.Output{dataNum}.mainDrop.impactVel(1))
                    set(S.W_V2_H3_V2_T1_G_edit(1),'string',I.file.tab.full.Output{dataNum}.mainDrop.impactVel(2))
                    set(S.W_V2_H3_V2_T1_G_edit(5),'string',I.file.tab.full.Output{dataNum}.mainDrop.iniDia)
                    I.obs.mainDrop=I.file.tab.full.Output{dataNum}.mainDrop.impact;
                case 7
                    P=get(S.W_V2_H2_V3_T8_G_pop,'String');
                    set(S.W_V2_H2_V3_T8_G_pop,'value',find(strcmp(I.file.tab.full.Setting{dataNum}.contactAngle.method,P)==1))
                    set(S.W_V2_H2_V3_T8_G_edit(1),'string',I.file.tab.full.Setting{dataNum}.contactAngle.zone)
                    set(S.W_V2_H2_V3_T8_G_edit(2),'string',I.file.tab.full.Setting{dataNum}.contactAngle.offset)
                    set(S.W_V2_H2_V3_T8_G_edit(3),'string',I.file.tab.full.Setting{dataNum}.contactAngle.smoothVal)
                    set(S.W_V2_H2_V3_T8_G_edit(4),'string',I.file.tab.full.Setting{dataNum}.contactAngle.Weight)
                case 8
                    I.track.mod=I.file.tab.full.Setting{dataNum}.trackingMod;
                case 9
                    I.class.drops.tab=I.file.tab.full.Output{dataNum}.dropClass;
                case 10
                    I.class.pinning.tab(:,[1:5,7])=I.file.tab.full.Output{dataNum}.pinning;
            end
        end
        
    case S.W_V2_H1_V2_V1_H_push(4)
        I.img.display.analysisLvl=1;
        set(S.W_V2_H2_V2_H_pop,'val',I.img.display.analysisLvl);
        set(S.W_V2_H2_V2_H_edit,'string',I.img.display.analysisLvl)
        %initialisation(S);
end

set(S.W_V1,'UserData',I);
%initialisation(S);
imgProcessing(S,1)

end

function []=W_V2_H1_V2_V4_H_edit_sharedCall(varargin) %FPS + Pixel/mm 
[S] = varargin{[3]};  % Get calling handle and structure

I=get(S.W_V1,'UserData');

b=min(5,I.img.display.analysisLvl);

imgProcessing(S,b)

end

function []=W_V2_H1_V2_V5_H_sharedCall(varargin) %Separation
[h,S] = varargin{[1,3]};  % Get calling handle and structure
I=get(S.W_V1,'UserData');
imgDim=size(I.img.type.Raw{1});

switch h  % Who called?
    case S.W_V2_H1_V2_V5_H_pop
        set(S.W_V2_H2_V3_T2,'Parent',[])
        set(S.W_V2_H2_V3_T3,'Parent',[])
        set(S.W_V2_H2_V3_T4,'Parent',[])
        set(S.W_V2_H2_V3_T5,'Parent',[])
        set(S.W_V2_H2_V3_T6,'Parent',[])
        set(S.W_V2_H2_V3_T7,'Parent',[])
        set(S.W_V2_H2_V3_T8,'Parent',[])
        set(S.W_V2_H2_V3_T9,'Parent',[])
        if get(h,'value')==1
            set(S.W_V2_H1_V2_V5_H_edit,'string',0)
            set(S.W_V2_H1_V2_V5_H_edit,'Enable','off')
            tabRef=[2,3,4,6,8];
        else
            set(S.W_V2_H1_V2_V5_H_edit,'string',round(imgDim(1)/2))
            set(S.W_V2_H1_V2_V5_H_edit,'Enable','on')
            tabRef=[2,3,4,5,6,7,8,9];
        end
        for k=1:length(tabRef)
            switch tabRef(k)
                case 2
                    set(S.W_V2_H2_V3_T2,'Parent',S.W_V2_H2_V3_T)
                    set(S.W_V2_H2_V3_T2_G,'Parent',S.W_V2_H2_V3_T2);
                case 3
                    set(S.W_V2_H2_V3_T3,'Parent',S.W_V2_H2_V3_T)
                    set(S.W_V2_H2_V3_T3_H,'Parent',S.W_V2_H2_V3_T3);
                case 4
                    set(S.W_V2_H2_V3_T4,'Parent',S.W_V2_H2_V3_T)
                    set(S.W_V2_H2_V3_T4_H,'Parent',S.W_V2_H2_V3_T4);
                case 5
                    set(S.W_V2_H2_V3_T5,'Parent',S.W_V2_H2_V3_T)
                    set(S.W_V2_H2_V3_T5_G,'Parent',S.W_V2_H2_V3_T5);
                case 6
                    set(S.W_V2_H2_V3_T6,'Parent',S.W_V2_H2_V3_T)
                    set(S.W_V2_H2_V3_T6_G,'Parent',S.W_V2_H2_V3_T6);
                case 7
                    set(S.W_V2_H2_V3_T7,'Parent',S.W_V2_H2_V3_T)
                    set(S.W_V2_H2_V3_T7_G,'Parent',S.W_V2_H2_V3_T7);
                case 8
                    set(S.W_V2_H2_V3_T8,'Parent',S.W_V2_H2_V3_T)
                    set(S.W_V2_H2_V3_T8_G,'Parent',S.W_V2_H2_V3_T8);
                case 9
                    set(S.W_V2_H2_V3_T9,'Parent',S.W_V2_H2_V3_T)
                    set(S.W_V2_H2_V3_T9_G,'Parent',S.W_V2_H2_V3_T9);
            end
        end
        if get(h,'value')==1
            S.W_V2_H2_V3_T.TabTitles={'lvl 1','lvl 2','lvl 3','lvl 4','lvl 5','lvl 7'};
        else
            S.W_V2_H2_V3_T.TabTitles={'lvl 1','lvl 2','lvl 3','lvl 4','lvl 4U','lvl 5','lvl 5U','lvl 7','lvl 7U'};
        end


    case S.W_V2_H1_V2_V5_H_edit
        ySepLim=str2double(get(h,'string'));
        ySepLim = round(ySepLim);
        if ySepLim<2
            ySepLim=2;
        elseif ySepLim>imgDim(1)-1
            ySepLim=imgDim(1)-1;
        end
        set(h,'string',ySepLim)
end

b=min(5,I.img.display.analysisLvl);
imgProcessing(S,b)

end


%==========================================================================
% ANALYSIS 

%--------------------------------------------------------------------------
% Image controller 

function []=W_V2_H2_V1_V_V1_H_popCall(varargin) %Select the image type
S= varargin{3};  %Get structure
imgProcessing(S,0)
end
function []=W_V2_H2_V1_V_V1_H_sharedCall(varargin) %Select the images number
[h,S]=varargin{[1,3]};  % Get calling handle and structure
I=get(S.W_V1,'UserData');
p=0;
if size(I.img.type.img2show,1)>1 % Set of images
    maxLim=length(I.img.type.img2show);    
    switch h  % Who called?
        case {S.W_V2_H2_V1_V_V1_H_edit(1),S.W_V2_H2_V1_V_V1_H_H_push(1),S.W_V2_H2_V1_V_V1_H_H_push(2)}
            imgNbr=round(str2double(get(S.W_V2_H2_V1_V_V1_H_edit(1),'string')));
            switch h
                case S.W_V2_H2_V1_V_V1_H_edit(1)
                    %Nothing
                case S.W_V2_H2_V1_V_V1_H_H_push(1)
                    imgNbr=imgNbr-1;
                case S.W_V2_H2_V1_V_V1_H_H_push(2)
                    imgNbr=imgNbr+1;
            end            
            maxNbr=round(str2double(get(S.W_V2_H2_V1_V_V1_H_edit(2),'string')));% OR "round(get(S.W_V2_H2_V1_V_V1_H_slide,'max'));"
            if imgNbr>maxNbr
                imgNbr=maxNbr;
            elseif imgNbr<1
                imgNbr=1;
            end
        case S.W_V2_H2_V1_V_V1_H_edit(2)
            maxNbr=round(str2double(get(h,'string')));
            if maxNbr>maxLim
                maxNbr=maxLim;
            elseif maxNbr<1
                maxNbr=1;
            end
            imgNbr=round(str2double(get(S.W_V2_H2_V1_V_V1_H_edit(1),'string')));
            if maxNbr<imgNbr
                maxNbr=imgNbr;
                set(S.W_V2_H2_V1_V_V1_H_edit(2),'string',num2str(maxNbr))
            end
            p=1;
        case S.W_V2_H2_V1_V_V1_H_slide
            imgNbr=round(get(h,'value')); %sldInfo=get(S.W_V2_H2_V1_V_V1_H_slide,{'min','value','max'});  % Get the slider's info
            maxNbr=round(str2double(get(S.W_V2_H2_V1_V_V1_H_edit(2),'string')));% OR "round(get(S.W_V2_H2_V1_V_V1_H_slide,'max'));"
    end 
    set(S.W_V2_H2_V1_V_V1_H_edit(1),'string',num2str(imgNbr)) %back in intenger
    set(S.W_V2_H2_V1_V_V1_H_edit(2),'string',num2str(maxNbr))
    set(S.W_V2_H2_V1_V_V1_H_slide,'max',maxNbr)
    set(S.W_V2_H2_V1_V_V1_H_slide,'value',imgNbr)
    
%     I.img.display.nbr=[1,1,1];
% I.img.display.type=1; %1:Frames, 2:Single image, 3: Pinning images
    if I.img.display.type==1     
        I.img.info.nbr=str2double(get(S.W_V2_H2_V1_V_V1_H_edit(2),'string'));
        I.img.display.nbr(1)=imgNbr;
    elseif I.img.display.type==3
        I.img.display.nbr(3)=imgNbr;
    end
else
    %Do nothing
end

set(S.W_V1,'UserData',I);
if p==0
    setImgNbr(S)
else % Number of image used as base was modified
    imgProcessing(S,1)
end

end
function []=W_V2_H2_V1_V_V2_T1_sharedCall(varargin) %Display the selected features
S=varargin{3}; % Get the structure
imgProcessing(S,0);
end
function []=W_V2_H2_V1_V_V2_T2_sharedCall(varargin) %Change the features properties
[h,S]=varargin{[1,3]};  % Get calling handle and structure
I=get(S.W_V1,'UserData');
fieldNames=I.img.features0.Row;
str={'Additional lines';'Surface limit';'Centroid';'Bounding box';'Contact angle';'Tracking lines';'Underneath'};
switch h  % Who called?
    case S.W_V2_H2_V1_V_V2_T2_H_push(1)
        str=[str;{'Tracked drops';['Class: ',I.class.drops.text{1}];['Class: ',I.class.drops.text{2}];['Class: ',I.class.drops.text{3}];['Class: ',I.class.drops.text{4}];['Class: ',I.class.drops.text{5}]}];  
        colorMapOptions={'parula';'jet';'hsv';'hot';'cool';'spring';'summer';'autumn';'winter';'gray';'bone';'copper';'pink'};
        [s,v]=listdlg('PromptString','Select the feature:','SelectionMode','single','ListString',str);
        if v==1
            switch s
                case {1,2,3,4,5,7,8}
                    color2apply=uisetcolor(double(I.img.features0.color{(fieldNames{s})})./255);
                    if length(color2apply)>1
                        color2apply=double(uint8(color2apply.*255));
                        I.img.features.color{(fieldNames{s})}=color2apply;
                    end
                case 6
                    [s2,v2]=listdlg('PromptString','Select what feature color you want to change:','SelectionMode','single','ListString',colorMapOptions,'InitialValue',2);
                    if v2==1
                        I.img.features.color{(fieldNames{s})}=colorMapOptions{s2};
                    end
                case {9,10,11,12,13}
                    t=s-8;
                    color2apply=uisetcolor(double(I.img.features0.color{(fieldNames{8})}(t,:))./255);
                    if length(color2apply)>1
                        color2apply=double(uint8(color2apply.*255));
                        I.img.features.color{(fieldNames{s})}(t,:)=color2apply;
                    end
            end
        end     
    case S.W_V2_H2_V1_V_V2_T2_H_push(2)
        str=[str;'Class'];
        [s,v]=listdlg('PromptString','Select what feature shape you want to change:','SelectionMode','single','ListString',str);      
        if v==1
            prompt=[join(['Enter the' str(s) 'thichness:']),join(['Enter the' str(s) 'length:'])];
            if not(s==5)
               prompt=prompt{1}; 
            end           
            inputStr=convertStringsToChars(string(I.img.features0.shape{(fieldNames{s})}));
            if ~iscell(inputStr)
                inputStr={inputStr};
            end
            answer=inputdlg(prompt,'Input',1,inputStr);            
            if ~isempty(answer)                
                I.img.features.shape{(fieldNames{s})}=str2double(answer');
            end
            switch s
                case 1
                            [I.img.features.pxList{'addLines'}]=transfoCoord2PixelList(I.img.type.M,'Line',I.img.features.positions{'addLines'},I.img.features.shape{'addLines'});      
                case 2
                            [I.img.features.pxList{'limitSurface'}]=getSurfLimit(I.img.type.S{1},1); %I.img.type.SL
                case 3
                            [I.img.features.pxList{'centroid'}]=transfoCoord2PixelList(I.img.type.M,'Point',I.img.features.positions{'centroid'},I.img.features.shape{'centroid'});
                case 4
                            [I.img.features.pxList{'boundingBox'}]=transfoCoord2PixelList(I.img.type.M,'Box',I.img.features.positions{'boundingBox'},I.img.features.shape{'boundingBox'});
                case 5
                            [I.img.features.positions{'contactAngle'}]=getAng2draw(I.obs.mainDrop,I.img.type.B,I.img.features.shape{'contactAngle'}(2));
                            [I.img.features.pxList{'contactAngle'}]=transfoCoord2PixelList(I.img.type.M,'Line',I.img.features.positions{'contactAngle'},I.img.features.shape{'contactAngle'}(1));
                case 6
                            [I.img.features.pxList{'tracking'}]=transfoCoord2PixelList(I.img.type.M,'Tracking',I.img.features.positions{'tracking'},I.img.features.shape{'tracking'}); 
            end
        end              
end

set(S.W_V1,'UserData',I);
imgProcessing(S,0);
end
function []=W_V2_H2_V1_V_V2_T3_sharedCall(varargin) %Save image or movie
[h,S]=varargin{[1,3]};  % Get calling handle and structure
I=get(S.W_V1,'UserData');
months={'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun','Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
c=clock;
name4saving=[get(S.W_V2_H1_V2_V3_H_edit(1),'string') '_' get(S.W_V2_H1_V2_V3_H_edit(2),'string') ...
    '-' sprintf('%02d',c(3)) months{c(2)} sprintf('%04d',c(1)) ...
    '_' sprintf('%02d',c(4)) 'h' sprintf('%02d',c(5)) 'm' sprintf('%02d',round(c(6))) 's'];
switch h  % Who called?  
    case S.W_V2_H2_V1_V_V2_T3_H_push(1)
        name4saving=['Img-' name4saving '.tif'];
        imwrite(I.img.type.img2show{str2double(get(S.W_V2_H2_V1_V_V1_H_edit(1),'string'))},name4saving)
    case S.W_V2_H2_V1_V_V2_T3_H_push(2)
        name4saving=['Vid-' name4saving '.avi'];  
        v=VideoWriter(name4saving,'Uncompressed AVI');
%         name4saving=['Vid-' name4saving '.mp4'];
%         v=VideoWriter(name4saving,'MPEG-4');
        open(v)
        for n=1:length(I.img.type.img2show)
            writeVideo(v,I.img.type.img2show{n})
%             writeVideo(v,flip(I.img.type.img2show{n},1))
        end
        close(v)
end
end

%--------------------------------------------------------------------------
% Analysis level 

function []=W_V2_H2_V2_H_sharedCall(varargin) % Control the process level
[h,S] = varargin{[1,3]};  % Get calling handle and structure
I=get(S.W_V1,'UserData');
switch h  % Who called?
    case {S.W_V2_H2_V2_H_pop,S.W_V2_H2_V2_H_H_push(1),S.W_V2_H2_V2_H_H_push(2)}
        c=get(S.W_V2_H2_V2_H_pop,'val');
        switch h
            case S.W_V2_H2_V2_H_pop
                %nothing
            case S.W_V2_H2_V2_H_H_push(1)
                c=c-1;
            case S.W_V2_H2_V2_H_H_push(2)
                c=c+1;
        end
    case S.W_V2_H2_V2_H_edit        
        c=abs(round(str2double(get(h,'string'))));
    case S.W_V2_H2_V2_H_H_push(3)
        c=Inf;
end
P=get(S.W_V2_H2_V2_H_pop,{'string','val'});
if c<1
    c=1;
elseif c>length(P{1})
    c=length(P{1});
end
set(S.W_V2_H2_V2_H_pop,'val',c) 
set(S.W_V2_H2_V2_H_edit,'string',c)

I.img.display.analysisLvl=get(S.W_V2_H2_V2_H_pop,'val');

set(S.W_V1,'UserData',I);
imgProcessing(S,c)
end

%--------------------------------------------------------------------------
% Analysis settings, tab: lvl 1: Dim

function []=W_V2_H2_V3_T1_G_shared1Call(varargin) % Values to crop the images
[h,S] = varargin{[1,3]};  % Get calling handle and structure
I=get(S.W_V1,'UserData');
switch h  % Who called?
    case S.W_V2_H2_V3_T1_G_edit(1)
        if str2double(get(h,'string'))>str2double(get(S.W_V2_H2_V3_T1_G_edit(2),'string'))
            set(h,'string',str2double(get(S.W_V2_H2_V3_T1_G_edit(2),'string')))
        end
        pxMax=I.img.info.size(2);
    case S.W_V2_H2_V3_T1_G_edit(2)
        if str2double(get(h,'string'))<str2double(get(S.W_V2_H2_V3_T1_G_edit(1),'string'))
            set(h,'string',str2double(get(S.W_V2_H2_V3_T1_G_edit(1),'string')))
        end
        pxMax=I.img.info.size(2);
    case S.W_V2_H2_V3_T1_G_edit(3)
        if str2double(get(h,'string'))>str2double(get(S.W_V2_H2_V3_T1_G_edit(4),'string'))
            set(h,'string',str2double(get(S.W_V2_H2_V3_T1_G_edit(4),'string')))
        end
        pxMax=I.img.info.size(1);
    case S.W_V2_H2_V3_T1_G_edit(4)
        if str2double(get(h,'string'))<str2double(get(S.W_V2_H2_V3_T1_G_edit(3),'string'))
            set(h,'string',str2double(get(S.W_V2_H2_V3_T1_G_edit(3),'string')))
        end
        pxMax=I.img.info.size(1);
end
if str2double(get(h,'string'))<1
    set(h,'string',1)
elseif str2double(get(h,'string'))>pxMax
    set(h,'string',pxMax)
end
end
function []=W_V2_H2_V3_T1_G_shared2Call(varargin) % Cropping buttons
[h,S] = varargin{[1,3]};  % Get calling handle and structure
switch h  % Who called?
    case S.W_V2_H2_V3_T1_G_push(1)
        [S]=cropImgPara(S);
        I=get(S.W_V1,'UserData');
        I.img.modi.enable{'crop'}=1;
        set(S.W_V1,'UserData',I);
    case S.W_V2_H2_V3_T1_G_push(2)
        [S]=initialPara(S,[2,4]);
end
imgProcessing(S,1)
end

%--------------------------------------------------------------------------
% Analysis settings, tab: lvl 2: Filters
function []=W_V2_H2_V3_T2_G_checkCall(varargin)
[h,S]=varargin{[1,3]};  % Get calling handle and structure

imgProcessing(S,2)
%set(S.W_V2_H2_V3_T2_G_check(1),'Callback',{@W_V2_H2_V3_T2_G_checkCall,S});  

end

%--------------------------------------------------------------------------
% Analysis settings, tab: lvl 3: Bg

function []=W_V2_H2_V3_T3_H_sharedCall(varargin) % Number of images for the background
[h,S]=varargin{[1,3]};  % Get calling handle and structure
switch h  % Who called?
    case S.W_V2_H2_V3_T3_H_edit
        set(h,'string',abs(round(str2double(get(h,'string')))))
    case S.W_V2_H2_V3_T3_H_push
        [S]=initialPara(S,5);
end
imgProcessing(S,3)
end 

%--------------------------------------------------------------------------
% Analysis settings, tab: lvl 4: Surf

function []=W_V2_H2_V3_T4_H2_V_radioCall(varargin) %Manage the surface limit options
[h,S]=varargin{[1,3]};  % Get calling handle and structure
switch h  % Who called?
    case S.W_V2_H2_V3_T4_H2_V_radio(1)
        set(S.W_V2_H2_V3_T4_H2_V_radio(2),'Value',0)       
        set(S.W_V2_H2_V3_T4_H3_V1,'Visible','on') 
        set(S.W_V2_H2_V3_T4_H3_V2_push(1),'Visible','on')
        set(S.W_V2_H2_V3_T4_H3_V2_H_edit,'Visible','off')
        set(S.W_V2_H2_V3_T4_H3_V2_push(2),'Visible','off') 
      
    case S.W_V2_H2_V3_T4_H2_V_radio(2)
        set(S.W_V2_H2_V3_T4_H2_V_radio(1),'Value',0);
        set(S.W_V2_H2_V3_T4_H3_V1,'Visible','off')
        set(S.W_V2_H2_V3_T4_H3_V2_push(1),'Visible','off')
        set(S.W_V2_H2_V3_T4_H3_V2_H_edit,'Visible','on')
        set(S.W_V2_H2_V3_T4_H3_V2_push(2),'Visible','on') 
end

imgProcessing(S,4)        
end
function []=W_V2_H2_V3_T4_H3_V1_H_sharedCall(varargin) % Manage the limit (line)
[h,S]=varargin{[1,3]};  % Get calling handle and structure
I=get(S.W_V1,'UserData');
limCenter=str2double(get(S.W_V2_H2_V3_T4_H3_V1_H_edit(1),'string'));
limAngle=str2double(get(S.W_V2_H2_V3_T4_H3_V1_H_edit(2),'string'));
switch h  % Who called?
    case S.W_V2_H2_V3_T4_H3_V1_H1_push(1)
        limCenter=limCenter+1;
    case S.W_V2_H2_V3_T4_H3_V1_H1_push(2)
        limCenter=limCenter-1;
    case S.W_V2_H2_V3_T4_H3_V1_H2_push(1)
        limAngle=limAngle+0.25;
    case S.W_V2_H2_V3_T4_H3_V1_H2_push(2)
        limAngle=limAngle-0.25;
end
if limCenter>size(I.img.type.BG{1},1)
    limCenter=size(I.img.type.BG{1},1);    
elseif limCenter<1
    limCenter=1; 
end
if limAngle>5
    limAngle=5;    
elseif limAngle<-5
    limAngle=-5; 
end
if limAngle==0
    limCenter=round(limCenter);
end
set(S.W_V2_H2_V3_T4_H3_V1_H_edit(1),'string',limCenter)
set(S.W_V2_H2_V3_T4_H3_V1_H_edit(2),'string',limAngle)

imgProcessing(S,4)
end
function []=W_V2_H2_V3_T4_H3_V2_H_editCall(varargin) % Manage the limit (background)
[h,S]=varargin{[1,3]};  % Get calling handle and structure
set(h,'string',uint8(abs(round(str2double(get(h,'string'))))))

imgProcessing(S,4)
end
function []=W_V2_H2_V3_T4_H3_V2_H_sharedCall(varargin) % Reset the limit background 
S=varargin{3};  % Get structure
[S]=initialPara(S,6);
imgProcessing(S,4)
end

%--------------------------------------------------------------------------
% Analysis settings, tab: lvl 4: Focus 

function []=W_V2_H2_V3_T5_sharedCall(varargin) % Reset the limit background 
[h,S]=varargin{[1,3]};  % Get calling handle and structure
switch h
    case S.W_V2_H2_V3_T5_G_pop
        P=get(h,'value');
        if P==1
            set(S.W_V2_H2_V3_T5_G_edit,'enable','off')
        else
            set(S.W_V2_H2_V3_T5_G_edit,'enable','on')
        end
    case S.W_V2_H2_V3_T5_G_edit
        set(h,'string',uint8(str2double(get(h,'string'))))
    case S.W_V2_H2_V3_T5_G_push
        set(S.W_V2_H2_V3_T5_G_edit,'string',0)
end
end


%--------------------------------------------------------------------------
% Analysis settings, tab: lvl 5: Bin

function []=W_V2_H2_V3_T6_G_sharedCall(varargin) %Manage the binarisation
[h,S]=varargin{[1,3]};  % Get calling handle and structure
switch h
    case {S.W_V2_H2_V3_T6_G_edit(1)}
        set(h,'string',uint8(str2double(get(h,'string'))))
    case {S.W_V2_H2_V3_T6_G_edit(2),S.W_V2_H2_V3_T6_G_edit(3)}
        set(h,'string',max([round(str2double(get(h,'string'))),0]))
    case S.W_V2_H2_V3_T6_G_check(1)
        if get(h,'value')==0
            set(S.W_V2_H2_V3_T6_G_check(2),'value',0)
        end
    case S.W_V2_H2_V3_T6_G_check(2)
        if get(h,'value')==1
            set(S.W_V2_H2_V3_T6_G_check(1),'value',1)
        end    
    case S.W_V2_H2_V3_T6_G_push
        [S]=initialPara(S,7);     
end

imgProcessing(S,5)
end

%--------------------------------------------------------------------------
% Analysis settings, tab: lvl 5: Bin

function []=W_V2_H2_V3_T7_G_sharedCall(varargin) %Manage the binarisation
[h,S]=varargin{[1,3]};  % Get calling handle and structure
switch h
    case S.W_V2_H2_V3_T7_G_pop 
        P=get(h,'value');
        if P==1
            set(S.W_V2_H2_V3_T7_G_edit(2),'enable','off')
        else
            set(S.W_V2_H2_V3_T7_G_edit(2),'enable','on')
        end
    case S.W_V2_H2_V3_T7_G_edit(1)
        set(h,'string',uint8(str2double(get(h,'string'))))
    case S.W_V2_H2_V3_T7_G_edit(2)
         set(h,'string',uint8(str2double(get(h,'string'))))
    case S.W_V2_H2_V3_T7_G_edit(3)
        set(h,'string',max([round(str2double(get(h,'string'))),0]))
    case S.W_V2_H2_V3_T7_G_push
        %[S]=initialPara(S,7);     
end

imgProcessing(S,5)
end

%--------------------------------------------------------------------------
% Analysis settings, tab: lvl 7A: CA

function []=W_V2_H2_V3_T8_G_sharedCall(varargin) %Manage the contact angle options
[h,S]=varargin{[1,3]};  % Get calling handle and structure
switch h
    case S.W_V2_H2_V3_T8_G_pop
        switch get(h,'value')
            case 1
                set(S.W_V2_H2_V3_T8_G_edit(1),'visible','off')
                set(S.W_V2_H2_V3_T8_G_edit(2),'visible','off')
                set(S.W_V2_H2_V3_T8_G_edit(3),'visible','off')
                set(S.W_V2_H2_V3_T8_G_edit(4),'visible','off')
            case 2
                set(S.W_V2_H2_V3_T8_G_edit(1),'visible','on')
                set(S.W_V2_H2_V3_T8_G_edit(2),'enable','on')
                set(S.W_V2_H2_V3_T8_G_edit(3),'enable','on')
                set(S.W_V2_H2_V3_T8_G_edit(4),'enable','on')
            case 3
                set(S.W_V2_H2_V3_T8_G_edit(1),'visible','on')
                set(S.W_V2_H2_V3_T8_G_edit(2),'enable','on')
                set(S.W_V2_H2_V3_T8_G_edit(3),'enable','off')
                set(S.W_V2_H2_V3_T8_G_edit(4),'enable','on')
            case 4
                set(S.W_V2_H2_V3_T8_G_edit(1),'visible','on')
                set(S.W_V2_H2_V3_T8_G_edit(2),'enable','on')
                set(S.W_V2_H2_V3_T8_G_edit(3),'enable','on')
                set(S.W_V2_H2_V3_T8_G_edit(4),'enable','off')
            case 5
                set(S.W_V2_H2_V3_T8_G_edit(1),'visible','on')
                set(S.W_V2_H2_V3_T8_G_edit(2),'visible','off')
                set(S.W_V2_H2_V3_T8_G_edit(3),'visible','off')
                set(S.W_V2_H2_V3_T8_G_edit(4),'visible','off')
        end
    case S.W_V2_H2_V3_T8_G_edit(1)
        setVal=round(str2double(get(h,'string')));
        minVal=3;
        maxVal=20;
        if setVal<minVal
            setVal=minVal;
        elseif setVal>maxVal
            setVal=maxVal;
        end
        set(h,'string',setVal)
    case S.W_V2_H2_V3_T8_G_edit(2)
        setVal=str2double(get(h,'string'));
        minVal=-0.5;
        maxVal=0.5;
        if setVal<minVal
            setVal=minVal;
        elseif setVal>maxVal
            setVal=maxVal;
        end
        set(h,'string',setVal)
    case S.W_V2_H2_V3_T8_G_edit(3)
        setVal=str2double(get(h,'string'));
        minVal=0;
        maxVal=1;
        if setVal<minVal
            setVal=minVal;
        elseif setVal>maxVal
            setVal=maxVal;
        end
        set(h,'string',setVal)
    case S.W_V2_H2_V3_T8_G_edit(1)
        setVal=round(str2double(get(h,'string')));
        minVal=0;
        maxVal=3;
        if setVal<minVal
            setVal=minVal;
        elseif setVal>maxVal
            setVal=maxVal;
        end
        set(h,'string',setVal)
    case S.W_V2_H2_V3_T8_G_push
        [S]=initialPara(S,9);
end

I=get(S.W_V1,'UserData');
[I.obs.mainDrop]=getContactAngle(I.obs.mainDrop,I.img.type.S{1},I.img.type.E,str2double(get(S.W_V2_H2_V3_T8_G_edit(1),'string')),...
    get(S.W_V2_H2_V3_T8_G_pop,'val'),str2double(get(S.W_V2_H2_V3_T6_G_edit(1),'string')),...
    str2double(get(S.W_V2_H2_V3_T8_G_edit(2),'string')),str2double(get(S.W_V2_H2_V3_T8_G_edit(3),'string')),str2double(get(S.W_V2_H2_V3_T8_G_edit(4),'string')));
[I.img.features.positions{'contactAngle'}]=getAng2draw(I.obs.mainDrop,I.img.type.B,I.img.features.shape{'contactAngle'}(2));
[I.img.features.pxList{'contactAngle'}]=transfoCoord2PixelList(I.img.type.M,'Line',I.img.features.positions{'contactAngle'},I.img.features.shape{'contactAngle'}(1));
set(S.W_V1,'UserData',I);
imgProcessing(S,0) 

end

%--------------------------------------------------------------------------
% Analysis settings, tab: lvl 7B: Underneath
function []=W_V2_H2_V3_T9_G_sharedCall(varargin) %Manage the binarisation
[h,S]=varargin{[1,3]};  % Get calling handle and structure
switch h
    case S.W_V2_H2_V3_T9_G_edit
        if get(h,'string')<0 
             set(h,'string',0)
        end
    case S.W_V2_H2_V3_T9_G_check
       %nothing   
end

imgProcessing(S,7) 
end
%==========================================================================
% OutputS

%--------------------------------------------------------------------------
% Direct measurement

function []=wbmfcn(varargin) % WindowButtonMotionFcn for the image
S=varargin{3}; % Get the structure
[ptVal]=getPointerVal(S);
set(S.W_V2_H3_V1_V1_H_text(2),'String',sprintf("x=%d ; y=%d",ptVal(1),ptVal(2)))
end
function []=bdfcn(varargin) % ButtonDownFcn for the image
S=varargin{3}; % Get the structure
switch get(S.window,'selectiontype')
    case 'normal'
        [ptVal]=getPointerVal(S);
        pt=get(S.W_V2_H3_V1_V1_H_text(1),'UserData');
        switch pt
            case 1
                pt=2;
                set(S.W_V2_H3_V1_V2_G_edit(1),'string',ptVal(1))
                set(S.W_V2_H3_V1_V2_G_edit(3),'string',ptVal(2))
            case 2
                pt=1;
                set(S.W_V2_H3_V1_V2_G_edit(2),'string',ptVal(1))
                set(S.W_V2_H3_V1_V2_G_edit(4),'string',ptVal(2))
            otherwise
                pt=1;
        end
        set(S.W_V2_H3_V1_V1_H_text(1),'UserData',pt);
        pointerInfo(S) 
    case 'alt'
        %Do nothing
    case 'open'
        %Do nothing
    case 'extend'
        %Do nothing
    otherwise
end
end
function []=W_V2_H3_V1_V2_G_sharedCall(varargin) %Calculate the values from the left click
[h,S] = varargin{[1,3]};  % Get calling handle and structure
I=get(S.W_V1,'UserData');
I_max=size(I.img.type.img2show{1}); %[ln;cl]
pxVal=str2double(get(h,'string'));
switch h  % Who called?
    case S.W_V2_H3_V1_V2_G_edit(1)
        pxMax=I_max(2);
    case S.W_V2_H3_V1_V2_G_edit(2)
        pxMax=I_max(2);
    case S.W_V2_H3_V1_V2_G_edit(3)
        pxMax=I_max(1);
    case S.W_V2_H3_V1_V2_G_edit(4)
        pxMax=I_max(1);
end
if pxVal<1
    pxVal=1;
elseif pxVal>pxMax
    pxVal=pxMax;
end
set(h,'string',pxVal)
pointerInfo(S)
end
function []=W_V2_H3_V1_V3_H_sharedCall(varargin) % Display line(s)
[h,S] = varargin{[1,3]};  % Get calling handle and structure
I=get(S.W_V1,'UserData');
switch h  % Who called?
    case S.W_V2_H3_V1_V3_H_push(1)
        [ptZone]=getPointerZone(S,0);
        I.img.features.positions{'addLines'}{:}=cat(1,I.img.features.positions{'addLines'}{:},ptZone,[NaN,NaN]);       
        [I.img.features.pxList{'addLines'}]=transfoCoord2PixelList(I.img.type.M,'Line',I.img.features.positions{'addLines'},I.img.features.shape{'addLines'});      
    case S.W_V2_H3_V1_V3_H_push(2)
        I.img.features.positions{'addLines'}=cell(1,1);
        I.img.features.pxList{'addLines'}=[];
end
set(S.W_V1,'UserData',I);
imgProcessing(S,0)
end

%--------------------------------------------------------------------------
% Analysis outputs, tab: Props

function []=W_V2_H3_V2_T1_G_edit_sharedCall(varargin) %Check diameter and velocity values
[h,S] = varargin{[1,3]};  % Get calling handle and structure
val=str2double(get(h,'string'));
switch h  % Who called?
    case S.W_V2_H3_V2_T1_G_edit(1)
        val2=val*(0.001/str2double(get(S.W_V2_H1_V2_V4_H_edit(2),'string')))*str2double(get(S.W_V2_H1_V2_V4_H_edit(1),'string'));
        set(S.W_V2_H3_V2_T1_G_edit(3),'string',val2);
    case S.W_V2_H3_V2_T1_G_edit(2)
        val2=val*(0.001/str2double(get(S.W_V2_H1_V2_V4_H_edit(2),'string')))*str2double(get(S.W_V2_H1_V2_V4_H_edit(1),'string'));
        set(S.W_V2_H3_V2_T1_G_edit(4),'string',val2);
    case S.W_V2_H3_V2_T1_G_edit(5)
        val2=val*(1000/str2double(get(S.W_V2_H1_V2_V4_H_edit(2),'string')));
        set(S.W_V2_H3_V2_T1_G_edit(6),'string',val2);
end

end


function []=W_V2_H3_V2_T1_G_push_sharedCall(varargin) %Check diameter and velocity values
[h,S] = varargin{[1,3]};  % Get calling handle and structure
tab2plot=get(h,'UserData');
if ~isempty(tab2plot)
    switch h  % Who called? 
    case S.W_V2_H3_V2_T1_G_push(1)
        
        displayTabValues(tab2plot,1,'Frame number',[2:size(tab2plot,2)],'Velocity [px/frame]',0,'')
        
        %plotTab(tab2plot(:,:),'Velocity [px/frame]')      
    case S.W_V2_H3_V2_T1_G_push(2)
        displayTabValues(tab2plot,1,'Frame number',[2:size(tab2plot,2)-1],'Diameter [px]',size(tab2plot,2),'Eccentricity [-]')
        %plotTab(tab2plot(:,[1:4,6]),'Diameter [px]')      
    end
end 
end

%--------------------------------------------------------------------------
% Analysis outputs, tab: CL

function []=W_V2_H3_V2_T2_G_pushCall(varargin) %Display the contact line behavior 
S=varargin{3};  % Get calling handle and structure
I=get(S.W_V1,'UserData');
displaySpreadingData(I.obs.mainDrop,str2double(get(S.W_V2_H3_V2_T1_G_edit(5),'string')),str2double(get(S.W_V2_H3_V2_T1_G_edit(1),'string')))
end

%--------------------------------------------------------------------------
% Analysis outputs, tab: Pinning

%--------------------------------------------------------------------------
% Analysis outputs, tab: Obs

%--------------------------------------------------------------------------
% Analysis outputs, tab: Save

function []=W_V2_H3_V2_T5_V2_H_push_sharedCall(varargin)
[h,S] = varargin{[1,3]};  % Get calling handle and structure
I=get(S.W_V1,'UserData');

switch h
    case {S.W_V2_H3_V2_T5_V2_H_push(1),S.W_V2_H3_V2_T5_V2_H_push(2)}
        dataNum=str2double(get(S.W_V2_H1_V2_V1_H_edit,'string'));
        % Setup
        I.file.tab.full.Path{dataNum}=get(S.W_V2_H1_V2_V2_H_edit,'string');
        I.file.tab.full.Surface{dataNum}=get(S.W_V2_H1_V2_V3_H_edit(1),'string');
        I.file.tab.full.Liquid{dataNum}=get(S.W_V2_H1_V2_V3_H_edit(2),'string');
        % Camera
        I.file.tab.full.Camera{dataNum}.FPS=get(S.W_V2_H1_V2_V4_H_edit(1),'string');
        I.file.tab.full.Camera{dataNum}.mm2px=get(S.W_V2_H1_V2_V4_H_edit(2),'string');
        P=get(S.W_V2_H1_V1_T1_V2_H_pop(:),'String');
        I.file.tab.full.Camera{dataNum}.format={P{1}{get(S.W_V2_H1_V1_T1_V2_H_pop(1),'value')},P{2}{get(S.W_V2_H1_V1_T1_V2_H_pop(2),'value')}};
        % Analysis
        I.file.tab.full.Lvl{dataNum}=str2double(get(S.W_V2_H2_V2_H_edit,'string'));
        % Settings
        switch h
            case S.W_V2_H3_V2_T5_V2_H_push(1) %Add case
                lvlMax=I.file.tab.full.Lvl{dataNum};
            case S.W_V2_H3_V2_T5_V2_H_push(2) %Discard case
                lvlMax=1;
        end
        for k=1:lvlMax
            switch k
                case 1
                    I.file.tab.full.Setting{dataNum}.imgNbr=I.img.info.nbr;
                    I.file.tab.full.Setting{dataNum}.clear=I.img.modi.zone{'clear'};
                    I.file.tab.full.Setting{dataNum}.dimensions=str2double(get(S.W_V2_H2_V3_T1_G_edit(:),'string'));
                case 2
                    I.file.tab.full.Setting{dataNum}.filters.median=get(S.W_V2_H2_V3_T2_G_check(1),'value');
                    I.file.tab.full.Setting{dataNum}.filters.sharpening=get(S.W_V2_H2_V3_T2_G_check(2),'value');  
                case 3
                    I.file.tab.full.Setting{dataNum}.backgroundNbr=str2double(get(S.W_V2_H2_V3_T3_H_edit,'string'));
                case 4
                    if get(S.W_V2_H2_V3_T4_H2_V_radio(1),'value')==1
                        I.file.tab.full.Setting{dataNum}.surface.type=get(S.W_V2_H2_V3_T4_H2_V_radio(1),'String');
                        I.file.tab.full.Setting{dataNum}.surface.val=str2double(get(S.W_V2_H2_V3_T4_H3_V1_H_edit(:),'String'));
                    else
                        I.file.tab.full.Setting{dataNum}.surface.type=get(S.W_V2_H2_V3_T4_H2_V_radio(2),'String');
                        I.file.tab.full.Setting{dataNum}.surface.val=str2double(get(S.W_V2_H2_V3_T4_H3_V2_H_edit,'String'));
                    end
                case 5
                    I.file.tab.full.Setting{dataNum}.binarisation.threshold=str2double(get(S.W_V2_H2_V3_T6_G_edit(1),'String'));
                    I.file.tab.full.Setting{dataNum}.binarisation.minDetection=str2double(get(S.W_V2_H2_V3_T6_G_edit(2),'String'));
                    I.file.tab.full.Setting{dataNum}.binarisation.surfCorrection=str2double(get(S.W_V2_H2_V3_T6_G_edit(3),'String'));
                    I.file.tab.full.Setting{dataNum}.binarisation.fill(1)=get(S.W_V2_H2_V3_T6_G_check(1),'value');
                    I.file.tab.full.Setting{dataNum}.binarisation.fill(2)=get(S.W_V2_H2_V3_T6_G_check(2),'value');
                case 6
                    I.file.tab.full.Setting{dataNum}.trackingMod=I.track.mod;
                    I.file.tab.full.Output{dataNum}.mainDrop.startImpact=str2double(get(S.W_V2_H3_V2_T1_G_edit(7),'String'));
                    I.file.tab.full.Output{dataNum}.mainDrop.impactVel=[str2double(get(S.W_V2_H3_V2_T1_G_edit(2),'String')),str2double(get(S.W_V2_H3_V2_T1_G_edit(1),'String'))];
                    I.file.tab.full.Output{dataNum}.mainDrop.iniDia=str2double(get(S.W_V2_H3_V2_T1_G_edit(5),'String'));
                    I.file.tab.full.Output{dataNum}.mainDrop.impact=I.obs.mainDrop;
                case 7
                    P=get(S.W_V2_H2_V3_T8_G_pop,'String');
                    I.file.tab.full.Setting{dataNum}.contactAngle.method=P{get(S.W_V2_H2_V3_T8_G_pop,'value')};
                    I.file.tab.full.Setting{dataNum}.contactAngle.zone=str2double(get(S.W_V2_H2_V3_T8_G_edit(1),'String'));
                    I.file.tab.full.Setting{dataNum}.contactAngle.offset=str2double(get(S.W_V2_H2_V3_T8_G_edit(2),'String'));
                    I.file.tab.full.Setting{dataNum}.contactAngle.smoothVal=str2double(get(S.W_V2_H2_V3_T8_G_edit(3),'String'));
                    I.file.tab.full.Setting{dataNum}.contactAngle.Weight=str2double(get(S.W_V2_H2_V3_T8_G_edit(4),'String'));
                case 8
                    I.file.tab.full.Setting{dataNum}.trackingMod=I.track.mod;
                case 9
                    I.file.tab.full.Output{dataNum}.dropClass=I.class.drops.tab;
                case 10
                    I.file.tab.full.Output{dataNum}.pinning=I.class.pinning.tab(:,[1:5,7]);
            end
        end
        set(S.W_V1,'UserData',I);
                       
    case S.W_V2_H3_V2_T5_V2_H_push(3) %Save data
        fileFull=get(S.W_V2_H1_V1_T1_V3_H_edit,'string');
        fileName=fileFull(find(fileFull==filesep,1,'last')+1:end-4);
        dropImpactData.(fileName)=I.file.tab.full;
        save([fileName '.mat'],'dropImpactData','-v7.3')
        set(S.W_V2_H1_V1_T1_V3_H_pop,'value',2)
        assignin('base','I',I)
        
end

end

%==========================================================================
% IMG

function []=cm_call(varargin) % Diplay the right options
S=varargin{3}; % Get the structure
I=get(S.W_V1,'UserData');
[ptLast]=getPointerLastClic(S);
P=get(S.W_V2_H2_V1_V_V1_H_pop,{'string','val'});  % Get the users choice.
imgNbr=str2double(get(S.W_V2_H2_V1_V_V1_H_edit(1),'string'));
switch P{1}{P{2},:}
    case 'Raw images'
        imgInfo=I.img.type.R{imgNbr};
    case 'Modified images'
        imgInfo=I.img.type.M{imgNbr};
    case 'Modified images 2'
        imgInfo=I.img.type.Mu{imgNbr};
    case 'Background'
        imgInfo=I.img.type.BG{1};
    case 'Background 2'
        imgInfo=I.img.type.BGu{1};
    case 'Enhanced images'
        imgInfo=I.img.type.E{imgNbr};
    case 'Enhanced images 2'
        imgInfo=I.img.type.Eu{imgNbr};
    case 'Binary surface'
        imgInfo=I.img.type.S{1};
    case 'Binary surface 2'
        imgInfo=I.img.type.S{1};
    case 'Binary images'
        imgInfo=I.img.type.B{imgNbr};
    case 'Binary images 2'
        imgInfo=I.img.type.Bu{imgNbr};
    case 'Pinned drops'
        imgInfo=I.img.type.P{imgNbr};
end

imgDim=size(imgInfo);
ptX=ptLast(1);
ptY=ptLast(2);
if ptX>imgDim(2)
    ptX=imgDim(2);
elseif ptX<1
    ptX=1;
end
if ptY>imgDim(1)
    ptY=imgDim(1);
elseif ptY<1
    ptY=1;
end
%Pixel info
set(S.um(1),'label',['Pixel value: ' num2str(imgInfo(ptY,ptX))])

if I.img.display.type==1
    
    % ID
    if strcmp(get(get(S.um(5),'Parent'),'UserData'),'Active')
        m=I.img.type.L{imgNbr}(ptY,ptX);
        if m>0
            ID=I.track.new{imgNbr}(m).dropID;
            if isnan(ID)
                set(S.um(5),'label','Drop ID: No ID')
            else
                set(S.um(5),'label',['Drop ID: ' num2str(ID)])
            end
        else
            set(S.um(5),'label','Drop ID: No drop selected')
        end
    end
    
    %Class
    if strcmp(get(get(S.um(7),'Parent'),'UserData'),'Active')
        m=I.img.type.L{imgNbr}(ptY,ptX);
        if m>0
            ID=I.track.new{imgNbr}(m).dropID;
            set(S.um(7),'label',['Class:' I.class.drops.text{I.class.drops.tab{ID,I.class.drops.tab.Properties.VariableNames}==1}])
        else
            set(S.um(7),'label','Class: No drop selected')
        end
    end
    
elseif I.img.display.type==3
    set(S.um(11),'label','Drop ID: No drop selected')
    set(S.um(13),'label','Drop type:-' )
    set(S.um(15),'label','Volume method:-')
    set(S.um(17),'label','Relative volume:-')
    if sum(I.img.type.P{imgNbr}(ptY,ptX))>0
        [pos,subPos]=getPinningPosition(S,imgNbr,ptX);
        set(S.um(11),'label',['Drop ID: ' num2str(I.class.pinning.tab.PinnedDrops{imgNbr}(pos))])
        if ~(subPos==0)
            set(S.um(13),'label',['Drop type: ' get(S.ums(20+I.class.pinning.tab.Type{imgNbr}{pos}(subPos)),'label')])
            set(S.um(15),'label',['Volume method: ' get(S.ums(23+I.class.pinning.tab.volMethod{imgNbr}{pos}(subPos)),'label')])
            set(S.um(17),'label',['Relative volume: ' num2str(I.class.pinning.tab.RelVol{imgNbr}{pos}(subPos))])
        end
    end
end

end
function []=umZIn_call(varargin) % Action righ click: Zoom in 
S=varargin{3}; % Get the structure
I=get(S.W_V1,'UserData');
I.img.modi.enable{'zoom'}=1;
[ptZone]=getPointerZone(S,0);
I.img.modi.zone{'zoom'}=[ptZone(1,1),ptZone(2,1),ptZone(1,2),ptZone(2,2)];
set(S.W_V1,'UserData',I);
imgProcessing(S,0) %imgProcessing(S,I.img.display.analysisLvl)
end 
function []=umZOut_call(varargin) % Action righ click: Zoom out
S=varargin{3}; % Get the structure
I=get(S.W_V1,'UserData');
I.img.modi.enable{'zoom'}=0;
I.img.modi.zone{'zoom'}=[1,I.img.info.size(2),1,I.img.info.size(1)];
set(S.W_V1,'UserData',I);
[S]=initialPara(S,2);
imgProcessing(S,0) 
end
function []=umClear_call(varargin) % Action righ click: Clear noise
S=varargin{3}; % Get the structure
I=get(S.W_V1,'UserData');
I.img.modi.enable{'clear'}=1;
[ptZone]=getPointerZone(S,1);
I.img.modi.zone{'clear'}=cat(1,I.img.modi.zone{'clear'},[ptZone(1,1),ptZone(2,1),ptZone(1,2),ptZone(2,2)]);
set(S.W_V1,'UserData',I);
imgProcessing(S,1)
end
function []=umCrop_call(varargin) % Action righ click: Crop image
S=varargin{3}; % Get the structure
[ptZone]=getPointerZone(S,1);
set(S.W_V2_H2_V3_T1_G_edit(1),'string',ptZone(1,1))
set(S.W_V2_H2_V3_T1_G_edit(2),'string',ptZone(2,1))
set(S.W_V2_H2_V3_T1_G_edit(3),'string',ptZone(1,2))
set(S.W_V2_H2_V3_T1_G_edit(4),'string',ptZone(2,2))
[S]=cropImgPara(S);
I=get(S.W_V1,'UserData'); %get here I because it was modified by cropImgPara
I.img.modi.enable{'crop'}=1;
set(S.W_V1,'UserData',I);
imgProcessing(S,1)
end
function []=umOri_call(varargin)  % Action righ click: Back to original
S=varargin{3}; % Get the structure
[S]=initialPara(S,[2:4]);
imgProcessing(S,1)
end
function []=umLine_call(varargin) % Action righ click: Set line position
S=varargin{3}; % Get the structure
I=get(S.W_V1,'UserData');
a=I.img.display.analysisLvl;
if a==1
    imgProcessing(S,3)
end
if str2double(get(S.W_V2_H2_V3_T4_H3_V1_H_edit(2),'string'))==0
    [ptLast]=getPointerLastClic(S);
%     m=tand(str2double(get(S.W_V2_H2_V3_T4_H3_V1_H_edit(2),'string')));
%     y=ptLast(2)+m*(ptLast(1)-mean([1,size(I.img.type.BG,2)]));
    set(S.W_V2_H2_V3_T4_H3_V1_H_edit(1),'string',ptLast(2))
else
    onCrop=1;
    x=[str2double(get(S.W_V2_H3_V1_V2_G_edit(1),'string')),str2double(get(S.W_V2_H3_V1_V2_G_edit(2),'string'))]+((I.modi.crop.posi(1)-1)*ones(1,2)).*I.img.modi.enable{'crop'}.*onCrop;
    y=[str2double(get(S.W_V2_H3_V1_V2_G_edit(3),'string')),str2double(get(S.W_V2_H3_V1_V2_G_edit(4),'string'))]+((I.modi.crop.posi(3)-1)*ones(1,2)).*I.img.modi.enable{'crop'}.*onCrop;
    [x,idx]=sort(x);
    y=y(idx);
    m=diff(y)/diff(x);
    limAngle=-atand(m);
    limCenter=m*(mean([1,size(I.img.type.BG{1},2)])-x(1))+y(1);
    set(S.W_V2_H2_V3_T4_H3_V1_H_edit(1),'string',limCenter);
    set(S.W_V2_H2_V3_T4_H3_V1_H_edit(2),'string',limAngle);
end
imgProcessing(S,4)
end
function []=umTrack(varargin) % Action righ click: Change tracking

[h,S] = varargin{[1,3]};  % Get calling handle and structure
I=get(S.W_V1,'UserData');
k=height(I.track.mod)+1;
I.track.mod(k,:)=repmat({NaN},[1,size(I.track.mod,2)]);
switch h  % Who called?
    case {S.ums(6),S.ums(7),S.ums(8),S.ums(9)}
        
        imgNbr=str2double(get(S.W_V2_H2_V1_V_V1_H_edit(1),'string'));
        [ptLast]=getPointerLastClic(S);
        if I.img.type.B{imgNbr}(ptLast(2),ptLast(1))==1 %Prevent to add wrong info to change the tracking
            switch h
                case S.ums(6) %Last frame
                    I.track.mod.Frame(k,1)=imgNbr+1;
                    I.track.mod.Frame0(k,1)=imgNbr;
                    I.track.mod.Obj0(k,1)=I.img.type.L{imgNbr}(ptLast(2),ptLast(1));
                    I.track.mod.Action(k,1)=0;
                case S.ums(7) %New drop
                    I.track.mod.Frame(k,1)=imgNbr;
                    I.track.mod.Obj(k,1)=I.img.type.L{imgNbr}(ptLast(2),ptLast(1));
                    I.track.mod.Action(k,1)=1;
                case S.ums(8) %Fuse drops
                    v=cat(1,I.track.drops(:,imgNbr));
                    ops=find(or(v>0,~isnan(v))==1);
                    ops=ops(ops~=I.track.new{imgNbr}(I.img.type.L{imgNbr}(ptLast(2),ptLast(1))).dropID); %Prevent to auto-select
                    if ~isempty(ops)
                        [indx,tf] = listdlg('ListSize',[250 300],'Name','Fuse','PromptString',{'Select a drop ID.',...
                            ['The selected drop will be merge with the clicked drop (ID=' num2str(10) ') at the frame ' num2str(imgNbr) '.'],''},...
                            'SelectionMode','single','ListString',string(ops));
                        if tf==1
                            I.track.mod.Frame(k,1)=imgNbr;
                            I.track.mod.Obj(k,1)=I.img.type.L{imgNbr}(ptLast(2),ptLast(1));
                            I.track.mod.Frame0(k,1)=I.track.mod.Frame(k);
                            idx=find(cat(1,I.track.new{I.track.mod.Frame(k)}.dropID)==ops(indx));
                            if length(idx)>1
                                dist=zeros(length(idx),1);
                                c1=I.track.new{I.track.mod.Frame(k)}(I.track.mod.Obj(k)).Centroid;
                                for w=1:length(idx)
                                    c2=I.track.new{I.track.mod.Frame0(k)}(idx(w)).Centroid;
                                    dist(w)=sqrt(sum((c1-c2).^2,2));
                                end
                                idx=idx(dist==min(dist));
                            end
                            I.track.mod.Obj0(k,1)=idx;
                            I.track.mod.Action(k,1)=2;
                        else
                            I.track.mod(k,:)=[];
                        end
                    else
                        I.track.mod(k,:)=[];
                    end
                case S.ums(9) %Associate drops
                    v=cat(1,I.track.drops(:,imgNbr));
                    ops=find(or(v>0,isnan(v))==1);
                    ops=ops(ops~=I.track.new{imgNbr}(I.img.type.L{imgNbr}(ptLast(2),ptLast(1))).dropID); %Prevent to auto-select
                    if ~isempty(ops)
                        [indx,tf] = listdlg('ListSize',[250 300],'Name','Associate','PromptString',{'Select a drop ID.',...
                            ['The clicked drop (ID=' num2str(10) ') will be associated with the last apparition of the selected drop.'],''},...
                            'SelectionMode','single','ListString',string(ops));
                        if tf==1
                            I.track.mod.Frame(k,1)=imgNbr;
                            I.track.mod.Obj(k,1)=I.img.type.L{imgNbr}(ptLast(2),ptLast(1));
                            col=find(I.track.drops(ops(indx),1:(imgNbr-1))>0,1,'last');
                            I.track.mod.Frame0(k,1)=col;
                            idx=find(cat(1,I.track.new{col}.dropID)==ops(indx));
                            if length(idx)>1
                                dist=zeros(length(idx));
                                c1=I.track.new{I.track.mod.Frame(k)}(I.track.mod.Obj(k)).Centroid;
                                for w=1:length(idx)
                                    c2=I.track.new{I.track.mod.Frame0(k)}(idx(w)).Centroid;
                                    dist(w)=sqrt(sum((c1-c2).^2,2));
                                end
                                distMin=find(dist==min(dist),1,'first');
                                idx=idx(distMin);
                            end
                            I.track.mod.Obj0(k,1)=idx;
                            I.track.mod.Action(k,1)=3;
                        else
                            I.track.mod(k,:)=[];
                        end
                    else
                        I.track.mod(k,:)=[];
                    end
            end
        end
    case S.ums(10) %Undo last modification
        if height(I.track.mod)>0
            I.track.mod.Action(k,1)=4;
        else
            I.track.mod(k,:)=[];
        end
end

%Tell tracking needs to start from the frame that is modified
I.track.frames='modification';

set(S.W_V1,'UserData',I);

% Apply right tracking process
k=height(I.track.mod);
if I.track.mod.Action(k)==4
    k=k-1;
end
condID1=0;
if ~or(isnan(I.track.mod.Obj(k)),isnan(I.track.mod.Frame(k)))
    condID1=or(condID1,I.track.new{I.track.mod.Frame(k)}(I.track.mod.Obj(k)).dropID==1);
end
if ~or(isnan(I.track.mod.Obj0(k)),isnan(I.track.mod.Frame0(k)))
    condID1=or(condID1,I.track.new{I.track.mod.Frame0(k)}(I.track.mod.Obj0(k)).dropID==1);
end
if condID1==1
    imgProcessing(S,6)
else
    imgProcessing(S,8)
end
end
function []=umClass(varargin) % Action righ click: Change drop class
[h,S] = varargin{[1,3]};  % Get calling handle and structure
I=get(S.W_V1,'UserData');
imgNbr=str2double(get(S.W_V2_H2_V1_V_V1_H_edit(1),'string'));
[ptLast]=getPointerLastClic(S);
m=I.img.type.L{imgNbr}(ptLast(2),ptLast(1));
if m>0
    ID=I.track.new{imgNbr}(m).dropID;
    vClass=false(1,size(I.class.drops.tab,2));
    switch h
        case S.ums(11)
            vClass(1)=true;
        case S.ums(12)
            vClass(2)=true;
        case S.ums(13)
            vClass(3)=true;
        case S.ums(14)
            vClass(4)=true;
        case S.ums(15)
            vClass(5)=true;
    end
    if ~isequal(I.class.drops.tab{ID,I.class.drops.tab.Properties.VariableNames},vClass) %Check if the new class is different from the previous one
        I.class.drops.tab{ID,I.class.drops.tab.Properties.VariableNames}=vClass;
        set(S.W_V1,'UserData',I);
        imgProcessing(S,0)
    end
end


end
function []=umPinning(varargin) %Action righ click: Change pinned drop
[h,S] = varargin{[1,3]};  % Get calling handle and structure
I=get(S.W_V1,'UserData');
imgNbr=str2double(get(S.W_V2_H2_V1_V_V1_H_edit(1),'string'));
[ptLast]=getPointerLastClic(S);
if I.img.display.type==1
    m=I.img.type.L{imgNbr}(ptLast(2),ptLast(1));
    if m>0
        k=height(I.class.pinning.tab);
        switch h
            case S.ums(16)
                ID=I.track.new{imgNbr}(m).dropID;
                I.class.pinning.tab.Frame{k+1}=imgNbr;
                I.class.pinning.tab.PinnedDrops{k+1}=ID;
            case S.ums(17)
                if k>1
                    I.class.pinning.tab(k,:)=[];
                    I.img.type.P{k}=[];
                end
        end
        [I.class.pinning.tab]=getPinnedDropLimits(I.img.type.S{1},I.img.features.pxList{'class'},I.class.pinning.tab);
        [I.class.pinning.tab]=getPinnedDropClass(I.track.new2,I.track.drops,I.obs.mainDrop,str2double(get(S.W_V2_H3_V2_T2_G_edit(3),'string')),I.class.pinning.tab);
        [I.class.pinning.tab]=getPinnedDropVolMeth(I.img.type.S{1},I.img.features.pxList{'class'},I.class.pinning.tab);
        [I.class.pinning.tab]=getPinnedDropVol(str2double(get(S.W_V2_H3_V2_T1_G_edit(5),'string')),I.img.type.S{1},I.img.features.pxList{'class'},I.class.pinning.tab);
        [I.img.features.pxList{'pinning'}]=transfoCalculatedShape(I.class.pinning.tab);
        [I.img.type.P]=getImgPinning(I.img.type.S{1},I.track.new2,I.track.drops,I.class.pinning.tab);
        I.img.display.nbr(3)=height(I.class.pinning.tab);
        set(S.W_V1,'UserData',I);
        set(S.W_V2_H2_V1_V_V1_H_pop,'Value',6)
        imgProcessing(S,0)
    end
    
elseif I.img.display.type==3
    switch h
        case S.um(10)
            k=height(I.class.pinning.tab);
            if k>1
                I.class.pinning.tab(k,:)=[];
                I.img.type.P{k}=[];
                I.img.display.nbr(3)=height(I.class.pinning.tab)-1;
            end
        case {S.ums(18),S.ums(19),S.ums(20)}
            [ptZone]=getPointerZone(S,1);
            xRange=min(ptZone(:,1)):max(ptZone(:,1));
            I.img.type.P{imgNbr}(:,xRange)=uint8(I.img.type.P{imgNbr}(:,xRange).*255);
            switch h
                case S.ums(18)
                    %Nothing
                case S.ums(19)
                    I.img.type.P{imgNbr}(:,xRange)=uint8(round(I.img.type.P{imgNbr}(:,xRange)./2));
                case S.ums(20)
                    I.img.type.P{imgNbr}(:,xRange)=uint8(round(I.img.type.P{imgNbr}(:,xRange)./4));
            end
            [I.class.pinning.tab]=getPinnedDropNewLimits(I.img.type.P); %%%%%%%
            [I.class.pinning.tab]=getPinnedDropClass(I.track.new2,I.track.drops,I.obs.mainDrop,str2double(get(S.W_V2_H3_V2_T2_G_edit(3),'string')),I.class.pinning.tab);
            [I.class.pinning.tab]=getPinnedDropVolMeth(I.img.type.S{1},I.img.features.pxList{'class'},I.class.pinning.tab);
            [I.class.pinning.tab]=getPinnedDropVol(str2double(get(S.W_V2_H3_V2_T1_G_edit(5),'string')),I.img.type.S{1},I.img.features.pxList{'class'},I.class.pinning.tab);
            [I.img.features.pxList{'pinning'}]=transfoCalculatedShape(I.class.pinning.tab);
            [I.img.type.P]=getImgPinning(I.img.type.S{1},I.track.new2,I.track.drops,I.class.pinning.tab);
            
        case {S.ums(21),S.ums(22),S.ums(23),S.ums(24),S.ums(25)}
            [ptLast]=getPointerLastClic(S);
            if I.img.type.P{imgNbr}(ptLast(2),ptLast(1))>0
                [pos,subPos]=getPinningPosition(S,imgNbr,ptLast(1));
                switch h
                    case {S.ums(21),S.ums(22),S.ums(23)} %Change type of pinning: Central/Peripheral/External
                        switch h
                            case S.ums(21)
                                I.class.pinning.tab.Type{imgNbr}{pos}(subPos)=1;
                            case S.ums(22)
                                I.class.pinning.tab.Type{imgNbr}{pos}(subPos)=2;
                            case S.ums(23)
                                I.class.pinning.tab.Type{imgNbr}{pos}(subPos)=3;
                        end
                    case {S.ums(24),S.ums(25)} %Change the method to calculate the volume
                        switch h
                            case S.ums(24)
                                I.class.pinning.tab.volMethod{imgNbr}{pos}(subPos)=1;
                            case S.ums(25)
                                I.class.pinning.tab.volMethod{imgNbr}{pos}(subPos)=2;
                        end
                        [I.class.pinning.tab]=getPinnedDropVol(str2double(get(S.W_V2_H3_V2_T1_G_edit(5),'string')),I.img.type.S{1},I.img.features.pxList{'class'},I.class.pinning.tab);
                end
            end
            [I.img.features.pxList{'pinning'}]=transfoCalculatedShape(I.class.pinning.tab);
    end
    set(S.W_V1,'UserData',I);
    imgProcessing(S,0)
end

end


%==========================================================================
%====================== Additional functions ==============================
%==========================================================================

function []=initialisation(S)
I=get(S.W_V1,'UserData');

    % Active panels
% set(findall(S.W_V2_H1_V2,'-property','enable'),'enable','on')
% set(findall(S.Ws_V2s_H1s_V1,'-property','enable'),'enable','on')

    % Get images
dataNum=str2double(get(S.W_V2_H1_V2_V1_H_edit,'string'));
P_type=get(S.W_V2_H1_V1_T1_V2_H_pop(1),{'string','val'});
P_format=get(S.W_V2_H1_V1_T1_V2_H_pop(2),{'string','val'});


% switch P_type{1}{P_type{2}} % Need to be done properly when move in the list
%     case P_type{1}{1}
%         [I.img.type.Raw]=getImgRaw(join([get(S.W_V2_H1_V1_T1_V1_H_edit(1),'string'),get(S.W_V2_H1_V2_V2_H_edit,'string')]),P_format{1}{P_format{2}});
%     case P_type{1}{2}
%         [I.img.type.Raw]=getMovRaw(join([get(S.W_V2_H1_V1_T1_V1_H_edit(1),'string'),get(S.W_V2_H1_V2_V2_H_edit,'string')]),P_format{1}{P_format{2}});
% end


switch P_type{1}{P_type{2}} 
    case P_type{1}{1}
        [I.img.type.Raw]=getImgRaw(join([get(S.W_V2_H1_V1_T1_V1_H_edit(1),'string'),get(S.W_V2_H1_V1_T1_V1_H_edit(2),'string')]),P_format{1}{P_format{2}});
    case P_type{1}{2}
        [I.img.type.Raw]=getMovRaw(join([get(S.W_V2_H1_V1_T1_V1_H_edit(1),'string'),get(S.W_V2_H1_V1_T1_V1_H_edit(2),'string')]),P_format{1}{P_format{2}});
end

% switch I.file.tab.full.AddInfo{dataNum}.type % strcmp(I.file.tab.full{dataNum}.AddInfo.type,P{1})   
%     case P{1}{1}
%         [I.img.type.Raw]=getImgRaw(join([get(S.W_V2_H1_V1_T1_V1_H_edit(1),'string'),I.file.tab.full.Path{dataNum}]),I.file.tab.full.AddInfo{dataNum}.format);
%     case P{1}{2}
%         [I.img.type.Raw]=getMovRaw(join([get(S.W_V2_H1_V1_T1_V1_H_edit(1),'string'),I.file.tab.full.Path{dataNum}]),I.file.tab.full.AddInfo{dataNum}.format);
% end

    % Data info
I.img.info.nbr=length(I.img.type.Raw);
I.img.info.size=size(I.img.type.Raw{1});
I.img.display.nbr=[1,1,1];
I.img.display.type=1; %1:Frames, 2:Single image, 3: Pinning images
I.img.display.analysisLvl=1;

% if isempty(I.file.tab.full.Path{dataNum})==0
%     set(S.W_V2_H1_V2_V2_H_edit,'string',I.file.tab.full.Path{dataNum}) 
%     set(S.W_V2_H1_V2_V3_H_edit(1),'string',I.file.tab.full.Surface{dataNum})
%     set(S.W_V2_H1_V2_V3_H_edit(2),'string',I.file.tab.full.Liquid{dataNum})
%     set(S.W_V2_H1_V2_V4_H_edit(1),'string',0)
%     set(S.W_V2_H1_V2_V4_H_edit(2),'string',0)
% end
    
    % Img selection    
set(S.W_V2_H2_V1_V_V1_H_edit(1),'string',1)
set(S.W_V2_H2_V1_V_V1_H_slide,'value',str2double(get(S.W_V2_H2_V1_V_V1_H_edit(1),'string')))
set(S.W_V2_H2_V1_V_V1_H_edit(2),'string',I.img.info.nbr)
set(S.W_V2_H2_V1_V_V1_H_slide,'max',str2double(get(S.W_V2_H2_V1_V_V1_H_edit(2),'string')))

set(S.W_V1,'UserData',I);

showOrHideButtons(S,1:6,0);
[S]=initialPara(S,[1:10]);
imgProcessing(S,1)
end
function [S]=initialPara(S,steps2ini)
I=get(S.W_V1,'UserData');

for i=1:length(steps2ini)
    switch steps2ini(i)
        case 1 %Analysis
            %set(S.W_V2_H2_V1_V_V1_H_pop,'String',I.img.options{1},'Value',1)
            set(S.W_V2_H2_V2_H_pop,'val',1)
            set(S.W_V2_H2_V2_H_edit,'string',1)           
        case 2 %Zoom            
            set(S.W_V2_H2_V3_T1_G_edit(1),'string',1)
            set(S.W_V2_H2_V3_T1_G_edit(2),'string',I.img.info.size(2))
            set(S.W_V2_H2_V3_T1_G_edit(3),'string',1)
            set(S.W_V2_H2_V3_T1_G_edit(4),'string',I.img.info.size(1))
            I.img.modi.enable{'zoom'}=0;
            I.img.modi.zone{'zoom'}=[1,I.img.info.size(2),1,I.img.info.size(1)];           
        case 3 %Reset image: Clear            
            I.img.modi.enable{'clear'}=0;
            I.img.modi.zone{'clear'}=[];          
        case 4 %Reset image: Crop            
            I.img.modi.enable{'crop'}=0;

            set(S.W_V2_H2_V3_T1_G_edit(1),'string',1)
            set(S.W_V2_H2_V3_T1_G_edit(2),'string',I.img.info.size(2))
            set(S.W_V2_H2_V3_T1_G_edit(3),'string',1)
            set(S.W_V2_H2_V3_T1_G_edit(4),'string',I.img.info.size(1))
            
            set(S.W_V1,'UserData',I);
            [S]=cropImgPara(S);
            I=get(S.W_V1,'UserData');
            
        case 5 %Background            
            set(S.W_V2_H2_V3_T3_H_edit,'string',0)
        case 6 %Limit           
            set(S.W_V2_H2_V3_T4_H2_V_radio(1),'Value',1)
            set(S.W_V2_H2_V3_T4_H3_V1_H_edit(1),'string',0)
            set(S.W_V2_H2_V3_T4_H3_V1_H_edit(2),'string',0)
            set(S.W_V2_H2_V3_T4_H3_V2_H_edit,'string',0)
            
        case 7 %Binarisation
            set(S.W_V2_H2_V3_T6_G_edit(1),'string',0)
            set(S.W_V2_H2_V3_T6_G_edit(2),'string',5)
            set(S.W_V2_H2_V3_T6_G_edit(3),'string',0)     
            set(S.W_V2_H2_V3_T6_G_check(1),'value',1)
            set(S.W_V2_H2_V3_T6_G_check(2),'value',0)
            set(S.W_V2_H2_V3_T7_G_edit(1),'string',0)
            set(S.W_V2_H2_V3_T7_G_edit(2),'string',255)
            set(S.W_V2_H2_V3_T7_G_edit(3),'string',5)
        case 8 %Tracking
            I.track.new=[];
            I.track.new2=[];
            I.track.drops=[];
            I.track.mod=I.track.mty;
        case 9 %Contact angle
            set(S.W_V2_H2_V3_T8_G_edit(1),'string',10)
            set(S.W_V2_H2_V3_T8_G_edit(2),'string',0)
            set(S.W_V2_H2_V3_T8_G_edit(3),'string',0.7)
            set(S.W_V2_H2_V3_T8_G_edit(4),'string',2)
        case 10 %Observations
    end   
    
%     I.img.features.positions{'addLines'}=[];
%     I.img.features.pxList{'addLines'}=[];
% I.img.features=I.img.features0;
end

set(S.W_V1,'UserData',I);
end

function []=imgProcessing(S,c) %Action the different processes
%c: requested level (c=0 if no image processing involved)
I=get(S.W_V1,'UserData');

%Processes
%   %Apply the right processes
[a]=I.img.display.analysisLvl; %available images level
b=get(S.W_V2_H2_V2_H_pop,'val'); %b: analysis level
if c>0 % Images depend on the most advanced process
    if a<=b % Need to run some processes
        if a<c %Run additional process(es)
            pr=a+1:c; 
        else
            pr=c:a; %if c==a: update the most advanced process; if c<a: update processes from the modified level to the most advanced one
        end
        for k=pr
            switch k
                case 1 % Image dimension
                    [I.img.type.R]=I.img.type.Raw(1:I.img.info.nbr,1);
                    %   % Clear
                    if I.img.modi.enable{'clear'}
                        [I.img.type.R]=getImgsCleared(I.img.type.R,I.img.modi.zone{'clear'});
                    end
                    %   % Crop
                    if I.img.modi.enable{'crop'}
                        [I.img.type.R]=getImgsCropped(I.img.type.R,I.modi.crop.posi);
                    end
                case 2 % Filter
                    [I.img.type.M,I.img.type.Mu]=getImgsSplitted(I.img.type.R,str2double(get(S.W_V2_H1_V2_V5_H_edit,'string')),I.modi.crop.posi);
                    if get(S.W_V2_H2_V3_T2_G_check(1),'value')==1
                        I.img.type.M=getImgsFiltMed(I.img.type.M);
                         I.img.type.Mu=getImgsFiltMed(I.img.type.Mu);
                    end
                    if get(S.W_V2_H2_V3_T2_G_check(2),'value')==1
                        I.img.type.M=getImgsSharp(I.img.type.M);
                        I.img.type.Mu=getImgsSharp(I.img.type.Mu);
                    end
                case 3 % Background substraction
                    if str2double(get(S.W_V2_H2_V3_T3_H_edit,'string'))==0
                        [n_base]=getNbrBackground(I.img.type.M);
                        set(S.W_V2_H2_V3_T3_H_edit,'string',n_base);
                    end
                    [I.img.type.BG{1}]=getImgBackground(I.img.type.M,str2double(get(S.W_V2_H2_V3_T3_H_edit,'string')));
                    [I.img.type.E]=getImgsEnhanced(I.img.type.M,I.img.type.BG{1});
                    if get(S.W_V2_H1_V2_V5_H_pop,'value')==2
                        [I.img.type.BGu{1}]=getImgBackground(I.img.type.Mu,str2double(get(S.W_V2_H2_V3_T3_H_edit,'string')));
                        [I.img.type.Eu]=getImgsEnhanced(I.img.type.Mu,I.img.type.BGu{1});
                    end
                case 4 % Surface limit
                    %   % Line
                    if get(S.W_V2_H2_V3_T4_H2_V_radio(1),'Value')==1
                        if str2double(get(S.W_V2_H2_V3_T4_H3_V1_H_edit(1),'string'))==0
                            greyLim=uint8(graythresh(I.img.type.BG{1})*255); %Limite: 1 to 255
                            [ImgS,~]=getSurfMaskFromBackground(I.img.type.BG{1},greyLim); %figure, imshow(ImgS)
                            yLim=find(diff(sum(~ImgS,2)>(size(ImgS,2)*0.75),1,1)==1,1,'last');
                            if isempty(yLim)
                                yLim=size(ImgS,1);
                            end
                            set(S.W_V2_H2_V3_T4_H3_V1_H_edit(1),'string',yLim)
                        end
                        [I.img.type.S{1}]=getSurfMaskFromLine(I.img.type.BG{1},[str2double(get(S.W_V2_H2_V3_T4_H3_V1_H_edit(1),'string')),str2double(get(S.W_V2_H2_V3_T4_H3_V1_H_edit(2),'string'))]);
                    %   % Background
                    else 
                        greyLim=str2double(get(S.W_V2_H2_V3_T4_H3_V2_H_edit,'string'));
                        if greyLim==0
                            greyLim=uint8(graythresh(I.img.type.BG{1})*255); %Limite: 1 to 255
                        end
                        [I.img.type.S{1},greyLim]=getSurfMaskFromBackground(I.img.type.BG{1},greyLim);
                        set(S.W_V2_H2_V3_T4_H3_V2_H_edit,'string',greyLim);
                    end
                    [I.img.features.pxList{'limitSurface'}]=getSurfLimit(I.img.type.S{1},1); %I.img.type.SL
                    if get(S.W_V2_H1_V2_V5_H_pop,'value')==2
                        if get(S.W_V2_H2_V3_T5_G_pop,'value')==1
                            I.img.type.Su{1}=true(size(I.img.type.BGu{1}));
                        else
                            greyThreshold=str2double(get(S.W_V2_H2_V3_T5_G_edit,'string'));
                            [I.img.type.Su{1},greyThreshold]=getUnderneathFocus(I.img.type.BGu{1},greyThreshold);
                            set(S.W_V2_H2_V3_T5_G_edit,'string',greyThreshold)
                        end
                    end
                case 5 % Binarisation: + Binary
                    if str2double(get(S.W_V2_H2_V3_T6_G_edit(1),'string'))==0
                        [greyThreshold]=getImgsBinarisedThreshold(I.img.type.E,I.img.type.S{1});
                        set(S.W_V2_H2_V3_T6_G_edit(1),'string',greyThreshold)
                    end
                    [I.img.type.B]=getImgsBinarised(I.img.type.E,I.img.type.S{1},str2double(get(S.W_V2_H2_V3_T6_G_edit(1),'string')));
                    [I.img.type.B]=getImgsBinFiltered(I.img.type.B,I.img.type.S{1},str2double(get(S.W_V2_H2_V3_T6_G_edit(3),'string')),str2double(get(S.W_V2_H2_V3_T6_G_edit(2),'string')));
                    [I.img.type.B]=getImgsBinFilled(I.img.type.B,I.img.type.S{1},get(S.W_V2_H2_V3_T6_G_check(1),'value'),get(S.W_V2_H2_V3_T6_G_check(2),'value'));
                    [I.track.ori,I.img.type.L]=getObjProp(I.img.type.B,I.img.type.S{1});              
                    if get(S.W_V2_H1_V2_V5_H_pop,'value')==2
                        if str2double(get(S.W_V2_H2_V3_T7_G_edit(1),'string'))==0
                            [darkGreyThreshold]=getUnderImgsBinarisedDarkThreshold(I.img.type.Eu,I.img.type.Su{1});
                            set(S.W_V2_H2_V3_T7_G_edit(1),'string',darkGreyThreshold)
                        end
                        if str2double(get(S.W_V2_H2_V3_T7_G_edit(2),'string'))==255
                            [brightGreyThreshold]=getUnderImgsBinarisedBrightThreshold(I.img.type.Eu,I.img.type.Su{1},str2double(get(S.W_V2_H2_V3_T7_G_edit(1),'string')));
                            set(S.W_V2_H2_V3_T7_G_edit(2),'string',brightGreyThreshold)
                        end
                        [I.img.type.Bu]=getUnderImgsBinarised(I.img.type.Eu,I.img.type.Su{1},get(S.W_V2_H2_V3_T7_G_pop,'value'),str2double(get(S.W_V2_H2_V3_T7_G_edit(1),'string')),str2double(get(S.W_V2_H2_V3_T7_G_edit(2),'string')));
                        [I.img.type.Bu]=getImgsBinFiltered(I.img.type.Bu,I.img.type.Su{1},0,str2double(get(S.W_V2_H2_V3_T7_G_edit(3),'string')));
                        %[I.img.type.Bu]=getUnderImgsBinFilled(I.img.type.Bu,Su,1,0);
                    end
                case 6 % Main tracking
                    [I.track.new,I.track.new2,I.track.drops,I.track.mod,I.track.frames]=getTracking(I.track.ori,I.track.new,I.track.new2,I.track.drops,I.track.mod,I.img.type.S{1},1,I.track.frames);
                    [I.img.features.positions{'centroid'},I.img.features.positions{'boundingBox'},I.img.features.positions{'tracking'}]=getInfo2draw(I.track.new2,I.track.drops);                   
                    [I.img.features.pxList{'drops'}]=transfoDrops2PixelList(I.track.drops,I.track.new2);
                    [I.img.features.pxList{'centroid'}]=transfoCoord2PixelList(I.img.type.M,'Point',I.img.features.positions{'centroid'},I.img.features.shape{'centroid'});
                    [I.img.features.pxList{'boundingBox'}]=transfoCoord2PixelList(I.img.type.M,'Box',I.img.features.positions{'boundingBox'},I.img.features.shape{'boundingBox'});
                    [I.img.features.pxList{'tracking'}]=transfoCoord2PixelList(I.img.type.M,'Tracking',I.img.features.positions{'tracking'},I.img.features.shape{'tracking'});
                case 7 % Main drop info
                    [impactFrame,impactVel,impactDia,checkVel,checkDia]=getImpactDropVD(I.track.drops(1,:),I.track.new2);
                    set(S.W_V2_H3_V2_T1_G_edit(7),'string',impactFrame)
                    set(S.W_V2_H3_V2_T1_G_edit(1),'string',impactVel(2))
                    set(S.W_V2_H3_V2_T1_G_edit(3),'string',impactVel(2)*(0.001/str2double(get(S.W_V2_H1_V2_V4_H_edit(2),'string')))*str2double(get(S.W_V2_H1_V2_V4_H_edit(1),'string')))
                    set(S.W_V2_H3_V2_T1_G_edit(2),'string',impactVel(1))
                    set(S.W_V2_H3_V2_T1_G_edit(4),'string',impactVel(1)*(0.001/str2double(get(S.W_V2_H1_V2_V4_H_edit(2),'string')))*str2double(get(S.W_V2_H1_V2_V4_H_edit(1),'string')))
                    set(S.W_V2_H3_V2_T1_G_edit(5),'string',impactDia)
                    set(S.W_V2_H3_V2_T1_G_edit(6),'string',impactDia*(1000/str2double(get(S.W_V2_H1_V2_V4_H_edit(2),'string'))))
                    set(S.W_V2_H3_V2_T1_G_push(1),'UserData',checkVel)
                    set(S.W_V2_H3_V2_T1_G_push(2),'UserData',checkDia)
                    
                    [I.obs.mainDrop,DmaxFrame]=getMainDropObs(I.track.drops(1,:),I.track.new2,I.img.type.S{1},str2double(get(S.W_V2_H3_V2_T1_G_edit(7),'string')));
                    [I.obs.mainDrop]=getContactAngle(I.obs.mainDrop,I.img.type.S{1},I.img.type.E,str2double(get(S.W_V2_H2_V3_T8_G_edit(1),'string')),...
                         get(S.W_V2_H2_V3_T8_G_pop,'val'),str2double(get(S.W_V2_H2_V3_T6_G_edit(1),'string')),...
                         str2double(get(S.W_V2_H2_V3_T8_G_edit(2),'string')),str2double(get(S.W_V2_H2_V3_T8_G_edit(3),'string')),str2double(get(S.W_V2_H2_V3_T8_G_edit(4),'string')));
                    set(S.W_V2_H3_V2_T2_G_edit(1),'string',I.obs.mainDrop.wet(I.obs.mainDrop.Frame==DmaxFrame(1))/impactDia)
                    set(S.W_V2_H3_V2_T2_G_edit(2),'string',I.obs.mainDrop.edge(I.obs.mainDrop.Frame==DmaxFrame(2))/impactDia)
                    set(S.W_V2_H3_V2_T2_G_edit(3),'string',DmaxFrame(1))
                    set(S.W_V2_H3_V2_T2_G_edit(4),'string',DmaxFrame(2))                 
                    [I.img.features.positions{'contactAngle'}]=getAng2draw(I.obs.mainDrop,I.img.type.B,I.img.features.shape{'contactAngle'}(2));
                    [I.img.features.pxList{'contactAngle'}]=transfoCoord2PixelList(I.img.type.M,'Line',I.img.features.positions{'contactAngle'},I.img.features.shape{'contactAngle'}(1));    
                    if get(S.W_V2_H1_V2_V5_H_pop,'value')==2
                        [I.obs.mainDrop,I.img.features.pxList{'underneath'}]=getMainDropUnderObs(I.obs.mainDrop,I.img.type.Bu,get(S.W_V2_H2_V3_T9_G_check,'value'),str2double(get(S.W_V2_H2_V3_T9_G_edit,'string')));
                    end
                case 8 % Full tracking: + Pinning
                    [I.track.new,I.track.new2,I.track.drops,I.track.mod,I.track.frames]=getTracking(I.track.ori,I.track.new,I.track.new2,I.track.drops,I.track.mod,I.img.type.S{1},2,I.track.frames);
                    [I.img.features.positions{'centroid'},I.img.features.positions{'boundingBox'},I.img.features.positions{'tracking'}]=getInfo2draw(I.track.new2,I.track.drops);
                    [I.img.features.pxList{'tracking'}]=transfoCoord2PixelList(I.img.type.M,'Tracking',I.img.features.positions{'tracking'},I.img.features.shape{'tracking'});
                    [I.img.features.pxList{'drops'}]=transfoDrops2PixelList(I.track.drops,I.track.new);
                    [I.img.features.pxList{'centroid'}]=transfoCoord2PixelList(I.img.type.M,'Point',I.img.features.positions{'centroid'},I.img.features.shape{'centroid'});
                    [I.img.features.pxList{'tracking'}]=transfoCoord2PixelList(I.img.type.M,'Tracking',I.img.features.positions{'tracking'},I.img.features.shape{'tracking'});    
                case 9 % Classification
                    [I.img.features.pxList{'class'}]=getImgsBinEdge(I.img.type.B,I.img.type.L,I.track.new,I.track.drops);
                    [I.class.drops.tab]=getDropClass(I.track.new2,I.track.drops,I.obs.mainDrop,str2double(get(S.W_V2_H3_V2_T2_G_edit(3:4),'string')),I.class.drops.tab);                    
                case 10 % Pinning
                    [I.class.pinning.tab]=getLastFramePinning(I.track.new2,I.track.drops,I.obs.mainDrop,I.class.drops.tab,I.class.pinning.tab);
                    [I.class.pinning.tab]=getPinnedDropLimits(I.img.type.S{1},I.img.features.pxList{'class'},I.class.pinning.tab);
                    [I.class.pinning.tab]=getPinnedDropClass(I.track.new2,I.track.drops,I.obs.mainDrop,str2double(get(S.W_V2_H3_V2_T2_G_edit(3),'string')),I.class.pinning.tab);
                    [I.class.pinning.tab]=getPinnedDropVolMeth(I.img.type.S{1},I.img.features.pxList{'class'},I.class.pinning.tab);
                    [I.class.pinning.tab]=getPinnedDropVol(str2double(get(S.W_V2_H3_V2_T1_G_edit(5),'string')),I.img.type.S{1},I.img.features.pxList{'class'},I.class.pinning.tab);
                    [I.img.type.P]=getImgPinning(I.img.type.S{1},I.track.new2,I.track.drops,I.class.pinning.tab);
                    [I.img.features.pxList{'pinning'}]=transfoCalculatedShape(I.class.pinning.tab);
            end
        end
        %Update the analysis level
        b=max([a,c]);
        I.img.display.analysisLvl=b;
        set(S.W_V2_H2_V2_H_pop,'val',b);
        set(S.W_V2_H2_V2_H_edit,'string',b)
    end
%   %Display the adapted type of image and features 

    switch b
        case 1
            imgOpt=1;
            imgType='Raw images';
            featureLvl=1;
        case 2
            if (get(S.W_V2_H1_V2_V5_H_pop,'value') ==1)
                imgOpt=[1,2];
            else
                imgOpt=[1:3];
            end
            imgType='Modified images';
            featureLvl=1;
        case 3
            if (get(S.W_V2_H1_V2_V5_H_pop,'value') ==1)
                imgOpt=[1,2,4,6];
            else
                imgOpt=[1:7];
            end
            imgType='Enhanced images';
            featureLvl=1;
        case 4
            if (get(S.W_V2_H1_V2_V5_H_pop,'value') ==1)
                imgOpt=[1,2,4,6,8];
            else
                imgOpt=[1:9];
            end
            imgType='Enhanced images';
            featureLvl=2;
        case 5
            if (get(S.W_V2_H1_V2_V5_H_pop,'value') ==1)
                imgOpt=[1,2,4,6,8,10];
            else
                imgOpt=[1:11];
            end
            imgType='Binary images';
            featureLvl=3;
        case 6
             if (get(S.W_V2_H1_V2_V5_H_pop,'value') ==1)
                imgOpt=[1,2,4,6,8,10];
            else
                imgOpt=[1:11];
            end
            imgType='Binary images';
            featureLvl=3;
        case 7
            if (get(S.W_V2_H1_V2_V5_H_pop,'value') ==1)
                imgOpt=[1,2,4,6,8,10];
            else
                imgOpt=[1:11];
            end
            imgType='Binary images';
            featureLvl=4;
        case 8
             if (get(S.W_V2_H1_V2_V5_H_pop,'value') ==1)
                imgOpt=[1,2,4,6,8,10];
            else
                imgOpt=[1:11];
            end
            imgType='Modified images';
            featureLvl=4;
        case 9
            if (get(S.W_V2_H1_V2_V5_H_pop,'value') ==1)
                imgOpt=[1,2,4,6,8,10];
            else
                imgOpt=[1:11];
            end
            imgType='Modified images';
            featureLvl=5;
        case 10
            if (get(S.W_V2_H1_V2_V5_H_pop,'value') ==1)
                imgOpt=[1,2,4,6,8,10,12];
            else
                imgOpt=[1:12];
            end
            imgType='Pinned drops';
            featureLvl=5;
    end
     
    
    set(S.W_V2_H2_V1_V_V1_H_pop,'String',I.img.options(imgOpt),'Value',find(strcmp(imgType,I.img.options(imgOpt))))
    switch featureLvl
        case 1
            Btn2show=[];
            Btn2hide=[1:7];
        case 2
            Btn2show=1;
            Btn2hide=[2:7];
        case 3
            Btn2show=[2:5];
            Btn2hide=[6:7];
        case 4
            Btn2show=6;
            Btn2hide=7;
        case 5
            Btn2show=7;
            Btn2hide=[];
    end 
    for k=1:length(S.W_V2_H2_V1_V_V2_T1_H_toggle)
        if ismember(k,Btn2show)
            if strcmp(get(S.W_V2_H2_V1_V_V2_T1_H_toggle(k),'Enable'),'off')
                set(S.W_V2_H2_V1_V_V2_T1_H_toggle(k),'Value',1)
            end
            set(S.W_V2_H2_V1_V_V2_T1_H_toggle(k),'Enable','on')
        end
        if ismember(k,Btn2hide)
            set(S.W_V2_H2_V1_V_V2_T1_H_toggle(k),'Value',0)
            set(S.W_V2_H2_V1_V_V2_T1_H_toggle(k),'Enable','off')
        end
    end  
end

%Delete info 
for k=[b:10]
    switch k
        case 1
            I.img.type.M=cell(1,1);
        case 2
            I.img.type.BG=cell(1,1);
            I.img.type.E=cell(1,1);
        case 3
            I.img.type.S=cell(1,1);
            I.img.features.positions{'limitSurface'}=[];
            I.img.features.pxList{'limitSurface'}=[];
            I.img.type.Su=cell(1,1);
        case 4
            I.img.type.B=cell(1,1);
            I.track.ori=cell(1,1);
            I.img.type.L=cell(1,1);
        case 5
            I.track.mod=I.track.mty;
            I.track.new=[];
            I.track.new2=[];
            I.track.drops=[];
            I.img.features.positions{'centroid'}=[];
            I.img.features.pxList{'centroid'}=[];
            I.img.features.positions{'boundingBox'}=[];
            I.img.features.pxList{'boundingBox'}=[];
            I.img.features.positions{'tracking'}=[];
            I.img.features.pxList{'tracking'}=[];
            I.img.features.positions{'drops'}=[];
            I.img.features.pxList{'drops'}=[];
            I.img.features.pxListUnder{'drops'}=[];
        case 6 
            I.obs.mainDrop=[];
            I.img.features.positions{'contactAngle'}=[];
            I.img.features.pxList{'contactAngle'}=[];
            %delete I.track.mod that implies first drop?
        case 7
            I.class.pinning.tab=I.class.drops.tab0;
        case 8
            I.img.features.pxList{'class'}=[];
        case 9
            I.img.display.nbr(3)=1;  
            I.img.type.P=cell(1,1);
            I.class.pinning.tab=I.class.pinning.tab0;
            I.img.features.pxList{'pinning'}=[];
        case 10
            %nothing
    end
end


% Choose the type of image
   
P=get(S.W_V2_H2_V1_V_V1_H_pop,{'string','val'});  % Get the users choice.
switch P{1}{P{2},:}
    case 'Raw images'
        I.img.type.img2show=I.img.type.R;
        I.img.display.type=1;
        I.img.view=1;
    case 'Modified images'
        I.img.type.img2show=I.img.type.M;
        I.img.display.type=1;
        I.img.view=1;
    case 'Modified images 2'
        I.img.type.img2show=I.img.type.Mu;
        I.img.display.type=1;
        I.img.view=2;
    case 'Background'
        I.img.type.img2show=I.img.type.BG;
        I.img.display.type=2;
        I.img.view=1;
    case 'Background 2'
        I.img.type.img2show=I.img.type.BGu;
        I.img.display.type=2;
        I.img.view=2;
    case 'Enhanced images'
        I.img.type.img2show=I.img.type.E;
        I.img.display.type=1;
        I.img.view=1;
    case 'Enhanced images 2'
        I.img.type.img2show=I.img.type.Eu;
        I.img.display.type=1;
        I.img.view=2;
    case 'Binary surface'
        I.img.type.img2show=I.img.type.S;
        I.img.display.type=2;
        I.img.view=1;
    case 'Binary surface 2'
        I.img.type.img2show=I.img.type.Su;
        I.img.display.type=2;
        I.img.view=2;
    case 'Binary images'
        I.img.type.img2show=I.img.type.B;
        I.img.display.type=1; 
        I.img.view=1;
    case 'Binary images 2'
        I.img.type.img2show=I.img.type.Bu;
        I.img.display.type=1; 
        I.img.view=2;
    case 'Pinned drops'
        I.img.type.img2show=I.img.type.P;
        I.img.display.type=3;
        I.img.view=1;
end


% Right clic options
switch I.img.display.type
    case 1
        if b<6
            [S]=managePointerMenue(S,'Image');
        elseif b<9
            [S]=managePointerMenue(S,'Tracking');
        elseif b==9
            [S]=managePointerMenue(S,'Class');
        else
            [S]=managePointerMenue(S,'Pinning');
        end
    case 2
        [S]=managePointerMenue(S,'Base');
    case 3
        [S]=managePointerMenue(S,'Pinning2');
end
    
set(S.W_V1,'UserData',I);

% Draw features
[S]=drawOnImgs(S);

% Display
setImgNbr(S)

assignin('base','S',S) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
assignin('base','I',I) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end 

function [S]=drawOnImgs(S)
I=get(S.W_V1,'UserData');

I.img.type.img2show=getImgsRGB(I.img.type.img2show);
if get(S.W_V2_H2_V1_V_V1_H_pop,'Value')>1
    if I.img.view==1
        if get(S.W_V2_H2_V1_V_V2_T1_H_toggle(1),'Value')==1 %Draw surface limit
            [I.img.type.img2show]=drawFeaturesOnRGB(I.img.type.img2show,I.img.features.pxList{'limitSurface'},I.img.features.color{'limitSurface'});
        end
        
        if I.img.display.type==1
            %Drops
            if get(S.W_V2_H2_V1_V_V2_T1_H_toggle(5),'Value')==1
                [I.img.type.img2show]=drawFeaturesOnRGB(I.img.type.img2show,I.img.features.pxList{'drops'},I.img.features.color{'drops'});
            end
            %Centroid
            if get(S.W_V2_H2_V1_V_V2_T1_H_toggle(2),'Value')==1
                [I.img.type.img2show]=drawFeaturesOnRGB(I.img.type.img2show,I.img.features.pxList{'centroid'},I.img.features.color{'centroid'});
            end
            %Bounding box
            if get(S.W_V2_H2_V1_V_V2_T1_H_toggle(3),'Value')==1
                [I.img.type.img2show]=drawFeaturesOnRGB(I.img.type.img2show,I.img.features.pxList{'boundingBox'},I.img.features.color{'boundingBox'});
            end
            %Class
            if get(S.W_V2_H2_V1_V_V2_T1_H_toggle(7),'Value')==1
                [classColor]=transfoClass2Color(I.img.features.color{'class'},I.class.drops.tab);
                [I.img.type.img2show]=drawFeaturesOnRGB(I.img.type.img2show,I.img.features.pxList{'class'},classColor);
            end
            %Contact Angle
            if get(S.W_V2_H2_V1_V_V2_T1_H_toggle(6),'Value')==1
                [I.img.type.img2show]=drawFeaturesOnRGB(I.img.type.img2show,I.img.features.pxList{'contactAngle'},I.img.features.color{'contactAngle'});
            end
            %Tracking
            if get(S.W_V2_H2_V1_V_V2_T1_H_toggle(4),'Value')==1
                [I.img.type.img2show]=drawFeaturesOnRGB(I.img.type.img2show,I.img.features.pxList{'tracking'},I.img.features.color{'tracking'});
            end
            
        elseif I.img.display.type==3
            [I.img.type.img2show]=drawFeaturesOnRGB(I.img.type.img2show,I.img.features.pxList{'pinning'},I.img.features.color{'pinning'});
        end
    else
        if I.img.display.type==1
            if get(S.W_V2_H2_V1_V_V2_T1_H_toggle(6),'Value')==1
                [I.img.type.img2show]=drawFeaturesOnRGB(I.img.type.img2show,I.img.features.pxList{'underneath'},I.img.features.color{'underneath'});
            end
        end
    end
end
%Additional lines
if ~isempty(I.img.features.pxList{'addLines'})
    [I.img.type.img2show]=drawFeaturesOnRGB(I.img.type.img2show,I.img.features.pxList{'addLines'},I.img.features.color{'addLines'});
end

%Zoom
if I.img.modi.enable{'zoom'}
    [I.img.type.img2show]=getImgsCropped(I.img.type.img2show,I.img.modi.zone{'zoom'});
end

set(S.W_V1,'UserData',I);
end
function []=setImgNbr(S)
I=get(S.W_V1,'UserData');

%     I.img.display.nbr=[1,1,1];
% I.img.display.type=1; %1:Frames, 2:Single image, 3: Pinning images

imgNbr=I.img.display.nbr(I.img.display.type);
imshow(I.img.type.img2show{imgNbr,1},'Parent',S.axMain);

set(S.W_V2_H2_V1_V_V1_H_edit(1),'string',num2str(imgNbr)) %back in intenger
set(S.W_V2_H2_V1_V_V1_H_edit(2),'string',num2str(size(I.img.type.img2show,1)))
set(S.W_V2_H2_V1_V_V1_H_slide,'max',size(I.img.type.img2show,1))
set(S.W_V2_H2_V1_V_V1_H_slide,'value',imgNbr)

switch I.img.display.type
    case 1
        set(S.W_V2_H2_V1_V_V1_H_edit(1),'enable','on');
        set(S.W_V2_H2_V1_V_V1_H_edit(2),'enable','on');
        set(S.W_V2_H2_V1_V_V1_H_H_push(1),'enable','on');
        set(S.W_V2_H2_V1_V_V1_H_H_push(2),'enable','on');
        set(S.W_V2_H2_V1_V_V1_H_edit,'enable','on');
        set(S.W_V2_H2_V1_V_V1_H_slide,'enable','on');
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(1),'visible','on')
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(2),'visible','on')
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(3),'visible','on')
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(4),'visible','on')
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(5),'visible','on')
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(6),'visible','on')
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(7),'visible','on')
    case 2
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(1),'enable','on')
        set(S.W_V2_H2_V1_V_V1_H_edit(1),'enable','off');
        set(S.W_V2_H2_V1_V_V1_H_edit(2),'enable','off');
        set(S.W_V2_H2_V1_V_V1_H_H_push(1),'enable','off');
        set(S.W_V2_H2_V1_V_V1_H_H_push(2),'enable','off');
        set(S.W_V2_H2_V1_V_V1_H_edit,'enable','off');
        set(S.W_V2_H2_V1_V_V1_H_slide,'enable','off');
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(1),'visible','on')
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(2),'visible','off')
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(3),'visible','off')
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(4),'visible','off')
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(5),'visible','off')
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(6),'visible','off')
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(7),'visible','off')
    case 3
        set(S.W_V2_H2_V1_V_V1_H_edit(1),'enable','on');
        set(S.W_V2_H2_V1_V_V1_H_edit(2),'enable','off');
        set(S.W_V2_H2_V1_V_V1_H_H_push(1),'enable','on');
        set(S.W_V2_H2_V1_V_V1_H_H_push(2),'enable','on');
        set(S.W_V2_H2_V1_V_V1_H_edit,'enable','on');
        set(S.W_V2_H2_V1_V_V1_H_slide,'enable','on');
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(1),'visible','on')
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(2),'visible','off')
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(3),'visible','off')
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(4),'visible','off')
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(5),'visible','off')
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(6),'visible','off')
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(7),'visible','off')
end

    
%imgNbr=min(length(I.img.type.img2show),str2double(get(S.W_V2_H2_V1_V_V1_H_edit(1),'string')));


set(S.axMain.Children,'HitTest','on')
set(S.axMain.Children,'ButtonDownFcn',{@bdfcn,S},'uicontextmenu',S.cm)

assignin('base','S',S) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
function []=pointerInfo(S)

ptM=[str2double(get(S.W_V2_H3_V1_V2_G_edit(1),'string')),str2double(get(S.W_V2_H3_V1_V2_G_edit(3),'string'));...
    str2double(get(S.W_V2_H3_V1_V2_G_edit(2),'string')),str2double(get(S.W_V2_H3_V1_V2_G_edit(4),'string'))];
dx=abs(ptM(1,1)-ptM(2,1));
dy=abs(ptM(1,2)-ptM(2,2));
dist(1)=sqrt(dx^2+dy^2);
dist(2)=dist(1)*1000/str2double(get(S.W_V2_H1_V2_V4_H_edit(2),'string'));
ang=atand(dy/dx);

set(S.W_V2_H3_V1_V2_G_text(1),'string',dx)
set(S.W_V2_H3_V1_V2_G_text(2),'string',dy)
set(S.W_V2_H3_V1_V2_G_text(3),'string',dist(1))
set(S.W_V2_H3_V1_V2_G_text(4),'string',dist(2))
set(S.W_V2_H3_V1_V2_G_text(5),'string',ang)

end

function [S]=cropImgPara(S) % Crop action
I=get(S.W_V1,'UserData');

if str2double(get(S.W_V2_H2_V2_H_edit,'string'))>2
    lm=str2double(get(S.W_V2_H2_V3_T4_H3_V1_H_edit(1),'string'))-(str2double(get(S.W_V2_H2_V3_T1_G_edit(3),'string'))-I.modi.crop.posi(3));
    lmMax=(str2double(get(S.W_V2_H2_V3_T1_G_edit(4),'string'))-str2double(get(S.W_V2_H2_V3_T1_G_edit(3),'string')))+1;
    if lm>lmMax
        lm=lmMax;
    end
    set(S.W_V2_H2_V3_T4_H3_V1_H_edit(1),'string',lm)
end

I.modi.crop.posi=[str2double(get(S.W_V2_H2_V3_T1_G_edit(1),'string')),...
            str2double(get(S.W_V2_H2_V3_T1_G_edit(2),'string')),...
            str2double(get(S.W_V2_H2_V3_T1_G_edit(3),'string')),...
            str2double(get(S.W_V2_H2_V3_T1_G_edit(4),'string'))];
               
set(S.W_V2_H3_V1_V2_G_edit(1),'string',1)
set(S.W_V2_H3_V1_V2_G_edit(2),'string',I.modi.crop.posi(2)-I.modi.crop.posi(1)+1)
set(S.W_V2_H3_V1_V2_G_edit(3),'string',1)
set(S.W_V2_H3_V1_V2_G_edit(4),'string',I.modi.crop.posi(4)-I.modi.crop.posi(3)+1)

set(S.W_V1,'UserData',I);                
end


function []=showOrHideButtons(S,vect,on)
str={'on','off'};
val=[1,0];
if on==0
    str=flip(str);
    val=flip(val);
end
for k=1:length(S.W_V2_H2_V1_V_V2_T1_H_toggle)
    if ismember(k,vect)
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(k),'Enable',str{1})
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(k),'Value',val(1))
    else
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(k),'Enable',str{2})
        set(S.W_V2_H2_V1_V_V2_T1_H_toggle(k),'Value',val(2))
    end
end
end

function [S]=managePointerMenue(S,opt)

k=[1,2];
switch opt
    case 'Base'
        %Nothing
    case 'Image'
        k=[k,3,4];
    case 'Tracking'
        k=[k,4,5,6];
    case 'Class'
        k=[k,5,7,8];
    case 'Pinning'
        k=[k,5,7,9];
    case 'Pinning2'
        k=[k,10:17];
end

for t=1:length(S.um)
    if ismember(t,k)
        set(S.um(t),'Parent',S.cm)
    else
        set(S.um(t),'Parent',S.cm0)
    end
end

end


function [cent,box,track]=getInfo2draw(r,d)

cent=cell(1,size(d,2));
box=cell(1,size(d,2));
track=cell(1,size(d,2));

CentPosXY=NaN(size(d,1),size(d,2),2);
for n=1:size(d,2)
    for m=1:size(d,1)
        if ~isnan(d(m,n))
            if d(m,n)>0
                c=r{n}(d(m,n)).Centroid;
                CentPosXY(m,n,:)=round(c);
            end
        end
    end
end

%Centroid 
for n=1:size(d,2)
    cent{n}=[cat(1,CentPosXY(:,n,1)),cat(1,CentPosXY(:,n,2))];
    cent{n}=cent{n}(~isnan(cent{n}(:,1)),:);
end

%Bouding box
for n=1:size(d,2)
    if d(1,n)>0
    BB=r{n}(d(1,n)).BoundingBox+[0.5 0.5 0 0];    
    box{n}=[BB(1),BB(2);...
        BB(1)+BB(3),BB(2);...
        BB(1)+BB(3),BB(2)+BB(4);...
        BB(1),BB(2)+BB(4)];
    else
        box{n}=[NaN,NaN];
    end
end

%Track
for m=1:size(d,1)
    track{1}=NaN(size(d,1),2);
    for n=2:size(d,2)
        if and(~isnan(CentPosXY(m,n-1,1)),~isnan(CentPosXY(m,n,1)))
            newVal=[CentPosXY(m,n,1),CentPosXY(m,n,2);CentPosXY(m,n-1,1),CentPosXY(m,n-1,2)];
        else
            newVal=[];
        end
        track{n}=cat(1,track{n},newVal,[NaN,NaN]);
    end   
end


end

function [ang]=getAng2draw(obsTab,imgsB,L)

obsArray=table2array(obsTab);
ang=cell(1,length(imgsB));
for n=1:length(imgsB)
    f=find(obsArray(:,1)==n,1);
    if isempty(f)
        ang{n}=[NaN,NaN];
    else
        ang{n}=NaN(5,2);
        ang{n}(1,:)=[obsArray(f,9),obsArray(f,11)];
        ang{n}(2,:)=ang{n}(1,:)+round(L*[-cosd(180-obsArray(f,13)),-sind(180-obsArray(f,13))]);                          
        ang{n}(4,:)=[obsArray(f,10),obsArray(f,12)];
        ang{n}(5,:)=ang{n}(4,:)+round(L*[cosd(180-obsArray(f,14)),-sind(180-obsArray(f,14))]);
    end
end

end

function [color]=transfoClass2Color(color0,classTab)
v=zeros(size(classTab,1),1);
for i=1:size(classTab,1)
    v(i)=find(classTab{i,classTab.Properties.VariableNames}==1);
end
color=color0(v,:);
end




function [ptVal]=getPointerVal(S)
I=get(S.W_V1,'UserData');

pointerOutput=round(get(S.axMain,'CurrentPoint')); %Position in image %[x,y]
ptVal=pointerOutput(1,1:2);

I_max=size(I.img.type.img2show{1}); %[ln;cl]
imgIN=[ptVal(1)<1,ptVal(1)>I_max(2),ptVal(2)<1,ptVal(2)>I_max(1)];
if sum(imgIN)>0
    ptVal=[0,0];
else
    ptVal=ptVal+[(I.img.modi.zone{'zoom'}(1)-1),(I.img.modi.zone{'zoom'}(3)-1)].*I.img.modi.enable{'zoom'};
end

end

function [ptLast]=getPointerLastClic(S)

ptNbr=get(S.W_V2_H3_V1_V1_H_text(1),'UserData');
switch ptNbr
    case 2 % 2 when 1 was the the last selection
        ptLast(1)=str2double(get(S.W_V2_H3_V1_V2_G_edit(1),'string'));
        ptLast(2)=str2double(get(S.W_V2_H3_V1_V2_G_edit(3),'string'));
    case 1 % 1 when 2 was the the last selection
        ptLast(1)=str2double(get(S.W_V2_H3_V1_V2_G_edit(2),'string'));
        ptLast(2)=str2double(get(S.W_V2_H3_V1_V2_G_edit(4),'string'));
end

end


function [ptZone]=getPointerZone(S,onCrop)

I=get(S.W_V1,'UserData');

I.img.modi.enable{'clear'}=1;

x=[str2double(get(S.W_V2_H3_V1_V2_G_edit(1),'string')),str2double(get(S.W_V2_H3_V1_V2_G_edit(2),'string'))]+((I.modi.crop.posi(1)-1)*ones(1,2)).*I.img.modi.enable{'crop'}.*onCrop;
y=[str2double(get(S.W_V2_H3_V1_V2_G_edit(3),'string')),str2double(get(S.W_V2_H3_V1_V2_G_edit(4),'string'))]+((I.modi.crop.posi(3)-1)*ones(1,2)).*I.img.modi.enable{'crop'}.*onCrop;

ptZone=[min(x),min(y);max(x),max(y)];
end

function [pos,subPos]=getPinningPosition(S,k,col)

I=get(S.W_V1,'UserData');

%Find pos
pos=1;
if k==1
    if length(I.class.pinning.tab.PinnedDrops{k})>1
        xLim=[];
        for p=1:length(I.class.pinning.tab.PinnedDrops{k})
            xLim=cat(1,xLim,[p,min(I.class.pinning.tab.Limits{k}{p}(:,1));p,max(I.class.pinning.tab.Limits{k}{p}(:,1))]);
        end
        pos=xLim(find((xLim(:,2)-col)>0)-1,1);
    end
end

%Find subPos
idx=and(col>I.class.pinning.tab.Limits{k}{pos}(:,1),col<I.class.pinning.tab.Limits{k}{pos}(:,2));
if ~(sum(idx)==1)
    subPos=0;
else
    subPos=find(idx==1);
end

end


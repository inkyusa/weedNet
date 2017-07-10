% script to annotate the dataset

clc;clear; close all;

%segpath = '/home/enddl22/extDisk/inkyu_storage/dataset/weednet/Weed-Plant-2m-all/plant/seg/';
%imgpath = '/home/enddl22/extDisk/inkyu_storage/dataset/weednet/Weed-Plant-2m-all/plant/img/';

segpath = '/home/jason/GPU/zetao_workspace/Projects/Inkyu_weednet/plant/seg';
imgpath = '/home/jason/GPU/zetao_workspace/Projects/Inkyu_weednet/plant/img';


allimg = dir(fullfile(imgpath,'*.png'));
allseg = dir(fullfile(segpath,'*.png'));
draw_last = 0;
redraw = 0;
idx = 1;

allmask = {};

%for idx = 1:length(allimg)
while (idx <= length(allimg))
    imgname = fullfile(imgpath,allimg(idx).name);
    segname = fullfile(segpath,allseg(idx).name);
    
    imgfile = imread(imgname);
    segfile = imread(segname);
    
    [height,width] = size(imgfile);
    tempmask = zeros(height,width);
    
    h1 = figure(1);
    imshow(imgfile);
    title('image');
    set(h1,'Units','normalized');
    movegui(h1,[1800,0]);
    hold on
    
    h2 = figure(2);
    imshow(segfile);
    title('segmentation result');
    button_last=uicontrol('Parent',h2,'Style','pushbutton','String','draw last region','Units','normalized','Position',[0.0 0 0.2 0.1],'Visible','on','Callback','draw_last = 1;');
    button_redraw = uicontrol('Parent',h2,'Style','pushbutton','String','re-draw regions','Units','normalized','Position',[0.5 0 0.2 0.1],'Visible','on','Callback','redraw = 1;');
    
    while(1)
        
        figure(2);
        BW = roipoly;
        hold on;
        visboundaries(BW)
        
        tempmask = tempmask + BW;
        
        if(draw_last == 1)
            'last'

          draw_last = 50;
          break;
        elseif(redraw == 1)
            redraw = 0;
            idx = idx -1;
            break;
        end
    end
    
    allmask{idx} = tempmask;
    idx = idx + 1;
    
    save('mask.mat','allmask','allimg','imgpath');
    
end
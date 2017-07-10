clear all;
close all;
path(path, '../funcs');
%bagfile_exp =  '../bag_link/matrice-2016-06-22-10-42-05_weed.bag';
%bagfile_exp =  '../../bag_link/20170330/2017-03-30-17-48-04.bag';

[filename,pathStr]=uigetfile('*.bag','Select a bag file'); 
bagfile_exp=[pathStr '/' filename];

bag = rosbag(bagfile_exp);
topic_name='/ximea_asl/image_raw';
imgBag = select(bag, 'Topic',topic_name);

printf('Total number of images = %d\n',imgBag.NumMessages);
[~,folderName,ext]=fileparts(bagfile_exp);
delete(gcp('nocreate'))
parpool(4)
storePath=[pathStr '/' folderName];
parfor i=1:imgBag.NumMessages
    if ~exist(storePath, 'dir')
        mkdir(storePath);
    end
    specImg=readSpecImage(bag,i,topic_name);
    specImg.saveDataCube(storePath,i);
end

%============================
%   Sub-sampling
%============================

dirInfo=dir(storePath);
Rate=10;
strTemp=sprintf('_%d',Rate);
subSampleStorePath=[storePath strTemp];
dirInfo(1:2)=[]; %delete './' and '../'
parfor i=1:length(dirInfo)
    if mod(str2num(dirInfo(i).name),Rate)==0
        srcDirPath=[storePath '/' dirInfo(i).name];
        dstDirPath=[subSampleStorePath '/' dirInfo(i).name];
        if ~exist(dstDirPath, 'dir')
            mkdir(dstDirPath);
            copyfile(srcDirPath,dstDirPath);
        else
            copyfile(srcDirPath,dstDirPath);
        end
    end
end

%============================
%   Sequence (copying only one channel for easy skim through..
%============================
%storePath='/Users/Inkyu/Research/ETH_Postdoc/Flourish/HyperspectralCamera/dev/data_local/xemia/falcon-2017-05-18-16-46-46_10';

dirInfo=dir(storePath);
dirInfo(1:2)=[]; %delete './' and '../'
dstDirPath=[storePath '_seq'];

if ~exist(dstDirPath, 'dir')
    mkdir(dstDirPath);
end
fileName='739.png';
for i=1:length(dirInfo)
    srcDirFile=[storePath '/' dirInfo(i).name '/' fileName];
    dstDirFile=[dstDirPath '/' dirInfo(i).name '.png'];
    copyfile(srcDirFile,dstDirFile);
end


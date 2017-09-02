clear all;
close all;

targetPath='/Volumes/MyStorage/Research/weedNet/data/Sequoia/Weed-Plant-2m-all';

nir_wl=790;
red_wl=660;
green_wl=550;
reg_wl=735;
blobSize=200;
gauss_th=2.5;
ndvi_th=0.8;
%===================================================================
%   Seperate hyperspectral and rgb images into different folders
%===================================================================
display('1. Seperate hyperspectral and rgb images into different folders');
display('and undistort RGB image');
dirInfo=dir(targetPath);
dirInfo(1:2)=[]; %delete './' and '../'
fileTif=dir([targetPath '/' '*.TIF']);
fileJPG=dir([targetPath '/' '*.JPG']);
mkdir([targetPath '/' 'multi']);
mkdir([targetPath '/' 'rgb']);
mkdir([targetPath '/' 'rgb_undist']);
addpath('../funcs');
addpath('./calib');

calibParamsRGB='./calib/calibRGB.mat';
load(calibParamsRGB);

for i=1:length(fileTif)
    movefile([targetPath '/' fileTif(i).name],[targetPath '/' 'multi']);
end
parfor i=1:length(fileJPG)
    seqNum=sprintf('%.4d',i-1);
    [~,name,ext]=fileparts(fileJPG(i).name);
    rgb=imread([targetPath '/' fileJPG(i).name]);
    rgb_undist = undistortImage(rgb,calibRGB,'OutputView','valid');
    imwrite(rgb_undist,[targetPath '/' 'rgb_undist' '/' seqNum ext]);
    movefile([targetPath '/' fileJPG(i).name],[targetPath '/' 'rgb']);
end


%===================================================================
%   Sort multispectral images(4ch imges) into a folder and image align
%===================================================================
display('2. Sort multispectral images(4ch imges) into a folder and image align');

dirInfo=dir([targetPath '/' 'multi']);
dirInfo(1:2)=[]; %delete './' and '../'
mkdir([targetPath '/' 'sort']);
parfor i=0:(length(dirInfo)/4-1)
    seqFolderName=sprintf('%.4d',i);
    mkdir([targetPath '/' 'sort' '/' seqFolderName]);
    for j=1:4
        fileNames=([targetPath '/' 'multi' '/' dirInfo(i*4+j).name]);
        switch fileNames(end-6:end-4)
            case 'GRE'
                green=iread(fileNames,'double','grey');
                imwrite(green,[targetPath '/' 'sort' '/' seqFolderName '/' num2str(green_wl) '.png']);
            case 'NIR'
                nir=iread(fileNames,'double','grey');
                imwrite(nir,[targetPath '/' 'sort' '/' seqFolderName '/' num2str(nir_wl) '.png']);
            case 'RED'
                red=iread(fileNames,'double','grey');
                imwrite(red,[targetPath '/' 'sort' '/' seqFolderName '/' num2str(red_wl) '.png']);
            case 'REG'
                reg=iread(fileNames,'double','grey');
                imwrite(reg,[targetPath '/' 'sort' '/' seqFolderName '/' num2str(reg_wl) '.png']);
        end
    end
end

%===================================================================
%   Undistort images
%===================================================================
display('3. undistort images');

dirInfo=dir([targetPath '/' 'multi']);
dirInfo(1:2)=[]; %delete './' and '../'
mkdir([targetPath '/' 'sort_undist']);
calibParamsNIR='./calib/calibNIR.mat';
load(calibParamsNIR);
calibParamsRED='./calib/calibRED.mat';
load(calibParamsRED);
calibParamsGRE='./calib/calibGRE.mat';
load(calibParamsGRE);
calibParamsREG='./calib/calibREG.mat';
load(calibParamsREG);



parfor i=0:(length(dirInfo)/4-1)
    seqFolderName=sprintf('%.4d',i);
    mkdir([targetPath '/' 'sort_undist' '/' seqFolderName]);
    for j=1:4
        fileNames=([targetPath '/' 'multi' '/' dirInfo(i*4+j).name]);
        switch fileNames(end-6:end-4)
             case 'GRE'
                 green=iread(fileNames,'double','grey');
                 green_undist = undistortImage(green,calibGRE,'OutputView','valid');
                 imwrite(green_undist,[targetPath '/' 'sort_undist' '/' seqFolderName '/' num2str(green_wl) '.png']);
            case 'NIR'
                nir=iread(fileNames,'double','grey');
                nir_undist = undistortImage(nir,calibNIR,'OutputView','valid');
                imwrite(nir_undist,[targetPath '/' 'sort_undist' '/' seqFolderName '/' num2str(nir_wl) '.png']);
            case 'RED'
                red=iread(fileNames,'double','grey');
                red_undist = undistortImage(red,calibRED,'OutputView','valid');
                imwrite(red_undist,[targetPath '/' 'sort_undist' '/' seqFolderName '/' num2str(red_wl) '.png']);
             case 'REG'
                 reg=iread(fileNames,'double','grey');
                 reg_undist = undistortImage(reg,calibREG,'OutputView','valid');
                 imwrite(reg_undist,[targetPath '/' 'sort_undist' '/' seqFolderName '/' num2str(reg_wl) '.png']);
        end
    end
end

display('4. Image registration only NIR and RED channel');
%Image registration only NIR and RED channel;
load imgRegiTf.mat;
dirInfo=dir([targetPath '/' 'sort_undist']);
dirInfo(1:2)=[]; %delete './' and '../'
mkdir([targetPath '/' 'sort_regi']);
parfor i=0:(length(dirInfo)-1)
    seqFolderName=sprintf('%.4d',i);
    mkdir([targetPath '/' 'sort_regi' '/' seqFolderName]);
    nirFileName=[targetPath '/' 'sort_undist' '/' seqFolderName '/' num2str(nir_wl) '.png'];
    redFileName=[targetPath '/' 'sort_undist' '/' seqFolderName '/' num2str(red_wl) '.png'];
   
    nir_img=iread(nirFileName,'double','grey');
    red_img=iread(redFileName,'double','grey');
    [regi_nir_img,regi_red_img]=alignImgs(nir_img,red_img,tformEstimate);
    imwrite(regi_nir_img,[targetPath '/' 'sort_regi' '/' seqFolderName '/' num2str(nir_wl) '.png']);
    imwrite(regi_red_img,[targetPath '/' 'sort_regi' '/' seqFolderName '/' num2str(red_wl) '.png']);
end

%===================================================================
%   Thresholding ndvi images and store them in 'plant/seg' folder
%   ndvi images are stored in 'ndvi' folder.
%===================================================================


display('5. Thresholding ndvi images and store them in');
display('plant/seg folder. ndvi images are stored in ndvi folder.');

dataFolderPath=[targetPath '/' 'sort_regi/'];
dataFolderSegPlantPath=[targetPath '/' 'plant/seg'];
dataFolderImgPlantPath=[targetPath '/' 'plant/img'];

dirInfo=dir(dataFolderPath);
dirInfo(1:2)=[]; %delete './' and '../'

ndviPath=[targetPath '/' 'ndvi'];

mkdir(ndviPath);
mkdir(dataFolderSegPlantPath);
mkdir(dataFolderImgPlantPath);


parfor i=1:length(dirInfo)
    nir_path=[dataFolderPath dirInfo(i).name '/' num2str(nir_wl) '.png'];
    red_path=[dataFolderPath dirInfo(i).name '/' num2str(red_wl) '.png'];

    nir_=iread(nir_path,'double','grey');
    red_=iread(red_path,'double','grey');
    ndvi=mat2gray((nir_-red_)./(nir_+red_)); %0~1 normalization.
    
    imwrite(ndvi,[ndviPath '/' dirInfo(i).name '.png']);
    

    ndvi_filt=imgaussfilt(ndvi,gauss_th);
    strTitle1=sprintf('NDVI Gauss filtered %.3f applied',gauss_th);

    ndvi_filt2=imsharpen(ndvi_filt);
    bwImg = (ndvi > ndvi_th);
    strTitle2=sprintf('NDVI with threshold %.3f applied',ndvi_th);
    bwImg = bwareaopen(bwImg, blobSize); % Get rid of small blobs:
    
    saveSegFileName=[dataFolderSegPlantPath '/' dirInfo(i).name '.png'];
    saveImgFileName=[dataFolderImgPlantPath '/' dirInfo(i).name '.png'];
    imwrite(bwImg,saveSegFileName);
    imwrite(imread(nir_path),saveImgFileName);
end




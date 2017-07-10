clear all;
close all;
wl=[670;678;752;778;790;857];
blobSize=5;
gauss_th=0.1;
ndvi_th=0.73;
targetPath='../../data/Xemia/Test';

mkdir([targetPath '/sort_regi' ]);
dirInfo=dir(targetPath);
dirInfo(1:2)=[]; %delete './' and '../'
for i=1:length(dirInfo)
    if ~strcmp(dirInfo(i).name,'sort_regi')
        srcDir=[targetPath '/' dirInfo(i).name];
        dstDir=[targetPath '/sort_regi' ];
        movefile(srcDir,dstDir);
    end
end

%===================================================================
%   Thresholding ndvi images and store them in 'plant/seg' folder
%   ndvi images are stored in 'ndvi' folder.
%===================================================================


display('Thresholding ndvi images and store them in');
display('plant/seg folder. ndvi images are stored in ndvi folder.');

%path(path, '../funcs');
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
    nir_path=[dataFolderPath dirInfo(i).name '/' num2str(wl(3)) '.png']; %NIR channel, 752
    red_path=[dataFolderPath dirInfo(i).name '/' num2str(wl(2)) '.png']; %Red channel, 678

    nir_=iread(nir_path,'double','grey');
    red_=iread(red_path,'double','grey');
    
    %ndvi=(nir-red)./(nir+red); %-1 ~ 1 normalization.
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


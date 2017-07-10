function [ out ] = getFolderInfo( path,type )
    out.path=path;
    out.type=type; %plant type. crop or weed
    out.dirImgInfo=dir([out.path '/plant/img']);
    out.dirImgInfo(1:2)=[]; %delete './' and '../'
    out.dirSegInfo=dir([out.path '/plant/seg']);
    out.dirSegInfo(1:2)=[]; %delete './' and '../'
end


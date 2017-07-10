function [fixed_crop,movingReg_crop,tformEstimate]=alignImgsForRGB(fix,move,tf)
    moving=move;
    fixed=fix;
    switch nargin
        case 3
            tformEstimate = tf;
        case 2
            tformEstimate = imregcorr(im2single(moving),im2single(fixed));
    end
    %figure;imshowpair(moving,fixed,'Scaling','joint');title('Before registration');
    %tformEstimate = tf; %imregcorr(im2single(moving),im2single(fixed));
    Rfixed = imref2d(size(fixed));
    movingReg = imwarp(moving,tformEstimate,'OutputView',Rfixed);
    %figure
    %imshowpair(fixed,movingReg,'falsecolor');title('After registration');
    
    % width and length of the input image
    [height,width]= size(fixed);

    % transform the four corners of the image to find crop area
    [x1,y1] = transformPointsForward(tformEstimate,0,0);
    [x2,y2] = transformPointsForward(tformEstimate,width,0);
    [x3,y3] = transformPointsForward(tformEstimate,width,height);
    [x4,y4] = transformPointsForward(tformEstimate,0,height);

    % find inner most borders for a rectangular crop
    if max([x1,x4]) < 0
        x_left = 0;      
    else
        x_left = ceil(max([x1,x4]));
    end

    if min([x2,x3]) > width
        x_right = width;     
    else
        x_right = floor(min([x2,x3]));
    end

    if max([y1,y2]) < 0
        y_top = 0;   
    else
        y_top = ceil(max([y1,y2])); 
    end

    if min([y3,y4]) > height
        y_bottom = height;      
    else
        y_bottom = floor(min([y3,y4]));
    end

    fixed_crop = imcrop(fixed,[x_left y_top+1 x_right-x_left y_bottom-y_top]);
    movingReg_crop = imcrop(movingReg,[x_left y_top+1 x_right-x_left y_bottom-y_top]);
    
    %figure
    %imshowpair(fixed_crop,movingReg_crop,'falsecolor');title('After cropping');
    %imwrite(fixed_crop,'./data/nir_regi.png');
    %imwrite(movingReg_crop,'./data/red_regi.png');
end
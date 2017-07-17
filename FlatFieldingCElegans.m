%function ReorganizingFiles()
%ReorganizingFiles Convert Image names and format from .czi to
%Micromanager
%   Run this function from the Experiment folder. This folder should
%   contain at least one subfolder with all the tif images. Another folder
%   would contain Blank images named FF_t000xyXX_z010_cXXX.tiff, where xyXX
%   is the field of view and cXXX is the Channel
 

InputFolder = 'TIFs'; % Name of folder containing all the images from the experiment. 
                      % Format should be: exp_tXXXxyXX_zXXX_cXXX.tiff
                      % t=time xy=Worm z=Zstack c=Channel
                      
                      
           
OutputFolder = 'FFTIFs'; % Output folder Name


FolderBackground = 'Blank';
Channels = {'c001','c002'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% CODE %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mkdir(OutputFolder);
for jj=1:length(Channels)
A = dir (strcat(FolderBackground,'/*z010_',Channels{jj},'.tif'));
    for a=1:length(A)
        BlImg(:,:,a)=double(imread(strcat(FolderBackground,'/',A(a).name)));
    end
    FFImg(:,:,jj)=imfilter(median(BlImg,3),fspecial('gaussian',5,2),'replicate');
end

for jj=1:length(Channels)
A = dir (strcat(InputFolder,'/*',Channels{jj},'.tif'));

for a = 1:(length(A))
    Img = double(imread(strcat(InputFolder,'/',A(a).name)));
    Aimg=Img./FFImg(:,:,jj);
    C=mean(Img(:))/mean(Aimg(:));
    Img=(Img./FFImg(:,:,jj))*C;
    imwrite(uint16(Img),strcat(OutputFolder,'/',A(a).name));
        
end


end





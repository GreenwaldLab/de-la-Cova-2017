
%ReorganizingFiles Convert Image names and format from .czi to
%Micromanager
%   Run this function from the Experiment folder. This folder should
%   contain at least one subfolder with all the tif images. 
xd=0; 
yd=0; % Manual Image registration. -3 means that 3 pixels at the begining of red image will be croped and 3 pixels at the end of the green image will be cropped


InputFolder = 'FFTIFs'; % Name of folder containing all the Flat images from the experiment. 
                      % Format should be: exp_tXXXxyXX_zXXX_cXXX.tiff
                      % t=time xy=Worm z=Zstack c=Channel
                      
                      
Channels = { 'YFP','Cherry'}; % How do you want Channels to be named. 
           % Channel c1 to cn will follow the order names in this list.
           % Needs to match Cell Profiler pipeline
           
           
OutputFolder = 'Images'; % Output folder Name



Channels2 = { 'c001','c002'};


 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% CODE %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Get the different strains

A=dir('FFTIFs/*t000xy*_z001_c001.tif');

for a=1:length(A) 
    
    Exp(a)=regexp(A(a).name,'(\w+)t000xy\d+_z001_c001.tif','tokens'); 

end
Experiments=unique([Exp{:}]);


Count=0;
for jj=1:length(Experiments)
A = dir (strcat(InputFolder,'/',Experiments{jj},'*.tif'));
X=zeros(size(A));
for a = 1:(length(A))
    N=(regexp(A(a).name,'\w+xy(\d+)_z\w+','tokens'));
    N=cell2mat(N{1});
    X(a)=str2double(N);
end
idx=unique(X);
TotalPos=length(idx);

for a = 1:TotalPos
    mkdir(strcat(OutputFolder,'/Pos',num2str(Count)));
   
       A = dir (strcat(InputFolder,'/',Experiments{jj},'t*xy',sprintf('%02d',idx(a)),'_z*c',sprintf('%03d',1),'*'));
       
        for c=1:length(A)
            
            
            Img = double(imread(strcat(InputFolder,'/',Experiments{jj},'t000xy',sprintf('%02d',idx(a)),'_z',sprintf('%03d',c),'_c001.tif')));
            Img = Img(max([1,1+xd]):min([512,512+xd]),max([1,1+yd]):min([512,512+yd]));
            imwrite(uint16(Img),strcat(OutputFolder,'/Pos',num2str(Count),'/img_',sprintf('%09d',c-1),'_',Channels{1},'_000.png'));
            
            
            Img2 = double(imread(strcat(InputFolder,'/',Experiments{jj},'t000xy',sprintf('%02d',idx(a)),'_z',sprintf('%03d',c),'_c002.tif')));
            Img2 = Img2(max([1,1-xd]):min([512,512-xd]),max([1,1-yd]):min([512,512-yd]));
            imwrite(uint16(Img2),strcat(OutputFolder,'/Pos',num2str(Count),'/img_',sprintf('%09d',c-1),'_',Channels{2},'_000.png'));
            imwrite(uint16(mat2gray(Img2./Img,[prctile(Img2(:)./Img(:),0.5),prctile(Img2(:)./Img(:),99.5)])*65535),strcat(OutputFolder,'/Pos',num2str(Count),'/img_',sprintf('%09d',c-1),'_RedoGreen_000.png'));
        
            
        end
   
   Count=Count+1; 
end
end







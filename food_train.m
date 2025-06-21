clc;
clear all;
%close all;
addpath('support');
F=dir('TRAIN');
F=char(F.name);
sz=size(F,1)-2;
hh=waitbar(0,'Please wait system is training..');
for ii=1:sz
    st=F(ii+2,:);
    cd TRAIN
    I=imread(st);
    cd ..
    I=imresize(I,[256,256]);
    tm=IRCTF(I);
    FV(ii,:)=tm(:);
     if strcmp(st(1:4),'appl')==1
         group(ii)=1;
     end
      if strcmp(st(1:4),'Baby')==1
         group(ii)=2;
      end
  
     if strcmp(st(1:4),'bana')==1
         group(ii)=3;
     end
      if strcmp(st(1:4),'Beet')==1
         group(ii)=4;
     end
     if strcmp(st(1:4),'Biry')==1
         group(ii)=5;
     end
     if strcmp(st(1:4),'Bitt')==1
         group(ii)=6;
     end
     if strcmp(st(1:4),'Blac')==1
         group(ii)=7;
     end  
     if strcmp(st(1:4),'Blue')==1
         group(ii)=8;
     end
     if strcmp(st(1:4),'Boil')==1
         group(ii)=9;
     end     
    waitbar(ii/sz);
end
close(hh);
SS=cnntrain(FV,group);
save SS SS





    
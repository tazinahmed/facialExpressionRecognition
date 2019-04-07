clear
files = dir('E:\Cohn\SevenExpression(N+Last3)');
NF = length(files);
images2 = cell(NF,1);
for k = 1 : NF
    thisfile = fullfile('E:\Cohn\SevenExpression(N+Last3)', files(k).name); 
try 
images2{k} = imread(thisfile); 
catch 
images2{k} = 0; 
fprintf('Unreadable file: %s\n', thisfile); 
end 
end
for k=3:NF
s1=size(images2{k},1)/3;
s2=size(images2{k},2)/2;
    for i= 1:s1:size(images2{k},1)
    for j=1:s2:size(images2{k},2)
        b=lbp(images2{k}(1:s1,1:s2));
        c=lbphist(b);
        d=pca(c);
        A(k,:)=d;
        b1=lbp(images2{k}(s1+1:100,1:s2));
        c1=lbphist(b1);
        d1=pca(c1);
        A1(k,:)=d1;
        b2=lbp(images2{k}(101:150,1:s2));
        c2=lbphist(b2);
        d2=pca(c2);
        A2(k,:)=d2;
        b3=lbp(images2{k}(1:s1,s2+1:110));
        c3=lbphist(b3);
        d3=pca(c3);
        A3(k,:)=d3;
        b4=lbp(images2{k}(s1+1:100,s2+1:110));
        c4=lbphist(b4);
        d4=pca(c4);
        A4(k,:)=d4;
        b5=lbp(images2{k}(101:150,s2+1:110));
        c5=lbphist(b5);
        d5=pca(c5);
        A5(k,:)=d5;
    end
    end
end
im1=fopen('number.txt','rt');
    Aj=fscanf(im1,'%d');
fclose(im1);

im=fopen('pca1.txt','wt');

    
for k=3:NF
%      fprintf(im,'\n');
       fprintf(im,'%d\t',Aj(k));
       for j=1:256
        fprintf(im,'%d',j);
        fprintf(im,':');
        fprintf(im,'%d\t',A(k,j)); 
        end
        for i=1:256
        fprintf(im,'%d',i+256);
        fprintf(im,':');
         fprintf(im,'%d\t',A1(k,i)); 
        end
        for m=1:256
        fprintf(im,'%d',m+513);
        fprintf(im,':');
         fprintf(im,'%d\t',A2(k,m)); 
        end
         for n=1:256
        fprintf(im,'%d',n+769);
        fprintf(im,':');
         fprintf(im,'%d\t',A3(k,n)); 
         end
        for o=1:256
        fprintf(im,'%d',o+1026);
        fprintf(im,':');
         fprintf(im,'%d\t',A4(k,o)); 
        end
        for o=1:256
        fprintf(im,'%d',o+1283);
        fprintf(im,':');
         fprintf(im,'%d\t',A5(k,o)); 
        end
        fprintf(im,'\n');
end

 fclose(im);
function result=lbp(a)
   result=size(size(a,1),size(a,2));
    for i= 2:size(a,1)-1
    for j=2:size(a,2)-1
        lv=0;
        if( a(i,j) > a(i-1,j-1))
            lv=lv+1;
        else 
            lv=lv+0;
        end
        if( a(i,j) > a(i,j-1))
            lv=lv+2;
            else 
            lv=lv+0;
        end
        
        if( a(i,j) > a(i+1,j-1))
            lv=lv+4;
            else 
            lv=lv+0;
        end
        
        if( a(i,j) > a(i+1,j))
            lv=lv+8;
            else 
            lv=lv+0;
        end
        
        if( a(i,j) > a(i+1,j+1))
            lv=lv+16;
            else 
            lv=lv+0;
        end
        
        if( a(i,j) > a(i,j+1))
            lv=lv+32;
            else 
            lv=lv+0;
        end
        
        if( a(i,j) > a(i-1,j+1))
            lv=lv+64;
            else 
            lv=lv+0;
        end
        
        if( a(i,j) > a(i-1,j))
            lv=lv+128;
            else 
            lv=lv+0;
        end
        result(i,j)=lv;
        
    end
    end
    end


function w=lbphist(a)
w=size(256,1);
for k = 0:255
    c=0;
    for i = 2:size(a,1)
        for j = 2:size(a,2)
            if(a(i,j)== k)
                c=c+1;  
            end
            w(k+1)=c;
        end
    end
end
end
function OriginalData =pca(Data)
Data_grayD = im2double(Data);              
Data_mean = mean(Data_grayD);      
[a, ~] = size(Data_grayD); 
Data_meanNew = repmat(Data_mean,a,1); 
DataAdjust = Data_grayD - Data_meanNew; 
cov_data = cov(DataAdjust);   
[V, ~] = eig(cov_data); 
V_trans = transpose(V); 
DataAdjust_trans = transpose(DataAdjust);  
FinalData = V_trans * DataAdjust_trans;   
OriginalData_trans = inv(V_trans) * FinalData;                         
OriginalData = transpose(OriginalData_trans) + Data_meanNew;                 
end
function [label1, grid1] = strimage_test(n)
    fidin = fopen('test-01-images.svm'); % ��test2.txt�ļ� 
    i = 1;
    apres = [];
  
  while ~feof(fidin)
    tline = fgetl(fidin); % ���ļ����� 
    apres{i} = tline;
    i = i+1;
  end
  
  label1 = [];
  grid1  = [];
  
  for i = 1 : n
    a = char(apres(i));
    
    lena = size(a);
    lena = lena(2);
    label = sscanf(a(1:3),'%d');
    label1 = [label1; label];
    xy = sscanf(a(4:lena), '%d:%d');
  
    lenxy = size(xy);
    lenxy = lenxy(1);
    
    
    grid = [];
    grid(784) = 0;
    for i=2:2:lenxy  %% ��һ����
        if(xy(i)<=0)
            break
        end
      grid(xy(i-1)) = xy(i) * 100/255;
    end
    grid1 = [grid1; grid];
    %grid2 = reshape(grid,28,28);
    %grid2 = fliplr(diag(ones(28,1)))*grid2;
    %grid2 = rot90(grid2,3);
    %image(grid2)
    % hold on;
  end
  
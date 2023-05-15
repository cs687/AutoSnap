function [ output_args ] = autosnap_beta_error_send_5_prime_only_rename_plot_beta_v1(pads, positions, padnames, colors, outputfolder,fname_title,auto_print,start_pad,handles)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
% inut parameters:
% pads: number of pads
% positions: numbero of positions per pads
% padnames: name of pads
% colors: in the form 'ryp'
% outputfolder: name of output folder

handles.outputfolder= outputfolder;
mkdir(handles.outputfolder);
handles.current_directory=cd;
if ~handles.only_plot && ~handles.no_rename
    for i=start_pad:pads
        %cd([handles.current_directory]);
        for j=1:positions
            for k=1:length(colors)
               if colors(k)=='r'
                  inputFile = ['awell-','t','-']; %input('Enter original file header, surrounded by single quotes: ');
               else
                  inputFile = ['awell-',colors(k),'-']; %input('Enter original file header, surrounded by single quotes: ');
               end

               channel = colors(k); %input('Enter the channel color (eg y, c, r) surrounded by single quotes: ');

               if exist([handles.current_directory,'\',inputFile num2str(str3((i-1)*positions + (j))) '.tif'],'file')==0
                   timepast=0;
                   while exist([handles.current_directory,'\',inputFile num2str(str3((i-1)*positions + (j))) '.tif'],'file')==0
                       pause(1);
                       timepast=timepast+1;
    %                    if timepast>10
    %                        disp('Renaming Stopped');
    %                        %send_error;
    %                        errordlg('Acquisition Error','Acquisition Error');
    %                        return
    %                    end
                   end
               end
                    disp(['Reading input file = ' inputFile num2str(str3((i-1)*positions + (j))) '.tif'])
%                     %oldname=[handles.current_directory,'\',inputFile num2str(str3((i-1)*positions + (j))) '.tif'];
%                     copyfile([handles.current_directory,'\',inputFile num2str(str3((i-1)*positions + (j))) '.tif'],[handles.current_directory, '\',handles.outputfolder,'\']);
%                     oldname=[handles.current_directory, '\',handles.outputfolder,'\',inputFile num2str(str3((i-1)*positions + (j))) '.tif'];
%                     newname=[handles.current_directory, '\',handles.outputfolder,'\', padnames{i} '_' num2str(str3(i)) '-' str2(j) '-' channel '.tif'];
%                     A = java.io.File(oldname);
%                     A.renameTo(java.io.File(newname)); 
                    
                    im = imread([handles.current_directory,'\',inputFile num2str(str3((i-1)*positions + (j))) '.tif']);
                    imwrite(im,[handles.current_directory, '\',handles.outputfolder,'\', padnames{i} '_' num2str(str3(i)) '-' str2(j) '-' channel '.tif'],'tiff');
            end
        end
    end
end

if ~handles.only_plot
%    parfor i=start_pad:pads
    for i=start_pad:pads
    %for i=[2]
        %cd([handles.current_directory, '\',handles.outputfolder]);
        fname=[padnames{i} '_' num2str(str3(i))];
        fname_array{i}=[padnames{i} '_' num2str(str3(i))];
        good=redseg_better_del_no_cells_auto_no_schmutz3_prime_v3(fname,handles, 'naturalback',1);
        %redseg_better_del_no_cells_auto_no_schmutz3_prime2(fname, 'naturalback',1);
        num_col=length(colors);
        if good>0
            analysesnaphist_auto_prime_2(fname,colors,fname_title{i},handles);
        end
     end
else
    for i=1:pads
        fname_array{i}=[padnames{i} '_' num2str(str3(i))];
    end
end
%Generating print file
figure;
j=1;
k=1;
for i=1:pads
    if j>9
        j=1;
        %saveas(gcf,[handles.current_directory, '\',handles.outputfolder,'\output_',num2str(k),'.jpg']);
        print(gcf,[handles.current_directory, '\',handles.outputfolder,'\output_',num2str(k),'.jpg'],'-dpng','-r900');
        saveas(gcf,[handles.current_directory, '\',handles.outputfolder,'\output_',num2str(k),'.fig']);
        figure;
        k=k+1;
    end
    subplot_tight(3,3,j);
    if exist([handles.current_directory, '\',handles.outputfolder,'\S',fname_array{i},'-1.jpg'])~=0
        image(imread([handles.current_directory, '\',handles.outputfolder,'\S',fname_array{i},'-1.jpg']));
        %imshow(imread([handles.current_directory, '\',handles.outputfolder,'\S',fname_array{i},'-1.jpg']));
        snapnow;
        axis off;
        j=j+1;
    end
end
%saveas(gcf,[handles.current_directory, '\',handles.outputfolder,'\output_',num2str(k),'.jpg']);
print(gcf,[handles.current_directory, '\',handles.outputfolder,'\output_',num2str(k),'.jpg'],'-dpng','-r900');
saveas(gcf,[handles.current_directory, '\',handles.outputfolder,'\output_',num2str(k),'.fig']);

if auto_print==1
    h=hgload('output.fig');
    set(gcf,'Units','centimeters');
    set(gcf,'PaperOrientation','landscape');
    set(gcf,'PaperType','A4');
    set(gcf, 'PaperPosition', [0.2 0.5 29 19.5 ]);
    print(h, '-PSouth Wing Colour Laserjet');
end


function send_error
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Defining Account details
myaddress = 'nikon.bacillus.1@gmail.com';
mypassword = 'P455w0rd!';

%Setting Prefences
setpref('Internet','E_mail',myaddress);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',myaddress);
setpref('Internet','SMTP_Password',mypassword);

%Setting Properties
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

%sending Email
sendmail(myaddress, 'Acquisition Error', 'Come and check me. I am having a problems!');
end
end



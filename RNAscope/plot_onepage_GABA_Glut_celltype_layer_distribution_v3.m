tic
clear all
close all

load /mnt/sanger-data2/C1_stuff/Dorsal_horn_MH/Stainings_2017/aggregate_Glut_RNAscope_counts.mat
%dataglut_LSC dataglut_CSC imagesource_glut_LSC imagesource_glut_CSC
%table_header_Glut
load /mnt/sanger-data2/C1_stuff/Dorsal_horn_MH/Stainings_2017/aggregate_GABA_RNAscope_counts.mat
%datagaba_LSC datagaba_CSC imagesource_gaba_LSC imagesource_gaba_CSC
%table_header_GABA

combi_needed = loadCellFile('/mnt/sanger-data2/C1_stuff/Dorsal_horn_MH/Stainings_2017/celltypes_combinations_to_output_v2.txt');
rmv = strcmpi(combi_needed(:,3),'-') | ~cellfun(@isempty, strfind(combi_needed(:,3),'alt_'));
combi_needed(rmv,:) = [];
combi_needed = [combi_needed(1:14,:);cell(1,4);combi_needed(15:end,:)];

% [~,xi] = sort(combi_needed(:,3));
% combi_needed = combi_needed(xi,:);

load ref_LSC;
load ref_CSC;
load layers_mask_LSC_ref
load layers_mask_CSC_ref

figure('position',[268,86,900,634],'color','w');
[ha, pos] = tight_subplot(6, 5, [0.01,0.01], [0.01,0.01], [0.01,0.01]);
% ha = reshape(ha,7,4)';
% ha = ha(:);
th = 3;
for i=1:length(combi_needed(:,1))
    i
    isgaba = ~isempty(strfind(combi_needed{i,1},'GAB'));
    isglut = ~isempty(strfind(combi_needed{i,1},'Glu'));
    if isgaba
        tmp = strsplit(combi_needed{i,2},',');
        tmpfname = combi_needed{i,2};
        tmpfname = regexprep(tmpfname,'+','pos_');
        tmpfname = regexprep(tmpfname,'-','neg_');
        tmpfname = regexprep(tmpfname,',','-');
        in_LSC = true(length(datagaba_LSC(:,1)),1);
        in_CSC = true(length(datagaba_CSC(:,1)),1);
        in_LSC(cellfun(@isempty, strfind(imagesource_gaba_LSC, combi_needed{i,1}))) = false;
        in_CSC(cellfun(@isempty, strfind(imagesource_gaba_CSC, combi_needed{i,1}))) = false;
        for j=1:length(tmp)
            if tmp{j}(1)=='+'
                in_LSC = in_LSC & datagaba_LSC(:,find(strcmpi(table_header_GABA,tmp{j}(2:end)) ) )>th;
                in_CSC = in_CSC & datagaba_CSC(:,find(strcmpi(table_header_GABA,tmp{j}(2:end)) ) )>th;
            elseif tmp{j}(1)=='-'
                in_LSC = in_LSC & ~(datagaba_LSC(:,find(strcmpi(table_header_GABA,tmp{j}(2:end)) ) )>th);
                in_CSC = in_CSC & ~(datagaba_CSC(:,find(strcmpi(table_header_GABA,tmp{j}(2:end)) ) )>th);
            end
        end
        %         figure('visible','off','color','w','position',[1,1,2000,1200]);
        %         axes('position',[0.01,0.01,0.9,0.46]);
        axes(ha(i))
        for ii=1:8
            for j=1:length(B_LSC{ii})
                plot(B_LSC{ii}{j}(:,2),B_LSC{ii}{j}(:,1),'color',[0.7,0.7,0.7]);hold on;
            end
        end
        plot(datagaba_LSC(in_LSC,2), datagaba_LSC(in_LSC,3),'.r','markersize',4); hold on;
        set(gca,'ydir','reverse','fontsize',6);
        axis tight
        axis equal
        %         set(gca,'xlim',[set_ref_LSC(1,1),set_ref_LSC(9,1)])
        axis off
        title([combi_needed{i,3},', ',' (',num2str(sum(in_LSC)),' cells)'],'fontsize',5);
    elseif isglut
        tmp = strsplit(combi_needed{i,2},',');
        tmpfname = combi_needed{i,2};
        tmpfname = regexprep(tmpfname,'+','pos_');
        tmpfname = regexprep(tmpfname,'-','neg_');
        tmpfname = regexprep(tmpfname,',','-');
        in_LSC = true(length(dataglut_LSC(:,1)),1);
        in_CSC = true(length(dataglut_CSC(:,1)),1);
        in_LSC(cellfun(@isempty, strfind(imagesource_glut_LSC, combi_needed{i,1}))) = false;
        in_CSC(cellfun(@isempty, strfind(imagesource_glut_CSC, combi_needed{i,1}))) = false;
        for j=1:length(tmp)
            if tmp{j}(1)=='+'
                in_LSC = in_LSC & dataglut_LSC(:,find(strcmpi(table_header_Glut,tmp{j}(2:end)) ) )>th;
                in_CSC = in_CSC & dataglut_CSC(:,find(strcmpi(table_header_Glut,tmp{j}(2:end)) ) )>th;
            elseif tmp{j}(1)=='-'
                in_LSC = in_LSC & ~(dataglut_LSC(:,find(strcmpi(table_header_Glut,tmp{j}(2:end)) ) )>th);
                in_CSC = in_CSC & ~(dataglut_CSC(:,find(strcmpi(table_header_Glut,tmp{j}(2:end)) ) )>th);
            end
        end
        %         figure('visible','off','color','w','position',[1,1,2000,1200]);
        %         axes('position',[0.01,0.01,0.9,0.46]);
        axes(ha(i))
        
        for ii=1:8
            for j=1:length(B_LSC{ii})
                plot(B_LSC{ii}{j}(:,2),B_LSC{ii}{j}(:,1),'color',[0.7,0.7,0.7]); hold on
            end
        end
        plot(dataglut_LSC(in_LSC,2), dataglut_LSC(in_LSC,3),'.r','markersize',4); hold on;
        set(gca,'ydir','reverse','fontsize',6);
        axis tight
        axis equal
        axis off
        title([combi_needed{i,3},', ',' (',num2str(sum(in_LSC)),' cells)'],'fontsize',5);
    end
end

eval(['export_fig /mnt/sanger-data2/C1_stuff/Dorsal_horn_MH/Stainings_2017/output_celltype_distribution_aug22_2017/'.....
    ,'All_LSC_GABAGlut_v3_',date,'.pdf']);

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

figure('position',[268,86,900,634],'color','w');
[ha, pos] = tight_subplot(6, 5, [0.01,0.01], [0.01,0.01], [0.01,0.01]);
th = 3;
for i=1:length(combi_needed(:,1))
    i
    isgaba = ~isempty(strfind(combi_needed{i,1},'GAB'));
    isglut = ~isempty(strfind(combi_needed{i,1},'Glu'));
    if isgaba
        tmp = strsplit(combi_needed{i,2},',');
        tmpfname = combi_needed{i,2};
        tmpfname = regexprep(tmpfname,'+','pos_');
        tmpfname = regexprep(tmpfname,'-','neg_');
        tmpfname = regexprep(tmpfname,',','-');
        in_LSC = true(length(datagaba_LSC(:,1)),1);
        in_CSC = true(length(datagaba_CSC(:,1)),1);
        in_LSC(cellfun(@isempty, strfind(imagesource_gaba_LSC, combi_needed{i,1}))) = false;
        in_CSC(cellfun(@isempty, strfind(imagesource_gaba_CSC, combi_needed{i,1}))) = false;
        for j=1:length(tmp)
            if tmp{j}(1)=='+'
                in_LSC = in_LSC & datagaba_LSC(:,find(strcmpi(table_header_GABA,tmp{j}(2:end)) ) )>th;
                in_CSC = in_CSC & datagaba_CSC(:,find(strcmpi(table_header_GABA,tmp{j}(2:end)) ) )>th;
            elseif tmp{j}(1)=='-'
                in_LSC = in_LSC & ~(datagaba_LSC(:,find(strcmpi(table_header_GABA,tmp{j}(2:end)) ) )>th);
                in_CSC = in_CSC & ~(datagaba_CSC(:,find(strcmpi(table_header_GABA,tmp{j}(2:end)) ) )>th);
            end
        end
        %         figure('visible','off','color','w','position',[1,1,2000,1200]);
        %         axes('position',[0.01,0.01,0.9,0.46]);
        axes(ha(i))
        for ii=1:8
            for j=1:length(B_CSC{ii})
                plot(B_CSC{ii}{j}(:,2),B_CSC{ii}{j}(:,1),'color',[0.7,0.7,0.7]);hold on;
            end
        end
        plot(datagaba_CSC(in_CSC,2), datagaba_CSC(in_CSC,3),'.r','markersize',4); hold on;
        set(gca,'ydir','reverse','fontsize',6);
        axis tight
        axis equal
        axis off
        title([combi_needed{i,3},', ',' (',num2str(sum(in_CSC)),' cells)'],'fontsize',5);
    elseif isglut
        tmp = strsplit(combi_needed{i,2},',');
        tmpfname = combi_needed{i,2};
        tmpfname = regexprep(tmpfname,'+','pos_');
        tmpfname = regexprep(tmpfname,'-','neg_');
        tmpfname = regexprep(tmpfname,',','-');
        in_LSC = true(length(dataglut_LSC(:,1)),1);
        in_CSC = true(length(dataglut_CSC(:,1)),1);
        in_LSC(cellfun(@isempty, strfind(imagesource_glut_LSC, combi_needed{i,1}))) = false;
        in_CSC(cellfun(@isempty, strfind(imagesource_glut_CSC, combi_needed{i,1}))) = false;
        for j=1:length(tmp)
            if tmp{j}(1)=='+'
                in_LSC = in_LSC & dataglut_LSC(:,find(strcmpi(table_header_Glut,tmp{j}(2:end)) ) )>th;
                in_CSC = in_CSC & dataglut_CSC(:,find(strcmpi(table_header_Glut,tmp{j}(2:end)) ) )>th;
            elseif tmp{j}(1)=='-'
                in_LSC = in_LSC & ~(dataglut_LSC(:,find(strcmpi(table_header_Glut,tmp{j}(2:end)) ) )>th);
                in_CSC = in_CSC & ~(dataglut_CSC(:,find(strcmpi(table_header_Glut,tmp{j}(2:end)) ) )>th);
            end
        end
        %         figure('visible','off','color','w','position',[1,1,2000,1200]);
        %         axes('position',[0.01,0.01,0.9,0.46]);
        axes(ha(i))
        for ii=1:8
            for j=1:length(B_CSC{ii})
                plot(B_CSC{ii}{j}(:,2),B_CSC{ii}{j}(:,1),'color',[0.7,0.7,0.7]);hold on;
            end
        end
        plot(dataglut_CSC(in_CSC,2), dataglut_CSC(in_CSC,3),'.r','markersize',4); hold on;
        set(gca,'ydir','reverse','fontsize',6);
        axis tight
        axis equal
        axis off
        title([combi_needed{i,3},', ',' (',num2str(sum(in_CSC)),' cells)'],'fontsize',5);
        
    end
end



eval(['export_fig /mnt/sanger-data2/C1_stuff/Dorsal_horn_MH/Stainings_2017/output_celltype_distribution_aug22_2017/'.....
    ,'All_CSC_GABAGlut_v3_',date,'.pdf']);


toc
function  Motif_ReCreation_CallBack( hfig,handles,z,fr,motifs,idx_motif_cells,motif_idx,I)

% Callback function that loads the motifs created from Motif_Creation_Callback
%   - hfig: identifier of the figure object whehre the motif will be created
%   - handles: variable with all the handlers and saved variables of the
%   environment
%   - z : vector with the z-score value of each motif
%   - fr: vector with the relative frequency regarding the cluster of a cell for each motif
%   - motifs: a matrix which shows the clusters of the microenvironment that each motif represents
%   - idx_motfi: a cell array that saves the idxes of the cells that
%   are grouped under each motif.
%   -motif_idx: a vector for the cluster of the cells of each motif
%   - I: vector representing the idx of motifs that should be loaded

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

global val
% val=10;
handlers=[];
num_subplots=10;

handlers_origin=getappdata(handles.figure1,'handlers_origin');
mean_val_origin=getappdata(handles.figure1,'mean_val_origin');
std_val_origin=getappdata(handles.figure1,'std_val_origin');

%%
% hfig=figure;
%%

tabgp = uitabgroup(hfig,'units','normalized','outerposition',[0 0 1 1]);     
popup = uicontrol( hfig,'Style', 'popup',...
           'String', {'All motifs','Z score -Asceding order','Z score -Desceding order','Frequency -Asceding order','Frequency -Desceding order'},...
           'Position', [0.01 0.95 0.12 0.05],...
           'Callback', {@Motif_Selection_Callback,hfig,handles,z,fr,motifs,idx_motif_cells,motif_idx,I}); 

%% Create the slider
jSlider = javax.swing.JSlider(javax.swing.JSlider.VERTICAL, val, 100, val);
[comp, container] = javacomponent(jSlider,[850 370 120 45 ],hfig);
container.Units = 'normalized';
container.Position = [0.91 0.05 0.09 0.8];
container.BackgroundColor=[1 1 1];
set(jSlider, 'MajorTickSpacing',5, 'PaintLabels',true , 'PaintTicks', true );
hjSlider = handle(jSlider, 'CallbackProperties');
set(hjSlider, 'StateChangedCallback', {@Motif_Threshold_Callback,hfig,handles,z,fr,motifs,idx_motif_cells,motif_idx,I});
popup2 = uicontrol( hfig,'Style', 'text','Units','normalized','Position',[0.91 0.85 0.09 0.05],'String','Motif threshold');

%% Reload of the motifs that have already been created from Motif_Creation_Callback
for i=1:ceil((size(motifs,1)+1)/num_subplots)
    tab{i}=uitab(tabgp,'Title',num2str(i));
    set(tab{i},'BackgroundColor',[1 1 1]);
    try
        d = uicontextmenu(get(hfig,'parent'));
        uimenu('Parent',d,'Label','Save_as','Callback',{@Save_as_Context_Menu, hfig, handles});
        set(tab{i},'UIContextMenu',d);
    catch
    end
end

set(popup,'Units','normalized')
set(popup,'Position',[0.005 0.86 0.07 0.05]);
try 
    z_new=mat2gray(z,[min(z) max(z)]);
catch
    
end
for i=1:length(idx_motif_cells)
        ax_=axes(tab{ceil(i/num_subplots)});
        if mod(i,num_subplots) == 0
            ax(i)=subplot(2,5,num_subplots,ax_);
        else
            ax(i) = subplot(2,5,mod(i,num_subplots),ax_);
        end
        
        handlers{i}=handlers_origin{I(i)};
        mean_val{i}=mean_val_origin{I(i)};
        std_val{i}=std_val_origin{I(i)};
        caxis(ax(i),[0 1]);
        set(handlers{i}(2),'CData',z_new(i));
        temp=fliplr(handlers{i});
        set(temp,'Parent',ax(i));

        set(handlers{i},'Tag',num2str(i));
        set(handlers{i},'ButtonDownFcn',{@Motif_checkBox_Callback,idx_motif_cells,handles,motif_idx(i)});
end


if ~isempty(handlers)
    set(ax,'visible', 'off'); 
    setappdata(handles.figure1,'motif_axes',ax);
    setappdata(handles.figure1,'motif_handlers',handlers);
    setappdata(handles.figure1,'t_idx_motif_cells',idx_motif_cells);
    setappdata(handles.figure1,'t_mean_val',mean_val);
    setappdata(handles.figure1,'t_std',std_val);
    setappdata(handles.figure1,'t_fr',fr);
    setappdata(handles.figure1,'t_z',z);
end

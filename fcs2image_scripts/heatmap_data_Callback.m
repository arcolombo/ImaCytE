function heatmap_data_Callback(source,~,ax_,fin_mat)

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

   val = source.Value; 
   h=findobj('Tag','h_hd');
    switch val
        case 1
            n=my_normalize(fin_mat,'rows');
            h(end).CData=n;
            caxis(ax_,[min(n(:)) max(n(:))])
        case 2
            h(end).CData=my_rescale(fin_mat,'rows');
            caxis(ax_,[0 1]);
        case 3
            h(end).CData=fin_mat;
            caxis(ax_,[min(fin_mat(:)), max(fin_mat(:))]);
    end
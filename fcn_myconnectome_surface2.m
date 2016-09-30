function [f,ph,ax,coorLims] = fcn_myconnectome_surface2(x,midVal)

if ~exist('midVal','var')
    midVal = min(x);
end

sl = gifti('sub013.L.inflated.32k_fs_LR.surf.gii');
gl = gifti('all_selected_L_new_parcel_renumbered.func.gii');

sr = gifti('sub013.R.inflated.32k_fs_LR.surf.gii');
gr = gifti('all_selected_R_new_parcel_renumbered.func.gii');

coorlmin = min(sl.vertices);
coorlmax = max(sl.vertices);
coorlrng = coorlmax - coorlmin;

coorrmin = min(sr.vertices);
coorrmax = max(sr.vertices);
coorrrng = coorrmax - coorrmin;

coorLims{1} = [coorlmin; coorlmax; coorlrng];
coorLims{2} = [coorrmin; coorrmax; coorrrng];

indl = gl.cdata > 0;
roil = gl.cdata(indl);

indr = gr.cdata > 0;
roir = gr.cdata(indr);

if size(x,2) == 1
    xl = x(roil);
    xr = x(roir);
    gl.cdata(indl) = xl;
    gl.cdata(~indl) = midVal;
    gr.cdata(indr) = xr;
    gr.cdata(~indr) = midVal;
elseif size(x,2) == 3
    xl = x(roil,:);
    xr = x(roir,:);
    gl.cdata = 0.5*ones(size(gl.cdata,1),3,'single');
    gr.cdata = 0.5*ones(size(gr.cdata,1),3,'single');
    gl.cdata(indl,:) = xl;
    gr.cdata(indr,:) = xr;
end

numpart = length(unique(x));

f(10) = figure;
ax(1) = axes;
ph(1) = trisurf(sl.faces,sl.vertices(:,1),sl.vertices(:,2),sl.vertices(:,3),gl.cdata);
view([-1 0 0]);
axis image
set(gca, 'XTick', [], 'XTickLabel', [])
set(gca, 'YTick', [], 'YTickLabel', [])
set(gca, 'zTick', [], 'ZTickLabel', [])
colormap(pmkmp(numpart));
set(gca, 'CLim', [0, numpart-1]);
colorbar();

f(1) = figure;
ax(1) = axes;
subplot(4,1,1)
ph(1) = trisurf(sl.faces,sl.vertices(:,1),sl.vertices(:,2),sl.vertices(:,3),gl.cdata);
view([-1 0 0]);
axis image
set(gca, 'XTick', [], 'XTickLabel', [])
set(gca, 'YTick', [], 'YTickLabel', [])
set(gca, 'zTick', [], 'ZTickLabel', [])
colormap(pmkmp(numpart));
set(gca, 'CLim', [0, numpart-1]);

ax(2) = axes;
subplot(4,1,3)
ph(3) = trisurf(sl.faces,sl.vertices(:,1),sl.vertices(:,2),sl.vertices(:,3),gl.cdata);
view([1 0 0]);
axis image
set(gca, 'XTick', [], 'XTickLabel', [])
set(gca, 'YTick', [], 'YTickLabel', [])
set(gca, 'zTick', [], 'ZTickLabel', [])
colormap(pmkmp(numpart));
set(gca, 'CLim', [0, numpart-1]);

%f(2) = figure;
ax(2) = axes;
subplot(4,1,2)
ph(2) = trisurf(sr.faces,sr.vertices(:,1),sr.vertices(:,2),sr.vertices(:,3),gr.cdata);
view([1 0 0]);
axis image
set(gca, 'XTick', [], 'XTickLabel', [])
set(gca, 'YTick', [], 'YTickLabel', [])
set(gca, 'zTick', [], 'ZTickLabel', [])
colormap(pmkmp(numpart));
set(gca, 'CLim', [0, numpart-1]);


ax(2) = axes;
subplot(4,1,4)
ph(4) = trisurf(sr.faces,sr.vertices(:,1),sr.vertices(:,2),sr.vertices(:,3),gr.cdata);
view([-1 0 0]);
axis image
set(gca, 'XTick', [], 'XTickLabel', [])
set(gca, 'YTick', [], 'YTickLabel', [])
set(gca, 'zTick', [], 'ZTickLabel', [])
colormap(pmkmp(numpart));
set(gca, 'CLim', [0, numpart-1]);
set(ph,'edgecolor','none');

disp('todo: check color limits')
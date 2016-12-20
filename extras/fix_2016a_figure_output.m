function fix_2016a_figure_output(figH)
%%% Fixes issue of figures being clipped when exported

if nargin <1 || isempty(figH)
    figH = gcf;
end

if ~verLessThan('matlab', '9.0') %% 2016a or more recent
    set(gcf,'PaperUnits','normalized');
    startPP = get(gcf,'PaperPosition');
%         newPP = [max(0,startPP(1)),max(0,startPP(2)),min(1,startPP(3)),min(1,startPP(4))];
    newPP = [max(0,startPP(1)),0.2,min(1,startPP(3)),0.6];
    set(figH,'PaperPosition',newPP);
end
local ffclassic=Class{}
ffclassic:include(gt_theme)

function ffclassic:init()
	gt_theme.init(self,
				{
				  window_color={r=0, g=52, b=153, alpha=100}, 
				  outline_color={r=255, g=255, b=255, alpha=255}
				})
end

return ffclassic
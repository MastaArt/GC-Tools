struct setRegionBySelectionBBox (	
	fn getViewportSafeFrameSize = (
		vs = [gw.getWinSizeX(), gw.getWinSizeY()]
		rs = [renderWidth, renderHeight]
		
		local va = vs.x as float / vs.y
		local ra = rs.x as float / rs.y

		local x, y, w, h
		if (va > ra) then (       
			h = vs.y
			w = (h * ra) as integer
			y = 0
			x = (vs.x - w) / 2
		) else (
			w = vs.x
			h = (w / ra) as integer
			x = 0
			y = (vs.y - h) / 2        
		)
		
		return box2 x y w h
	),

	fn init cam paddingX: 100 paddingY: 100 = (
		if(cam == undefined) do return false
		-- Important! Need disable the target!
		try (cam.targeted = false) catch()
		try (cam.type = #free) catch()
		
		viewport.setType #view_persp_user
		viewport.setCamera cam
		forceCompleteRedraw()
		viewport.setType #view_persp_user
		max zoomext sel
		forceCompleteRedraw()
		cam.transform = (inverse(viewport.getTM()))
		viewport.setCamera cam
		forceCompleteRedraw()
		
		view = viewport.activeViewport
		
		renderSceneDialog.close()	
		setRenderType  #blowUp		
		renderSceneDialog.commit()
		renderSceneDialog.update()
		forceCompleteRedraw()
		return false
		nodes = for node in selection where iskindof node GeometryClass collect node
		if(nodes.count == 0) do return (print "Error: Region not set!")
		
		local bmin = [1e9,1e9,0]
		local bmax = [-1e9,-1e9,0]
		
		gw.setTransform (matrix3 1)
		tp = gw.TransPoint
		
		for n in nodes do (
			m = snapShotAsMesh n
			for v in 1 to m.numverts do (
				vp = tp (GetVert m v)
				
				if(vp.x < bmin.x) do bmin.x = vp.x
				if(vp.x > bmax.x) do bmax.x = vp.x
				if(vp.y < bmin.y) do bmin.y = vp.y
				if(vp.y > bmax.y) do bmax.y = vp.y
			)
			
			free m
		)
		
		x = bmin.x as integer
		y = bmin.y as integer
		w = (bmax.x - bmin.x) as integer
		h = (bmax.y - bmin.y) as integer
		
		vpSafe = getViewportSafeFrameSize()
		
		x = x - vpSafe.x
		y = y - vpSafe.y
		
		cw = vpSafe.w
		ch = vpSafe.h
		
		px = x * 100.0 / cw
		py = y * 100.0 / ch
		pw = w * 100.0 / cw
		ph = h * 100.0 / ch
				
		x = (renderWidth * px / 100.0) as integer -- paddingX
		y = (renderHeight * py / 100.0) as integer  -- paddingY
		w = ((renderWidth * pw  / 100.0) as integer) --+ paddingX * 2 + (kw * 2)
		h = ((renderHeight * ph / 100.0) as integer) --+ paddingY * 2 + (kh * 2)
		
		kw = 0
		kh = 0
			
		if(w >= h) then kh = (w - h) / 2 else kw = (h - w) / 2
		
		ss = if(w > h) then w else h
		
		x = x - paddingX - kw
		y =  y - paddingY - kh
		w = w + (kw * 2) + (paddingX * 2)
		h = w --h + (kh * 2) --+ (paddingY * 2) 
		
		rect = box2 x y w h
			
		if(not EditRenderRegion.IsEditing) do EditRenderRegion.EditRegion() 		
		viewport.setBlowupRect  view rect
		forceCompleteRedraw()
		EditRenderRegion.UpdateRegion()
		forceCompleteRedraw()
	)
)

(setRegionBySelectionBBox()).init cameras[1]
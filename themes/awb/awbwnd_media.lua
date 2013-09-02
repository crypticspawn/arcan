--
-- AWB Frameserver Media Window
-- For a 3D session, we set up a FBO rendertarget 
-- and connect the output to the canvas along with some buttons to
-- navigate and control basic lighting.
-- 
-- For Vidcap, we add a popup button to select device / index
-- and restart the frameserver each time.
--
-- Adds a "play/pause" and possibly others 
-- based on frameserver capabilities.
--
-- Drag to Desktop behavior is link to recreate / reopen 
-- or add a screenshot
--

local shader_seqn = 0;

local function set_shader(modelv)
	local lshdr = load_shader("shaders/dir_light.vShader", 
		"shaders/dir_light.fShader", "media3d_" .. tostring(shader_seqn));

	shader_uniform(lshdr, "map_diffuse", "i", PERSIST, 0);
	shader_uniform(lshdr, "wlightdir", "fff", PERSIST, 1, 0, 0);
	shader_uniform(lshdr, "wambient",  "fff", PERSIST, 0.3, 0.3, 0.3);
	shader_uniform(lshdr, "wdiffuse",  "fff", PERSIST, 0.6, 0.6, 0.6); 

	image_shader(modelv, lshdr);
	return lshdr;
end

local function datashare(wnd)
	local res  = awbwman_setup_cursortag(sysicons.floppy);
	res.kind   = "media";
	res.source = wnd;
	return res;
end

local function add_vmedia_top(pwin, active, inactive, fsrv)
	local bar = pwin:add_bar("tt", active, inactive,
		pwin.dir.t.rsize, pwin.dir.t.bsize);
	bar.name = "vmedia_ttbarh";

	local cfg = awbwman_cfg();

	bar:add_icon("clone", "r", cfg.bordericns["clone"],
		function() datashare(pwin); end);

	if (fsrv) then
		bar:add_icon("pause", "l", cfg.bordericns["pause"],  function(self) 

			if (pwin.paused) then
				pwin.paused = nil;
				resume_movie(pwin.canvas.vid);
				image_sharestorage(cfg.bordericns["pause"], self.vid);
			else
				pwin.paused = true;
				pause_movie(pwin.canvas.vid);
				image_sharestorage(cfg.bordericns["play"], self.vid);
			end
		end);

		bar:add_icon("volume", "r", cfg.bordericns["volume"], function(self)
			pwin:focus();
			awbwman_popupslider(0.01, pwin.mediavol, 1.0, function(val)
				pwin:set_mvol(val);
			end, {ref = self.vid});
		end);
	end

	bar.click = function()
		pwin:focus();
	end

	mouse_addlistener(bar, {"click"});
	table.insert(pwin.handlers, bar);
end

local function slide_lightr(caller, status)
	local pwin = caller.parent.parent;

	awbwman_popupslider(0.01, pwin.amb_r, 1.0, function(val)
		shader_uniform(pwin.shader, "wambient", "fff", PERSIST,
			pwin.amb_r, pwin.amb_g, pwin.amb_b);
	end, {ref = caller.vid});
	return true;
end
local function slide_lightg(caller, status)
	local pwin = caller.parent.parent;
	pwin:focus();

	awbwman_popupslider(0.01, pwin.amb_g, 1.0, function(val)
		pwin.amb_g = val;
		shader_uniform(pwin.shader, "wambient", "fff", PERSIST,
			pwin.amb_r, pwin.amb_g, pwin.amb_b);
	end, {ref = caller.vid});
	return true;
end

local function slide_lightb(caller, status)
	local pwin = caller.parent.parent;
	pwin:focus();

	awbwman_popupslider(0.01, pwin.amb_b, 1.0, function(val)
		pwin.amb_b = val;
		shader_uniform(pwin.shader, "wambient", "fff", PERSIST,
			pwin.amb_r, pwin.amb_g, pwin.amb_b);
	end, {ref = caller.vid});
	return true;
end

local function zoom_in(self)
	local pwin = self.parent.parent;
	pwin:focus();

	props = image_surface_properties(pwin.model.vid);
	move3d_model(pwin.model.vid, props.x, props.y, props.z + 1.0, 
		awbwman_cfg().animspeed);
end

local function zoom_out(self)
	local pwin = self.parent.parent;
	pwin:focus();

	props = image_surface_properties(pwin.model.vid);
	move3d_model(pwin.model.vid, props.x, props.y, props.z - 1.0,
		awbwman_cfg().animspeed);
end

local function add_3dmedia_top(pwin, active, inactive)
	local bar = pwin:add_bar("tt", active, inactive, 
		pwin.dir.t.rsize, pwin.dir.t.bsize);
	local cfg = awbwman_cfg();

	bar:add_icon("zoom_in", "l", cfg.bordericns["plus"], zoom_in); 
	bar:add_icon("zoom_out", "l", cfg.bordericns["minus"], zoom_out);

	bar:add_icon("light_r", "l", cfg.bordericns["r1"], slide_lightr);
	bar:add_icon("light_g", "l", cfg.bordericns["g1"], slide_lightg);
	bar:add_icon("light_b", "l", cfg.bordericns["b1"], slide_lightb);

	bar:add_icon("clone", "r", cfg.bordericns["clone"], 
		function() datashare(pwin); end);

	bar.click = function()
		pwin:focus(true);
	end
	
	mouse_addlistener(bar, {"click"});
	table.insert(pwin.handlers, bar);
end

local function vcap_setup(pwin)
	local bar = pwin.dir.tt;
	local tbl = {};
	for i=0,9 do
		table.insert(tbl, tostring(i));
	end
	local msg = table.concat(tbl, [[\n\r]]);
	local capstr = "capture:device=%d";

	bar:add_icon("add", "l", awbwman_cfg().bordericns["plus"], function(icn)
		local vid, lines = desktoplbl(msg);
		awbwman_popup(vid, lines, function(ind)
			local vid = load_movie(string.format(capstr, ind), FRAMESERVER_NOLOOP,
			function(source, status)
				if (status.kind == "frameserver_terminated") then
					pwin:update_canvas(color_surface(1, 1, 100, 100, 100));
				end
			end);
			pwin:update_canvas(vid);
		end, {ref = icn.vid});
	end);

end

function input_3dwin(self, iotbl)
	if (iotbl.active == false or iotbl.lutsym == nil) then
		return;
	end

	if (iotbl.lutsym) then
		if (iotbl.lutsym == "UP" or 
			iotbl.lutsym == "PAGEUP" or iotbl.lutsym == "w") then
			zoom_in({parent = {parent = self}});	

		elseif (iotbl.lutsym == "DOWN" or 
			iotbl.lutsym ==" PAGEDOWN" or iotbl.lutsym == "s") then
			zoom_out({parent = {parent = self}});
	
		elseif (iotbl.lutsym == "LEFT") then
			rotate3d_model(self.model.vid, 0.0, 0.0, -15, 5, ROTATE_RELATIVE);

		elseif (iotbl.lutsym == "RIGHT") then
			rotate3d_model(self.model.vid, 0.0, 0.0, 15, 5, ROTATE_RELATIVE);
		end
	end	
end

function awbwnd_media(pwin, kind, source, active, inactive)
	local callback;

	if (kind == "frameserver" or 
		kind == "capture" or kind == "static") then
		
		local canvash = {
			name  = kind .. "_canvash",
			own   = function(self, vid) return vid == pwin.canvas.vid; end,
			click = function() pwin:focus(); end
		}

		mouse_addlistener(canvash, {"click"});
		table.insert(pwin.handlers, canvash);
	end

	if (kind == "frameserver") then
		add_vmedia_top(pwin, active, inactive, true);
		pwin.mediavol = 1.0;

		pwin.set_mvol = function(self, val)
			pwin.mediavol = val;
			local tmpvol = awbwman_cfg().global_vol * pwin.mediavol; 
			tmpvol = tmpvol < 0 and 0 or tmpvol;
			if (pwin.recv ~= nil) then
				audio_gain(pwin.recv, tmpvol);	
			end
		end
	
		callback = function(source, status)
			if (status.kind == "resized") then
				local vid, aud = play_movie(source);
				pwin.recv = aud;
				pwin:update_canvas(source);
				pwin:resize(status.width, status.height);
			end
		end

	elseif (kind == "capture") then
		add_vmedia_top(pwin, active, inactive);
		vcap_setup(pwin);

	elseif (kind == "static") then
		add_vmedia_top(pwin, active, inactive);
	
		callback = function(source, status) 
			if (status.kind == "loaded") then
				pwin:update_canvas(source, false);
				pwin:resize(status.width, status.height);
			end
		end

	elseif (kind == "3d" and source) then
		local dstvid = fill_surface(VRESW, VRESH, 0, 0, 0, VRESW, VRESH);
		image_tracetag(dstvid, "3dmedia_rendertarget");
		pwin.shader = set_shader(source.vid);
		show_image(source.vid);

		define_rendertarget(dstvid, {source.vid}, 
			RENDERTARGET_DETACH, RENDERTARGET_NOSCALE, 1, 1);
	
		local camera = null_surface(1, 1);
		scale3d_model(camera, 1.0, -1.0, 1.0);
		rotate3d_model(camera, 0.01, 0.01, 0.01);
		rendertarget_attach(dstvid, camera, RENDERTARGET_DETACH);
		camtag_model(camera, 0.01, 100.0, 45.0);

		pwin:update_canvas(dstvid, false);
		pwin.model = source;
		pwin.input = input_3dwin;
		pwin.amb_r = 0.3;
		pwin.amb_g = 0.3;
		pwin.amb_b = 0.3;

		local mh = {
			name = "3dwindow_canvas",
			own = function(self, vid) return vid == dstvid; end,
	
			drag = function(self, vid, dx, dy)
				pwin:focus();
				rotate3d_model(source.vid, 0.0, dy, dx, 0, ROTATE_RELATIVE);
			end,

			over = function(self, vid)
				local tag = awbwman_cursortag();
				if (tag and tag.kind == "media" and vid == pwin.canvas.vid) then
					tag:hint(true);
				end
			end,

			out = function()
				local tag = awbwman_cursortag();
				if (tag and tag.kind == "media") then
					tag:hint(false);
				end
			end,

			click = function()
				local tag = awbwman_cursortag();
				print("pwin click");
				pwin:focus();

				if (tag and tag.kind == "media") then
					local newdisp = null_surface(32, 32);
					image_sharestorage(tag.source.canvas.vid, newdisp);
					pwin.model:update_display(newdisp);
					tag:drop();
				end
			end
		};
	
		mouse_addlistener(mh, {"drag", "click", "over", "out"});
		add_3dmedia_top(pwin, active, inactive);
		table.insert(pwin.handlers, mh);
	else
		warning("awbwnd_media() media type: " .. kind .. "unknown\n");
	end

	return callback; 
end
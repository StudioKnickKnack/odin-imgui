package imgui_impl_wgpu

import imgui "../"
import "vendor:wgpu"

when      ODIN_OS == .Windows do foreign import lib "../imgui_windows_x64.lib"
else when ODIN_OS == .Linux   do foreign import lib "../imgui_linux_x64.a"
else when ODIN_OS == .Darwin {
	when ODIN_ARCH == .amd64 { foreign import lib "../imgui_darwin_x64.a" } else { foreign import lib "../imgui_darwin_arm64.a" }
}

// imgui_impl_wgpu.h
// Last checked `v1.90.3-docking` (eb42e1)
InitInfo :: struct {
	Device:                   wgpu.Device,
	NumFramesInFlight:        i32,
	RenderTargetFormat:       wgpu.TextureFormat,
	DepthStencilFormat:       wgpu.TextureFormat,
	PipelineMultisampleState: wgpu.MultisampleState,
}

// In Dear ImGui, `InitInfo` has a constructor and field defaults. This is the equivalent
INIT_INFO_DEFAULT :: InitInfo {
	RenderTargetFormat = .Undefined,
	DepthStencilFormat = .Undefined,
	PipelineMultisampleState = {
		count                  = 1,
		mask                   = ~u32(0), // -1u
		alphaToCoverageEnabled = false,
	}
}

@(link_prefix="ImGui_ImplWGPU_")
foreign lib {
	Init           :: proc(init_info: ^InitInfo) -> bool ---
	Shutdown       :: proc() ---
	NewFrame       :: proc() ---
	RenderDrawData :: proc(draw_data: ^imgui.DrawData, pass_encoder: wgpu.RenderPassEncoder) ---

	// Use if you want to reset your rendering device without losing Dear ImGui state.
	InvalidateDeviceObjects :: proc() ---
	CreateDeviceObjects     :: proc() -> bool ---
}

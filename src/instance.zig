const std = @import("std");

const _chained_struct = @import("chained_struct.zig");
const ChainedStruct = _chained_struct.ChainedStruct;
const ChainedStructOut = _chained_struct.ChainedStructOut;
const SType = _chained_struct.SType;

const _adapter = @import("adapter.zig");
const Adapter = _adapter.Adapter;
const RequestAdapterOptions = _adapter.RequestAdapterOptions;
const RequestAdapterCallbackInfo = _adapter.RequestAdapterCallbackInfo;
const RequestAdapterCallback = _adapter.RequestAdapterCallback;
const RequestAdapterStatus = _adapter.RequestAdapterStatus;
const RequestAdapterResponse = _adapter.RequestAdapterResponse;
const BackendType = _adapter.BackendType;

const _surface = @import("surface.zig");
const Surface = _surface.Surface;
const SurfaceDescriptor = _surface.SurfaceDescriptor;

const _misc = @import("misc.zig");
const WGPUFlags = _misc.WGPUFlags;
const WGPUBool = _misc.WGPUBool;
const StringView = _misc.StringView;
const Status = _misc.Status;

const _async = @import("async.zig");
const Future = _async.Future;
const WaitStatus = _async.WaitStatus;
const FutureWaitInfo = _async.FutureWaitInfo;

pub const InstanceBackend = WGPUFlags;
pub const InstanceBackends = struct {
    pub const all            = @as(InstanceBackend, 0x00000000);
    pub const vulkan         = @as(InstanceBackend, 0x00000001);
    pub const gl             = @as(InstanceBackend, 0x00000002);
    pub const metal          = @as(InstanceBackend, 0x00000004);
    pub const dx12           = @as(InstanceBackend, 0x00000008);
    pub const dx11           = @as(InstanceBackend, 0x00000010);
    pub const browser_webgpu = @as(InstanceBackend, 0x00000020);
    pub const primary        = vulkan | metal | dx12 | browser_webgpu;
    pub const secondary      = gl | dx11;
};

pub const InstanceFlag = WGPUFlags;
pub const InstanceFlags = struct {
    pub const default            = @as(InstanceFlag, 0x00000000);
    pub const debug              = @as(InstanceFlag, 0x00000001);
    pub const validation         = @as(InstanceFlag, 0x00000002);
    pub const discard_hal_labels = @as(InstanceFlag, 0x00000004);
};

pub const Dx12Compiler = enum(u32) {
    @"undefined" = 0x00000000,
    fxc          = 0x00000001,
    dxc          = 0x00000002,
};

pub const Gles3MinorVersion = enum(u32) {
    automatic  = 0x00000000,
    version_0  = 0x00000001,
    version_1  = 0x00000002,
    version_2  = 0x00000003,
};

pub const DxcMaxShaderModel = enum(u32) {
    dxc_max_shader_model_v6_0 = 0x00000000,
    dxc_max_shader_model_v6_1 = 0x00000001,
    dxc_max_shader_model_v6_2 = 0x00000002,
    dxc_max_shader_model_v6_3 = 0x00000003,
    dxc_max_shader_model_v6_4 = 0x00000004,
    dxc_max_shader_model_v6_5 = 0x00000005,
    dxc_max_shader_model_v6_6 = 0x00000006,
    dxc_max_shader_model_v6_7 = 0x00000007,
};

pub const GLFenceBehaviour = enum(u32) {
    gl_fence_behaviour_normal      = 0x00000000,
    gl_fence_behaviour_auto_finish = 0x00000001,
};

pub const InstanceExtras = struct {
    backends: InstanceBackend,
    flags: InstanceFlag,
    dx12_shader_compiler: Dx12Compiler,
    gles3_minor_version: Gles3MinorVersion,
    gl_fence_behavior: GLFenceBehaviour,
    dxil_path: [] u8 = "",
    dxc_path: []u8 = "",
    dxc_max_shader_model: DxcMaxShaderModel,
};

const WGPUInstanceExtras = extern struct {
    chain: ChainedStruct = ChainedStruct {
        .s_type = SType.instance_extras,
    },
    backends: InstanceBackend,
    flags: InstanceFlag,
    dx12_shader_compiler: Dx12Compiler,
    gles3_minor_version: Gles3MinorVersion,
    gl_fence_behavior: GLFenceBehaviour,
    dxil_path: StringView = StringView {},
    dxc_path: StringView = StringView {},
    dxc_max_shader_model: DxcMaxShaderModel,
};

pub const InstanceCapabilities = struct {
    // This struct chain is used as mutable in some places and immutable in others.
    next_in_chain: ?*ChainedStructOut = null,

    // Enable use of Instance.waitAny() with `timeoutNS > 0`.
    timed_wait_any_enable: bool,

    // The maximum number FutureWaitInfo supported in a call to Instance.waitAny() with `timeoutNS > 0`.
    timed_wait_any_max_count: usize,
};

const WGPUInstanceCapabilities = extern struct {
    // This struct chain is used as mutable in some places and immutable in others.
    next_in_chain: ?*ChainedStructOut = null,

    // Enable use of ::wgpuInstanceWaitAny with `timeoutNS > 0`.
    timed_wait_any_enable: WGPUBool,

    // The maximum number FutureWaitInfo supported in a call to ::wgpuInstanceWaitAny with `timeoutNS > 0`.
    timed_wait_any_max_count: usize,
};

pub const InstanceDescriptor = struct {
    features: InstanceCapabilities,
    native_extras: ?InstanceExtras = null,
};

const WGPUInstanceDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,

    // Instance features to enable
    features: WGPUInstanceCapabilities,

    // pub inline fn withNativeExtras(self: InstanceDescriptor, extras: *InstanceExtras) InstanceDescriptor {
    //     var id = self;
    //     id.next_in_chain = @ptrCast(extras);
    //     return id;
    // }
};

pub const WGSLLanguageFeatureName = enum(u32) {
    readonly_and_readwrite_storage_textures = 0x00000001,
    packed4x8_integer_dot_product           = 0x00000002,
    unrestricted_pointer_parameters         = 0x00000003,
    pointer_composite_access                = 0x00000004,
};

extern fn wgpuSupportedWGSLLanguageFeaturesFreeMembers(supported_wgsl_language_features: SupportedWGSLLanguageFeatures) void;

pub const SupportedWGSLLanguageFeatures = struct {
    features: []const WGSLLanguageFeatureName,
};

const WGPUSupportedWGSLLanguageFeatures = extern struct {
    feature_count: usize,
    features: [*]const WGSLLanguageFeatureName,

    // Unimplemented as of wgpu-native v25.0.2.1,
    // see https://github.com/gfx-rs/wgpu-native/blob/d8238888998db26ceab41942f269da0fa32b890c/src/unimplemented.rs#L193
    // pub inline fn freeMembers(self: SupportedWGSLLanguageFeatures) void {
    //     wgpuSupportedWGSLLanguageFeaturesFreeMembers(self);
    // }
};

extern fn wgpuGetInstanceCapabilities(capabilities: *WGPUInstanceCapabilities) Status;

extern fn wgpuCreateInstance(descriptor: ?*const WGPUInstanceDescriptor) ?*Instance;
extern fn wgpuInstanceCreateSurface(instance: *Instance, descriptor: *const SurfaceDescriptor) ?*Surface;
extern fn wgpuInstanceGetWGSLLanguageFeatures(instance: *Instance, features: *SupportedWGSLLanguageFeatures) Status;
extern fn wgpuInstanceHasWGSLLanguageFeature(instance: *Instance, feature: WGSLLanguageFeatureName) WGPUBool;
extern fn wgpuInstanceProcessEvents(instance: *Instance) void;
extern fn wgpuInstanceRequestAdapter(instance: *Instance, options: ?*const RequestAdapterOptions, callback_info: RequestAdapterCallbackInfo) Future;
extern fn wgpuInstanceWaitAny(instance: *Instance, future_count: usize, futures: ?[*] FutureWaitInfo, timeout_ns: u64) WaitStatus;
extern fn wgpuInstanceAddRef(instance: *Instance) void;
extern fn wgpuInstanceRelease(instance: *Instance) void;

pub const RegistryReport = extern struct {
    num_allocated: usize,
    num_kept_from_user: usize,
    num_released_from_user: usize,
    element_size: usize,
};

pub const HubReport = extern struct {
    adapters: RegistryReport,
    devices: RegistryReport,
    queues: RegistryReport,
    pipeline_layouts: RegistryReport,
    shader_modules: RegistryReport,
    bind_group_layouts: RegistryReport,
    bind_groups: RegistryReport,
    command_buffers: RegistryReport,
    render_bundles: RegistryReport,
    render_pipelines: RegistryReport,
    compute_pipelines: RegistryReport,
    pipeline_caches: RegistryReport,
    query_sets: RegistryReport,
    buffers: RegistryReport,
    textures: RegistryReport,
    texture_views: RegistryReport,
    samplers: RegistryReport,
};

pub const GlobalReport = extern struct {
    surfaces: RegistryReport,
    hub: HubReport,
};

pub const EnumerateAdapterOptions = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    backends: InstanceBackend,
};

// wgpu-native
extern fn wgpuGenerateReport(instance: *Instance, report: *GlobalReport) void;
extern fn wgpuInstanceEnumerateAdapters(instance: *Instance, options: ?*EnumerateAdapterOptions, adapters: ?[*]*Adapter) usize;

pub const InstanceError = error {
    FailedToCreateInstance,
    FailedToGetCapabilities,
} || std.mem.Allocator.Error;

pub const Instance = opaque {
    // This is a global function, but it creates an instance so I put it here.
    pub fn create(descriptor: ?InstanceDescriptor) InstanceError!*Instance {
        var maybe_instance: ?*Instance = undefined;
        if (descriptor) |d| {
            var instance_extras: ?*const ChainedStruct = undefined;
            if (d.native_extras) |native_extras| {
                instance_extras = @ptrCast(&WGPUInstanceExtras {
                    .backends = native_extras.backends,
                    .flags = native_extras.flags,
                    .dx12_shader_compiler = native_extras.dx12_shader_compiler,
                    .gles3_minor_version = native_extras.gles3_minor_version,
                    .gl_fence_behavior = native_extras.gl_fence_behavior,
                    .dxil_path = StringView.fromSlice(native_extras.dxil_path),
                    .dxc_path = StringView.fromSlice(native_extras.dxc_path),
                    .dxc_max_shader_model = native_extras.dxc_max_shader_model,
                });
            } else {
                instance_extras = null;
            }

            maybe_instance = wgpuCreateInstance(&WGPUInstanceDescriptor {
                .next_in_chain = instance_extras,
                .features = WGPUInstanceCapabilities {
                    .timed_wait_any_enable = @intFromBool(d.features.timed_wait_any_enable),
                    .timed_wait_any_max_count = d.features.timed_wait_any_max_count,
                },
            });
        } else {
            maybe_instance = wgpuCreateInstance(null);
        }

        return maybe_instance orelse InstanceError.FailedToCreateInstance;
    }

    // This is also a global function, but I think it would make sense being a member of Instance;
    // You'd use it like `const capabilities = try Instance.getCapabilities();`
    pub inline fn getCapabilities() InstanceError!InstanceCapabilities {
        var wgpu_capabilities: WGPUInstanceCapabilities = undefined;
        if (wgpuGetInstanceCapabilities(&wgpu_capabilities) == Status.success) {
            return InstanceCapabilities {
                .next_in_chain = wgpu_capabilities.next_in_chain,
                .timed_wait_any_enable = wgpu_capabilities.timed_wait_any_enable != 0,
                .timed_wait_any_max_count = wgpu_capabilities.timed_wait_any_max_count,
            };
        } else {
            return InstanceError.FailedToGetCapabilities;
        }
    }

    pub inline fn createSurface(self: *Instance, descriptor: *const SurfaceDescriptor) ?*Surface {
        return wgpuInstanceCreateSurface(self, descriptor);
    }

    // Unimplemented as of wgpu-native v25.0.2.1,
    // see https://github.com/gfx-rs/wgpu-native/blob/d8238888998db26ceab41942f269da0fa32b890c/src/unimplemented.rs#L100
    // pub inline fn getWGSLLanguageFeatures(self: *Instance, features: *SupportedWGSLLanguageFeatures) Status {
    //     return wgpuInstanceGetWGSLLanguageFeatures(self, features);
    // }

    // Unimplemented as of wgpu-native v25.0.2.1,
    // see https://github.com/gfx-rs/wgpu-native/blob/d8238888998db26ceab41942f269da0fa32b890c/src/unimplemented.rs#L108
    // pub inline fn hasWGSLLanguageFeature(self: *Instance, feature: WGSLLanguageFeatureName) bool {
    //     return wgpuInstanceHasWGSLLanguageFeature(self, feature) != 0;
    // }

    // Processes asynchronous events on this Instance, calling any callbacks for asynchronous operations created with `CallbackMode.allow_process_events`.
    pub inline fn processEvents(self: *Instance) void {
        wgpuInstanceProcessEvents(self);
    }

    fn defaultAdapterCallback(status: RequestAdapterStatus, adapter: ?*Adapter, message: StringView, userdata1: ?*anyopaque, userdata2: ?*anyopaque) callconv(.C) void {
        const ud_response: *RequestAdapterResponse = @ptrCast(@alignCast(userdata1));
        ud_response.* = RequestAdapterResponse {
            .status = status,
            .message = message.toSlice(),
            .adapter = adapter,
        };

        const completed: *bool = @ptrCast(@alignCast(userdata2));
        completed.* = true;
    }

    // This is a synchronous wrapper that handles asynchronous (callback) logic.
    // It uses polling to see when the request has been fulfilled, so needs a polling interval parameter.
    pub fn requestAdapterSync(self: *Instance, options: ?*const RequestAdapterOptions, polling_interval_nanoseconds: u64) RequestAdapterResponse {
        var response: RequestAdapterResponse = undefined;
        var completed = false;
        const callback_info = RequestAdapterCallbackInfo {
            .callback = defaultAdapterCallback,
            .userdata1 = @ptrCast(&response),
            .userdata2 = @ptrCast(&completed),
        };
        const adapter_future = wgpuInstanceRequestAdapter(self, options, callback_info);

        // TODO: Revisit once Instance.waitAny() is implemented in wgpu-native,
        //       it takes in futures and returns when one of them completes.
        _ = adapter_future;
        self.processEvents();
        while (!completed) {
            std.Thread.sleep(polling_interval_nanoseconds);
            self.processEvents();
        }

        return response;
    }

    pub inline fn requestAdapter(self: *Instance, options: ?*const RequestAdapterOptions, callback_info: RequestAdapterCallbackInfo) Future {
        return wgpuInstanceRequestAdapter(self, options, callback_info);
    }

    // Unimplemented as of wgpu-native v25.0.2.1,
    // see https://github.com/gfx-rs/wgpu-native/blob/d8238888998db26ceab41942f269da0fa32b890c/src/unimplemented.rs#L224
    // Wait for at least one Future in `futures` to complete, and call callbacks of the respective completed asynchronous operations.
    // pub inline fn waitAny(self: *Instance, future_count: usize, futures: ?[*] FutureWaitInfo, timeout_ns: u64) WaitStatus {
    //     return wgpuInstanceWaitAny(self, future_count, futures, timeout_ns);
    // }

    pub inline fn addRef(self: *Instance) void {
        wgpuInstanceAddRef(self);
    }


    pub inline fn release(self: *Instance) void {
        wgpuInstanceRelease(self);
    }

    // wgpu-native
    pub inline fn generateReport(self: *Instance, report: *GlobalReport) void {
        wgpuGenerateReport(self, report);
    }

    // Allocates memory to store the list of Adapters
    pub inline fn enumerateAdapters(self: *Instance, allocator: std.mem.Allocator, options: ?*EnumerateAdapterOptions) InstanceError![]*Adapter {
        const count = wgpuInstanceEnumerateAdapters(self, options, null);
        const adapters = try allocator.alloc(*Adapter, count);

        // TODO: Should we bother checking the returned count at this point or just trust that it matches what we got in the previous call?
        _ = wgpuInstanceEnumerateAdapters(self, options, adapters.ptr);
        return adapters;
    }
};

test "can create instance (and release it afterwards)" {
    const instance = try Instance.create(null);
    instance.release();
}

test "can request adapter" {
    const testing = @import("std").testing;

    const instance = try Instance.create(null);
    const response = instance.requestAdapterSync(null, 200_000_000);
    const adapter: ?*Adapter = switch(response.status) {
        .success => response.adapter,
        else => null,
    };
    try testing.expect(adapter != null);
}

test "can enumerate adapters" {
    const testing = @import("std").testing;

    const instance = try Instance.create(null);
    const adapters = try instance.enumerateAdapters(testing.allocator, null);
    defer testing.allocator.free(adapters);
    try testing.expect(adapters.len != 0);
}
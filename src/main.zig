// src/main.zig
const std = @import("std");
const builtin = @import("builtin");

const jetzig = @import("jetzig");
const zmd = @import("zmd");

pub const routes = @import("routes");

pub const formats: jetzig.Route.Formats = .{
    .index = &.{.json},
    .get = &.{.json},
    .post = &.{.json},
    .put = &.{.json},
    .delete = &.{.json},
    .patch = &.{.json},
    .custom = &.{.json},
    .new = &.{.json},
    .edit = &.{.json},
};

// Override default settings in `jetzig.config` here:
pub const jetzig_options = struct {
    /// Middleware chain with our new logging middleware
    pub const middleware: []const type = &.{
        @import("app/middleware/LoggingMiddleware.zig"),
    };

    // Set the host address to 0.0.0.0 to make it accessible from external networks
    pub const host = "0.0.0.0";

    // You can also specify a different port if needed (default is 8080)
    pub const port = 8080;

    pub const log_level: jetzig.log.Level = .debug;
    // Maximum bytes to allow in request body.
    pub const max_bytes_request_body: usize = std.math.pow(usize, 2, 16);

    // Maximum filesize for `public/` content.
    pub const max_bytes_public_content: usize = std.math.pow(usize, 2, 20);

    // Maximum filesize for `static/` content (applies only to apps using `jetzig.http.StaticRequest`).
    pub const max_bytes_static_content: usize = std.math.pow(usize, 2, 18);

    // Maximum length of a header name.
    pub const max_bytes_header_name: u16 = 40;

    /// Maximum number of `multipart/form-data`-encoded fields to accept per request.
    pub const max_multipart_form_fields: usize = 20;

    // Log message buffer size.
    pub const log_message_buffer_len: usize = 4096;

    // Maximum log pool size.
    pub const max_log_pool_len: usize = 256;

    // Number of request threads. Defaults to number of detected CPUs.
    pub const thread_count: ?u16 = null;

    // Number of response worker threads.
    pub const worker_count: u16 = 4;

    // Total number of connections managed by worker threads.
    pub const max_connections: u16 = 512;

    // Per-thread stack memory
    pub const buffer_size: usize = 64 * 1024;

    // Arena size
    pub const arena_size: usize = 1024 * 1024;

    // Path relative to cwd() to serve public content from.
    pub const public_content_path = "public";

    // HTTP buffer size
    pub const http_buffer_size: usize = std.math.pow(usize, 2, 16);

    // Job worker threads
    pub const job_worker_threads: usize = 4;

    // Job worker sleep interval
    pub const job_worker_sleep_interval_ms: usize = 10;

    /// Database Schema reference
    pub const Schema = @import("Schema");

    /// HTTP cookie configuration
    pub const cookies: jetzig.http.Cookies.CookieOptions = switch (jetzig.environment) {
        .development, .testing => .{
            .domain = "localhost",
            .path = "/",
        },
        .production => .{
            .same_site = .lax,
            .secure = true,
            .http_only = true,
            .path = "/",
        },
    };

    // Store configuration - using in-memory for simplicity
    pub const store: jetzig.kv.Store.Options = .{
        .backend = .memory,
    };

    // Job queue configuration
    pub const job_queue: jetzig.kv.Store.Options = .{
        .backend = .memory,
    };

    pub const formats: jetzig.Route.Formats = .{
        .index = &.{.json},
        .get = &.{.json},
        .post = &.{.json},
        .put = &.{.json},
        .delete = &.{.json},
        .patch = &.{.json},
        .custom = &.{.json},
        .new = &.{.json},
        .edit = &.{.json},
    };

    // Cache configuration
    pub const cache: jetzig.kv.Store.Options = .{
        .backend = .memory,
    };

    // Force development email delivery setting
    pub const force_development_email_delivery = false;

    // Markdown configuration (simplified)
    pub const markdown_fragments = struct {
        pub const root = .{ "<div>", "</div>" };
    };
};

pub fn init(app: *jetzig.App) !void {
    // Product API routes
    app.route(.GET, "/api/products", @import("app/api/products.zig"), .index);
    app.route(.GET, "/api/products/:id", @import("app/api/products.zig"), .get);
    app.route(.POST, "/api/products", @import("app/api/products.zig"), .post);
    app.route(.PUT, "/api/products/:id", @import("app/api/products.zig"), .put);
    app.route(.DELETE, "/api/products/:id", @import("app/api/products.zig"), .delete);

    // Health endpoint
    app.route(.GET, "/api/health", @import("app/api/health.zig"), .get);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = if (builtin.mode == .Debug) gpa.allocator() else std.heap.c_allocator;
    defer if (builtin.mode == .Debug) std.debug.assert(gpa.deinit() == .ok);

    var app = try jetzig.init(allocator);
    defer app.deinit();

    // Log server startup information
    // Use the environment logger instead of directly accessing app.logger
    try app.env.logger.INFO(
        "Starting server on {s}:{d}",
        .{
            jetzig_options.host,
            jetzig_options.port,
        },
    );

    try app.start(routes, .{});
}

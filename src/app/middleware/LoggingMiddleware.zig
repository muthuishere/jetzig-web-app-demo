const std = @import("std");
const jetzig = @import("jetzig");

pub const name = "LoggingMiddleware";

// This middleware logs all requests and responses
const LoggingMiddleware = @This();

pub fn init(request: *jetzig.http.Request) !*LoggingMiddleware {
    const middleware = try request.allocator.create(LoggingMiddleware);
    return middleware;
}

pub fn afterRequest(self: *LoggingMiddleware, request: *jetzig.http.Request) !void {
    _ = self;

    // Use path field directly
    try request.server.logger.INFO(
        "hello [API] Request: {s} {s}",
        .{
            @tagName(request.method),
            request.path.path, // Using the path field directly
        },
    );
}

pub fn beforeResponse(
    self: *LoggingMiddleware,
    request: *jetzig.http.Request,
    response: *jetzig.http.Response,
) !void {
    _ = self;

    try response.headers.append("content-type", "application/json");

    try request.server.logger.INFO(
        "[API] Response: {s} {s} - Status: {s}",
        .{
            @tagName(request.method),
            request.path.path, // Using the path field directly
            @tagName(response.status_code),
        },
    );
}

pub fn afterResponse(
    self: *LoggingMiddleware,
    request: *jetzig.http.Request,
    response: *jetzig.http.Response,
) !void {
    _ = self;
    _ = request;
    _ = response;
}

pub fn deinit(self: *LoggingMiddleware, request: *jetzig.http.Request) void {
    request.allocator.destroy(self);
}

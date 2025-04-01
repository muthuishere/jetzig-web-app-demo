const std = @import("std");
const jetzig = @import("jetzig");

// GET /api/health
pub fn get(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    var health_obj = try data.object();

    try health_obj.put("status", data.string("ok"));
    try health_obj.put("timestamp", data.integer(std.time.milliTimestamp()));
    try health_obj.put("api_version", data.string("1.0.0"));
    try health_obj.put("environment", data.string(@tagName(jetzig.environment)));

    // try request.headers.append("Accept", "application/json");

    // // Set the response content type to JSON
    // request.response.content_type = "application/json";

    // try request.response.headers.append("content_type", "application/json");
    //
    // try request.headers.append("Content-Type", "application/json");

    // request.response.content_type = "application/json";

    // request.setTemplate("json");

    // try request.headers.append("content-type", "application/json");
    return request.render(.ok);
}

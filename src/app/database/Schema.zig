const jetzig = @import("jetzig");
const jetquery = jetzig.jetquery;

pub const Product = jetquery.Model(@This(), "zigproducts", struct {
    id: i32,
    name: []const u8,
    description: []const u8,
    price: f64,
    created_at: jetquery.DateTime,
    updated_at: jetquery.DateTime,
}, .{});

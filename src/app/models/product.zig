const std = @import("std");
const jetzig = @import("jetzig");

pub const Product = struct {
    id: ?i64 = null,
    name: []const u8,
    description: []const u8,
    price: f64,

    // Create a product from data
    pub fn fromData(allocator: std.mem.Allocator, _: *jetzig.Data, value: *jetzig.Data.Value) !*Product {
        var product = try allocator.create(Product);

        product.name = try allocator.dupe(u8, value.getT(.string, "name") orelse "");
        product.description = try allocator.dupe(u8, value.getT(.string, "description") orelse "");

        // Convert f128 to f64 explicitly
        if (value.getT(.float, "price")) |price_float| {
            product.price = @floatCast(price_float);
        } else {
            product.price = 0.0;
        }

        if (value.get("id")) |id_value| {
            // Fix: Use the correct approach to get the integer value directly
            switch (id_value.*) {
                .integer => |int_value| {
                    product.id = @intCast(int_value.value);
                },
                else => {}, // Do nothing if it's not an integer
            }
        }

        return product;
    }

    // Convert to data value
    pub fn toData(self: *const Product, data: *jetzig.Data) !*jetzig.Data.Value {
        var obj = try data.object();

        if (self.id) |id| {
            try obj.put("id", data.integer(id));
        }

        try obj.put("name", data.string(self.name));
        try obj.put("description", data.string(self.description));
        try obj.put("price", data.float(self.price));

        return obj;
    }
};

// zig-crud/src/app/api/products.zig
const std = @import("std");
const jetzig = @import("jetzig");
const Query = jetzig.database.Query;

// GET /api/products
pub fn index(request: *jetzig.Request) !jetzig.View {
    const query = Query(.Product).orderBy(.{ .created_at = .desc });
    const products = try request.repo.all(query);

    var root = try request.data(.object);
    try root.put("products", products);

    return request.render(.ok);
}

pub fn post(request: *jetzig.Request) !jetzig.View {
    const Params = struct {
        name: []const u8,
        description: []const u8, // Changed from optional to mandatory
        price: f64,
    };

    const params = try request.expectParams(Params) orelse {
        return request.fail(.unprocessable_entity);
    };

    try request.repo.insert(.Product, .{
        .name = params.name,
        .description = params.description,
        .price = params.price,
    });

    return request.render(.created);
}

pub fn get(id: []const u8, request: *jetzig.Request) !jetzig.View {
    const query = Query(.Product).find(id);
    const product = try request.repo.execute(query) orelse {
        return request.fail(.not_found);
    };

    var root = try request.data(.object);
    try root.put("product", product);

    return request.render(.ok);
}

// PUT /api/products/:id
pub fn put(id: []const u8, request: *jetzig.Request) !jetzig.View {
    const query = Query(.Product).find(id);
    var product = try request.repo.execute(query) orelse {
        return request.fail(.not_found);
    };

    const Params = struct {
        name: ?[]const u8,
        description: ?[]const u8,
        price: ?f64,
    };

    const params = try request.expectParams(Params) orelse {
        return request.fail(.unprocessable_entity);
    };

    // Update fields if provided
    if (params.name) |name| {
        product.name = name;
    }

    if (params.description) |description| {
        product.description = description;
    }

    if (params.price) |price| {
        product.price = price;
    }

    try request.repo.save(product);

    var root = try request.data(.object);
    try root.put("product", product);

    return request.render(.ok);
}

// DELETE /api/products/:id
pub fn delete(id: []const u8, request: *jetzig.Request) !jetzig.View {
    const query = Query(.Product).find(id);
    const product = try request.repo.execute(query) orelse {
        return request.fail(.not_found);
    };

    try request.repo.delete(product);

    return request.render(.no_content);
}

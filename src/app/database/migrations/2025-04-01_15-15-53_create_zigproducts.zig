const std = @import("std");
const jetquery = @import("jetquery");
const t = jetquery.schema.table;

pub fn up(repo: anytype) !void {
    try repo.createTable(
        "zigproducts",
        &.{
            t.primaryKey("id", .{}),
            t.column("name", .string, .{}),
            t.column("description", .text, .{}),
            t.column("price", .decimal, .{}),
            t.timestamps(.{}),
        },
        .{},
    );
}

pub fn down(repo: anytype) !void {
    try repo.dropTable("zigproducts", .{});
}

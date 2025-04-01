pub const database = .{
    // Null adapter fails when a database call is invoked.
    .development = .{
        .adapter = .postgresql,
        .hostname = "localhost",
        .port = 5472,
        .username = "postgres",
        .password = "postgres",
        .database = "postgres",
    },
    .testing = .{
        .adapter = .postgresql,
        .hostname = "localhost",
        .port = 5472,
        .username = "postgres",
        .password = "postgres",
        .database = "postgres",
    },
    .production = .{
        .adapter = .postgresql,
        .hostname = "localhost",
        .port = 5472,
        .username = "postgres",
        .password = "postgres",
        .database = "postgres",
    },
    // PostgreSQL adapter configuration.
    //
    // All options except `adapter` can be configured using environment variables:
    //
    // * JETQUERY_HOSTNAME
    // * JETQUERY_PORT
    // * JETQUERY_USERNAME
    // * JETQUERY_PASSWORD
    // * JETQUERY_DATABASE
    //
    // .testing = .{
    //     .adapter = .postgresql,
    //     .hostname = "localhost",
    //     .port = 5432,
    //     .username = "postgres",
    //     .password = "password",
    //     .database = "myapp_testing",
    // },
    //
    // .development = .{
    //     .adapter = .postgresql,
    //     .hostname = "localhost",
    //     .port = 5432,
    //     .username = "postgres",
    //     .password = "password",
    //     .database = "myapp_development",
    // },
    //
    // .production = .{
    //     .adapter = .postgresql,
    //     .hostname = "localhost",
    //     .port = 5432,
    //     .username = "postgres",
    //     .password = "password",
    //     .database = "myapp_production",
    // },
};

using Api.Models;
using Microsoft.Data.Sqlite;
using Microsoft.EntityFrameworkCore;
using System.Data.Common;

namespace Api.Test;

internal class TestDbContext : ApplicationContext, IDisposable
{
    private DbConnection _connection = null!;
    private bool _disposeConnection;

    public TestDbContext(DbContextOptions options) : base(options)
    {
    }

    public static TestDbContext Create()
    {
        var connection = CreateDbConnection();

        var dbContext = Create(connection);
        dbContext._disposeConnection = true;
        return dbContext;
    }

    public static DbConnection CreateDbConnection()
    {
        var connection = new SqliteConnection("DataSource=:memory:");
        connection.Open();
        return connection;
    }

    public static TestDbContext Create(DbConnection connection)
    {
        var options = new DbContextOptionsBuilder<TestDbContext>()
            .UseSqlite(connection)
            .Options;

        var testDbContext = new TestDbContext(options)
        {
            _connection = connection,
            _disposeConnection = false
        };
        testDbContext.Database.EnsureCreated();

        return testDbContext;
    }

    public override void Dispose()
    {
        if (_disposeConnection == true)
        {
            _connection?.Dispose();
        }
        base.Dispose();
    }
}

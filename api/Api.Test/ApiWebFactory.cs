using Api.Models;
using Api.Options;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using System.Data.Common;

namespace Api.Test;
public class ApiWebFactory : WebApplicationFactory<IApiMarker>
{
    private readonly DbConnection _database = TestDbContext.CreateDbConnection();

    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        // We configure our services for testing
        builder.ConfigureTestServices(services =>
        {
            services.Configure<HashSettings>(options =>
            {
                options.PlayerSalt = "Player";
                options.PlayerMinLength = 8;
            });

            services.RemoveAll<ApplicationContext>();
            services.AddScoped<ApplicationContext, TestDbContext>(sp => TestDbContext.Create(_database));
        });
    }

    public override ValueTask DisposeAsync()
    {
        _database.Dispose();
        return base.DisposeAsync();
    }

    public HttpClient GetClient(Client client) => client switch
    {
        Client.Unauthorized => UnauthorizedClient,
        _ => throw new ArgumentOutOfRangeException(nameof(client), client, null)
    };

    public HttpClient UnauthorizedClient => _unauthorizedClient ??= CreateUnauthorizedClient();
    private HttpClient _unauthorizedClient = null!;
    private HttpClient CreateUnauthorizedClient()
    {
        var client = CreateClient();

        return client;
    }
}

[CollectionDefinition(Name)]
public class ApiWebFactoryCollection : ICollectionFixture<ApiWebFactory>
{
    public const string Name = "ApiWebFactory Collection";
}

public enum Client
{
    Unauthorized
}
using Api.Options;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.Extensions.DependencyInjection;

namespace Api.Test;
public class ApiWebFactory : WebApplicationFactory<IApiMarker>
{
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
        });
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
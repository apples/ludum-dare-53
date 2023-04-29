using Api.Features.Cycle.Get;

namespace Api.Test.Cycle.Get;

[Collection(ApiWebFactoryCollection.Name)]
public class GetTests
{
    private readonly ApiWebFactory _apiWebFactory;

    public GetTests(ApiWebFactory apiWebFactory)
    {
        _apiWebFactory = apiWebFactory;
    }

    [Fact]
    public async Task Get_Ok()
    {
        // Arrange
        var username = Random.Shared.GenerateRandomString(Random.Shared.Next(1, 16),
            '0'..'9', 'A'..'Z', 'a'..'z',          // Alphanumeric
            '!'..'/', ':'..'@', '['..'`', '{'..'~' // Special characters
        );
        var cycle = 1;

        Models.Player player = new()
        {
            UserName = username,
            CurrentCycle = cycle
        };

        await using var scope = _apiWebFactory.Services.CreateAsyncScope();
        var dbContext = scope.ServiceProvider.GetService<ApplicationContext>()!;

        dbContext.Players.Add(player);
        await dbContext.SaveChangesAsync();

        using var client = _apiWebFactory.CreateAuthorizedClient(player.UserName, player.PlayerID);

        // Act
        var (response, result) = await client.GETAsync<Endpoint, Request, Response>(new()
        {
            Level = "Main"
        });
        
        // Assert
        response.Should().NotBeNull();
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        result.Should().NotBeNull();
        result!.Cycle.Should().Be(cycle);
    }

    [Fact]
    public async Task Get_Unauthorized()
    {
        // Act
        var (response, _) = await _apiWebFactory.UnauthorizedClient.GETAsync<Endpoint, Request, ErrorResponse>(new()
        {
            Level = "Main"
        });

        // Assert
        response.Should().NotBeNull();
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }
}

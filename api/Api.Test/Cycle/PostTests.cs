using Api.Features.Cycle.Post;

namespace Api.Test.Cycle;

[Collection(ApiWebFactoryCollection.Name)]
public class PostTests
{
    private readonly ApiWebFactory _apiWebFactory;

    public PostTests(ApiWebFactory apiWebFactory)
    {
        _apiWebFactory = apiWebFactory;
    }

    [Fact]
    public async Task Post_Ok()
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
        var (response, _) = await client.POSTAsync<Endpoint, Request, EmptyResponse>(new()
        {
            Level = "Main"
        });

        // Assert
        response.Should().NotBeNull();
        response.StatusCode.Should().Be(HttpStatusCode.OK);
    }

    [Fact]
    public async Task Post_Unauthorized()
    {
        // Act
        var (response, _) = await _apiWebFactory.UnauthorizedClient.POSTAsync<Endpoint, Request, ErrorResponse>(new()
        {
            Level = "Main"
        });

        // Assert
        response.Should().NotBeNull();
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }
}

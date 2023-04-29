using Api.Features.Player.Create;

namespace Api.Test.Player;

[Collection(ApiWebFactoryCollection.Name)]
public class CreateTests
{
    private readonly ApiWebFactory _apiWebFactory;

    public CreateTests(ApiWebFactory apiWebFactory)
    {
        _apiWebFactory = apiWebFactory;
    }

    [Fact]
    public async Task Create_Ok()
    {
        // Arrange
        var username = Random.Shared.GenerateRandomString(Random.Shared.Next(1, 16),
            '0'..'9', 'A'..'Z', 'a'..'z',          // Alphanumeric
            '!'..'/', ':'..'@', '['..'`', '{'..'~' // Special characters
        );

        var hashService = _apiWebFactory.Services.GetService<IHashService>()!;

        // Act
        var (response, result) = await _apiWebFactory.UnauthorizedClient.POSTAsync<Endpoint, Request, Response>(new()
        {
            UserName = username
        });

        // Assert
        response.Should().NotBeNull();
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        result.Should().NotBeNull();
        result!.Key.Should().NotBeEmpty();

        var playerID = hashService.DecodePlayerID(result.Key);
        playerID.Should().NotBeNull();

        playerID!.Value.Should().Be(username.Length);
    }
}
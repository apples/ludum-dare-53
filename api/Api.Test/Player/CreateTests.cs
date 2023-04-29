using Api.Features.Player.Create;
using System.Text;

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
        
        await using var scope = _apiWebFactory.Services.CreateAsyncScope();
        var dbContext = scope.ServiceProvider.GetService<ApplicationContext>()!;

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

        var decodedBytes = Convert.FromBase64String(result.Key);
        var decodedString = Encoding.UTF8.GetString(decodedBytes);

        var keySplit = decodedString.Split(':');
        var playerUserName = keySplit[0];
        var playerIDHash = keySplit[1];

        playerUserName.Should().Be(username);

        var playerID = hashService.DecodePlayerID(playerIDHash);
        playerID.Should().NotBeNull();

        var createDbPlayer = await dbContext.Players.FindAsync(playerID);
        createDbPlayer.Should().NotBeNull();
        createDbPlayer!.UserName.Should().Be(username);
        createDbPlayer!.CurrentCycle.Should().Be(0);
    }

    [Fact]
    public async Task Create_BadRequest_Used_UserName()
    {
        // Arrange
        var username = Random.Shared.GenerateRandomString(Random.Shared.Next(1, 16),
            '0'..'9', 'A'..'Z', 'a'..'z',          // Alphanumeric
            '!'..'/', ':'..'@', '['..'`', '{'..'~' // Special characters
        );

        await using var scope = _apiWebFactory.Services.CreateAsyncScope();
        var dbContext = scope.ServiceProvider.GetService<ApplicationContext>()!;

        dbContext.Players.Add(new Models.Player
        {
            UserName = username
        });
        await dbContext.SaveChangesAsync();

        // Act
        var (response, result) = await _apiWebFactory.UnauthorizedClient.POSTAsync<Endpoint, Request, ErrorResponse>(new()
        {
            UserName = username
        });


        // Assert
        response.Should().NotBeNull();
        response!.StatusCode.Should().Be(HttpStatusCode.BadRequest);

        result.Should().NotBeNull();
        result!.Errors.Should().ContainKey("UserName");
        result!.Errors["UserName"].Should().ContainSingle().Which
            .Should().Be($"UserName '{username}' already used");
    }
}
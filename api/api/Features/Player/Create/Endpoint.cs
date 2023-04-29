namespace Api.Features.Player.Create;

public class Endpoint : Endpoint<Request, Response, Mapper>
{
    public override void Configure()
    {
        Post("/player");
        AllowAnonymous();
    }

    public override async Task HandleAsync(Request playerCreateReqest, CancellationToken cancellationToken)
    {
        var requestPlayer = Map.ToEntity(playerCreateReqest);

        requestPlayer.PlayerID = requestPlayer.UserName.Length;

        var response = Map.FromEntity(requestPlayer);

        await SendOkAsync(response, cancellationToken);
    }
}

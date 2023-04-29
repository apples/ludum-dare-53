using Api.Models;

namespace Api.Features.Player.Create;

public class Endpoint : Endpoint<Request, Response, Mapper>
{
    private readonly ApplicationContext _dbContext;

    public Endpoint(ApplicationContext dbContext)
    {
        _dbContext = dbContext;
    }

    public override void Configure()
    {
        Post("/player");
        AllowAnonymous();
    }

    public override async Task HandleAsync(Request playerCreateReqest, CancellationToken cancellationToken)
    {
        var requestPlayer = Map.ToEntity(playerCreateReqest);

        _dbContext.Players.Add(requestPlayer);
        await _dbContext.SaveChangesAsync(cancellationToken);

        var response = Map.FromEntity(requestPlayer);

        await SendOkAsync(response, cancellationToken);
    }
}

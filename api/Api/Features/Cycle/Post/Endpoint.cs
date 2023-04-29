using Api.Models;
using Microsoft.EntityFrameworkCore;

namespace Api.Features.Cycle.Post;

public sealed class Endpoint : Endpoint<Request>
{
    private readonly ApplicationContext _dbContext;

    public Endpoint(ApplicationContext dbContext)
    {
        _dbContext = dbContext;
    }

    public override void Configure()
    {
        Post("/cycle/{Level}");
    }

    public override async Task HandleAsync(Request request, CancellationToken cancellationToken)
    {
        int playerID = this.GetPlayerID();

        var player = await _dbContext.Players.FirstOrDefaultAsync(p =>
            p.PlayerID == playerID, cancellationToken);

        if (player is null)
        {
            ThrowError("Player not found");
        }

        // TODO: Update player cycle tables

        await SendOkAsync(cancellationToken);
    }
}

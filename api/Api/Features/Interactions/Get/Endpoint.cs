using Api.Models;
using Microsoft.EntityFrameworkCore;

namespace Api.Features.Interactions.Get;

public class Endpoint : Endpoint<Request, Response>
{
    private readonly ApplicationContext _dbContext;

    public Endpoint(ApplicationContext dbContext)
    {
        _dbContext = dbContext;
    }

    public override void Configure()
    {
        Get("/interactions/{Level}/{Cycle}");
    }

    public override async Task HandleAsync(Request request, CancellationToken cancellationToken)
    {
        var playerID = this.GetPlayerID();

        var includeTypes = request.IncludeTypes
            .SelectMany(t => t.Split(','))
            .ToArray();
        var excludeTypes = request.ExcludeTypes
            .SelectMany(t => t.Split(','))
            .ToArray();

        var interactions = await _dbContext.Interactions
            .Where(i => i.PlayerID != playerID &&
                i.Level == request.Level &&
                i.Cycle <= request.Cycle &&
                (includeTypes.Length == 0 || includeTypes.Contains(i.InteractionType)) &&
                (excludeTypes.Length == 0 || excludeTypes.Contains(i.InteractionType)))
            .Join(_dbContext.Players,
                i => i.PlayerID,
                p => p.PlayerID,
                (i, p) => new
                {
                    i.InteractionID,
                    i.InteractionType,
                    i.Content,
                    p.UserName,
                })
            .Select(i => new Interaction
            {
                InteractionID = i.InteractionID,
                InteractionType = i.InteractionType,
                Content = i.Content,
                UserName = i.UserName,
            })
            .Take(request.Count)
            .ToListAsync(cancellationToken);

        // TODO: Randomly select interactions, probably have to use raw SQL

        await SendOkAsync(new Response
        {
            Interactions = interactions
        }, cancellationToken);
    }
}

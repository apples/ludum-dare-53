using Api.Models;

namespace Api.Features.Interactions.Post;

public class Endpoint : Endpoint<Request>
{
    private readonly ApplicationContext _dbContext;

    public Endpoint(ApplicationContext dbContext)
    {
        _dbContext = dbContext;
    }

    public override void Configure()
    {
        Post("/interactions/{Level}/{Cycle}");
    }

    public override async Task HandleAsync(Request request, CancellationToken cancellationToken)
    {
        var playerID = this.GetPlayerID();

        var interactions = request.Interactions
            .Select(i => new Models.Interaction
            {
                PlayerID = playerID,
                Level = request.Level,
                Cycle = request.Cycle,
                InteractionType = i.InteractionType,
                Content = i.Content,
                CreatedTimeStamp = DateTime.UtcNow,
            });

        _dbContext.Interactions.AddRange(interactions);
        await _dbContext.SaveChangesAsync(cancellationToken);

        await SendOkAsync(cancellationToken);
    }
}

using Api.Models;

namespace Api.Features.HealthCheck;

public class Endpoint : EndpointWithoutRequest
{
    private readonly ApplicationContext _dbContext;

    public Endpoint(ApplicationContext dbContext)
    {
        _dbContext = dbContext;
    }

    public override void Configure()
    {
        Get("/healthcheck");
        AllowAnonymous();
    }

    public override async Task HandleAsync(CancellationToken cancellationToken)
    {
        var canConnect = await _dbContext.Database.CanConnectAsync();

        if (canConnect == false)
        {
            ThrowError("Database error");
        }

        await SendOkAsync(new { Status = "OK" }, cancellationToken);
    }
}

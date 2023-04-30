using Api.Extensions;
using Api.Models;
using Microsoft.EntityFrameworkCore;
using System.Text;

namespace Api.Features.Player.Get;

public class Endpoint : Endpoint<Request>
{
    public override void Configure()
    {
        Get("/player");
    }

    public override async Task HandleAsync(Request request, CancellationToken cancellationToken)
    {
        var claimUserName = User.FindFirstValue<string>("UserName");
        
        if (claimUserName == request.UserName)
        {
            await SendOkAsync(cancellationToken);
        }
        else
        {
            await SendNotFoundAsync(cancellationToken);
        }
    }
}

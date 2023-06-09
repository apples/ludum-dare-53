﻿using Api.Auth;
using Api.Models;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace Api.Features.Cycle.Get;

public sealed class Endpoint : Endpoint<Request, Response>
{
    private readonly ApplicationContext _dbContext;

    public Endpoint(ApplicationContext dbContext)
    {
        _dbContext = dbContext;
    }

    public override void Configure()
    {
        Get("/cycle/{Level}");
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

        await SendOkAsync(new Response
        {
            Cycle = player.CurrentCycle
        }, cancellationToken);
    }
}

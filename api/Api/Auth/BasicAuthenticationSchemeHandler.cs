using Api.Models;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using System.Security.Claims;
using System.Text;
using System.Text.Encodings.Web;

namespace Api.Auth;

public class BasicAuthenticationSchemeHandler : AuthenticationHandler<BasicAuthenticationSchemeOptions>
{
    private readonly IHashService _hashService;
    private readonly ApplicationContext _applicationContext;

    public BasicAuthenticationSchemeHandler(
        IOptionsMonitor<BasicAuthenticationSchemeOptions> options,
        ILoggerFactory logger,
        UrlEncoder encoder,
        ISystemClock clock,
        IHashService hashService,
        ApplicationContext applicationContext) :
        base(options, logger, encoder, clock)
    {
        _hashService = hashService;
        _applicationContext = applicationContext;
    }

    protected async override Task<AuthenticateResult> HandleAuthenticateAsync()
    {
        if (Request.Headers.TryGetValue("Authorization", out var authorizations) == false)
        {
            return AuthenticateResult.Fail("No Authorization headers");
        }

        if (authorizations.Count == 0)
        {
            return AuthenticateResult.Fail("No Authorizations provided");
        }
        else if (authorizations.Count > 1)
        {
            return AuthenticateResult.Fail("Too many Authorizations provided");
        }

        var authorization = authorizations[0];

        const string basic = "Basic ";
        if (string.IsNullOrEmpty(authorization) == true)
        {
            return AuthenticateResult.Fail("Empty Authorization provided");
        }
        else if (authorization.StartsWith(basic) == false)
        {
            return AuthenticateResult.Fail("Authorization is not basic");
        }

        var authorizationValue = authorization[basic.Length..].Trim();

        var decodedKeyBytes = Convert.FromBase64String(authorizationValue);
        var decodedKey = Encoding.UTF8.GetString(decodedKeyBytes);
        var colonIndex = decodedKey.IndexOf(':');
        if (colonIndex == -1)
        {
            return AuthenticateResult.Fail("Invalid authorization provided");
        }
        var username = decodedKey[..colonIndex];
        var playerIDHash = decodedKey[(colonIndex + 1)..];

        var playerID = _hashService.DecodePlayerID(playerIDHash);

        if (playerID is null)
        {
            return AuthenticateResult.Fail("Invalid authorization provided");
        }

        var player = await _applicationContext.Players
            .AsNoTracking()
            .FirstOrDefaultAsync(p =>
                p.PlayerID == playerID &&
                p.UserName == username);

        if (player is null)
        {
            return AuthenticateResult.Fail("Player not found");
        }

        var claims = new Claim[]
        {
            new UserNameClaim(player.UserName),
            new PlayerIDClaim(player.PlayerID)
        };
        var identity = new ClaimsIdentity(claims, "Basic");
        var principal = new ClaimsPrincipal(identity);
        var ticket = new AuthenticationTicket(principal, Scheme.Name);

        return AuthenticateResult.Success(ticket);
    }
}

public class BasicAuthenticationSchemeOptions : AuthenticationSchemeOptions
{
}
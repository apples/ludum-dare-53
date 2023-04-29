using System.Security.Claims;

namespace Api.Auth;

public class PlayerIDClaim : Claim
{
    public int PlayerID { get; init; }

    public PlayerIDClaim(int playerID) : base("PlayerID", playerID.ToString())
    {
        PlayerID = playerID;
    }
}

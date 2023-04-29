using System.Security.Claims;

namespace Api.Auth;

public class UserNameClaim : Claim
{
    public string UserName { get; init; }

    public UserNameClaim(string userName) : base("UserName", userName)
    {
        UserName = userName;
    }
}

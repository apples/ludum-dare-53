using System.Security.Claims;

namespace Api.Extensions;

public static class ClaimsPrincipalExtensions
{
    public static T? FindFirstValue<T>(this ClaimsPrincipal principal, string claimType)
    {
        var claim = principal.FindFirst(claimType) ?? throw new Exception("ClaimType not found");

        var convertedType = Convert.ChangeType(claim.Value, typeof(T)) ?? throw new Exception("Unable to convert type");

        return (T)convertedType;
    }
}

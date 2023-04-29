using Api.Models;

namespace Api.Extensions;

public static class EndpointExtensions
{
    public static int GetPlayerID<TRequest>(this Endpoint<TRequest> endpoint)
        where TRequest : notnull
    {
        try
        {
            return endpoint.User.FindFirstValue<int>("PlayerID");
        }
        catch (Exception)
        {
            endpoint.ThrowError("Unable to get PlayerID");
            return -1;
        }
    }

    public static int GetPlayerID<TRequest, TResponse>(this Endpoint<TRequest, TResponse> endpoint)
        where TRequest : notnull
        where TResponse : notnull
    {
        try
        {
            return endpoint.User.FindFirstValue<int>("PlayerID");
        }
        catch (Exception)
        {
            endpoint.ThrowError("Unable to get PlayerID");
            return -1;
        }
    }

    public static int GetPlayerID<TRequest, TResponse, TMapper>(this Endpoint<TRequest, TResponse, TMapper> endpoint)
        where TRequest : notnull
        where TResponse : notnull
        where TMapper : notnull, IMapper
    {
        try
        {
            return endpoint.User.FindFirstValue<int>("PlayerID");
        }
        catch (Exception)
        {
            endpoint.ThrowError("Unable to get PlayerID");
            return -1;
        }
    }
}

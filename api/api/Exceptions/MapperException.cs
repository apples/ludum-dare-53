using System.Linq.Expressions;

namespace Api.Exceptions;


[Serializable]
public class MapperException<TRequest> : Exception
{
    public Expression<Func<TRequest, object>> RequestProperty { get; init; }

	public MapperException(Expression<Func<TRequest, object>> property, string? message) : base(message)
    {
        RequestProperty = property;
    }
}
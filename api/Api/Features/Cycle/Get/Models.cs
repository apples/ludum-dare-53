namespace Api.Features.Cycle.Get;

public sealed class Request
{
    public string Level { get; set; } = default!;
}

public sealed class Validator : Validator<Request>
{
    public Validator()
    {
        RuleFor(x => x.Level)
            .NotEmpty();
    }
}

public sealed class Response
{
    public int Cycle { get; set; }
}

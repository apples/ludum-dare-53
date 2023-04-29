namespace Api.Features.Player.Create;

public class Request
{
    public string UserName { get; set; } = default!;
}

public class Validator : Validator<Request>
{
    public Validator()
    {
        RuleFor(x => x.UserName)
            .NotEmpty();
    }
}

public class Response
{
    public string Key { get; set; } = default!;
}
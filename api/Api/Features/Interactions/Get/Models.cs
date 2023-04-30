namespace Api.Features.Interactions.Get;

public sealed class Request
{
    public string Level { get; set; } = default!;

    public int Cycle { get; set; }

    public int Count { get; set; } = 10;

    public List<string> IncludeTypes { get; set; } = new();

    public List<string> ExcludeTypes { get; set; } = new();
}

public sealed class Response
{
    public List<Interaction> Interactions { get; set; } = default!;
}

public sealed class Interaction
{
    public int InteractionID { get; set; }

    public string UserName { get; set; } = default!;

    public string InteractionType { get; set; } = default!;

    public string Content { get; set; } = default!;
}

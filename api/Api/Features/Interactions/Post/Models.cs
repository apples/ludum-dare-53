namespace Api.Features.Interactions.Post;

public class Request
{
    public string Level { get; set; } = default!;

    public int Cycle { get; set; }

    public List<Interaction> Interactions { get; set; } = default!;
}

public class Interaction
{
    public string InteractionType { get; set; } = default!;

    public string Content { get; set; } = default!;
}

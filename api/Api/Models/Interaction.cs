namespace Api.Models;

public sealed class Interaction
{
    public int InteractionID { get; set; }

    public int PlayerID { get; set; }

    public string Level { get; set; } = default!;

    public int Cycle { get; set; }

    public string InteractionType { get; set; } = default!;

    public string Content { get; set; } = default!;

    public DateTime CreatedTimeStamp { get; set; }
}

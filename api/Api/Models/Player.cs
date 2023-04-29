namespace Api.Models;

public sealed class Player
{
    public int PlayerID { get; set; }

    public string UserName { get; set; } = default!;

    public int CurrentCycle { get; set; }
}
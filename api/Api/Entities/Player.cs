using StronglyTypedIds;

namespace Api.Entities;

[StronglyTypedId]
public partial struct PlayerID { }

public sealed class Player
{
    public PlayerID PlayerID { get; set; }

    public string UserName { get; set; } = default!;

    public int CurrentCycle { get; set; }
}